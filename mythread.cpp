/*
function: 封装socket及对它的操作，方便移入新线程。
author: zouyujie
date: 2024.4.16
*/
#include <QThread>
#include <QImage>
#include <QDir>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QFile>

#include "mythread.h"

MyThread::MyThread(QObject *parent) :
    QObject(parent)
{
    //map_Switch
    map_Switch = {
        {"CheckAccountNumber", Purpose::CheckAccountNumber},
        {"Register", Purpose::Register},
        {"Login", Purpose::Login},
        {"PrepareSendFile", Purpose::PrepareSendFile},
        {"SendFile", Purpose::SendFile},
        {"ReceiveFile", Purpose::ReceiveFile},
        {"RequestGetProfileAndName", Purpose::RequestGetProfileAndName},
        {"GetChatHistory", Purpose::GetChatHistory},
        {"RefreshFriendList", Purpose::RefreshFriendList},
        {"TransmitMsg", Purpose::TransmitMsg},
        {"CheckGroupNumber", Purpose::CheckGroupNumber},
        {"GetFriendList", Purpose::GetFriendList},
        {"GetGroupChatHistory", Purpose::GetGroupChatHistory},
        {"GetGroupLeader", Purpose::GetGroupLeader}
    };

    //cache_Path
    cache_Path = QDir::currentPath();  //当前工作目录

    //buffer
    buffer = new QBuffer(&file, this);
}

MyThread::~MyThread()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "子线程析构。";

    socket->disconnectFromHost();
}

void MyThread::buildConnection()
{
    //socket
    socket = new QTcpSocket(this);
    //socket->connectToHost(QHostAddress::LocalHost, 2222);  //与服务端建立连接
    socket->connectToHost("139.9.0.64", 2222);  //与服务端建立连接
    connect(socket, &QTcpSocket::connected, this, &MyThread::onConnected);
    connect(socket, &QTcpSocket::readyRead, this, &MyThread::onReadyRead);
    connect(socket, &QTcpSocket::disconnected, this, &MyThread::onDisconnected);
}

void MyThread::onConnected()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "与服务器连接成功。";
}

void MyThread::onDisconnected()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "与服务器断开连接。";
}

