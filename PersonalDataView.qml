/*
function: 个人资料视图。
author: zouyujie
date: 2024.4.11
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {

    id: self

    width: Screen.width/1707*800
    height: Screen.height/1067*600
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

    RowLayout {  //信息
        anchors.fill: parent
        spacing: 0

        Item {  //左半边
            Layout.fillHeight: true
            Layout.preferredWidth: self.width/2

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Item {  //封面
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.7
                    Image {
                        source: "qrc:/image/12.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                Rectangle {  //头像
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.3
                    color: "gray"

                    Item {
                        anchors.centerIn: parent
                        width: parent.width*0.7
                        height: parent.height*0.5
                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {  //头像
                                Layout.fillHeight: true
                                Layout.preferredWidth: parent.width*0.4
                                MyProfileImage {
                                    id: myProfileImage
                                    imgSrc: main_ProfileImage
                                    width: 100
                                    height: 100
                                    imageHeight: main_ProfileImage==="qrc:/image/profileImage.png" ? height*0.75:height*0.93
                                    imageWidth: main_ProfileImage==="qrc:/image/profileImage.png" ? width*0.75:width*0.93
                                    anchors.centerIn: parent
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: {
                                            myProfileImage.scale = 1.1
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            myProfileImage.scale = 1
                                        }
                                        onClicked: {  //点击头像
                                            changeAvatarView.visible = true
                                            changeAvatarView.raise()
                                        }
                                    }
                                    Behavior on scale {
                                        NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                                    }
                                }
                            }
                            Item {  //名称
                                Layout.fillHeight: true
                                Layout.preferredWidth: parent.width*0.6

                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    height: 60

                                    Text {
                                        id: userName
                                        width: parent.width
                                        text: main_NickName
                                        font {
                                            pointSize: 18
                                            family: mFONT_FAMILY
                                            bold: true
                                        }
                                        elide: Qt.ElideRight
                                        color: "#eeffffff"
                                    }
                                    Text {
                                        id: personalSignature
                                        width: parent.width
                                        text: main_PersonalSignature
                                        anchors.top: userName.bottom
                                        anchors.topMargin: 15
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        elide: Qt.ElideRight
                                        color: "#eeffffff"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Item {  //右半边
            Layout.fillHeight: true
            Layout.preferredWidth: self.width/2

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20
                }
                Item {  //中间
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }
                        Item {  //qq号
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //qq号图标
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                    Image {
                                        height: parent.height*0.7
                                        width: parent.height*0.7
                                        source: "qrc:/image/QQ-1.png"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //qq号
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 100
                                    Text {
                                        text: main_AccountNumber
                                        font {
                                            pointSize: 12
                                            family: mFONT_FAMILY
                                        }
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                }
                                Item {  //编辑资料
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 70
                                    Text {
                                        text: "编辑资料"
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 12
                                            family: mFONT_FAMILY
                                        }
                                        color: "#5698c3"
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: {
                                                cursorShape = Qt.PointingHandCursor
                                            }
                                            onClicked: {
                                                personalDataEditView.visible = true
                                                personalDataEditView.raise()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Item {  //属相
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //属相图标
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                    Image {
                                        source: "qrc:/image/用户.png"
                                        height: parent.height*0.7
                                        width: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text {
                                        text: "属"+main_ZodiacSign
                                        font {
                                            pointSize: 12
                                            family: mFONT_FAMILY
                                        }
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                        Item {  //等级
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //等级图标
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                    Image {
                                        source: "qrc:/image/重要等级.png"
                                        height: parent.height*0.7
                                        width: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //等级
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        Item {  //等级图标1
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 32

                                            Image {
                                                height: parent.height*0.7
                                                width: parent.height*0.7
                                                source: "qrc:/image/等级.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        Item {  //等级图标2
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 32
                                            Image {
                                                height: parent.height*0.7
                                                width: parent.height*0.7
                                                source: "qrc:/image/等级.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        Item {  //等级图标3
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 32
                                            Image {
                                                height: parent.height*0.7
                                                width: parent.height*0.7
                                                source: "qrc:/image/等级.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                        Item {  //空间
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //空间图标
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                    Image {
                                        source: "qrc:/image/QQ空间.png"
                                        height: parent.height*0.7
                                        width: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //XX的空间
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: main_NickName+"的空间"
                                        font {
                                            pointSize: 12
                                            family: mFONT_FAMILY
                                        }
                                    }
                                }
                            }
                        }
                        Item {  //分割线1
                            Layout.fillWidth: true
                            Layout.preferredHeight: 12
                            MenuSeparator { width: parent.width; anchors.centerIn: parent }
                        }
                        Item {  //Q龄
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //Q龄图标
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                    Image {
                                        source: "qrc:/image/ic_聊天.png"
                                        height: parent.height*0.7
                                        width: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //Q龄
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 85
                                    Text {
                                        text: "Q龄"
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        color: "gray"
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text {
                                        text: main_Old + "年"
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                    }
                                }
                            }
                        }
                        Item {  //血型
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 40
                                }
                                Item {  //血型
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 85
                                    Text {
                                        text: "血型"
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        color: "gray"
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text {
                                        text: main_BloodGroup
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                    }
                                }
                            }
                        }
                        Item {  //分割线2
                            Layout.fillWidth: true
                            Layout.preferredHeight: 12
                            MenuSeparator { width: parent.width; anchors.centerIn: parent }
                        }
                        Item {  //照片墙
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //照片墙
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 40
                                    Text {
                                        text: "照片墙"
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            pointSize: 12
                                            family: mFONT_FAMILY
                                        }
                                    }
                                }
                                Item {  //图片
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/image/12.png"
                                        fillMode: Image.PreserveAspectCrop
                                    }
                                }
                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 10
                                }
                            }
                        }
                    }
                }  //end 中间
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20
                }
            }
        }
    }

    ColumnLayout {  //关闭栏
        y: 10
        anchors.fill: parent

        Item {
            y: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 35

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
                        icon.color: "gray"
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
                        icon.color: "gray"
                        onClicked: {
                            self.close()
                        }
                    }
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    ChangeAvatarView {  //更换头像视图
        id: changeAvatarView
        visible: false
    }

    PersonalDataEditView {  //个人信息编辑视图
        id: personalDataEditView
        visible: false
    }
}
