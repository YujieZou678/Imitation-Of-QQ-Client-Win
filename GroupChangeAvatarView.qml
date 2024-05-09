/*
function: 更换群头像视图。
author: zouyujie
date: 2024.5.8
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import Qt5Compat.GraphicalEffects

Window {

    property int index: -1  //该群聊位于好友列表index
    property string profileImage: "qrc:/image/profileImage.png"

    id: self

    width: Screen.width/1707*500
    height: Screen.height/1067*(550+75)
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理
    onYChanged: {
        if (y > Screen.desktopAvailableHeight - 30) {
            self.showMinimized()
        }
    }
    onVisibilityChanged: {
        if (self.visibility === Window.Windowed) {
            self.x = (Screen.desktopAvailableWidth-width)/2
            self.y = (Screen.desktopAvailableHeight-height)/2
        }
    }

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
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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
        Item {  //中间信息
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 25
                }
                Item {  //中间内容
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {  //上传本地照片按钮
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80

                            Item {  //上传本地照片按钮
                                anchors.verticalCenter: parent.verticalCenter
                                width: 150
                                height: 40
                                MyToolButton {
                                    iconSource: "qrc:/image/上传.png"
                                    iconWidth: 30
                                    iconHeight: 30
                                    clickColor: "#e2e1e4"
                                    opacity: 0.6
                                    bacColor: "white"
                                    borderWidth: 1
                                    text: "上传本地照片"
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 11
                                    }
                                    onClicked: {
                                        fileDialog.open()
                                    }
                                }
                            }
                        }
                        Item {  //中间照片
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Image {
                                id: image
                                anchors.fill: parent
                                source: profileImage
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                            }
                            ColorOverlay {  //颜色滤镜
                                id: colorOverlay
                                anchors.fill: parent
                                source: image
                                color: "#35000000"
                            }
                            MyProfileImage {  //头像
                                id: myProfileImage
                                y: 10
                                anchors.fill: parent
                                imageHeight: imgSrc==="qrc:/image/profileImage.png" ? height*0.75:height
                                imageWidth: imgSrc==="qrc:/image/profileImage.png" ? width*0.75:width
                                imgSrc: profileImage
                                imgRadius: 450
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 25
                }
            }
        }
        Rectangle {  //确定按钮
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: "#e2e1e4"
            opacity: 0.5

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Item {  //确定按钮
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Item{
                        width: parent.width
                        height: parent.height*0.6
                        anchors.verticalCenter: parent.verticalCenter

                        MyToolButton {
                            Text {
                                text: "确定"
                                anchors.centerIn: parent
                                color: "#eeffffff"
                                font {
                                    family: mFONT_FAMILY
                                    pointSize: 10
                                    bold: true
                                }
                            }
                            bacColor: "#11659a"
                            clickColor: "#5698c3"
                            onClicked: {
                                if (main_FriendsList[index].profileImage === image.source+"") {
                                    self.close()
                                    return
                                }

                                main_FriendsList[index].profileImage = image.source+""
                                /* 好友列表刷新（只有自己） */
                                var data = layoutUserView.msgListView.listModel.get(index)
                                data.profileImage = main_FriendsList[index].profileImage
                                layoutUserView.msgListView.listModel.set(index, data)
                                /* 群资料刷新 */
                                layoutUserView.msgListView.loaderSource = "MyGroupChatView.qml"
                                var item = layoutUserView.msgListView.repeater.itemAt(index).item
                                item.groupProfileImage = main_FriendsList[index].profileImage

                                console.log("开始缓冲")
                                /* 上传到服务器 */
                                function onReply() {
                                    console.log("服务端文件接收完毕,退出缓冲");
                                    onFinished_SeverReceiveFile.disconnect(onReply)  //连接
                                }
                                onFinished_SeverReceiveFile.connect(onReply)  //连接

                                /* 处理地址：file:///... */
                                var source = main_FriendsList[index].profileImage.split("/")
                                source.shift()
                                source.shift()
                                source.shift()
                                source = source.join("/")
                                //source = "/"+source
                                toServer_PrepareSendFile(source, groupNumber)  //准备发送文件

                                self.close()
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20
                }
                Item {  //取消按钮
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Item{
                        width: parent.width
                        height: parent.height*0.6
                        anchors.verticalCenter: parent.verticalCenter

                        MyToolButton {
                            text: "取消"
                            font {
                                family: mFONT_FAMILY
                                pointSize: 10
                            }
                            bacColor: "white"
                            clickColor: "#baccd9"
                            onClicked: {
                                self.close()
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 15
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFile
        nameFilters: ["Image File(*.png *.jpg)"]
        acceptLabel: "确定"
        rejectLabel: "取消"
        onAccepted: {
            image.source = file+""
            myProfileImage.imgSrc = file+""
        }
    }
}
