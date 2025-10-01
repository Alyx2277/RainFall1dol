import QtQuick
import QtQuick.Controls

Item {
    id: root

    width:parent.width
    height: 230

    // 标题
    Rectangle {
        id:titleRec
        width: root.width
        height: 30
        x:0
        y:0

        Text {
            id: titleText
            text: qsTr("动作时间轴")
        }
    }
    // 按钮
    Rectangle {
        // 容器属性
        id: controlContainer
        width: root.width  // 总宽度，根据按钮数量和间距调整
        height: 40  // 高度，略大于按钮尺寸
        color: "#f0f0f0"  // 浅灰色背景
        radius: 4   // 圆角效果
        border.color: "#ddd"  // 边框颜色
        border.width: 1       // 边框宽度
        x:0
        y:30
        // 开始播放按钮
        Button {
            id: playButton
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "play"  // 播放图标
            // tooltip: qsTr("开始播放")
            text: qsTr("开始")

            // 按钮点击事件
            onClicked: {
                console.log("开始播放");
                createActionPoints();
                // 在这里添加开始播放的逻辑
            }
        }

        // 停止播放按钮
        Button {
            id: stopButton
            anchors.left: playButton.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "stop"  // 停止图标
            text: qsTr("停止播放")

            // 按钮点击事件
            onClicked: {
                console.log("停止播放")
                // 在这里添加停止播放的逻辑
            }
        }

        // 删除按钮
        Button {
            id: deleteButton
            anchors.left: stopButton.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            icon.name: "delete"  // 删除图标
            text: qsTr("删除")

            // 按钮点击事件
            onClicked: {
                console.log("删除")
                // 在这里添加删除的逻辑
            }
        }
    }

    // 时间轴
    Rectangle {
        id:frameview

        x: 0
        y: 70
        width: parent.width
        height: parent.height - y
        color: "#ffffff"

        ScrollView {
            id: scrollView
            x: 200
            y: 40
            width: parent.width-x
            height: parent.height-y
            clip: true // 确保内容在边界内显示
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            Flickable {
                id: flickableScrollView
                contentWidth: item1.width+200
                contentHeight: item1.height
            }

            Item {
                id: item1
                width: childrenRect.width
                height: childrenRect.height

                Rectangle {
                    id: recAni1
                    x: 0
                    y: 0
                    width: 3000
                    height: 30
                    color: "#8a8a8a"

                    // Rectangle {
                    //     id: recFrame1
                    //     x: 279
                    //     y: 1
                    //     width: 200
                    //     height: 28
                    //     color: "#404040"
                    //     border.color: "#ffffff"
                    //     border.width: 2
                    // }

                    // Rectangle {
                    //     id: recFrame2
                    //     x: 558
                    //     y: 1
                    //     width: 344
                    //     height: 28
                    //     color: "#404040"
                    //     border.color: "#ffffff"
                    //     border.width: 2
                    // }
                }

                Rectangle {
                    id: recAni2
                    x: 0
                    y: 30
                    width: parent.width
                    height: 30
                    color: "#c9c9c9"
                }

                Rectangle {
                    id: recAni3
                    x: 0
                    y: 60
                    width: parent.width
                    height: 30
                    color: "#8a8a8a"
                }
            }
            // 真正加载时间轴上动作时间块
            Repeater {
                model: actionPointsModel

                Rectangle {
                    width: 80
                    height: 30
                    color: "#404040"
                    radius: 5
                    border.color: "#c9c9c9"
                    x: model.x
                    y: model.y
                    visible: model.visible
                }
            }
        }

        // 左边时间轴
        ScrollView {
            id: scrollView1
            x: 0
            y: 40
            width: 200
            height: parent.height-y
            clip: true // 确保内容在边界内显示
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Flickable {
                id: flickableScrollView1
                contentWidth: 0
                contentHeight: 0
                interactive: false // 禁用鼠标滑动
                contentY: flickableScrollView.contentY
            }


            Rectangle {
                id: rectangle1
                x: 0
                y: 0
                width: 200
                height: 30
                color: "#404040"
                Text {
                    color: "white"
                    anchors.centerIn: parent
                    text: qsTr("人物动作轴")
                }
            }

            Rectangle {
                id: rectangle2
                x: 0
                y: 30
                width: 200
                height: 30
                color: "#616161"
                Text {
                    color: "white"
                    anchors.centerIn: parent
                    text: qsTr("音乐轴")
                }
            }


            Rectangle {
                id: rectangle3
                x: 0
                y: 60
                width: 200
                height: 30
                color: "#404040"
                Text {
                    color: "white"
                    anchors.centerIn: parent
                    text: qsTr("场景动作轴")
                }
            }
        }

        ScrollView {
            id: scrollView2
            x: 200
            y: 0
            width: parent.width-x
            height: 40
            clip: true // 确保内容在边界内显示
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Flickable {
                id: flickableScrollView2
                contentWidth: 0
                contentHeight: 0
                interactive: false // 禁用鼠标滑动
                contentX: flickableScrollView.contentX

                //                onContentYChanged: {
                //                    // 当 ScrollView 2 滚动时，同步 ScrollView 1 的滚动位置
                //                    flickableScrollView.contentY = contentY;
                //                }

            }

            // Rectangle {
            //     id: recTimeruler
            //     x: 0
            //     y: 0
            //     width: parent.width
            //     height: 40
            //     color: "#aeaeae"

            //     Text {
            //         id: text1
            //         x: 605
            //         y: 8
            //         text: qsTr("100")
            //         font.pixelSize: 20
            //     }
            // }
            TimelineRuler {
                id: recTimeruler

                x: 0
                y: 0
                width: 8000
                height: 40

                startYear: 0
                endYear: 200
            }
        }

        Rectangle {
            id: recTimerulerMenu
            x: 0
            y: 0
            width: 200
            height: 40
            color: "#aeaeae"
            border.width: 1
        }
    }
    function createActionPoints() {
        // 添加关键点数据到模型
        actionPointsModel.append({x: recTimeruler.x-5, y: 0, visible: true});
        // 可以根据需要添加更多关键点
    }
    ListModel {
        id: actionPointsModel
    }
}

