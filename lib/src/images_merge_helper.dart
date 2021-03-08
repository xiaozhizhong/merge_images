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

class ImagesMergeHelper {
  ///Merge images from a list of ui.Image
  ///[imageList] list of ui.Image
  ///[direction] merge direction, default to vertical
  ///[fit] Whether to Scale the pictures to same width/height when pictures has
  ///different width/height,
  /// Fit width when direction is vertical, and fit height when horizontal.
  /// Default to true.
  ///[backgroundColor] background color of picture
  static Future<ui.Image> margeImages(List<ui.Image> imageList,
      {Axis direction = Axis.vertical, bool fit = true, Color? backgroundColor}) {
    int maxWidth = 0;
    int maxHeight = 0;
    //calculate max width/height of image
    imageList.forEach((image) {
      if (direction == Axis.vertical) {
        if (maxWidth < image.width) maxWidth = image.width;
      } else {
        if (maxHeight < image.height) maxHeight = image.height;
      }
    });
    int totalHeight = maxHeight;
    int totalWidth = maxWidth;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final paint = Paint();
    Canvas canvas = Canvas(recorder);
    double dx = 0;
    double dy = 0;
    //set background color
    if (backgroundColor != null) canvas.drawColor(backgroundColor, BlendMode.srcOver);
    //draw images into canvas
    imageList.forEach((image) {
      double scaleDx = dx;
      double scaleDy = dy;
      double imageHeight = image.height.toDouble();
      double imageWidth = image.width.toDouble();
      if (fit) {
        //scale the image to same width/height
        canvas.save();
        if (direction == Axis.vertical && image.width != maxWidth) {
          canvas.scale(maxWidth / image.width);
          scaleDy *= imageWidth / maxWidth;
          imageHeight *= maxWidth / imageWidth;
        } else if (direction == Axis.horizontal && image.height != maxHeight) {
          canvas.scale(maxHeight / image.height);
          scaleDx *= imageHeight / maxHeight;
          imageWidth *= maxHeight / imageHeight;
        }
        canvas.drawImage(image, Offset(scaleDx, scaleDy), paint);
        canvas.restore();
      } else {
        //draw directly
        canvas.drawImage(image, Offset(dx, dy), paint);
      }
      //accumulate dx/dy
      if (direction == Axis.vertical) {
        dy += imageHeight;
        totalHeight += imageHeight.floor();
      } else {
        dx += imageWidth;
        totalWidth += imageWidth.floor();
      }
    });
    //output image
    return recorder.endRecording().toImage(totalWidth, totalHeight);
  }

  ///transfer ui.Image to Unit8List
  ///[image]
  ///[format] default to png
  static Future<Uint8List?> imageToUint8List(ui.Image image, {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    ByteData? byteData = await image.toByteData(format: format);
    return byteData?.buffer.asUint8List();
  }

  ///transfer ui.Image to File
  ///[image]
  ///[path] path to store temporary file, will use [ getTemporaryDirectory ]
  ///by path_provider if null
  static Future<File?> imageToFile(ui.Image image, {String? path}) async {
    Uint8List? byte = await imageToUint8List(image);
    if(byte==null) return null;
    final directory = path ?? (await getTemporaryDirectory()).path;
    String fileName = DateTime.now().toIso8601String();
    String fullPath = '$directory/$fileName.png';
    File imgFile = new File(fullPath);
    return await imgFile.writeAsBytes(byte);
  }

  ///transfer Unit8List to ui.Image
  ///[bytes] Uint8List bytes
  static Future<ui.Image> uint8ListToImage(Uint8List bytes) async {
    ImageProvider provider = MemoryImage(bytes);
    return await loadImageFromProvider(provider);
  }

  ///load ui.Image from File
  ///[file] Image file
  static Future<ui.Image> loadImageFromFile(File file) async {
    Uint8List bytes = file.readAsBytesSync();
    return await uint8ListToImage(bytes);
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
    late ImageStreamListener listener;
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
