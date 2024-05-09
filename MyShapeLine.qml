/*
function: 底下那根可以切换的线。
author: zouyujie
date: 2024.4.7
*/
import QtQuick
import QtQuick.Shapes

Shape {

    property real lineWidth: 0  //线宽度
    property string lineColor: "black"  //线颜色
    property real lineOpacity: 1  //线的透明度

    property real lineStartX: 0
    property real lineStartY: 0
    property real lineEndX: 0
    property real lineEndY: 0

    anchors.fill: parent
    opacity: lineOpacity

    ShapePath {
        strokeWidth: lineWidth
        strokeColor: lineColor
        strokeStyle: ShapePath.SolidLine
        startX: lineStartX
        startY: lineStartY
        PathLine {
            x: lineStartX; y: lineStartY
        }
        PathLine {
            x: lineEndX; y: lineEndY
        }
    }

    Behavior on lineStartX {
        NumberAnimation { duration: 300; easing.type: Easing.InQuad; }
    }
    Behavior on lineEndX {
        NumberAnimation { duration: 300; easing.type: Easing.InQuad; }
    }
}
