/*
function: 群聊天窗口。
author: zouyujie
date: 2024.5.5
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {

    property string groupNumber: "123456789"  //群聊账号
    property string groupName: "XX群"         //群聊名
    property string groupLeader: ""           //群主
    property int index: -1                    //该群聊位于好友列表index
    property string groupProfileImage: ""     //群头像

    function updateData() {     //刷新所有聊天记录
        myGroupMsgListView.updateData()
    }

    function addMsgData(Msg) {  //增加一条聊天信息
        myGroupMsgListView.addMsgData(Msg)
    }
    function addFriend(data) {  //列表添加一个好友
        listModel.append(data)
    }
    function updateOneData(index, oneData) {  //更新一个好友信息视图
        listModel.set(index, oneData)
    }
    function clearFriendList() {  //清空列表数据
        listModel.clear()
    }

    id: self
    width: Screen.width/1707*900
    height: Screen.height/1067*550
    visible: false
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {  //拖动栏
            Layout.fillWidth: true
            Layout.preferredHeight: Screen.height/1067*35
            color: "lightblue"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                DragHandler {  //跟随移动
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { self.startSystemMove() }
                }

                Item {
                    Layout.preferredWidth: Screen.width/1707*18
                }
                Item {
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    Image {
                        anchors.fill: parent
                        source: "qrc:/image/QQ-01.png"
                        fillMode: Image.PreserveAspectFit
                        scale: 1.5
                        opacity: 0.8
                    }
                }
                Item { width: Screen.width/1707*22 }
                Item {  //聊天对象
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text {
                        id: objText
                        anchors.centerIn: parent
                        text: groupName
                        font {
                            family: mFONT_FAMILY
                            pointSize: 13
                        }
                        color: "#eeffffff"
                    }
                    Item {  //空间图标
                        height: parent.height
                        width: Screen.width/1707*30
                        anchors.left: objText.right
                        Image {
                            id: editGroup
                            height: Screen.height/1067*17
                            width: Screen.width/1707*17
                            source: "qrc:/image/编辑.png"
                            anchors.centerIn: parent
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    cursorShape = Qt.PointingHandCursor
                                    editGroup.scale = 1.2
                                }
                                onExited: {
                                    cursorShape = Qt.CustomCursor
                                    editGroup.scale = 1
                                }
                                Behavior on scale {
                                    NumberAnimation { duration: 800; easing.type: Easing.OutQuad }
                                }
                                onClicked: {
                                    /* 进入群资料视图 */
                                    groupDataView.visible = true
                                    groupDataView.raise()
                                }
                            }
                        }
                    }
                }
                Item{
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    MyToolButton {
                        iconSource: "qrc:/image/最小化.png"
                        icon.color: "white"
                        onClicked: {
                            self.showMinimized()
                        }
                    }
                }
                Item {
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    MyToolButton {
                        iconSource: "qrc:/image/关闭.png"
                        icon.color: "white"
                        onClicked: {
                            self.close()
                        }
                    }
                }
            }
        }
        Item {  //下
            Layout.fillWidth: true
            Layout.fillHeight: true
            //color: "lightblue"
            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {  //聊天框
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*700
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {  //消息框
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            MyGroupMsgListView {
                                id: myGroupMsgListView
                                groupNumber: self.groupNumber
                            }
                        }
                        Rectangle {  //发送消息框
                            Layout.fillWidth: true
                            Layout.preferredHeight: Screen.height/1067*180

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //线
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Screen.height/1067*5
                                    MenuSeparator { width: parent.width; padding: 0 }
                                }
                                Item {  //菜单栏
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Screen.height/1067*35
                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        Item {  //表情
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*40
                                            MyToolButton {
                                                iconSource: "qrc:/image/呆.png"
                                                clickColor: "#00000000"
                                            }
                                        }
                                        Item {  //文件
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*40
                                            MyToolButton {
                                                iconSource: "qrc:/image/文件.png"
                                                clickColor: "#00000000"
                                            }
                                        }
                                        Item {  //图片
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*40
                                            MyToolButton {
                                                iconSource: "qrc:/image/图片.png"
                                                clickColor: "#00000000"
                                            }
                                        }
                                        Item {  //振动
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*40
                                            MyToolButton {
                                                iconSource: "qrc:/image/振动.png"
                                                clickColor: "#00000000"
                                                scale: 1.15
                                            }
                                        }
                                        Item {  //更多
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*40
                                            MyToolButton {
                                                iconSource: "qrc:/image/更多.png"
                                                clickColor: "#00000000"
                                                scale: 1.2
                                            }
                                        }
                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                                Item {  //发送消息框
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    ScrollView {
                                        width: parent.width
                                        height: parent.height
                                        anchors.verticalCenter: parent.verticalCenter

                                        TextArea {
                                            id: msgText
                                            wrapMode: TextEdit.Wrap
                //                            background: Rectangle {
                //                                border.color: "gray"
                //                            }
                                            font {
                                                family: mFONT_FAMILY
                                                pointSize: 12
                                            }
                                            //text: main_PersonalSignature
                                        }
                                    }
                                }
                                Item {  //关闭，发送按钮
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Screen.height/1067*50

                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }
                                        Item {  //关闭
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*100
                                            Item {
                                                width: Screen.width/1707*85
                                                height: parent.height*0.6
                                                anchors.centerIn: parent
                                                MyToolButton {
                                                    text: "关闭"
                                                    font {
                                                        family: mFONT_FAMILY
                                                        pointSize: 10
                                                    }
                                                    bacColor: "white"
                                                    borderWidth: 1
                                                    clickColor: "lightgray"
                                                    clickOpacity: 0.6
                                                    onClicked: {
                                                        self.close()
                                                    }
                                                }
                                            }
                                        }
                                        Item {  //发送
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*100
                                            Item {
                                                width: Screen.width/1707*85
                                                height: parent.height*0.6
                                                anchors.centerIn: parent
                                                MyToolButton {
                                                    Text {
                                                        text: "发送"
                                                        anchors.centerIn: parent
                                                        color: "#eeffffff"
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 10
                                                        }
                                                    }
                                                    font {
                                                        family: mFONT_FAMILY
                                                        pointSize: 10
                                                    }
                                                    bacColor: "lightblue"
                                                    clickColor: "#baccd9"
                                                    borderWidth: 1
                                                    onClicked: {
                                                        /* 发送消息 */
                                                        var data = {}
                                                        data.IsMyMsg = "true"
                                                        data.Msg = msgText.text
                                                        data.SendMsgNumber = main_AccountNumber
                                                        if (data.Msg === "") { console.log("不能发送空消息！"); return }
                                                        myGroupMsgListView.addMsgData(data)

                                                        /* 上传到服务器缓存和转发 json数据*/
                                                        var chatHistory = {}
                                                        chatHistory.GroupNumber = groupNumber
                                                        chatHistory.ChatHistory = {}
                                                        chatHistory.ChatHistory.SendMsgNumber = main_AccountNumber
                                                        chatHistory.ChatHistory.Msg = msgText.text
                                                        chatHistory.ChatHistory.IsMyMsg = ""
                                                        /* 本地缓存 */
                                                        saveLocalCache_GroupChatHistory(chatHistory)
                                                        /* 云缓存 */
                                                        chatHistory.AccountNumber = main_AccountNumber
                                                        toServer_SaveGroupChatHistory(chatHistory)

                                                        /* 刷新对应好友的最后一行聊天记录视图 */
                                                        for (var i=0; i<main_FriendsList.length; i++) {
                                                            if (groupNumber === main_FriendsList[i].accountNumber) {
                                                                updateFriendListViewOneRow(i, msgText.text, main_AccountNumber)  //更新视图
                                                                break;
                                                            }
                                                        }

                                                        /* 清空输入内容 */
                                                        msgText.clear()
                                                        msgText.forceActiveFocus()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Item {  //群栏
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*200

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        MenuSeparator {  //竖线
                            Layout.fillHeight: true
                            Layout.preferredWidth: 1
                            padding: 0
                        }
                        Item {  //内容
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 0

                                Rectangle {  //群号
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Screen.height/1067*50
                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        Rectangle {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*60
                                            Text {
                                                text: "群号"
                                                font {
                                                    family: mFONT_FAMILY
                                                    pointSize: 12
                                                }
                                                anchors.verticalCenter: parent.verticalCenter
                                                x: 10
                                            }
                                        }
                                        Rectangle {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextEdit {
                                                text: groupNumber
                                                font {
                                                    family: mFONT_FAMILY
                                                    pointSize: 13
                                                    underline: true
                                                }
                                                anchors.centerIn: parent
                                                color: "lightblue"
                                                readOnly: true
                                                selectionColor: "lightgray"
                                            }
                                        }
                                        Item {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: Screen.width/1707*50
                                        }
                                    }
                                }
                                Rectangle {  //群通知
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Screen.height/1067*200
                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        Item {  //群通知
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 0
                                            RowLayout {
                                                anchors.fill: parent
                                                spacing: 0
                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.preferredWidth: Screen.width/1707*60
                                                    Text {
                                                        text: "群通知"
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 12
                                                        }
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        x: 10
                                                    }
                                                }
                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                }
                                            }
                                        }
                                        Item {  //没有通知的背景图
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Image {
                                                width: Screen.width/1707*40
                                                height: Screen.height/1067*40
                                                anchors.centerIn: parent
                                                source: "qrc:/image/没有通知.png"
                                            }
                                        }
                                    }
                                }
                                Rectangle {  //群成员
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        Item {  //横线
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 5
                                            MenuSeparator { width: parent.width; padding: 0 }
                                        }
                                        Item {  //群成员
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: Screen.height/1067*40
                                            Text {
                                                text: "群成员"
                                                font {
                                                    family: mFONT_FAMILY
                                                    pointSize: 12
                                                }
                                                anchors.verticalCenter: parent.verticalCenter
                                                x: 10
                                            }
                                        }
                                        Rectangle {  //list
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            ListView {
                                                id: listView
                                                model: ListModel {
                                                    id: listModel
                                                }
                                                anchors.fill: parent
                                                clip: true
                                                delegate: Item {
                                                    height: Screen.height/1067*40
                                                    width: listView.width
                                                    RowLayout {
                                                        anchors.fill: parent
                                                        spacing: 0
                                                        Item {
                                                            Layout.fillHeight: true
                                                            Layout.preferredWidth: Screen.width/1707*(10+40)
                                                            MyProfileImage {  //头像
                                                                x: 10
                                                                imgSrc: profileImage
                                                                width: Screen.height/1067*35
                                                                height: Screen.height/1067*35
                                                                imageHeight: profileImage==="qrc:/image/profileImage.png" ? height*0.75:height
                                                                imageWidth: profileImage==="qrc:/image/profileImage.png" ? width*0.75:width
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }
                                                        }
                                                        Rectangle {  //昵称
                                                            Layout.fillHeight: true
                                                            Layout.fillWidth: true
                                                            Text {
                                                                text: nickName
                                                                font {
                                                                    family: mFONT_FAMILY
                                                                    pointSize: 11
                                                                }
                                                                anchors.verticalCenter: parent.verticalCenter
                                                            }
                                                        }
                                                        Item {  //群用户图像
                                                            Layout.fillHeight: true
                                                            Layout.preferredWidth: Screen.width/1707*40
                                                            Image {
                                                                width: Screen.height/1067*35
                                                                height: Screen.height/1067*35
                                                                scale: 0.8
                                                                anchors.centerIn: parent
                                                                source: {
                                                                    /* 判断是否是群主 */
                                                                    if (accountNumber === groupLeader) {
                                                                        /* 群主 */
                                                                        return "qrc:/image/群主.png"
                                                                    } else return "qrc:/image/用户.png"
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    GroupDataView {  //个人资料视图
        id: groupDataView
        visible: false
        profileImage: self.groupProfileImage
        accountNumber: self.groupNumber
        nickName: self.groupName
        groupLeader: self.groupLeader
        index: self.index
    }
}
