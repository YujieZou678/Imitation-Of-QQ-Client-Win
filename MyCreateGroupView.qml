/*
function: 创建群聊窗口。
author: zouyujie
date: 2024.5.5
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: self
    width: Screen.width/1707*400
    height: Screen.height/1067*150
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
                        text: "创建群聊"
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
        }  //end 拖动栏
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.preferredWidth: 20
                }
                Item {  //群号
                    Layout.fillHeight: true
                    Layout.preferredWidth: 40
                    Text {
                        text: "群号"
                        anchors.centerIn: parent
                        font {
                            family: mFONT_FAMILY
                            pointSize: 14
                        }
                    }
                }
                Item {  //输入框
                    Layout.fillHeight: true
                    Layout.fillWidth: true
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

                                    Item {
                                        Layout.preferredWidth: 5
                                    }
                                    Item {  //输入框
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        TextField {
                                            id: textField
                                            anchors.fill: parent
                                            verticalAlignment: TextField.AlignVCenter
                                            placeholderText: "注册群号(9个有效数字)"
                                            placeholderTextColor: "#856d72"
                                            validator: RegularExpressionValidator {
                                                regularExpression: /[1-9]\d{8}/
                                            }
                                            background: Rectangle {
                                                color: "#00000000"
                                            }
                                            font {
                                                family: mFONT_FAMILY
                                                pointSize: 13
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
                                    text: "创建"
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 13
                                    }
                                    bacColor: "#baccd9"
                                    clickColor: "#93b5cf"
                                    bacRadius: 5
                                    clickOpacity: 0.6
                                    onClicked: {
                                        /* 服务器：创建群聊 */
                                        if (textField.acceptableInput) {
                                            toServer_CreateGroup(textField.text, main_AccountNumber)
                                        } else console.log("输入不合法！")
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
