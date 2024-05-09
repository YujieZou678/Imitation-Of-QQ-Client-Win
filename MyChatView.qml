/*
function: 聊天窗口。
author: zouyujie
date: 2024.4.20
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {

    property string friendAccountNumber: ""  //聊天对象账号
    property string chatObj: ""              //聊天对象名

    function updateData() {     //刷新所有聊天记录
        myMsgListView.updateData()
    }

    function addMsgData(Msg) {  //增加一条聊天信息
        myMsgListView.addMsgData(Msg)
    }

    id: self
    width: Screen.width/1707*700
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
                        text: chatObj
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
                            height: Screen.width/1707*18
                            width: Screen.width/1707*18
                            source: "qrc:/image/QQ空间1.png"
                            anchors.centerIn: parent
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
        Item {  //消息框
            Layout.fillWidth: true
            Layout.fillHeight: true
            //color: "lightblue"
            MyMsgListView {
                id: myMsgListView
                friendAccountNumber: self.friendAccountNumber
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
                                onClicked: {
                                    //
                                }
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
                                        if (data.msg === "") return
                                        myMsgListView.addMsgData(data)

                                        /* 上传到服务器缓存和转发 json数据*/
                                        var chatHistory = {}
                                        chatHistory.AccountNumber = main_AccountNumber
                                        chatHistory.FriendAccountNumber = friendAccountNumber
                                        chatHistory.ChatHistory1 = {}
                                        chatHistory.ChatHistory1.Msg = msgText.text
                                        chatHistory.ChatHistory1.IsMyMsg = "true"
                                        chatHistory.ChatHistory1.SendMsgNumber = main_AccountNumber
                                        chatHistory.ChatHistory2 = {}
                                        chatHistory.ChatHistory2.Msg = msgText.text
                                        chatHistory.ChatHistory2.IsMyMsg = "false"
                                        chatHistory.ChatHistory2.SendMsgNumber = main_AccountNumber
                                        /* 本地缓存 */
                                        saveLocalCache_ChatHistory(chatHistory)

                                        if (main_AccountNumber === friendAccountNumber) {
                                            chatHistory.IsNeedTransmit = "false"
                                        }
                                        else chatHistory.IsNeedTransmit = "true"
                                        /* 云缓存 */
                                        toServer_SaveChatHistory(chatHistory)

                                        /* 刷新对应好友的最后一行聊天记录视图 */
                                        for (var i=0; i<main_FriendsList.length; i++) {
                                            if (friendAccountNumber === main_FriendsList[i].accountNumber) {
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
