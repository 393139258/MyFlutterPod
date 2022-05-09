# MyFlutterPod

[![CI Status](https://img.shields.io/travis/393139258/MyFlutterPod.svg?style=flat)](https://travis-ci.org/393139258/MyFlutterPod)
[![Version](https://img.shields.io/cocoapods/v/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)
[![License](https://img.shields.io/cocoapods/l/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)
[![Platform](https://img.shields.io/cocoapods/p/MyFlutterPod.svg?style=flat)](https://cocoapods.org/pods/MyFlutterPod)

## 通过Pod安装

pod 'MyFlutterPod',:git=>'https://github.com/393139258/MyFlutterPod.git'

## 使用

以下使用方式不是必须要flutter环境  
使用方式:  
1.编辑Podfile  
pod 'MyFlutterPod',:git=>'https://github.com/393139258/MyFlutterPod.git'  
2.把OCFile文件夹代码拖入OC工程中  
3.修改info.plist   
	增加key  io.flutter.embedded_views_preview   bool   YES  
4.bitcode设置成NO  
5.跳转  
YMFlutterViewController *flutterVc = [[YMFlutterViewController alloc] init];  
flutterVc.view.backgroundColor = [UIColor whiteColor];  
//这一步是去除跳转时加载的默认启动页
flutterVc.splashScreenView = [[UIView alloc] init];
[self.navigationController pushViewController:flutterVc animated:YES];  

## Author

393139258@qq.com

## License

MyFlutterPod is available under the MIT license. See the LICENSE file for more info.
