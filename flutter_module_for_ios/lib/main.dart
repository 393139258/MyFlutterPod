import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_platform_images/ios_platform_images.dart';

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

  //用户原生传递消息过来
  static const eventChannel = EventChannel('com.nativeToFlutter');

  //flutter回传参数
  static const MethodChannel _methodChannel =
      const MethodChannel("com.flutterToNative");

  //系统返回的正常id会大于等于0, -1则可以认为 还未加载纹理
  int daTextureId = -1;

  void flutterGetBatteryLevel() async {
    String batteryLevel;
    try {
      final String result =
          await _methodChannel.invokeMethod('getBatteryLevel', 'jason');
      batteryLevel = result;
    } catch (e) {
      batteryLevel = 'Failed to get battery level.';
    }

    setState(() {
      lists.add(batteryLevel);
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
    if (daTextureId >= 0) {
      _methodChannel.invokeMethod('dispose', {'textureId': daTextureId});
    }
  }

  void newTexture() async {
    daTextureId = await _methodChannel.invokeMethod("create", {
      'img': 'icon_app', //本地图片名
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
        textureId: daTextureId,
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

  Widget _buildListViewCell(int index, String title) {
    Widget imageTexture =
        daTextureId >= 0 ? getTextureBody(context) : Text('load');
    return InkWell(
      onTap: flutterGetBatteryLevel,
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
              child: Column(
                children: [
                  Text("第$index条数据"),
                  Container(
                    width: 30,
                    height: 30,
                    child: Image(
                      image: IosPlatformImages.load("icon_app"),
                    ),
                  ),
                ],
              ),
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
