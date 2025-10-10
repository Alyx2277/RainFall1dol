import QtQuick

Rectangle {
    id:timeRec
    property int enableSize: 12
    property bool isPressed: false
    property point customPoint
    color: "#00debff3"
    border.color: "#d37e49"
    property string profileText: "init"
    readonly property int minWidth: 80
    readonly property int minHeight: 30
    property bool isDragging: false

    signal dragTimeRecFinish()
    Text{
        text: profileText
        color: "#D9E4E7"
        anchors.centerIn: parent
    }
    MouseArea {

        id: mouseArea
        anchors.fill: timeRec
        // drag.target: parent
    }

    Item
    {
        id: right
        width: enableSize
        height: 30
        anchors.right: parent.right
        // anchors.top: rightTop.bottom
        // anchors.bottom: rightBottom.top
        onFocusChanged: {console.log("focus change,lose focus");}

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true

            onPressed: function(mouse) {
                isDragging = true;
                // 暂时禁用Flickable的滑动
                flickableScrollView.interactive = false;
                press(mouse)}
            onEntered: enter(6)
            onReleased: {
                isDragging = false;
                // 恢复Flickable的滑动
                flickableScrollView.interactive = true;
                release();

                // [完成]TODO：这里还要做处理后面的时间块位置的工作
                // 可能可以用发出信号？or what ever
                relocationWidth();
                dragTimeRecFinish()
            }
            onMouseXChanged: positionChange(Qt.point(mouseX, customPoint.y), 1, 1)
        }
    }

    function enter(direct)
    {
    }

    function press(mouse)
    {
        console.log("prease mouse");
        isPressed = true
        customPoint = Qt.point(mouse.x, mouse.y)
    }

    function release()
    {
        isPressed = false
        console.log("release mouse");
    }

    function positionChange(newPosition, directX, directY) {
        if(!isPressed) return;

        // 计算与起始点的相对偏移
        var deltaX = newPosition.x - customPoint.x;
        // var deltaY = newPosition.y - customPoint.y;

        // 简化宽高计算逻辑
        if(directX >= 0) {
            width = Math.max(minWidth, width + deltaX);
        } else {
            x += deltaX;
            width = Math.max(minWidth, width - deltaX);
        }
        // 更新起始点，使下一次计算更准确
        customPoint = newPosition;

        // 应用边界限制
        applyBoundsRestrictions();
    }

    // 分离边界限制逻辑
    function applyBoundsRestrictions() {
        // 使用父容器作为边界参考，而非跨组件引用dragBackground
        var parentRect = parent;
        x = Math.max(0, Math.min(parentRect.width - width, x));
    }

    function relocationWidth(){
        var i = timeRec.width%40;
        if(i>20) {
            timeRec.width+=(37-i);
        } else {
            timeRec.width-=(i+3);
        }
    }
}
