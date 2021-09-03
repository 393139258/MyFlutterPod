//
//  IOSPlatformView.m
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import "IOSPlatformView.h"

@implementation IOSPlatformView {
	int64_t _viewId;
	UILabel * _uiLabel;
	//消息回调
	FlutterMethodChannel* _channel;
}

//在这里只是创建了一个UILabel
-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
	if ([super init]) {
		if (frame.size.width == 0) {
			frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 22);
		}
		_uiLabel = [[UILabel alloc] initWithFrame:frame];
		_uiLabel.textColor = [UIColor blackColor];
		_uiLabel.text = @"ios 原生 uilabel ";
		_uiLabel.font = [UIFont systemFontOfSize:14];
		_uiLabel.textAlignment = NSTextAlignmentCenter;
		_uiLabel.backgroundColor = [UIColor grayColor];
		
		_viewId = viewId;
	}
	return self;
}

//协议方法
- (nonnull UIView *)view {
	return _uiLabel;
}

@end
