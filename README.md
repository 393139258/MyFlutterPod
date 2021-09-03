# MyFlutterPod

[![CI Status](https://img.shields.io/travis/393139258/MyFlutterPod.svg?style=flat)](https://travis-ci.org/393139258/MyFlutterPod)
[![Version](https://img.shields.io/cocoapods/v/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)
[![License](https://img.shields.io/cocoapods/l/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)
[![Platform](https://img.shields.io/cocoapods/p/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)

## 通过Pod安装

pod 'MyFlutterPod',:git=>'https://github.com/393139258/MyFlutterPod.git'

## 使用

以下使用方式不是必须要flutter环境\n
使用方式:\n
1.编辑Podfile\n
pod 'MyFlutterPod',:git=>'https://github.com/393139258/MyFlutterPod.git'\n
2.把OCFile文件夹代码拖入OC工程中\n
3.修改info.plist \n
	增加key  io.flutter.embedded_views_preview   bool   YES\n
4.跳转（随便在那里增加跳转）\n
YMFlutterViewController *flutterVc = [[YMFlutterViewController alloc] init];\n
flutterVc.view.backgroundColor = [UIColor whiteColor];\n
[self.navigationController pushViewController:flutterVc animated:YES];\n

## Author

393139258, 393139258@qq.com

## License

MyFlutterPod is available under the MIT license. See the LICENSE file for more info.
