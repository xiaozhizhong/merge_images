import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

///
///@author xiaozhizhong
///@date 2020/4/1
///@description images merge helper
///

class ImagesMergeHelper{
  ///Merge images from a list of ui.Image
  ///[imageList] list of ui.Image
  ///[direction] merge direction, default to vertical
  static Future<ui.Image> fromImages(List<ui.Image> imageList,
      {Axis direction = Axis.vertical}) {
    int totalWidth = 0;
    int totalHeight = 0;
    //calculate width and height of canvas
    imageList.forEach((image) {
      if (direction == Axis.vertical) {
        if (totalWidth < image.width) totalWidth = image.width;
        totalHeight += image.height;
      } else {
        if (totalHeight < image.height) totalHeight = image.height;
        totalWidth += image.width;
      }
    });
    Rect rect =
    Rect.fromLTWH(0, 0, totalWidth.toDouble(), totalHeight.toDouble());
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final paint = Paint();
    Canvas canvas = Canvas(recorder, rect);
    double dx = 0;
    double dy = 0;
    //draw images into canvas
    imageList.forEach((image) {
      canvas.drawImage(image, Offset(dx, dy), paint);
      if (direction == Axis.vertical) {
        dy += image.height;
      } else {
        dx += image.width;
      }
    });
    return recorder.endRecording().toImage(totalWidth, totalHeight);
  }

  ///transfer ui.Image to Unit8List
  ///[image]
  ///[format] default to png
  static Future<Uint8List> imageToUint8List(ui.Image image,
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    ByteData byteData = await image.toByteData(format: format);
    return byteData.buffer.asUint8List();
  }

  ///transfer ui.Image to File
  ///[image]
  ///[path] path to store temporary file, will use [ getTemporaryDirectory ] by path_provider if null
  static Future<File> imageToFile(ui.Image image,{String path}) async{
    Uint8List byte = await imageToUint8List(image);
    final directory = path ?? (await getTemporaryDirectory()).path;
    String fileName = DateTime.now().toIso8601String();
    String fullPath = '$directory/$fileName.png';
    File imgFile = new File(fullPath);
    return await imgFile.writeAsBytes(byte);
  }



  ///load ui.Image from asset
  ///[asset] asset path
  static Future<ui.Image> loadImageFromAsset(String asset) async {
    ByteData data = await rootBundle.load(asset);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  ///load ui.Image from ImageProvider
  ///[provider] ImageProvider
  static Future<ui.Image> loadImageFromProvider(
      ImageProvider provider, {
        ImageConfiguration config = ImageConfiguration.empty,
      }) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener listener;
    ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }
}