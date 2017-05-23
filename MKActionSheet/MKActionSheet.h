//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKASOrientationConfig.h"



@class MKActionSheet, MASConstraintMaker;
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



typedef void(^MKActionSheetCustomTitleViewLayoutBlock)(MASConstraintMaker *make, UIView *superview);
/** 
 * PS:
 * 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。
 * 可以将 currentVC 设置为当前 viewController
 */

// default UI setting
// _selected and multiselect style, default no cancel button, title alignment default: Portrait-left, Landscape-center
// init with object array ,default no cancel button

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

/** block */
@property (nonatomic, copy) MKActionSheetBlock block;                                   /*!< callback for click button  */
@property (nonatomic, copy) MKActionSheetMultiselectBlock multiselectBlock;             /*!< callback for multiselect style, return selected array */


/**  custom UI */
@property (nonatomic, assign) CGFloat windowLevel;          /*!< default: UIWindowLevelStatusBar - 1 */
@property (nonatomic, weak) UIViewController *currentVC;    /*!< current viewController, for statusBar keep the same style */
@property (nonatomic, assign) BOOL enabledForBgTap;         /*!< default: YES */
@property (nonatomic, assign) BOOL manualDismiss;           /**  [default: NO]. if set 'YES', you need calling the method of 'dismiss' to hide actionSheet by manual */

/** action sheet */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 [default: 0.3f] */

//title
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 [default: RGBA(100.0f, 100.0f, 100.0f, 1.0f)]*/
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 [default: sys 14] */
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title side spacee [default: 20] */

//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 [default:RBGA(51.0f, 51.0f, 51.0f, 1.0f)] */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 [default: sys 18] */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 [default: 0.6] */
@property (nonatomic, assign) CGFloat buttonImageRightSpace;        /*!< 带图片样式 图片右边离 title 的距离 [default: 12.f] */

//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< [default:-1]*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< [default:RBGA(250.0f, 10.0f, 10.0f, 1.0f)]*/

//cancel Title
@property (nonatomic, assign) BOOL needCancelButton;                /*!< 是否需要取消按钮 */
@property (nonatomic, copy) NSString *cancelTitle;                 /*!< cancel button title [dafault:取消] */


//MKActionSheetSelectType_selected
@property (nonatomic, assign) NSInteger selectedIndex;              /*!< selected button index */
@property (nonatomic, copy) NSString *selectedBtnImageName;         /*!< image name for selected button  */

//MKActionSheetSelectType_multiselect
@property (nonatomic, copy) NSString *selectBtnImageNameNormal;     /*!< image name for select button normal state */
@property (nonatomic, copy) NSString *selectBtnImageNameSelected;   /*!< image name for select button selected state )*/
@property (nonatomic, strong) NSString *multiselectConfirmButtonTitle;      /*!< confirm button title */
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< confirm button title color */
@property (nonatomic, strong) UIImage *placeholderImage;


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

- (void)reloadWithTitleArray:(NSArray *)titleArray;
- (void)reloadWithObjArray:(NSArray *)objArray;

- (void)setPortraitConfig:(MKASOrientationConfig *)config;          /*!< set Portrait config  */
- (void)setLandscapeConfig:(MKASOrientationConfig *)config;         /*!< set Landscape config */

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


