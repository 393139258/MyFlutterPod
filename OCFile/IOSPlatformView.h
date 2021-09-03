//
//  IOSPlatformView.h
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface IOSPlatformView : NSObject <FlutterPlatformView>
- (instancetype)initWithWithFrame:(CGRect)frame
				  viewIdentifier:(int64_t)viewId
					   arguments:(id)args
				 binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
