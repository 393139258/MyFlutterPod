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
  List<String> lists = ["点击选择图片", "增加一行", "第三盒"];

  //用户原生传递消息过来
  static const eventChannel = EventChannel('com.nativeToFlutter');

  //flutter回传参数
  static const MethodChannel _methodChannel =
      const MethodChannel("com.flutterToNative");

  int textureId = -1;

  void flutterGetOcMethod(int index) async {
    if (index == 0) {
      chooseImages();
    } else if (index == 1) {
      addLine();
    } else {
      otherMethod();
    }
  }

  void otherMethod() {
    _methodChannel.invokeMethod("otherMethod");
  }

  //调用原生的图片选择
  void chooseImages() {
    _methodChannel.invokeMethod("popImagePicker");
  }

  //增加一行
  void addLine() async {
    String userInfo;
    try {
      final String result =
          await _methodChannel.invokeMethod('dealWithMyName', 'jason');
      userInfo = result;
    } catch (e) {
      userInfo = 'Failed to deal.';
    }

    setState(() {
      lists.add(userInfo);
    });
  }

  @override
  void initState() {
    super.initState();

    //接受原生回传的参数
    eventChannel.receiveBroadcastStream().listen(_getData, onError: _getError);
    newTexture();
  }

  @override
  void dispose() {
    super.dispose();
    if (textureId >= 0) {
      _methodChannel.invokeMethod('disposeTexture', {'textureId': textureId});
    }
  }

  void newTexture() async {
    textureId = await _methodChannel.invokeMethod("createImage", {
      'img': 'icon_app', //本地图片名, 或者url
      'width': 60,
      'height': 60,
      'asGif': false,
    });
    setState(() {});
  }

  //显示图片的widget
  Widget getTextureBody(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Texture(
        textureId: textureId,
      ),
    );
  }

  void _getData(dynamic data) {
    // UserInfoModel userM = UserInfoModel.fromJson(data);
    String ocString = data.toString();
    if (ocString.length != 0) {
      setState(() {
        lists.add(ocString);
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

  //

  Widget _buildListViewCell(int index, String title) {
    Widget imageTexture =
        textureId >= 0 ? getTextureBody(context) : Text('load');
    return InkWell(
      onTap: () {
        flutterGetOcMethod(index);
      },
      child: Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: imageTexture,
                ),
                Container(
                  child: Text(title),
                  margin: EdgeInsets.only(left: 15),
                ),
              ],
            ),
            Container(
              child: Text("第$index条数据"),
              margin: EdgeInsets.only(right: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoModel {
  String? name;
  String? age;
  UserInfoModel({this.name, this.age});
  UserInfoModel.fromJson(Map<String, dynamic> json) {
    this.name = json["name"];
    this.age = json["age"];
  }
}
