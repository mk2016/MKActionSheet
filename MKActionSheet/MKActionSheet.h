//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MKActionSheet_WindowLevel   UIWindowLevelStatusBar - 1

@class MKActionSheet;

#pragma mark - ***** 枚举 ******

typedef NS_ENUM(NSInteger, MKActionSheetSelectType) {
    MKActionSheetSelectType_common    = 1,      //default
    MKActionSheetSelectType_selected,           //默认带有一个 已选择的 选项
    MKActionSheetSelectType_multiselect,        //多选 样式
};

/** title button 的对其方式， 如果button 带 icon图片，将自动设置成 left */
typedef NS_ENUM(NSInteger, MKActionSheetButtonTitleAlignment) {
    MKActionSheetButtonTitleAlignment_center = 1,        //default
    MKActionSheetButtonTitleAlignment_left,
    MKActionSheetButtonTitleAlignment_right,
};

/** 当带有图片时, 指定 imageKey 对应的类型*/
typedef NS_ENUM(NSInteger, MKActionSheetButtonImageValueType) {
    MKActionSheetButtonImageValueType_none = 0,        //default
    MKActionSheetButtonImageValueType_image,
    MKActionSheetButtonImageValueType_name,
    MKActionSheetButtonImageValueType_url,
};

#pragma mark - ***** MKActionSheet Block ******
/**
 *  单选的 block
 *
 *  @param actionSheet self
 *  @param buttonIndex clicked button's index
;
 */
typedef void(^MKActionSheetBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex);

/**
 *  multiselect block
 *
 *  @param actionSheet self
 *  @param array       selected array
 */
typedef void(^MKActionSheetMultiselectBlock)(MKActionSheet* actionSheet, NSArray *array);

/**
 *  imageKey 的类型为 url时，可用 这个block 加载 图片
 *
 *  @param actionSheet self
 *  @param button      需要设置图片的按钮
 *  @param imageUrl    图片的 URL，即 'imageKey'  对应的值
 */
typedef void(^MKActionSheetSetButtonImageWithUrlBlock)(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl);

/** before and after animation block */
typedef void(^MKActionSheetWillPresentBlock)(MKActionSheet* actionSheet);
typedef void(^MKActionSheetDidPresentBlock)(MKActionSheet* actionSheet);

typedef void(^MKActionSheetWillDismissBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex);
typedef void(^MKActionSheetDidDismissBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex);
typedef void(^MKActionSheetWillDismissMultiselectBlock)(MKActionSheet* actionSheet, NSArray *array);
typedef void(^MKActionSheetDidDismissMultiselectBlock)(MKActionSheet* actionSheet, NSArray *array);

#pragma mark - ***** MKActionSheet Delegate ******
@protocol MKActionSheetDelegate <NSObject>

@optional
/**
 *  单选 delegage
 *
 *  @param actionSheet self
 *  @param buttonIndex clicked button's index
 */
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex;

/**
 *  多选样式 的delegate 点击确认后 返回 选中的 array， 如果有 取消 按钮，取消按钮返回的 array 为nil
 *
 *  @param actionSheet self
 *  @param array       被选中的button 对应数据的 array
 */
- (void)actionSheet:(MKActionSheet *)actionSheet selectArray:(NSArray *)selectArray;

/**
 *  带 icon 图片，并 imageKey 对应的 图片类型是 URL方式， 调用此回调 设置图片（也可以使用 delegate)
 *
 *  @param actionSheet actionSheet with self
 *  @param button      要设置图片的 button
 *  @param imageUrl    button 的 URL， 即 object 对应 的 imageKey 字段
 */
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl;


/** before and after animation delegate */
- (void)willPresentActionSheet:(MKActionSheet *)actionSheet;    /*!< before animation and showing view */
- (void)didPresentActionSheet:(MKActionSheet *)actionSheet;     /*!< after animation */

