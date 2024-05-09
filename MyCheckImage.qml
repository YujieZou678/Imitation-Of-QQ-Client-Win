/*
function: 检查密码账号输入是否合法的图片。
author: zouyujie
date: 2024.3.19
*/
import QtQuick

Image {

    property bool isRight: false

    function prompt() {  //输入不合法的提示
        myAnimation.start()
    }

    anchors.fill: parent
    source: isRight ? "qrc:/image/正确.png":"qrc:/image/错误.png"
    scale: isRight ? 0.85:0.7
    opacity: 0.8
    visible: false

    SequentialAnimation {
        id: myAnimation
        PropertyAnimation {
            target: parent
            property: "scale"
            from: 1
            to: 1.3
            duration: 200
        }
        PropertyAnimation {
            target: parent
            property: "scale"
            from: 1.3
            to: 1
            duration: 200
        }
    }
}
