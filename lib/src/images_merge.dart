import 'dart:math';
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
      {this.direction = Axis.vertical,
      this.controller,
      this.fit = true,
      this.backgroundColor});

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

  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        _calculate(constraint);
        return RepaintBoundary(
          key: controller?.key ?? ValueKey(0),
          child:
              ClipRRect(
                child: Container(
                  color: backgroundColor,
                  child: CustomPaint(
                    painter: _MergePainter(imageList, direction, fit,scale),
                    size: Size(totalWidth.toDouble(), totalHeight.toDouble()),
                  ),
                ),
              )
          ,);
      },
    );
  }

  _scale(){

  }

  ///calculating width and height of canvas
  _calculate(BoxConstraints constraint) {
    //calculate the max width/height of images
    imageList.forEach((image) {
      if (direction == Axis.vertical) {
        if (totalWidth < image.width) totalWidth = image.width;
      } else {
        if (totalHeight < image.height) totalHeight = image.height;
      }
    });
    //calculate the constraint of parent
    if (direction == Axis.vertical &&
        constraint.hasBoundedWidth &&
        totalWidth > constraint.maxWidth) {
      scale = constraint.maxWidth / totalWidth;
      totalWidth = constraint.maxWidth.floor();

    } else if (direction == Axis.horizontal &&
        constraint.hasBoundedHeight &&
        totalHeight > constraint.maxHeight) {
      scale = constraint.maxHeight / totalHeight;
      totalHeight = constraint.maxHeight.floor();

    }
    //calculate the opposite
    imageList.forEach((image) {
      if (direction == Axis.vertical) {
        if (image.width < totalWidth && !fit) {
          totalHeight += image.height;
        } else {
          if (!fit)
            totalHeight += (image.height * scale).floor();
          else
            totalHeight += (image.height * totalWidth / image.width).floor();
        }
      } else {
        if (image.height < totalHeight && !fit) {
          totalWidth += image.width;
        } else {
          if (!fit)
            totalWidth += (image.width * scale).floor();
          else
            totalWidth += (image.width * totalHeight / image.height).floor();
        }
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