void MyThread::onReadyRead()
{
    if (ifNeedReceiveFile) {
        /* 开始接收文件 */
        count += 1;
        //QByteArray data = QByteArray::fromBase64(socket->readAll());
        QByteArray data = socket->readAll();
        file.append(data);
        receiveSize += data.size();
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "开始接收图像文件 次数"+QString::number(count)+" "+QString::number(receiveSize);

        if (fileSize <= receiveSize) {  //图像文件接收完毕
            QDir folder;
            bool exist = folder.exists(cache_Path+"/config/profileImage");
            if (!exist) {  //该文件夹不存在
                qDebug() << cache_Path+"/config/profileImage";
                if (!folder.mkpath(cache_Path+"/config/profileImage")) {
                    qDebug() << "config文件夹创建失败！";
                }
            }

            QImage image;
            image.loadFromData(file);
            if (!image.save(cache_Path+"/config/profileImage/"+accountNumber+".jpg", "JPG", 80)) {
                qDebug() << "接收文件：图像文件保存失败！";
            }

            ifNeedReceiveFile = false;
            qDebug() << "子线程" << QThread::currentThread() << ":"
                     << "图像文件接收完毕。";
            emit finished_ReceiveFile(nickName, true);
        }
        return;
    }

    if (socket->bytesAvailable() <= 0) return;  //字节为空则退出
    QByteArray data = socket->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QString data_Purpose = doc["Purpose"].toString();
    enum Purpose purpose = map_Switch[data_Purpose];
    switch (purpose) {
    case Purpose::CheckAccountNumber: {
        QString reply = doc["Reply"].toString();
        emit getReply_CheckAccountNumber(reply);

        if (reply == "false") return;  //账号错误
        QString check = doc["Check"].toString();
        if (check == "Login") {
            /* 准备接收文件 */
            fileSize = doc["FileSize"].toInt();
            accountNumber = doc["AccountNumber"].toString();
            qDebug() << "子线程" << QThread::currentThread() << ":"
                     << "准备接收"+accountNumber+"图像文件 大小："+QString::number(fileSize);
            if (fileSize == 0) return;  //如果为0,服务端没有数据,就不需要接收文件
            file.clear();
            receiveSize = 0;
            count = 0;
            ifNeedReceiveFile = true;
            toServer_ReceiveFile(accountNumber);  //准备好接收文件
        }
        break;
    }
    case Purpose::Register: {
        QString reply = doc["Reply"].toString();
        emit getReply_Register(reply);
        break;
    }
    case Purpose::Login: {
        QString reply = doc["Reply"].toString();
        QString isRepeatOnline = doc["IsRepeatOnline"].toString();
        if (isRepeatOnline == "true") {
            qDebug() << "重复登陆！";
            emit getReply_Login("false");
            return;
        }
        emit getReply_Login(reply);
        if (reply == "false") return;  //密码错误
        /* 接收个人信息+好友列表 */
        emit getReply_GetPersonalData(doc.object());
        break;
    }
    case Purpose::PrepareSendFile: {
        QString reply = doc["Reply"].toString();
        if (reply == "true") {
            /* 开始发送文件 */
            toServer_SendFile();
        }
        break;
    }
    case Purpose::SendFile: {
        QString reply = doc["Reply"].toString();
        if (reply == "true") {
            emit finished_SeverReceiveFile();
        }
        break;
    }
    case Purpose::ReceiveFile: {
        break;
    }
    case Purpose::RequestGetProfileAndName: {
        /* 昵称赋值 */
        nickName = doc["NickName"].toString();
        /* 准备接收文件 */
        fileSize = doc["FileSize"].toInt();
        accountNumber = doc["AccountNumber"].toString();
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "准备接收"+accountNumber+"图像文件 大小："+QString::number(fileSize);
        if (fileSize == 0) {  //如果为0,需要发送默认信号
            emit finished_ReceiveFile(nickName, false); //昵称 是否接收了头像
            return;
        }
        file.clear();
        receiveSize = 0;
        count = 0;
        ifNeedReceiveFile = true;
        toServer_ReceiveFile(accountNumber);  //准备好接收文件
        break;
    }
    case Purpose::GetChatHistory: {
        /* 得到与某好友的聊天记录 */
        QJsonArray chatHistory = doc["ChatHistory"].toArray();
        emit getReply_GetChatHistory(chatHistory);
        break;
    }
    case Purpose::RefreshFriendList: {
        /* 成功加好友 */
        emit getReply_RefreshFriendList(doc.object());
        break;
    }
    case Purpose::TransmitMsg: {
        /* json格式
         * Msg:
         *  Msg,
         *  IsMyMsg,
         *  SendMsgNumber
         * SendPerson
        */
        emit getReply_TransmitMsg(doc.object());
        break;
    }
    case Purpose::CheckGroupNumber: {
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "群号已存在，群聊创建失败！";
        break;
    }
    case Purpose::GetFriendList: {
        QJsonArray friendList = doc["FriendList"].toArray();
        emit getReply_GetFriendList(friendList);
        break;
    }
    case Purpose::GetGroupChatHistory: {
        /* 得到某群聊的聊天记录 */
        QJsonArray chatHistory = doc["ChatHistory"].toArray();
        emit getReply_GetGroupChatHistory(chatHistory);
        break;
    }
    case Purpose::GetGroupLeader: {
        QString groupLeader = doc["GroupLeader"].toString();
        emit getReply_GetGroupLeader(groupLeader);
        break;
    }
    default:
        break;
    }
}

