/*
function: 群消息记录, ListView。
author: zouyujie
date: 2024.5.6
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {

    property alias listModel: listModel
    property alias scrollBar: scrollBar

    property string groupNumber: ""  //群号

    function friendProfileImage(SendMsgNumber) {  //获取好友头像
        var file = cache_Path+"/config/profileImage/"+SendMsgNumber+".jpg"
        /* 处理地址：file:///... */
        var source = file.split("/")
        source.shift()
        source.shift()
        source.shift()
        source = source.join("/")
        if (fileIsExit(source)) {
            /* 该头像存在 */
            return cache_Path+"/config/profileImage/"+SendMsgNumber+".jpg"
        }

        return "qrc:/image/profileImage.png"
    }

    function updateData() {  //刷新所有聊天记录
        listModel.clear()
        for (var i=0; i<main_FriendsList.length; i++) {
            if (main_FriendsList[i].accountNumber === groupNumber) {
                /* 找到对应群数据 */
                var chatHistory = main_FriendsList[i].chatHistory  //聊天记录列表
                for (var j=0; j<chatHistory.length; j++) {
                    /* 初始化聊天记录 */
                    var data = {}
                    data.isMyMsg = chatHistory[j].IsMyMsg
                    data.msg = chatHistory[j].Msg
                    data.sendMsgNumber = chatHistory[j].SendMsgNumber
                    listModel.append(data)
                }

                break
            }
        }
    }

    function addMsgData(Msg) {  //增加一条聊天信息
        var data = {}
        data.sendMsgNumber = Msg.SendMsgNumber
        data.isMyMsg = Msg.IsMyMsg
        data.msg = Msg.Msg
        listModel.append(data)
        scrollBar.position = 1
    }

    anchors.fill: parent

    ListView {
        id: listView
        anchors.fill: parent
        model: ListModel {
            id: listModel
        }
        delegate: listViewDelegate
        clip: true
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            anchors.right: parent.right
            Component.onCompleted: {
                position = 1
            }
        }
    }

    Component {  //一条消息
        id: listViewDelegate
        Rectangle {
            id: listViewDelegateItem
            Text {  //提前获取消息的高度
                id: testText
                visible: false
                text: msg
                font.pointSize: 12
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.4
                width: 500  //设置最长宽度
            }

            height: testText.contentHeight+50  //弹性变化
            width: listView.width
            //color: "red"

            RowLayout {
                anchors.fill: parent
                spacing: 0
                /* 非本人发的消息 */
                Item {  //头像
                    Layout.fillHeight: true
                    Layout.preferredWidth: 70
                    visible: sendMsgNumber===main_AccountNumber? false:true
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                        }
                        MyProfileImage {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            imgSrc: friendProfileImage(sendMsgNumber)
                            imageHeight: friendProfileImage(sendMsgNumber)==="qrc:/image/profileImage.png" ? 50*0.75:50
                            imageWidth: friendProfileImage(sendMsgNumber)==="qrc:/image/profileImage.png" ? 50*0.75:50
                            imgRadius: parent.width
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
                Item {  //消息
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: sendMsgNumber===main_AccountNumber? false:true

                    Rectangle {  //消息
                        height: testText.contentHeight+10
                        width: testText.contentWidth+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.preferredHeight: 11
                                Layout.fillWidth: true
                            }
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Text {
                                    anchors.centerIn: parent
                                    text: msg
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 12
                                    }
                                    wrapMode: Text.Wrap
                                    lineHeight: 1.4
                                    width: testText.contentWidth
                                }
                            }
                            Item {
                                Layout.preferredHeight: 5
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                /* 本人发的消息 */
                Item {  //消息
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: sendMsgNumber===main_AccountNumber? true:false

                    Rectangle {  //消息
                        height: testText.contentHeight+10
                        width: testText.contentWidth+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.preferredHeight: 11
                                Layout.fillWidth: true
                            }
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Text {
                                    anchors.centerIn: parent
                                    text: msg
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 12
                                    }
                                    wrapMode: Text.Wrap
                                    lineHeight: 1.4
                                    width: testText.contentWidth
                                }
                            }
                            Item {
                                Layout.preferredHeight: 5
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
                Item {  //头像
                    Layout.fillHeight: true
                    Layout.preferredWidth: 70
                    visible: sendMsgNumber===main_AccountNumber? true:false
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                        }
                        MyProfileImage {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            imgSrc: main_ProfileImage
                            imageHeight: main_ProfileImage==="qrc:/image/profileImage.png" ? 50*0.75:50
                            imageWidth: main_ProfileImage==="qrc:/image/profileImage.png" ? 50*0.75:50
                            imgRadius: parent.width
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }
        }
    }
}
