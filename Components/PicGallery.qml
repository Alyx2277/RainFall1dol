import QtQuick
import QtQuick.Controls
import QtQml.Models
import "../utils" as Utils

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

    property int maxWidth: 640 // 最大最小宽高
    property int maxHeight: 480
    property int minWidth: 400
    property int minHeight: 200
    // 信号
    signal itemClicked(int index,string imageUrl)
    signal loadMoreRequested()
    signal scollPositionChanged(real position)

    // 计算属性
    property real contentY: gridView.contentY
    property real contentHeight: gridView.contentHeight
    // property int visibleItemCount: gridView.visibleItemCount


    // 内部函数 检查项目是否在可见区域附近
    // 控制了加载多少图片
    // function isItemNearView(index) {
    //     if(!enableLazyLoad) return true;

    //     var itemPos = index * cellHeight;
    //     var buffer = preloadMargin * cellHeight;
    //     return itemPos>=(gridView.contentY - buffer) &&
    //             itemPos <= (gridView.contentY + gridView.height + buffer);
    // }
    function isItemNearView(index) {
        if(!enableLazyLoad) return true;

        // 计算网格布局参数
        var columns = Math.floor(gridView.width / cellWidth);
        var rows = Math.ceil(model.count / columns);

        // 计算项目在网格中的位置
        var row = Math.floor(index / columns);
        var col = index % columns;

        // 计算项目在内容中的像素位置
        var itemX = col * cellWidth;
        var itemY = row * cellHeight;

        // 计算缓冲区（考虑X和Y方向）
        var bufferX = preloadMargin * cellWidth;
        var bufferY = preloadMargin * cellHeight;

        // 检查项目是否在可见区域+缓冲区范围内
        var inXRange = itemX >= (gridView.contentX - bufferX) &&
                (itemX + cellWidth) <= (gridView.contentX + gridView.width + bufferX);

        var inYRange = itemY >= (gridView.contentY - bufferY) &&
                (itemY + cellHeight) <= (gridView.contentY + gridView.height + bufferY);

        return inXRange && inYRange;
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

            // 加载图片
            //这里逻辑写的不好，还要修改 2025.9.28
            sourceComponent: {
                if(root.enableLazyLoad && !root.isItemNearView(index)) {
                    console.log("not near ,get index is",index);
                    return placeholderComponent;
                }
                console.log("near ,get index is",index);
                return imageItemComponent;
            }

            // 当项目进入视图时加载真实内容
            onLoaded: {
                if(item && item instanceof PicWindow) {
                    console.log("onLoaded model.url: ",model.url);
                    item.imageSource = model.url || "";
                }
            }
        }
        // 滚动处理
        onContentYChanged: {
            root.scollPositionChanged(contentY / contentHeight);
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
    Component {
        id: placeholderComponent
        Rectangle {
            width: gridView.cellWidth
            height: gridView.cellHeight
            color: "#f0f0f0"
            radius: 4
        }
    }

    // 图片项目组件
    Component{
        id: imageItemComponent
        PicWindow {
            width: gridView.cellWidth
            height: gridView.cellHeight
            // thumbnailSize
            imageSource: model.url || model.imageUrl || ""

            // onImageClicked: {
            //     PicGallery.itemClicked(index,imageUrl);
            // }

            // onImageLoaded: {
            //     if(enableCache) {
            //         // 缓存处理逻辑
            //     }
            // }
        }
    }
    // 滚动延迟处理定时器
    Timer {
        id: scrollTimer
        interval: 150
        onTriggered: root.preloadImages()
    }
    // 内存清理定时器
    // 目前看不出内存清理重要性，好像内存占用还好
    // Timer {
    //     interval: 10000 //十秒清理一次
    //     running: enableLazyLoad
    //     repeat: true
    //     onTriggered: {
    //         if(model && model.count > 100)
    //         {
    //             console.log("enter timer clean");
    //             //清理原理视图的项目
    //         }
    //     }
    // }
    // 组件初始化
    Component.onCompleted: {
        if(model) {
            console.log("PicGallery initialized with", model.count, "items");
        }
    }
}
