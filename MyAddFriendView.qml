/*
function: 加好友窗口。
author: zouyujie
date: 2024.4.21
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: self
    width: Screen.width/1707*400
    height: Screen.height/1067*450
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {  //拖动栏
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: "lightblue"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                DragHandler {  //跟随移动
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { self.startSystemMove() }
                }

                Item {
                    Layout.preferredWidth: 18
                }
                Item {
                    height: 35
                    width: 40
                    Image {
                        anchors.fill: parent
                        source: "qrc:/image/QQ-01.png"
                        fillMode: Image.PreserveAspectFit
                        scale: 1.5
                        opacity: 0.8
                    }
                }
                Item { width: 22 }
                Item {  //聊天对象
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text {
                        id: objText
                        anchors.centerIn: parent
                        text: "加好友/群"
                        font {
                            family: mFONT_FAMILY
                            pointSize: 13
                        }
                        //color: "#eeffffff"
                    }
                }
                Item{
                    height: 35
                    width: 40
                    MyToolButton {
                        iconSource: "qrc:/image/最小化.png"
                        icon.color: "white"
                        onClicked: {
                            self.showMinimized()
                        }
                    }
                }
                Item {
                    height: 35
                    width: 40
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
        Item {  //搜索框
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Item {
                width: parent.width*0.9
                height: 50
                anchors.centerIn: parent

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "lightgray"
                        opacity: 0.6
                        radius: 5

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {  //搜索图标
                                Layout.fillHeight: true
                                Layout.preferredWidth: 40
                                Image {
                                    source: "qrc:/image/搜索.png"
                                    width: 20
                                    height: 20
                                    anchors.centerIn: parent
                                }
                            }
                            Item {  //输入框
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextField {
                                    id: textField
                                    anchors.fill: parent
                                    verticalAlignment: TextField.AlignVCenter
                                    validator: RegularExpressionValidator {
                                        regularExpression: /[1-9]\d{8,9}/
                                    }
                                    background: Rectangle {
                                        color: "#00000000"
                                    }
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 14
                                    }
                                    onTextChanged: {
                                        if (text === "") {
                                            clearIcon.visible = false
                                            return
                                        }
                                        clearIcon.visible = true
                                    }
                                }
                            }
                            Item {  //清空图标
                                Layout.fillHeight: true
                                Layout.preferredWidth: 40
                                MyToolButton {
                                    id: clearIcon
                                    visible: false
                                    iconSource: "qrc:/image/关闭.png"
                                    clickColor: "#00000000"
                                    icon.color: "gray"
                                    iconHeight: 20
                                    iconWidth: 20
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: {
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            cursorShape = Qt.ArrowCursor
                                        }
                                        onClicked: {
                                            textField.clear()
                                            textField.focus = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 10
                    }
                    Item {  //搜索按钮
                        Layout.fillHeight: true
                        Layout.preferredWidth: 80
                        MyToolButton {
                            text: "搜索"
                            font {
                                family: mFONT_FAMILY
                                pointSize: 13
                            }
                            bacColor: "#baccd9"
                            clickColor: "#93b5cf"
                            bacRadius: 5
                            clickOpacity: 0.6
                            onClicked: {
                                /* 判断是否有效 */
                                if (!textField.acceptableInput) {
                                    console.log("输入不合法！")
                                    return
                                }
                                /* 验证号码是否存在 */
                                var accountNumber = textField.text  //查找的账号
                                function onReply(isExit) {  //检测账号
                                    if (isExit === "true") {
                                        /* 获取头像 昵称 账号 是不是好友 */
                                        function onFinished(nickName, isReceive) {  //昵称 是否接收了头像
                                            var data = {}
                                            data.profileImage = isReceive? cache_Path+"/config/profileImage/"+accountNumber+".jpg":"qrc:/image/profileImage.png"
                                            data.nickName = nickName===""? "未知昵称":nickName
                                            data.accountNumber = accountNumber
                                            /* 判断是否为好友 */
                                            var isFriend = false
                                            for (var i=0; i<main_FriendsList.length; i++) {
                                                if (accountNumber === main_FriendsList[i].accountNumber) {
                                                    isFriend = true
                                                    if (nickName !== main_FriendsList[i].nickName) {
                                                        if (nickName !== "") {
                                                            main_FriendsList[i].nickName = nickName
                                                        }
                                                    }
                                                    /* 刷新好友列表视图数据 */
                                                    updateFriendListView()
                                                }
                                            }
                                            data.isFriend = isFriend  //bool
                                            listModel.clear()
                                            listModel.append(data)

                                            onFinished_ReceiveFile.disconnect(onFinished)  //断开连接
                                        }
                                        onFinished_ReceiveFile.connect(onFinished)  //连接

                                        toServer_RequestGetProfileAndName(accountNumber)  //请求获取数据
                                    } else {  //账号不存在
                                        console.log("该账号不存在")
                                    }

                                    onGetReply_CheckAccountNumber.disconnect(onReply)  //断开连接
                                }  //验证账号
                                onGetReply_CheckAccountNumber.connect(onReply)  //连接

                                toServer_CheckAccountNumber(accountNumber, "Register")  //请求验证账号
                            }
                        }
                    }
                }
            }
        }
        Item {  //查找人
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.05
                }
                Item {  //查找人
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {  //查找人
                        anchors.fill: parent
                        spacing: 0

                        Item {  //查找人
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Text {
                                text: "查找人"
                                anchors.verticalCenter: parent.verticalCenter
                                font {
                                    family: mFONT_FAMILY
                                    pointSize: 12
                                }
                                color: "gray"
                            }
                        }
                        Item {  //listView
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            ListView {
                                id: listView
                                anchors.fill: parent
                                model: ListModel {
                                    id: listModel
                                }
                                clip: true
                                delegate: Item {
                                    height: 100
                                    width: listView.width
                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        Rectangle {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: parent.height
                                            //color: "red"
                                            MyProfileImage {
                                                imgSrc: profileImage
                                                width: 80
                                                height: 80
                                                imageHeight: profileImage==="qrc:/image/profileImage.png" ? height*0.75:height
                                                imageWidth: profileImage==="qrc:/image/profileImage.png" ? width*0.75:width
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        Rectangle {  //查找人信息
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            //color: "red"
                                            ColumnLayout {
                                                anchors.fill: parent
                                                spacing: 0
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 15
                                                }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 30
                                                    Text {
                                                        text: nickName
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 14
                                                        }
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 20
                                                    Text {
                                                        text: accountNumber
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 11
                                                        }
                                                        color: "lightblue"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 25
                                                }
                                            }
                                        }
                                        Item {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 100
                                            Item {
                                                height: 30
                                                width: 80
                                                anchors.centerIn: parent
                                                MyToolButton {
                                                    text: {
                                                        if (isFriend) return "发消息"
                                                        else {
                                                            if (accountNumber.match(/[1-9]\d{9}/)) {
                                                                return "加好友"
                                                            } else return "加群"
                                                        }
                                                    }

                                                    borderWidth: 1
                                                    bacRadius: 5
                                                    clickColor: "#e2e1e4"
                                                    clickOpacity: 0.8
                                                    font.family: mFONT_FAMILY
                                                    onClicked: {
                                                        /* 判断发消息 or 加好友 */
                                                        if (text === "发消息") {
                                                            /* 发消息 */
                                                            //
                                                        } else if (text === "加好友"){
                                                            /* 加好友 */
                                                            var data = {}
                                                            data.AccountNumber = main_AccountNumber      //自己的账号
                                                            data.FriendAccountNumber = accountNumber     //好友账号
                                                            data.ChatHistory = {}                        //聊天记录
                                                            data.ChatHistory.Msg = "我们成为好友了，现在开始聊天吧。"
                                                            data.ChatHistory.IsMyMsg = "false"
                                                            data.ChatHistory.SendMsgNumber = accountNumber
                                                            toServer_AddFriend(data)

                                                            isFriend = true
                                                        } else {
                                                            /* 加群 */
                                                            var data = {}
                                                            data.AccountNumber = main_AccountNumber      //自己的账号
                                                            data.GroupNumber = accountNumber             //好友账号
                                                            data.ChatHistory = {}                        //聊天记录
                                                            data.ChatHistory.Msg = "我是"+main_NickName+"。"
                                                            data.ChatHistory.IsMyMsg = ""
                                                            data.ChatHistory.SendMsgNumber = main_AccountNumber
                                                            toServer_AddGroup(data)

                                                            isFriend = true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    MenuSeparator { width: parent.width; padding: 0; anchors.bottom: parent.bottom }
                                }  //end Delegate
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.05
                }
            }
        }
    }
}
