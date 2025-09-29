import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./Components"

ApplicationWindow {
    id:root
    width: 900
    height: 600
    visible: true
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open...") }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("Cu&t") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

    ListModel {
        id: imageModel
        Component.onCompleted: {
            for (var i = 0; i < 108; i++) {
                // 根据您的实际文件命名规则调整路径
                append({"url": "qrc:/action/images/image" + i + ".png"});
            }
        }
    }

    PicGallery {
        id: gallery
        // anchors.fill: parent
        width: root.width* 0.7 // 540
        height: root.height* 0.6 // 360
        model: imageModel
        columns: 5
        cellWidth: 300
        cellHeight: 300

        onItemClicked: function(index, url) {
            console.log("Clicked item", index, "url:", url);
            // 打开大图查看等操作
        }

        onLoadMoreRequested: {
            console.log("Load more requested");
            // 加载更多图片
        }
    }

    TimelineEditor {
        id: timeline

        anchors {
            bottom: parent.bottom
            bottomMargin: 0
        }
    }
}
