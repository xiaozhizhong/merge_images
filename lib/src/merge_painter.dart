part of "images_merge.dart";

///
///@author xiaozhizhong
///@date 2020/4/1
///@description painter
///
class _MergePainter extends CustomPainter {
  _MergePainter(this.imageList, this.direction, this.fit);

  final List<ui.Image> imageList;
  final Axis direction;
  final bool fit;

  @override
  void paint(Canvas canvas, Size size) {
    double dx = 0;
    double dy = 0;
    double totalWidth = size.width;
    double totalHeight = size.height;
    Paint paint = Paint();
    imageList.forEach((image) {
      //scale the image to same width/height
      if (fit) {
        canvas.save();
        double scaleDx = dx;
        double scaleDy = dy;
        if (direction == Axis.vertical && image.width != totalWidth) {
          canvas.scale(totalWidth / image.width);
          scaleDy *= image.width / totalWidth;
        } else if (direction == Axis.horizontal &&
            image.height != totalHeight) {
          canvas.scale(totalHeight / image.height);
          scaleDx *= image.height / totalHeight;
        }
        canvas.drawImage(image, Offset(scaleDx, scaleDy), paint);
        canvas.restore();
      } else {
        canvas.drawImage(image, Offset(dx, dy), paint);
      }
      if (direction == Axis.vertical) {
        dy += image.height;
      } else {
        dx += image.width;
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
