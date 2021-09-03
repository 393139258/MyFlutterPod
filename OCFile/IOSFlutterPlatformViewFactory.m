//
//  IOSFlutterPlatformViewFactory.m
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import "IOSFlutterPlatformViewFactory.h"
#import "IOSPlatformView.h"

@implementation IOSFlutterPlatformViewFactory {
	id<FlutterPluginRegistrar> _registrar;
}
 
- (instancetype)initWith:(NSObject<FlutterPluginRegistrar>*)registrar {
	self = [super init];
	if (self) {
		_registrar = registrar;
	}
	return self;
}

//设置参数的编码方式
- (NSObject<FlutterMessageCodec> *)createArgsCodec {
	return [[FlutterJSONMessageCodec alloc] init];
}

//用来创建 ios 原生view
- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
	//args 为flutter 传过来的参数, 根据参数按需加载视图
	NSLog(@"传过来的参数 %@", args);
	IOSPlatformView *textLagel = [[IOSPlatformView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_registrar.messenger];
	return textLagel;
}

@end
