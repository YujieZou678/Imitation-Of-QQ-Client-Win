/*
function: 菜单，有设置，退出，帮助等选择。
author: zouyujie
date: 2024.4.6
*/
import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {

    property string enterColor: "#e2e1e4"

    anchors.fill: parent
    opacity: 0.85
    radius: 5
    layer.enabled: true
    layer.effect: DropShadow {  //阴影
        color:  "#c0c4c3"
        samples: 17
        radius: 8
    }

    ColumnLayout {  //内容
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillHeight: true
        }
        Rectangle {  //设置
            Layout.fillWidth: true
            Layout.preferredHeight: 63
            color: "#00000000"
            opacity: 0.7
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = enterColor
                }
                onExited: {
                    parent.color = "#00000000"
                }
                onClicked: {
//                    personalSettingView.visible = true
//                    personalSettingView.raise()
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 175
                    Text {
                        text: "设置"
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pointSize: 13
                            family: mFONT_FAMILY
                        }
                        color: "#737c7b"
                    }
                }
            }
        }
        Rectangle {  //关于QQ
            Layout.fillWidth: true
            Layout.preferredHeight: 63
            opacity: 0.7
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = enterColor
                }
                onExited: {
                    parent.color = "#00000000"
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 175
                    Text {
                        text: "关于QQ"
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pointSize: 13
                            family: mFONT_FAMILY
                        }
                        color: "#737c7b"
                    }
                }
            }
        }
        MenuSeparator { Layout.fillWidth: true }
        Rectangle {  //退出
            Layout.fillWidth: true
            Layout.preferredHeight: 63
            opacity: 0.7
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = enterColor
                }
                onExited: {
                    parent.color = "#00000000"
                }
                onClicked: {
                    Qt.quit()
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Image {
                        width: 28
                        height: 28
                        anchors.centerIn: parent
                        source: "qrc:/image/退出.png"
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 175

                    Text {
                        text: "退出"
                        anchors.verticalCenter: parent.verticalCenter
                        font {
                            pointSize: 13
                            family: mFONT_FAMILY
                        }
                        color: "#737c7b"
                    }
                }
            }
        }
    }

//    PersonalSettingView {
//        id: personalSettingView
//        visible: false
//    }
}
