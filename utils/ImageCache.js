//处理图片缓存
.pragma library

var imageCache = {}

function getCachedImage(url) {
    return imageCache[url];
}

function cacheImage(url, imageData) {
    if(!imageCache[url]) {
        imageCache[url] = imageData;
    }
}

function clearCache() {
    imageCache = {};
}

function removeFromeCache(url) {
    delete imageCache[url];
}

function getCachedSize() {
    return Object.keys(imageCache).length;
}
