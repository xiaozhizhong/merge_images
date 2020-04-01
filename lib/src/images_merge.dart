import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

part "merge_painter.dart";

///
///@author xiaozhizhong
///@date 2020/4/1
///@description images merge widget
///
// ignore: must_be_immutable
class ImagesMerge extends StatelessWidget {
  ImagesMerge(this.imageList,
      {this.direction = Axis.vertical, this.controller, this.fit = true,this.backgroundColor});

  ///List of images list, content must be ui.Image.
  ///If you have another format of image, you can transfer it to ui.Image by [ImagesMergeHelper].
  final List<ui.Image> imageList;

  ///Merge direction, default to vertical.
  final Axis direction;

  ///Whether to Scale the pictures to same width/height when pictures has different width/height,
  ///Fit width when direction is vertical, and fit height when horizontal.
  ///Default to true.
  final bool fit;

  ///background color
  final Color backgroundColor;

  ///Controller to capture screen.
  final CaptureController controller;

  int totalWidth = 0;
  int totalHeight = 0;

  @override
  Widget build(BuildContext context) {
    _calculate();

    return RepaintBoundary(
      key: controller.key ?? ValueKey(0),
      child: Container(
        color: backgroundColor,
        child: CustomPaint(
          painter: _MergePainter(imageList, direction, fit),
          size: Size(totalWidth.toDouble(), totalHeight.toDouble()),
        ),
      ),
    );
  }

  ///calculating width and height of canvas
  _calculate() {
    imageList.forEach((image) {
      if (direction == Axis.vertical) {
        if (totalWidth < image.width) totalWidth = image.width;
        totalHeight += image.height;
      } else {
        if (totalHeight < image.height) totalHeight = image.height;
        totalWidth += image.width;
      }
    });
  }
}

/// Screen shot capture controller
class CaptureController {
  CaptureController({@required this.key});

  final GlobalKey key;

  ///capture the screen shot by RepaintBoundary
  Future<Uint8List> capture() async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: dpr);

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
