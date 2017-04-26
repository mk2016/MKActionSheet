//
//  MKActionSheetAdd.h
//  MKActionSheet
//
//  Created by xmk on 2017/4/26.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (MKASAdditions)
@property (nonatomic, assign) BOOL mkas_selected;
@end

@interface UIImage (MKASAdditions)
+ (UIImage *)mkas_imageWithColor:(UIColor *)color;
@end
