/*
function: 密码是否显示图片。
author: zouyujie
date: 2024.3.23
*/
import QtQuick

Image {

    property bool showPassWord: false  //是否显示密码

    anchors.fill: parent
    source: showPassWord ? "qrc:/image/密码显示.png":"qrc:/image/@2x密码不显示.png"
    scale: 0.8
    MouseArea {
        anchors.fill: parent
        onClicked: {
            showPassWord = !showPassWord
        }
    }
}
