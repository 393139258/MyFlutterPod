//
//  YMFlutterViewController.m
//  PeiPei
//
//  Created by 李恒 on 2021/9/1.
//

#import "YMFlutterViewController.h"
#import "ShortMediaWeakProxy.h"
#import "YMFlutterTexturePresenter.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "IOSPlatformPlugin.h"
#import <FlutterPluginRegistrant/FlutterPluginRegistrant-umbrella.h>

//dart 定义的key, 需要统一
static NSString *kFlutterToNative = @"com.flutterToNative";
static NSString *kNativeToFlutter = @"com.nativeToFlutter";

//flutter 调用OC的方法名
static NSString *kFlutterCallOcMethodName = @"dealWithMyName";

@interface YMFlutterViewController ()<FlutterStreamHandler, TZImagePickerControllerDelegate>
@property (nonatomic, strong) FlutterEventSink eventSinks;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, YMFlutterTexturePresenter *> *renders;
@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textures;
@end

@implementation YMFlutterViewController

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//控制器返回时一定要设为nil
	[self.eventChannel setStreamHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//插件注册
//	[GeneratedPluginRegistrant registerWithRegistry:(NSObject<FlutterPluginRegistry> *)[self pluginRegistry]];
	[IOSPlatformPlugin registerWithRegistrar:[self registrarForPlugin:@"IOSPlatformPlugin"]];
	
	//设置eventChannel代理
	[self.eventChannel setStreamHandler:self];
	[self setupMethodChannel];
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
	@weakify(self);
	if ([call.method containsString:kFlutterCallOcMethodName]) {
		if ([call.arguments isKindOfClass:[NSString class]]) {
			//这个dealWithMyName方法名称可以不与flutter定义的那个字符串一直
			//处理flutter传递过来的数据， 并通过result返回处理结果
			result([self dealWithMyName:call.arguments]);
		}
	} else if ([@"createImage" isEqualToString:call.method]) {
		
		//这个方法由flutter调用, 在 flutter界面需要显示图片的地方， 使用OC工程的图片或者设置url由OC加载后回传给flutter显示, 参数结构可以自定义
		NSString *imageStr = call.arguments[@"img"];
		Boolean asGif = [call.arguments[@"asGif"] boolValue];
		CGFloat width = [call.arguments[@"width"] floatValue];
		CGFloat height = [call.arguments[@"height"] floatValue];
		CGSize size = CGSizeMake(width, height);
		YMFlutterTexturePresenter *render = [[YMFlutterTexturePresenter alloc] initWithImageStr:imageStr size:size asGif:asGif];
		int64_t textureId = [self.textures registerTexture:render];
		render.updateBlock = ^{
			@strongify(self);
			[self.textures textureFrameAvailable:textureId];
		};
		[self.renders setObject:render forKey:@(textureId)];
		result(@(textureId));
	}else if ([@"disposeTexture" isEqualToString:call.method]) {
		if (call.arguments[@"textureId"] != nil && ![call.arguments[@"textureId"] isKindOfClass:[NSNull class]]) {
			YMFlutterTexturePresenter *render = [self.renders objectForKey:call.arguments[@"textureId"]];
			[self.renders removeObjectForKey:call.arguments[@"textureId"]];
			[render dispose];
			NSNumber *numb = call.arguments[@"textureId"];
			if (numb) {
				[self.textures unregisterTexture:numb.longLongValue];
			}
		}
	} else if([@"popImagePicker" isEqualToString:call.method]) {
		[self popImagePicker];
	}
}

//设置对应的Flutter调用方法
- (void)setupMethodChannel {
	FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:kFlutterToNative binaryMessenger:(NSObject<FlutterBinaryMessenger> *)[ShortMediaWeakProxy proxyWithtTarget:self]];
	@weakify(self);
	[methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
		@strongify(self);
		[self onMethodCall:call result:result];
	}];
}

- (NSObject<FlutterTextureRegistry> *)textures {
	if ([self conformsToProtocol:@protocol(FlutterTextureRegistry)]) {
		return (NSObject<FlutterTextureRegistry> *)[ShortMediaWeakProxy proxyWithtTarget:self];
	}
	return nil;
}

- (NSObject<FlutterBinaryMessenger> *)messenger {
	if ([self conformsToProtocol:@protocol(FlutterBinaryMessenger)]) {
		return (NSObject<FlutterBinaryMessenger> *)[ShortMediaWeakProxy proxyWithtTarget:self];
	}
	return nil;
}

//原生方法, 处理flutter参数
- (NSString *)dealWithMyName:(NSString *)argument {
	return [NSString stringWithFormat:@"flutter->oc:%@", argument];
}

- (void)popImagePicker {
	TZImagePickerController *imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
	imagePickerController.showSelectBtn = NO;
	[imagePickerController setNaviBgColor:gHex(@"00D8B3")];
	[imagePickerController setIconThemeColor:gHex(@"00D8B3")];
	[[YMPageTool qwe_getTopVC].navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
	UIImage *heamage = photos[0];
	if (heamage) {
		@weakify(self);
		CGSize size = CGSizeMake(40, 40);
		YMFlutterTexturePresenter *render = [[YMFlutterTexturePresenter alloc] initWithImageStr:heamage size:size asGif:NO];
		int64_t textureId = [self.textures registerTexture:render];
		render.updateBlock = ^{
			@strongify(self);
			[self.textures textureFrameAvailable:textureId];
		};
		[self.renders setObject:render forKey:@(textureId)];
		
		NSString *textureIdStr = [NSString stringWithFormat:@"%lld", textureId];
		if (self.eventSinks) {
			self.eventSinks(@{@"type": @"1", @"texture": textureIdStr});
		}
	}
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
	self.eventSinks = events;
	if (self.eventSinks) {
		//oc主动传递给flutter的参数
		NSDictionary *para = @{@"type": @"0", @"name": @"lheng", @"city": @"wuhan"};
		self.eventSinks(para);
	}
	return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
	self.eventSinks = nil;
	return nil;
}

//OC传递给flutter参数用的channel
- (FlutterEventChannel *)eventChannel {
	if (!_eventChannel) {
		_eventChannel = [FlutterEventChannel eventChannelWithName:kNativeToFlutter binaryMessenger:(NSObject<FlutterBinaryMessenger> *)[ShortMediaWeakProxy proxyWithtTarget:self]];
	}
	return _eventChannel;
}

- (void)dealloc {
	NSLog(@"flutter vc -dealloc-");
}

@end
