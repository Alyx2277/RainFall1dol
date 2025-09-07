import QtQuick
// components/TitleBar.qml
Rectangle {
    id: titleBar
    color: "#2c3e50"

    property string currentMacroName: "未命名宏"
    property bool isConnected: false

    Row {
        anchors.fill: parent
        spacing: 10

        // 软件logo和标题
        Image {
            source: "qrc:/images/logo.png"
            height: 30
            width: 30
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "键盘宏软件 - " + currentMacroName
            color: "white"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        // 连接状态指示器
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: isConnected ? "#2ecc71" : "#e74c3c"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: isConnected ? "已连接" : "未连接"
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        // 功能按钮区
        Row {
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter

            MacroButton {
                text: "新建"
                onClicked: macroManager.createNewMacro()
            }

            MacroButton {
                text: "保存"
                onClicked: macroManager.saveMacro()
            }

            MacroButton {
                text: "导入"
                onClicked: fileDialog.open()
            }

            MacroButton {
                text: "设置"
                onClicked: settingsDialog.open()
            }
        }

        // 右侧操作按钮
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            MinimizeButton {
                onClicked: mainWindow.showMinimized()
            }

            MaximizeButton {
                onClicked: toggleMaximize()
            }

            CloseButton {
                onClicked: Qt.quit()
            }
        }
    }
}
