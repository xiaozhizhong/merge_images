part of "images_merge.dart";

///
///@author xiaozhizhong
///@date 2020/4/1
///@description painter
///
class _MergePainter extends CustomPainter {
  _MergePainter(this.imageList, this.direction, this.fit, this.scale);

  final List<ui.Image> imageList;
  final Axis direction;
  final bool fit;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    double dx = 0;
    double dy = 0;
    double totalWidth = size.width;
    double totalHeight = size.height;
    Paint paint = Paint();
    imageList.forEach((image) {
      //scale the image to same width/height
      double imageHeight;
      double imageWidth;
      double dxScale = dx;
      double dyScale = dy;
      if (direction == Axis.vertical) {
        if (image.width < totalWidth && !fit) {
          canvas.drawImage(image, Offset(dx, dy), paint);
        } else {
          canvas.save();
          if (!fit) {
            imageHeight = image.height * scale;
            canvas.scale(imageHeight / image.height);
          } else {
            canvas.scale(totalWidth / image.width);
            imageHeight = image.height * totalWidth / image.width;
          }

          dyScale *= image.height / imageHeight;
          canvas.drawImage(image, Offset(dxScale, dyScale), paint);
          canvas.restore();
        }
      } else {
        if (image.height < totalHeight && !fit) {
          canvas.drawImage(image, Offset(dx, dy), paint);
        } else {
          canvas.save();
          if (!fit) {
            imageWidth = image.width * scale;
            canvas.scale(imageWidth / image.width);
          } else {
            canvas.scale(totalHeight / image.height);
            imageWidth = image.width * totalHeight / image.height;
          }
          dxScale *= image.width / imageWidth;
          canvas.drawImage(image, Offset(dxScale, dyScale), paint);
          canvas.restore();
        }
      }
      if (direction == Axis.vertical) {
        dy += imageHeight;
      } else {
        dx += imageWidth;
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
