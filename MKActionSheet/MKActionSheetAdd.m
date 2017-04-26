//
//  MKActionSheetAdd.m
//  MKActionSheet
//
//  Created by xmk on 2017/4/26.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKActionSheetAdd.h"
#import <objc/runtime.h>

@implementation NSObject (MKASAdditions)
- (void)setMkas_selected:(BOOL)mkas_selected{
    objc_setAssociatedObject(self, @selector(mkas_selected), @(mkas_selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mkas_selected{
    NSNumber *selected = objc_getAssociatedObject(self, @selector(mkas_selected));
    return [selected boolValue];
}

@end

@implementation UIImage (MKASAdditions)
+ (UIImage *)mkas_imageWithColor:(UIColor *)color;{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
