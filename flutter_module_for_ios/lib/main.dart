import 'package:flutter/foundation.dart';
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
  int chooseTextureId = -1;

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

  //根据纹理来构造图片视图
  Widget createImageFromTexture(int textureId, double wh) {
    return textureId >= 0
        ? Container(
            width: wh,
            height: wh,
            child: Texture(
              textureId: textureId,
            ),
            margin: EdgeInsets.only(right: 15),
          )
        : Container();
  }

  //native有数据传过来时，会主动调用此方法
  void _getData(dynamic data) {
    NativeDataModel userM = NativeDataModel.fromJson(data);
    if (userM.type == "0") {
      String ocString = "姓名: ${userM.name}, 城市: ${userM.city}";
      if (ocString.length != 0) {
        setState(() {
          //增加列表的数据
          lists.add(ocString);
        });
      }
    } else if (userM.type == "1") {
      //用户选择的图片
      setState(() {
        chooseTextureId = int.parse(userM.texture!);
      });
    }
  }

  //错误处理, 可以不用管
  void _getError(Object error) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == 3) {
              return showNativeView();
            } else {
              return _buildListViewCell(index, lists[index]);
            }
          },
          itemCount: lists.length,
        ),
      ),
    );
  }

  Widget showNativeView() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        color: Colors.red,
        width: 100,
        height: 100,
        child: UiKitView(
          viewType: "webview",
          creationParams: {"showType": "1"},
          creationParamsCodec: const JSONMessageCodec(),
        ),
      );
    } else {
      return AndroidView(
        viewType: "webview",
        creationParams: {"showType": "1"},
        creationParamsCodec: const JSONMessageCodec(),
      );
    }
  }

  Widget _buildListViewCell(int index, String title) {
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
                //列表的索引
                Container(
                  child: Text("$index",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  margin: EdgeInsets.only(left: 12),
                ),
                //选择的图片
                createImageFromTexture(textureId, 60),
                //标题
                Container(
                  child: Text(title),
                  margin: EdgeInsets.only(left: 15),
                ),
              ],
            ),
            Row(
              children: [
                index == 0
                    ? createImageFromTexture(chooseTextureId, 40)
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//对OC传过来的数据进行模型转换
class NativeDataModel {
  String? name; //姓名
  String? city; //城市
  String? type; //用类型来区分不同的数据
  String? texture; //用户选择的图片纹理
  NativeDataModel({this.name, this.city, this.type, this.texture});
  NativeDataModel.fromJson(Map<dynamic, dynamic> json) {
    this.name = json["name"];
    this.city = json["city"];
    this.type = json["type"];
    this.texture = json["texture"];
  }
}
