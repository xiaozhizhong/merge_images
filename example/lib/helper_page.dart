import 'dart:typed_data';

import 'package:example/image_preview_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:merge_images/merge_images.dart';

///
///@author xiaozhizhong
///@date 2020/4/2
///@description images merge helper example page
///
class ImagesMergeHelperPage extends StatefulWidget {
  @override
  _ImagesMergeHelperPageState createState() => _ImagesMergeHelperPageState();
}

class _ImagesMergeHelperPageState extends State<ImagesMergeHelperPage> {
  ui.Image assetImage1;
  ui.Image assetImage2;
  ui.Image providerImage;

  final networkImagePath =
      "http://img.article.pchome.net/00/29/20/31/pic_lib/s960x639/Sakura_28s960x639.jpg";

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  loadImage() async {
    assetImage1 =
        await ImagesMergeHelper.loadImageFromAsset("assets/sunset.jpeg");
    assetImage2 =
        await ImagesMergeHelper.loadImageFromAsset("assets/bridge.jpg");
    providerImage = await ImagesMergeHelper.loadImageFromProvider(
        NetworkImage(networkImagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget Page"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/sunset.jpeg",
                scale: 10,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/bridge.jpg",
                scale: 10,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                height: 10,
              ),
              Image.network(
                networkImagePath,
                scale: 10,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                  onPressed: () => _merge(fit: true, direction: Axis.vertical),
                  child: Text(
                    "vertical & fit",
                    style: Theme.of(context).textTheme.title,
                  )),
              RaisedButton(
                  onPressed: () => _merge(fit: false, direction: Axis.vertical),
                  child: Text(
                    "vertical",
                    style: Theme.of(context).textTheme.title,
                  )),
              RaisedButton(
                  onPressed: () =>
                      _merge(fit: true, direction: Axis.horizontal),
                  child: Text(
                    "horizontal & fit",
                    style: Theme.of(context).textTheme.title,
                  )),
              RaisedButton(
                  onPressed: () =>
                      _merge(fit: false, direction: Axis.horizontal),
                  child: Text(
                    "horizontal",
                    style: Theme.of(context).textTheme.title,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  ///merge images using ImagesMergeHelper and preview
  _merge({bool fit, Axis direction}) async {
    ui.Image image = await ImagesMergeHelper.margeImages(
        [assetImage1, assetImage2, providerImage],
        fit: fit, direction: direction, backgroundColor: Colors.black26);
    Uint8List bytes = await ImagesMergeHelper.imageToUint8List(image);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Preview(bytes)));
  }
}
