import QtQuick
import QtQuick.Controls

Item {
    // components/MacroGallery.qml
    Rectangle {
        id: macroGallery
        color: "#34495e"

        property var macroList: []
        property int currentIndex: -1

        // 搜索框
        TextField {
            id: searchField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            placeholderText: "搜索宏..."
            onTextChanged: filterMacros(text)
        }

        // 宏列表网格视图
        GridView {
            id: macroGrid
            anchors.top: searchField.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            anchors.topMargin: 15

            cellWidth: 100
            cellHeight: 120

            model: macroList
            clip: true

            delegate: MacroThumbnail {
                width: 90
                height: 110
                macroName: modelData.name
                macroImage: modelData.imagePath
                isSelected: index === currentIndex

                onClicked: {
                    currentIndex = index
                    previewPanel.loadMacro(modelData)
                    timelineEditor.loadMacroData(modelData.commands)
                }

                onDoubleClicked: {
                    macroManager.executeMacro(modelData.id)
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }
        }

        // 添加新宏按钮
        FloatingActionButton {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            iconSource: "qrc:/icons/add.png"
            onClicked: macroCreatorDialog.open()
        }

        function filterMacros(searchText) {
            // 实现搜索过滤逻辑
        }
    }
}
