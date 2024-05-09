/*
function: 封装socket及对它的操作，方便移入新线程。
author: zouyujie
date: 2024.4.16
*/
#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QObject>
#include <QTcpSocket>
#include <QBuffer>

class MyThread : public QObject
{
    Q_OBJECT

public:
    MyThread(QObject *parent = nullptr);
    ~MyThread();

    QString cache_Path{""};  //缓存地址
    void buildConnection();  //构建连接

    void toServer_CheckAccountNumber(const QString&, const QString&);  //验证账号是否存在
    void toServer_Register(const QString&, const QString&);            //存入注册信息
    void toServer_Login(const QString&, const QString&);               //验证登陆信息
    void toServer_RequestGetProfileAndName(const QString&);            //请求获取某好友的头像和昵称
    void toServer_ReceiveFile(const QString&);                         //准备好接收某文件
    void toServer_PrepareSendFile(const QString&, const QString&);     //更换头像：准备发送文件
    void toServer_SendFile();                                          //更换头像：开始发送文件
    void toServer_ChangePersonalData(QJsonObject);                     //更改个人资料
    void toServer_AddFriend(QJsonObject);                              //添加好友
    void toServer_SaveChatHistory(QJsonObject);                        //上传聊天记录
    void toServer_GetChatHistory(const QString&, const QString&);      //获取与某好友的聊天记录
    void toServer_CreateGroup(const QString&, const QString&);         //创建群聊
    void toServer_GetFriendList(const QString&);                       //获取好友列表
    void toServer_SaveGroupChatHistory(QJsonObject);                   //上传群聊天记录
    void toServer_GetGroupChatHistory(const QString&);                 //获取某群聊的聊天记录
    void toServer_AddGroup(QJsonObject);                               //添加群聊
    void toServer_GetGroupLeader(const QString&);                      //获取群主

signals:
    void getReply_CheckAccountNumber(const QString&);           //信号：收到验证账号的回复
    void getReply_Register(const QString&);                     //信号：收到注册的回复
    void getReply_Login(const QString&);                        //信号：收到登陆的回复
    void finished_ReceiveFile(const QString&, bool);            //信号：文件接收完毕
    void finished_SeverReceiveFile();                           //信号：服务端文件接收完毕
    void getReply_GetPersonalData(const QJsonObject&);          //信号：收到个人信息
    void getReply_GetChatHistory(const QJsonArray&);            //信号：收到与某好友的聊天信息
    void getReply_RefreshFriendList(const QJsonObject&);        //信号：刷新好友列表
    void getReply_TransmitMsg(const QJsonObject&);              //信号：转发消息（有好友发消息）
    void getReply_GetFriendList(const QJsonArray&);             //信号：获取好友列表
    void getReply_GetGroupChatHistory(const QJsonArray&);       //信号：收到某群的聊天信息
    void getReply_GetGroupLeader(const QString&);               //信号：收到群主账号

public slots:
    void onConnected();     //连接到服务器
    void onDisconnected();  //与服务器断开连接
    void onReadyRead();     //收到服务器的信息

private:
    enum class Purpose {    //枚举(class内部使用)
        CheckAccountNumber,
        Register,
        Login,
        PrepareSendFile,
        SendFile,
        ReceiveFile,
        RequestGetProfileAndName,
        GetChatHistory,
        RefreshFriendList,
        TransmitMsg,
        CheckGroupNumber,
        GetFriendList,
        GetGroupChatHistory,
        GetGroupLeader
    };
    QMap<QString, enum Purpose> map_Switch;  //用于寻找信息是哪个目的

    /* 封装一个socket */
    QTcpSocket *socket;     //旧连接

    /* 发送文件数据 */
    QBuffer *buffer;        //与data绑定

    /* 接收文件数据 */
    bool ifNeedReceiveFile{false};  //是否需要接收文件
    QByteArray file;                //文件数据
    QString accountNumber;          //账号
    QString nickName;               //该账号昵称
    qint64 fileSize{0};             //文件大小
    qint64 receiveSize{0};          //已接收大小
    int count{0};                   //接收次数

    /* 大文件传输 */
//    MyThread *MyThread;     //子线程
//    QThread *thread;
};

#endif // MYTHREAD_H
