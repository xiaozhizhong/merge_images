import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:merge_images/merge_images.dart';
import 'dart:ui' as ui;

import 'image_preview_page.dart';
import 'main.dart';

///
///@author xiaozhizhong
///@date 2020/4/2
///@description images merge widget example page
///
class ImagesMergeWidgetPage extends StatefulWidget {
  @override
  _ImagesMergeWidgetPageState createState() => _ImagesMergeWidgetPageState();
}

class _ImagesMergeWidgetPageState extends State<ImagesMergeWidgetPage> {
  var imageList = <ui.Image>[];
  late ui.Image assetImage1;
  late ui.Image assetImage2;
  late ui.Image providerImage;

  final captureController = CaptureController();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  loadImage() async {
    assetImage1 = await ImagesMergeHelper.loadImageFromAsset("assets/sunset.jpeg");
    assetImage2 = await ImagesMergeHelper.loadImageFromAsset("assets/bridge.jpg");
    providerImage = await ImagesMergeHelper.loadImageFromProvider(NetworkImage(networkImagePath));
    setState(() {
      imageList.add(assetImage1);
      imageList.add(assetImage2);
      imageList.add(providerImage);
    });
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("merge(vertical&fit)"),
              ),
              Offstage(
                offstage: imageList.isEmpty,
                child: Container(
                  width: 100,
                  child: ImagesMerge(
                    imageList,
                    direction: Axis.vertical,
                    fit: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("merge(vertical)"),
              ),
              Offstage(
                offstage: imageList.isEmpty,
                child: Container(
                  width: 100,
                  child: ImagesMerge(
                    imageList,
                    direction: Axis.vertical,
                    backgroundColor: Colors.black26,
                    fit: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("merge(horizontal&fit)"),
              ),
              Offstage(
                offstage: imageList.isEmpty,
                child: Container(
                  height: 70,
                  child: ImagesMerge(
                    imageList,
                    direction: Axis.horizontal,
                    fit: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("merge(horizontal)"),
              ),
              Offstage(
                offstage: imageList.isEmpty,
                child: Container(
                  height: 70,
                  child: ImagesMerge(
                    imageList,
                    direction: Axis.horizontal,
                    fit: false,
                    backgroundColor: Colors.black26,
                    controller: captureController,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => getCapture(context), child: Text("Capture", style: Theme.of(context).textTheme.headline6))
            ],
          ),
        ),
      ),
    );
  }

  ///get capture of widget by RepaintBoundary
  getCapture(context) async {
    Uint8List? bytes = await captureController.capture();
    if (bytes == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Preview(bytes)));
  }
}
