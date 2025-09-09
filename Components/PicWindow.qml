import QtQuick

Image {
    id: root

    property string imageSource: "" //图片路径
    source: imageSource

    fillMode: Image.PreserveAspectFit //保持宽高比，不变形


}
