import 'package:flutter/material.dart';

import 'helper_page.dart';
import 'widget_page.dart';

const networkImagePath = "https://pic.dbw.cn/003/013/364/00301336495_44db9bad.jpg";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Example Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: _toWidget,
                child: Text(
                  "ImagesMerge Widget",
                  style: Theme.of(context).textTheme.headline6,
                )),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: _toHelper,
                child: Text(
                  "ImagesMerge Helper",
                  style: Theme.of(context).textTheme.headline6,
                )),
          ],
        ),
      ),
    );
  }

  _toWidget() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImagesMergeWidgetPage()));
  }

  _toHelper() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImagesMergeHelperPage()));
  }
}
