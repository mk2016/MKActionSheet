//
//  UIImage+MKASAdd.m
//  MKActionSheet
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "UIImage+MKASAdd.h"

@implementation UIImage(MKExtension)

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
