/*
function: 功能按钮, 如：最小化，关闭按钮。
author: zouyujie
date: 2024.3.22
*/
import QtQuick
import QtQuick.Controls

ToolButton {

    property string iconSource: ""
    property int iconHeight: 40
    property int iconWidth: 40

    property string clickColor: "#f07c82"
    property string bacColor: "#00000000"  //背景色
    property int bacRadius: 0
    property real clickOpacity: 1
    property int borderWidth: 0  //边框宽度

    id: self

    anchors.fill: parent
    icon.source: iconSource
    icon.height: iconHeight
    icon.width: iconWidth
    background: Rectangle {  //背景
        color: self.down ? clickColor:bacColor
        opacity: clickOpacity
        border.width: borderWidth
        border.color: "lightgray"
        radius: bacRadius
    }
}
