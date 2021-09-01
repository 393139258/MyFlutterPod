#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IosPlatformImagesPlugin.h"
#import "UIImage+ios_platform_images.h"

FOUNDATION_EXPORT double ios_platform_imagesVersionNumber;
FOUNDATION_EXPORT const unsigned char ios_platform_imagesVersionString[];

