/*
function: 单选按钮。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RadioButton {

    property bool ifSelect: false  //是否勾选协议

    function prompt() {  //没勾选协议提示
        myIndicatorAnimation.start()
    }

    id: self
    indicator: Rectangle {
        id: myIndicator
        width: 20
        height: 20
        radius: 100
        border.color: "#b2bbbe"
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: {
                ifSelect = !ifSelect
            }
        }
        SequentialAnimation {
            id: myIndicatorAnimation
            PropertyAnimation {
                target: myIndicator
                property: "scale"
                from: 1
                to: 1.5
                duration: 200
            }
            PropertyAnimation {
                target: myIndicator
                property: "scale"
                from: 1.5
                to: 1
                duration: 200
            }
        }

        Rectangle {
            width: 10
            height: 10
            anchors.centerIn: parent
            radius: 100
            color: "#619ac3"
            visible: ifSelect
        }
    }

    contentItem: RowLayout {
        spacing: 0

        Item {
            Layout.preferredWidth: self.indicator.width
        }
        Text {
            text: "我已阅读并同意"
            color: "#5e7987"
            font.family: mFONT_FAMILY
        }
        Text {
            text: "服务协议"
            color: "#5698c3"
            font.family: mFONT_FAMILY
        }
        Text {
            text: "和"
            color: "#5e7987"
            font.family: mFONT_FAMILY
        }
        Text {
            text: "QQ隐私保护指引"
            color: "#5698c3"
            font.family: mFONT_FAMILY
        }
    }
}
