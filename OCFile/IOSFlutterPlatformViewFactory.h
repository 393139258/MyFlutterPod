//
//  IOSFlutterPlatformViewFactory.h
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface IOSFlutterPlatformViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWith:(NSObject<FlutterPluginRegistrar> *)registrar;

@end
