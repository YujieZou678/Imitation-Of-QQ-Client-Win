/*
function: 主窗口。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Dialogs

ApplicationWindow {
    id: window

    property string mFONT_FAMILY: "微软雅黑"

    /* 各个界面视图声明 */
    property alias layoutLoginView: layoutLoginView        //登陆界面
    property alias layoutRegisterView: layoutRegisterView  //注册界面
    property alias layoutUserView: layoutUserView          //用户界面

    /* 登陆之后的个人数据 */
    property string main_ProfileImage: "qrc:/image/profileImage.png"     //登陆头像
    property string main_AccountNumber: "0000000000"                     //登陆账号
    property string main_NickName: "未知昵称"                             //昵称
    property string main_Sex: "男"                                       //性别
    property string main_ZodiacSign: "马"                                //生肖
    property string main_Old: "0"                                        //Q龄
    property string main_BloodGroup: "其他血型"                           //血型
    property string main_PersonalSignature: "这个人很懒什么都没留下......"  //个性签名
    property var main_FriendsList: []  //好友列表
    function updateFriendListView() {  //更新所有好友列表视图
        layoutUserView.msgListView.updateAllData()
    }
    function updateFriendListViewOneData(index, oneData) {  //更新对应好友
        layoutUserView.msgListView.updateOneData(index, oneData)
    }
    function updateFriendListViewOneRow(index, row, sendMsgNumber) {  //更新对应好友最后一排聊天记录
        layoutUserView.msgListView.updateOneDataRow(index, row, sendMsgNumber)
    }
    /*main_FriendsList 一个数据的json格式
    1.accountNumber,
    2.nickName,
    3.profileImage,
    4.chatHistory:
           IsMyMsg,
           Msg,
           SendMsgNumber
    5.groupLeader(群聊：群主账号)
    */
    property var main_ExtralFriendList: []  //群好友里不是当前用户好友的列表
    /*main_ExtralFriendList 一个数据的json格式
    1.accountNumber,
    2.nickName,
    3.profileImage,
    */

    width: Screen.width/1707*520
    height: Screen.height/1067*400
//    width: 400
//    height: 800
    visible: true

    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理
    onYChanged: {
        if (y > Screen.desktopAvailableHeight - 30) {
            window.showMinimized()
        }
    }
    onVisibilityChanged: {
        if (window.visibility === Window.Windowed) {
            window.x = (Screen.desktopAvailableWidth-width)/2
            window.y = (Screen.desktopAvailableHeight-height)/2
        }
    }

    LayoutLoginView {  //登陆界面
        id: layoutLoginView
        //visible: false
    }

    LayoutRegisterView {  //注册界面
        id: layoutRegisterView
        visible: false
    }

    LayoutUserView {  //登陆成功进入用户界面
        id: layoutUserView
        visible: false
    }

    function switchRegisterView() {  //切换到注册界面
        window.width = Screen.width/1707*520
        window.height = Screen.height/1067*460
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutLoginView.visible = false
        layoutRegisterView.clearView()
        layoutRegisterView.visible = true
    }
    function switchLoginView() {  //切换到登陆界面
        window.width = Screen.width/1707*520
        window.height = Screen.height/1067*400
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutRegisterView.visible = false
        layoutLoginView.clearView()
        layoutLoginView.visible = true
    }
    function switchUserView() {  //切换到用户界面
        window.width = Screen.width/1707*400
        window.height = Screen.height/1067*800
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutLoginView.visible = false
        layoutRegisterView.visible = false
        layoutUserView.visible = true
    }
}
