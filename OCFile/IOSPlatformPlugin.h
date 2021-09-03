//
//  IOSPlatformPlugin.h
//  PeiPei
//
//  Created by 李恒 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface IOSPlatformPlugin : NSObject<FlutterPlugin>
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end
