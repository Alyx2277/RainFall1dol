import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int previousWidth: 0
    property bool lOr: false // false 是左手， true是右手
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
                    // 真正加载时间轴上动作时间块
                    Repeater {
                        id: rectRepeater
                        model: actionPointsModel

                        DragRectangle {
                            width: model.width
                            height: 30
                            color: "#404040"
                            radius: 5
                            border.color: "#c9c9c9"
                            // border.width: 1
                            x: model.x
                            y: model.y
                            visible: model.visible
                            profileText: "nowHand: "+ lOr


                            onWidthChanged: updateSubsequentItems();

                            function updateSubsequentItems() {
                                for(let i = index+1;i<rectRepeater.count;i++) {
                                    let prevItem = rectRepeater.itemAt(i-1);
                                    let currItem = rectRepeater.itemAt(i);
                                    currItem.x = prevItem.x + prevItem.width+3;

                                    actionPointsModel.setProperty(i, "x", currItem.x);
                                }
                            }
                        }
                    }
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
            }
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
        // 添加新的时间块数据
        var newX = root.previousWidth;
        actionPointsModel.append({x: newX+1, y: 0, visible: true, time:80 ,width: time-3,lOr: root.lOr});

        // 计算并更新最远的x轴位置
        var maxX = 0;
        // 遍历所有时间块找到最大的x值
        for (var i = 0; i < actionPointsModel.count; i++) {
            var currentItem = actionPointsModel.get(i);
            // 考虑时间块自身宽度，计算其右边缘位置
            var rightEdge = currentItem.x + 79; // 80是时间块的宽度
            if (rightEdge > maxX) {
                maxX = rightEdge;
            }
        }

        // 更新previousWidth为最远的位置
        root.previousWidth = maxX;
        console.log("最远时间块位置已更新为: " + root.previousWidth);
    }
    property int time: 80
    ListModel {
        id: actionPointsModel


    }

    function relocation_After_All_TimeRecX() {

    }
}

