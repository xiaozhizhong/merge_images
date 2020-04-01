part of "images_merge.dart";

///
///@author xiaozhizhong
///@date 2020/4/1
///@description painter
///
class _MergePainter extends CustomPainter{

  _MergePainter(this.imageList,this.direction);
  final List<ui.Image> imageList;
  final Axis direction;

  @override
  void paint(Canvas canvas, Size size) {
    double dx = 0;
    double dy = 0;
    Paint paint = Paint();
    imageList.forEach((image) {
      canvas.drawImage(image, Offset(dx, dy), paint);
      if (direction == Axis.vertical) {
        dy += image.height;
      } else {
        dx += image.width;
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate!=this;
  }

}