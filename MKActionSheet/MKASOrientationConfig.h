//
//  MKASOrientationConfig.h
//  MKActionSheet
//
//  Created by xmk on 2017/5/19.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MK_SCREEN_WIDTH
#define MK_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#endif

#ifndef MK_SCREEN_HEIGHT
#define MK_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#endif

#ifndef MK_IS_IPHONE_XX
    #define MK_IS_IPHONE_X_XS   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
    CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
    #define MK_IS_IPHONE_XSMAX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
    CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
    #define MK_IS_IPHONE_XR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
    CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
    #define MK_IS_IPHONE_XX     MK_IS_IPHONE_X_XS || MK_IS_IPHONE_XSMAX || MK_IS_IPHONE_XR
#endif

#ifndef MK_WEAK_SELF
#define MK_WEAK_SELF            __weak typeof(self) weakSelf = self;
#endif

#ifndef MK_BLOCK_EXEC
#define MK_BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#endif

#ifndef MK_COLOR_RGBA
#define MK_COLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#endif


#pragma mark - ***** 枚举 ******
typedef NS_ENUM(NSInteger, MKActionSheetSelectType) {
    MKActionSheetSelectType_common  = 1,        //default
    MKActionSheetSelectType_selected,           //have a selected button
    MKActionSheetSelectType_multiselect,        //multiselect
};

/** Alignment type of button title,default:center  (if button have icon,default:left) */
typedef NS_ENUM(NSInteger, MKActionSheetButtonTitleAlignment) {
    MKActionSheetButtonTitleAlignment_center    = 1,        //default
    MKActionSheetButtonTitleAlignment_left,
    MKActionSheetButtonTitleAlignment_right,
};

/** if button have icon, type for the 'imageKey' */
typedef NS_ENUM(NSInteger, MKActionSheetButtonImageValueType) {
    MKActionSheetButtonImageValueType_none      = 1,        //default
    MKActionSheetButtonImageValueType_image,
    MKActionSheetButtonImageValueType_name,
    MKActionSheetButtonImageValueType_url,
};



@interface MKASOrientationConfig : NSObject
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 [default: center] */
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title Alignment style [default: center] */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< 按钮高度 [default: 48.0f] */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 [default:5.6，全部显示,可设置成 0] */
@end
