import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> lists = ["第一盒", "第二盒", "第三盒"];

  static const eventChannel = EventChannel('com.nativeToFlutter');

  @override
  void initState() {
    super.initState();

    eventChannel.receiveBroadcastStream().listen(_getData, onError: _getError);
  }

  void _getData(dynamic data) {
    String OCString = data.toString();
    if (OCString.length != 0) {
      setState(() {
        lists.add(OCString);
      });
    }
  }

  void _getError(Object error) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildListViewCell(index, lists[index]);
          },
          itemCount: lists.length,
        ),
      ),
    );
  }

  Widget _buildListViewCell(int index, String title) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(title),
            margin: EdgeInsets.only(left: 15),
          ),
          Container(
            child: Text("第${index}条数据"),
            margin: EdgeInsets.only(right: 15),
          ),
        ],
      ),
    );
  }
}