void MyThread::toServer_CheckAccountNumber(const QString &accountNumber, const QString &check)
{
    QJsonObject json;
    json.insert("Purpose", "CheckAccountNumber");  //目的
    json.insert("AccountNumber", accountNumber);   //账号
    json.insert("Check", check);                   //判断是用于登陆or注册
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MyThread::toServer_Register(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Register");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MyThread::toServer_Login(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Login");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MyThread::toServer_RequestGetProfileAndName(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "RequestGetProfileAndName");  //目的: 获取该账号的头像+昵称
    json.insert("AccountNumber", accountNumber);         //账号
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MyThread::toServer_ReceiveFile(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "ReceiveFile");  //目的
    json.insert("Reply", "true");
    json.insert("AccountNumber", accountNumber);
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MyThread::toServer_PrepareSendFile(const QString&url, const QString&id)
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "准备发送图像文件";

    /* 准备发送文件 */
    file.clear();        //清空文件数据
    accountNumber = id;  //赋值

    buffer->open(QIODevice::WriteOnly);  //打开
    QImage image(url);
    if (!image.save(buffer, "JPG", 80)) {
        qDebug() << "准备发送：图像文件保存失败";
    }
    buffer->close();  //关闭

    /* 发送信息 */
    if (file.size() >= 1024*1024*10) {  //压缩后大于10M视为大文件
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "当前不支持传输大文件";
        return;
    }

    QJsonObject json;
    json.insert("Purpose", "PrepareSendFile");  //目的
    json.insert("FileSize", file.size());
    json.insert("AccountNumber", accountNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "图像文件准备完毕 大小："+QString::number(file.size());
}

void MyThread::toServer_SendFile()
{
    qintptr oneSend_Size = 4000000;     //一次最大传输:四百万 字节
    if (file.size() < oneSend_Size) {   //一次性传输
        qintptr send_FileSize = socket->write(file);
        socket->flush();  //立刻传输
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "图像文件发送完毕 大小："+QString::number(send_FileSize);
    }
    else {  //需要多次传输
        qintptr hadSend_Size = 0;  //已经传输的大小
        for (int i=0; i<1000; i++) {
            if (hadSend_Size >= file.size()) {  //检测是否发送完毕
                qDebug() << "子线程" << QThread::currentThread() << ":"
                         << "图像文件发送完毕 大小："+QString::number(hadSend_Size);
                break;
            }

            QByteArray send_Data;
            if (file.size()-hadSend_Size < oneSend_Size) {  //最后一次字节不够
                send_Data = file.last(file.size()-hadSend_Size);
            } else {
                send_Data = file.sliced(hadSend_Size, oneSend_Size);
            }
            qintptr oneWrite_Size = socket->write(send_Data);
            socket->flush();  //立刻传输
            qDebug() << "子线程" << QThread::currentThread() << ":"
                     << "图像文件第"+QString::number(i+1)+"次发送 大小："+QString::number(oneWrite_Size);
            hadSend_Size += oneWrite_Size;
        }
    }
}

void MyThread::toServer_ChangePersonalData(QJsonObject doc)
{
    /* json格式
     * AccountNumber,
     * NickName,
     * Sex,
     * ZodiacSign,
     * BloodGroup,
     * PersonalSignature
    */
    doc.insert("Purpose", "ChangePersonalData");  //目的
    QJsonDocument _doc(doc);
    QByteArray send_Data = _doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "个人信息已上传";
}

void MyThread::toServer_AddFriend(QJsonObject obj)
{
    /* json格式
     * AccountNumber,
     * FriendAccountNumber,
     * ChatHistory:
     *      Msg,
     *      IsMyMsg,
     *      SendMsgNumber
    */
    obj.insert("Purpose", "AddFriend");
    QJsonDocument doc(obj);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    QString friendAccountNumber = obj["FriendAccountNumber"].toString();
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "加好友"+friendAccountNumber;
}

void MyThread::toServer_SaveChatHistory(QJsonObject obj)
{
    /* json格式
     * AccountNumber,
     * FriendAccountNumber,
     * ChatHistory:
     *      Msg,
     *      IsMyMsg,
     *      SendMsgNumber
     * IsNeedTransmit
    */
    obj.insert("Purpose", "SaveChatHistory");  //目的
    QJsonDocument doc(obj);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "云缓存聊天记录";
}

void MyThread::toServer_GetChatHistory(const QString &accountNumber, const QString &friendAccountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "GetChatHistory");  //目的
    json.insert("AccountNumber", accountNumber);
    json.insert("FriendAccountNumber", friendAccountNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "加载与"+friendAccountNumber+"的聊天记录...";
}

void MyThread::toServer_CreateGroup(const QString &groupNumber, const QString &accountNumber)
{
    /* 群号 当前用户账号 */
    QJsonObject json;
    json.insert("Purpose", "CreateGroup");  //目的
    json.insert("GroupNumber", groupNumber);
    json.insert("AccountNumber", accountNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "准备创建群聊 "+groupNumber;
}

void MyThread::toServer_GetFriendList(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "GetFriendList");  //目的
    json.insert("AccountNumber", accountNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
}

void MyThread::toServer_SaveGroupChatHistory(QJsonObject obj)
{
    /* json格式
     * GroupNumber,
     * AccountNumber,
     * ChatHistory:
     *      Msg,
     *      IsMyMsg,
     *      SendMsgNumber
    */
    obj.insert("Purpose", "SaveGroupChatHistory");  //目的
    QJsonDocument doc(obj);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "云缓存群聊天记录";
}

void MyThread::toServer_GetGroupChatHistory(const QString &groupNumber)
{
    QJsonObject json;
    json.insert("Purpose", "GetGroupChatHistory");  //目的
    json.insert("GroupNumber", groupNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "加载群"+groupNumber+"的聊天记录...";
}

void MyThread::toServer_AddGroup(QJsonObject obj)
{
    /* json格式
     * GroupNumber,
     * AccountNumber,
     * ChatHistory:
     *      Msg,
     *      IsMyMsg,
     *      SendMsgNumber
    */
    obj.insert("Purpose", "AddGroup");  //目的
    QJsonDocument doc(obj);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "添加群聊";
}

void MyThread::toServer_GetGroupLeader(const QString &groupNumber)
{
    QJsonObject json;
    json.insert("Purpose", "GetGroupLeader");  //目的
    json.insert("GroupNumber", groupNumber);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "获取群主账号";
}




