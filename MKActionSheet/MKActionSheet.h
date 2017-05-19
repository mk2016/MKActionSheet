//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#define MKActionSheet_WindowLevel   UIWindowLevelStatusBar - 1

@class MKActionSheet;

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

#pragma mark - ***** MKActionSheet Block ******
/**
 *  clicked block
 *
 *  @param actionSheet self
 *  @param buttonIndex index with clicked button
 */
typedef void(^MKActionSheetBlock)(MKActionSheet *actionSheet, NSInteger buttonIndex);

/**
 *  multiselect block
 *
 *  @param actionSheet self
 *  @param array       selected array
 */
typedef void(^MKActionSheetMultiselectBlock)(MKActionSheet *actionSheet, NSArray *array);

/**
 *  when 'imageKey' type is 'url'，use this block load image
 *
 *  @param actionSheet self
 *  @param button      button of need load image
 *  @param imageUrl    the 'imageKey' value
 */
typedef void(^MKActionSheetSetButtonImageWithUrlBlock)(MKActionSheet *actionSheet, UIButton *button, NSString *imageUrl);

typedef void(^MKActionSheetCustomTitleViewLayoutBlock)(MASConstraintMaker *make, UIView *superview);
/** 
 * 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。
 * 现默认使用不新建window的模式，
 * 但如果您的项目使用了多个window,当顶部window不是keywindow时，sheetView会被顶部window遮住。
 * 此时建议 将 needNewWindow 设置为 YES; 并在项目info.plist 中 新增 “View controller-based status bar appearance” 设置为 NO。
 * 这样也可以让 status bar 不变色
 */


@interface MKActionSheetConfig : NSObject

@end

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

@property (nonatomic, copy) MKActionSheetBlock block;                                   /*!< callback for click button  */
@property (nonatomic, copy) MKActionSheetMultiselectBlock multiselectBlock;             /*!< callback for multiselect style, return selected array */
@property (nonatomic, copy) MKActionSheetSetButtonImageWithUrlBlock buttonImageBlock;   /*!< callback for set button image */

/**  custom UI */
@property (nonatomic, assign) CGFloat windowLevel;                  /*!< default: UIWindowLevelStatusBar - 1 */
@property (nonatomic, assign) BOOL enabledForBgTap;                 /*!< default: YES */
@property (nonatomic, weak) UIViewController *currentVC;            /*!< current viewController, for statusBar keep the same style */
//title
@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 [default: RGBA(100.0f, 100.0f, 100.0f, 1.0f)]*/
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 [default: sys 14] */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 [default: center] */
//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 [default:RBGA(51.0f, 51.0f, 51.0f, 1.0f)] */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 [default: sys 18] */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 [default: 0.6] */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< 按钮高度 [default: 48.0f] */
@property (nonatomic, assign) CGFloat buttonImageRightSpace;        /*!< 带图片样式 图片右边离 title 的距离 [default: 12.f] */
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title Alignment style [default: center] */
//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< [default:-1]*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< [default:RBGA(250.0f, 10.0f, 10.0f, 1.0f)]*/
//cancel Title
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< cancel button title [dafault:取消] */
//action sheet
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title side spacee [default: 20] */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 [default: 0.3f] */
@property (nonatomic, assign) BOOL needCancelButton;                /*!< 是否需要取消按钮 */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 [default:5.6，全部显示,可设置成 0] */

//MKActionSheetSelectType_selected
@property (nonatomic, assign) NSInteger selectedIndex;              /*!< selected button index, (MKActionSheetSelectType_selected) */
@property (nonatomic, copy) NSString *selectedBtnImageName;         /*!< image name for selected button (MKActionSheetSelectType_selected) */

//MKActionSheetSelectType_multiselect
@property (nonatomic, copy) NSString *selectBtnImageNameNormal;     /*!< image name for select button normal state (MKActionSheetSelectType_multiselect)  */
@property (nonatomic, copy) NSString *selectBtnImageNameSelected;   /*!< image name for select button selected state (MKActionSheetSelectType_multiselect )*/
@property (nonatomic, strong) NSString *multiselectConfirmButtonTitle;      /*!< confirm button title (MKActionSheetSelectType_multiselect) */
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< confirm button title color (MKActionSheetSelectType_multiselect) */


@property (nonatomic, assign) BOOL manualDismiss;                   /*!< is manual dismiss [default: NO]  if set 'YES', you need calling the method of 'dismiss' to hide actionSheet by manual */
#pragma mark - ***** init method ******
/**
 *  init MKActionSheet with buttonTitles array and selectType
 *
 *  @param title            title string
 *  @param buttonTitleArray button titles Array
 *  @param selectType       select type
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray
                   selectType:(MKActionSheetSelectType)selectType;

/** selectType default: MKActionSheetSelectType_common */
- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray;

/**
 *  init MKActionSheet with buttonTitles array and selectType
 *
 *  @param title            title string
 *  @param objArray         object array
 *  @param buttonTitleKey   the button title key in object
 *  @prram imageKey         the image key in object
 *  @param imageValueType   the image value type
 *  @param selectType       the select type
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
               buttonTitleKey:(NSString *)buttonTitleKey
                     imageKey:(NSString *)imageKey
               imageValueType:(MKActionSheetButtonImageValueType)imageValueType
                   selectType:(MKActionSheetSelectType)selectType;

/** init with objArray,  default: MKActionSheetButtonImageValueType_none */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
               buttonTitleKey:(NSString *)buttonTitleKey
                   selectType:(MKActionSheetSelectType)selectType;

/** init with objArray,   default: MKActionSheetSelectType_common */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
               buttonTitleKey:(NSString *)buttonTitleKey
                     imageKey:(NSString *)imageKey
               imageValueType:(MKActionSheetButtonImageValueType)imageValueType;

/** init with objArray,   default: MKActionSheetSelectType_common MKActionSheetButtonImageValueType_none */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
               buttonTitleKey:(NSString *)buttonTitleKey;






- (void)setCustomTitleView:(UIView *)view makeConstraints:(MKActionSheetCustomTitleViewLayoutBlock)block;
- (void)addButtonWithButtonTitle:(NSString *)title;
- (void)removeButtonWithButtonTitle:(NSString *)title;

- (void)addButtonWithObj:(id)obj;
- (void)removeButtonWithObj:(id)model;

- (void)removeButtonWithIndex:(NSInteger)index;

/** show method */
/**
 *  single select block
 *
 *  @param block call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj)
 */
- (void)showWithBlock:(MKActionSheetBlock)block;

/**
 *  multiselect style block
 *
 *  @param multiselectblock  call back (MKActionSheet *actionSheet, NSArray *array)
 */
- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock;

/** dismiss */
- (void)dismiss;
@end


