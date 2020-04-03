# merge_images in flutter

<a href="https://pub.dev/packages/pull_to_refresh">
  <img src="https://img.shields.io/pub/v/pull_to_refresh.svg"/>
</a>

## 简介 
合并图片（垂直或水平方向）
![Preview](example/preview/preview1.png)

## 特性
* 支持水平和垂直方向
* 提供helper可在代码中合并多张图片并得到合并后的图片，也提供widget直接合并并显示图片。
* 可自动缩放图片以保持一致（垂直时对齐宽度，水平时对齐高度）

## 用法
#### ImagesMergeHelper
使用这个helper在代码中合并图片

``` dart
ui.Image image = await ImagesMergeHelper.margeImages(
[assetImage1,assetImage2,providerImage],///images list
   fit: true,///scale image to fit others
   direction: Axis.vertical,///direction of images
   backgroundColor: Colors.black26);///background color
```
此外，它也提供了几个方法做图片类型的转换:
``` dart
///ui.Image to Uint8List
Uint8List bytes = await ImagesMergeHelper.imageToUint8List(image);
///ui.Image to File
File file = await ImagesMergeHelper.imageToFile(image);
///Uint8List to ui.Image
ui.Image image = await ImagesMergeHelper.uint8ListToImage(imageBytes);
///file to ui.Image
ui.Image image = await ImagesMergeHelper.loadImageFromFile(file);
///asset to ui.Image
ui.Image image = await ImagesMergeHelper.loadImageFromAsset(assetPath);
///ImageProvider to ui.Image
ui.Image image = await ImagesMergeHelper.loadImageFromProvider(imageProvider);

```
#### ImageMerge
使用这个widget直接显示图片
``` dart
ImagesMerge(
  imageList,///images list
  direction: Axis.vertical,///direction
  backgroundColor: Colors.black26,///background color
  fit: false,///scale image to fit others
),
```