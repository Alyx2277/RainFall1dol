import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./Components"

ApplicationWindow {
    width: 800
    height: 680
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

    PicWindow {
        width: 400
        height: 400
        imageSource: "qrc:/action/images/image0.png"
    }

    TimelineEditor {
        id: timeline

    }
}
