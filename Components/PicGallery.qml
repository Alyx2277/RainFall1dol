import QtQuick
import QtQuick.Controls
import QtQml.Models
import "utils" as Utils

Item {
    id: root

    // 属性
    property alias model: gridView.model
    property int columns: 4
    property real cellWidth: 150
    property real cellHeight: 150
    property int preloadMargin: 3 // 预加载前后几行的图片
    property bool enableCache: true
    property bool enableLazyLoad: true

    signal itemClicked(int index,string imageUrl)
    signal loadMoreRequested()
    signal scollPositionChanged(real position)

    // 计算属性
    property real contentY: gridView.contentY
    property real contentHeight: gridView.contentHeight
    property int visibleItemCount: gridView.visibleItemCount

    // 内部函数 检查项目是否在可见区域附近
    function isItemNearView(index) {
        if(!enableLazyLoad) return true;

        var itemPos = index * cellHeight;
        var buff = preloadMargin * cellHeight;
        return itemPos>=(gridView.contentY - buffer) &&
                itemPos <= (gridView.contentY + gridView.height + buffer);
    }

    // 内部函数 预加载图片
    function preloadImages() {
        if(!model || model.count === 0) return;

        var firstIndex = Math.max(0, Math.floor(gridView.contentY / cellHeight)-preloadMargin);
        var lastIndex = Math.min(model.count - 1, Math.floor((gridView.contentY + gridView.height) / cellHeight) + preloadMargin);

        for(var i = firstIndex; i <= lastIndex; i++) {
            var item = gridView.itemAt(0,i*cellHeight);
            if(!item) {
                // 触发延迟加载
            }
        }
    }
    // 清除缓存
    function clearCache() {
        Utils.ImageCache.clearCache();
    }
    // 滑动到指定位置
    function scrollTo(position) {
        gridView.contentY = position;
    }
    // 滚动到指定索引
    function scrollToIndex(index) {
        gridView.positionViewAtIndex(index, GridView.Visible);
    }

    // Grid布局
    GridView {
        id: gridView
        anchors.fill: parent
        clip:true
        cacheBuffer: enableLazyLoad ? cellHeight * preloadMargin * 2 : 0

        cellWidth: root.cellWidth
        cellHeight: root.cellHeight

        // 使用动态代理实现延迟加载
        delegate: Loader {
            width: gridView.cellWidth
            height: gridView.cellHeight
            asynchronous: true

            sourceComponent: {
                if(root.enableLazyLoad && !root.isItemNearView(index)) {
                    return placeholdComponent;
                }
                return imageItemComponent;
            }

            // 当项目进入视图时加载真实内容
            onLoaded: {
                if(item && item instanceof PicWindow) {
                    item.imageUrl = model.url || model.imageUrl || "";
                }
            }
        }
        // 滚动处理
        onContentYChanged: {
            root.scrollPostionChanged(contentY / contentHeight);
            if (enableLazyLoad) {
                scrollTimer.restart();
            }
        }
        // 到达底部加载更多
        onMovementEnded: {
            if(atYEnd && model && model.count> 0){
                root.loadMoreRequested();
            }
        }
    }
    // 占位符组件
    // 图片项目组件
    // 滚动延迟处理定时器
    // 内存清理定时器
    // 组件初始化
}
