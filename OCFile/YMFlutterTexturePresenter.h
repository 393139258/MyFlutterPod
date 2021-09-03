//
//  YMFlutterTexturePresenter.h
//  Pods
//
//  Created by xhw on 2020/5/15.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface YMFlutterTexturePresenter : NSObject <FlutterTexture>

@property(copy,nonatomic) void(^updateBlock) (void);

- (instancetype)initWithImageStr:(id)imageStr size:(CGSize)size asGif:(Boolean)asGif;

- (void)dispose;
- (void)create;

@end


