//
//  IOSPlatformPlugin.m
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import "IOSPlatformPlugin.h"
#import "IOSFlutterPlatformViewFactory.h"

@implementation IOSPlatformPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
	//注册flutter需要显示的iOS自定义view Id: 双端约定好即可
	IOSFlutterPlatformViewFactory *fc = [[IOSFlutterPlatformViewFactory alloc] initWith:registrar];
	[registrar registerViewFactory:fc withId:@"webview"];
}

@end
