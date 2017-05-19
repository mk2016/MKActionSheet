//
//  MKASOrientationConfig.h
//  MKActionSheet
//
//  Created by xmk on 2017/5/19.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifndef MKActionSheetDefine
#define MKSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MKSCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MKSCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MKCOLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#define MKWEAKSELF typeof(self) __weak weakSelf = self;
#define MKBlockExec(block, ...) if (block) { block(__VA_ARGS__); };
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