- (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; /*!< before animation and hiding view */
- (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  /*!< after animation */

- (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithSelectArray:(NSArray *)selectArray; /*!< before animation and hiding view */
- (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithSelectArray:(NSArray *)selectArray;  /*!< after animation */

@end


/** 
 * 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。
 * 现默认使用不新建window的模式，
 * 但如果您的项目使用了多个window,当顶部window不是keywindow时，sheetView会被顶部window遮住。
 * 此时建议 将 needNewWindow 设置为 YES; 并在项目info.plist 中 新增 “View controller-based status bar appearance” 设置为 NO。
 * 这样也可以让 status bar 不变色
 */
#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

@property (nonatomic, weak) id <MKActionSheetDelegate> delegate;    /*!< 代理 */
@property (nonatomic, assign) MKActionSheetSelectType selectType;   /*!< 选择模式：默认、单选(在初始选择的后面会有标示)、多选*/

@property (nonatomic, copy) MKActionSheetBlock block;                           /*!< 点击按钮回调 */
@property (nonatomic, copy) MKActionSheetMultiselectBlock multiselectBlock;     /*!< 多选样式的回调 返回选择的数组 */
@property (nonatomic, copy) MKActionSheetSetButtonImageWithUrlBlock buttonImageBlock;   /*!< 设置 button image 的回调 */

/** before and after animation block */
@property (nonatomic, copy) MKActionSheetWillPresentBlock willPresentBlock;
@property (nonatomic, copy) MKActionSheetDidPresentBlock didPresentBlock;
@property (nonatomic, copy) MKActionSheetWillDismissBlock willDismissBlock;
@property (nonatomic, copy) MKActionSheetDidDismissBlock didDismissBlock;
@property (nonatomic, copy) MKActionSheetWillDismissMultiselectBlock willDismissMultiselectBlock;
@property (nonatomic, copy) MKActionSheetDidDismissMultiselectBlock didDismissMultiselectBlock;

/**  custom UI */
@property (nonatomic, assign) CGFloat windowLevel;
@property (nonatomic, assign) BOOL needNewWindow;
@property (nonatomic, assign) BOOL enableBgTap;                     /*!< 蒙版是否可以点击 收起*/
//title
@property (nonatomic, weak) UIView *customTitleView;                /*!< 自定义标题View */
@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 [default: RGBA(100.0f, 100.0f, 100.0f, 1.0f)]*/
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 [default: sys 14] */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 [default: center] */
//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 [default:RBGA(51.0f, 51.0f, 51.0f, 1.0f)] */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 [default: sys 18] */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 [default: 0.6] */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< 按钮高度 [default: 48.0f] */
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title 对齐方式 [default: center] */
//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 [default:-1]*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 [default:RBGA(250.0f, 10.0f, 10.0f, 1.0f)]*/
//cancel Title
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title [dafault:取消] */
//action sheet
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title 边距 [default: 20] */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 [default: 0.0f] */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 [default: 0.3f] */
@property (nonatomic, assign,getter=isNeedCancelButton) BOOL needCancelButton;              /*!< 是否需要取消按钮 */
@property (nonatomic, assign,getter=isShowSeparator) BOOL showSeparator;    /*!< 是否显示分割线 [default: YES]*/
@property (nonatomic, assign) CGFloat separatorLeftMargin;          /*!< 分割线离左边的边距 [default:0] */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 [default:5.6，全部显示,可设置成 0] */
//object Array
@property (nonatomic, copy) NSString *titleKey;                     /*!< 传入为object array 时 指定 title 的字段名 */
@property (nonatomic, copy) NSString *imageKey;                     /*!< 传入为object array 时 指定button image对应的字段名 */
@property (nonatomic, assign) MKActionSheetButtonImageValueType imageValueType;   /*!< imageKey对应的类型：image、imageName、imageUrl */
//set image name
@property (nonatomic, copy) NSString *selectedBtnImageName;         /*!< 带默认选中模式，选中图片的名字 */
@property (nonatomic, copy) NSString *selectBtnImageNameNormal;     /*!< 多选模式，选择按钮非选中状态图片 */
@property (nonatomic, copy) NSString *selectBtnImageNameSelected;   /*!< 多选模式，选择按钮选中状态图片 */
//selected
@property (nonatomic, assign) NSInteger selectedIndex;              /*!< 默认选中的button index, 带默认选中样式 */
//multiselect
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< 多选 确定按钮 颜色 */

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
 *  init MKActionSheet with objects array and selectType
 *
 *  支持直接传入 model 或 NSDictionary 数据的初始化方法。必须设置titleKey，object中的titleKey字段将用于显示按钮title,
 *  参照普遍需求，传入object模式默认去除取消按钮。如果需要取消按钮可自己设置  needCancelButton = YES;
 *  有取消按钮时，点击取消按钮  block 和 delegate 中返回 的 obj 为 nil。
 *
 *  @param title    title string
 *  @param objArray objects array
 *  @param titleKey object中titleKey的值，用于显示按钮title,
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
                     titleKey:(NSString *)titleKey
                   selectType:(MKActionSheetSelectType)selectType;

/** selectType default: MKActionSheetSelectType_common */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
                     titleKey:(NSString *)titleKey;



/**
 *  init MKActionSheet with buttonTitles array and selectType
 *
 *  @param title       title string
 *  @param buttonTitle many button titles
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                   selectType:(MKActionSheetSelectType)selectType
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

/** selectType default: MKActionSheetSelectType_common*/
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;





/** other method */
/**
 *  设置 带icon 的样式，imageKey 为 图片对应的字段， imageValueType
 *
 *  @param imageKey       imageKey
 *  @param imageValueType imageKey 的 类型
 */
- (void)setImageKey:(NSString *)imageKey imageValueType:(MKActionSheetButtonImageValueType)imageValueType;
- (void)addButtonWithObj:(id)obj;
- (void)addButtonWithTitle:(NSString *)title;

/** show method */
/**
 *  just show, your need manual setting that block or delegate
 */
- (void)show;

/** delegate 模式 */
- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;

/**
 *  单选模式时用的 block，返回 被选中的 title 或 object
 *
 *  @param block call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj)
 */
- (void)showWithBlock:(MKActionSheetBlock)block;

/**
 *  多选模式时用的 block，点击 确定 的回调，返回被选中的 array
 *
 *  @param block  call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj)
 */
- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock;


- (void)dismiss;
@end
