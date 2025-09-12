import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
Item{
    id: root

    property string imageSource: "" //图片路径
    property real borderRadius: 8
    property string placeholderText: "暂无图片" //占位文字
    property color placeholderColor: "#f0f0f0" //占位背景色
    property color textColor: "#999999"

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
    // 占位符（图片加载中和加载失败的显示）
    Rectangle {
        id: placeholder
        anchors.fill: parent
        color: root.placeholderColor
        radius: root.borderRadius
        visible: actualImage.status !== Image.Ready

        Text {
            anchors.centerIn: parent
            text: {
                if (actualImage.status === Image.Loading) return "加载中..."
                if (actualImage.status === Image.Error) return "加载失败"
                return root.placeholderText
            }
            color: root.textColor
            font.pixelSize: 14
        }

        //旋转加载指示器
        BusyIndicator {
            anchors.centerIn: parent
            running: actualImage.status === Image.Loading
            visible: running
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

