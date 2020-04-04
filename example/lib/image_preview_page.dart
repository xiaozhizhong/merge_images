import 'dart:typed_data';

import 'package:flutter/material.dart';

///
///@author xiaozhizhong
///@date 2020/4/4
///@description images preview page
///
class Preview extends StatelessWidget {
  Preview(this.image);

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("preview"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Image.memory(image),
      ),
    );
  }
}
