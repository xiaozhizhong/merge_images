# merge_images in flutter

<a href="https://pub.dev/packages/pull_to_refresh">
  <img src="https://img.shields.io/pub/v/pull_to_refresh.svg"/>
</a>

[中文文档](README(CH).MD)

## Intro 
Merge images (Image stitching) in vertical or horizontal direction.
![Preview](example/preview/preview1.png)

## Features
* Support vertical and horizontal direction.
* Provide a helper to merge images in code and get a result image, and a widget to automatically merge and show images.
* Automatically scale the image to fit other images (fit width in vertical, and height in horizontal).

## Usage
#### ImagesMergeHelper
Use this helper to merge images in code.

``` dart
ui.Image image = await ImagesMergeHelper.margeImages(
[assetImage1,assetImage2,providerImage],///images list
   fit: true,///scale image to fit others
   direction: Axis.vertical,///direction of images
   backgroundColor: Colors.black26);///background color
```
Besides, it provider some functions to do image format conversion:
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
Use this widget to automatically merge and show images.
``` dart
ImagesMerge(
  imageList,///images list
  direction: Axis.vertical,///direction
  backgroundColor: Colors.black26,///background color
  fit: false,///scale image to fit others
),
```
