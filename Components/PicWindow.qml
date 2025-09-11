import QtQuick
import Qt5Compat.GraphicalEffects

Item{
    id: root

    property string imageSource: "" //图片路径
    property real borderRadius: 8

    Image {
        id: actualImage
        anchors.fill: parent
        source: root.imageSource
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        visible: status == Image.Ready

        layer.enabled: root.borderRadius > 0
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: actualImage.width
                height: actualImage.height
                radius: root.borderRadius
            }
        }
    }
    // 边框
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#e0e0e0"
        radius: root.borderRadius
    }
}

