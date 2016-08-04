//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKActionSheet;

#pragma mark - ***** 枚举 ******
typedef NS_ENUM(NSInteger, MKActionSheetParamType) {
    MKActionSheetParamType_common    = 1,       //default
    MKActionSheetParamType_object,              //model or NSDictionary
};

/** title button 的对其方式， 如果button 带 icon图片，将自动设置成 left */
typedef NS_ENUM(NSInteger, MKActionSheetButtonTitleAlignment) {
    MKActionSheetButtonTitleAlignment_center = 1,        //default
    MKActionSheetButtonTitleAlignment_left,
    MKActionSheetButtonTitleAlignment_right,
};

/** 当button 带 icon 图片时， 指定 object 里 imageKey 对应的使用类型 */
typedef NS_ENUM(NSInteger, MKActionSheetButtonImageType) {
    MKActionSheetButtonImageType_none = 0,        //default
    MKActionSheetButtonImageType_image,
    MKActionSheetButtonImageType_name,
    MKActionSheetButtonImageType_url,  
};

#pragma mark - ***** MKActionSheet Block ******
/** 默认模式 */
typedef void(^MKActionSheetBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex);
/** 初始化 数组为  object array */
typedef void(^MKActionSheetParamBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex, id obj);
/**
 *  带 icon 图片，并 imageKey 对应的 图片类型是 URL方式， 调用此回调 设置图片（也可以使用 delegate)
 *
 *  @param actionSheet actionSheet with self
 *  @param button      要设置图片的 button
 *  @param imageUrl    button 的 URL， 即 object 对应 的 imageKey 字段
 */
typedef void(^MKActionSheetSetButtonImageWithUrlBlock)(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl);



#pragma mark - ***** MKActionSheet Delegate ******
@protocol MKActionSheetDelegate <NSObject>

@optional
/** 以title array 初始化时 点击按钮的 代理 */
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex;
/**
 *  以 object array 初始化时 点击按钮时执行
 *
 *  @param actionSheet actionSheet with self
 *  @param buttonIndex button index
 *  @param obj         选择按钮对应的 obj, 如果带有 cancel button,点击cancel button 返回的 obj 为nil
 */
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex selectObj:(id)obj;

/**
 *  带 icon 图片，并 imageKey 对应的 图片类型是 URL方式， 调用此回调 设置图片（也可以使用 delegate)
 *
 *  @param actionSheet actionSheet with self
 *  @param button      要设置图片的 button
 *  @param imageUrl    utton 的 URL， 即 object 对应 的 imageKey 字段
 */
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl;
@end


#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

@property (nonatomic, copy) MKActionSheetBlock block;               /*!< 点击按钮回调 */
@property (nonatomic, copy) MKActionSheetParamBlock paramBlock;     /*!< 点击按钮回调带参数 */
@property (nonatomic, copy) MKActionSheetSetButtonImageWithUrlBlock buttonImageBlock;   /*!< 设置 button image 的回调 */
@property (nonatomic, weak) id <MKActionSheetDelegate> delegate;    /*!< 代理 */

/**  custom UI */
//title
@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 */
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 */
//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< default: 48.0f*/
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title 对齐方式 */
//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 */
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 */
//cancel Title
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title */
//action sheet
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 default: 0.3f */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 default: 0.0f */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 default: 0.3f */
@property (nonatomic, assign) BOOL isNeedCancelButton;              /*!< 是否需要取消按钮 */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 默认-1，全部显示*/

@property (nonatomic, copy) NSString *titleKey;                     /*!< 传入为object array 时 指定 title 的字段名 */


#pragma mark - ***** Class method ******
+ (void)sheetWithTitle:(NSString *)title
      buttonTitleArray:(NSArray *)buttonTitleArray
destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 block:(MKActionSheetBlock)block;

+ (void)sheetWithTitle:(NSString *)title
      buttonTitleArray:(NSArray *)buttonTitleArray
                 block:(MKActionSheetBlock)block;

+ (void)sheetWithTitle:(NSString *)title
      buttonTitleArray:(NSArray *)buttonTitleArray
    isNeedCancelButton:(BOOL)isNeedCancelButton
    maxShowButtonCount:(CGFloat)maxShowButtonCount
                 block:(MKActionSheetBlock)block;

+ (void)sheetWithTitle:(NSString *)title
destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sheetWithTitle:(NSString *)title
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  支持直接传入 model 或 NSDictionary 数据的初始化方法。必须设置titleKey，object中的titleKey字段将用于显示按钮title,
 *  参照普遍需求，传入object模式默认去除取消按钮。如果需要取消按钮可自己设置  isNeedCancelButton = YES;
 *  有取消按钮时，点击取消按钮  block 和 delegate 中返回 的 obj 为 nil。
 *
 *  @param title      title string
 *  @param objArray   object data array. 支持 model or NSDictionary
 *  @param titleKey   用于显示按钮title, object中对应的key
 *  @param paramBlock call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj )
 */
+ (void)sheetWithTitle:(NSString *)title
              objArray:(NSArray *)objArray
              titleKey:(NSString *)titleKey
            paramBlock:(MKActionSheetParamBlock)paramBlock;



#pragma mark - ***** init method ******
/**
 *  init MKActionSheet with buttonTitleArray
 *
 *  @param title            title string
 *  @param buttonTitleArray button titles Array
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray;


/**
 *  init MKActionSheet with buttonTitleArray and destructiveButtonIndex
 *
 *  @param title                  title string
 *  @param buttonTitleArray       button titles Array
 *  @param destructiveButtonIndex destructive button index
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex;


/**
 *  init MKActionSheet with many button titles
 *
 *  @param title            title string
 *  @param buttonTitle      many button titles
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  init MKActionSheet with many button titles and destructiveButtonIndex
 *
 *  @param title                  title string
 *  @param destructiveButtonIndex destructive button index
 *  @param buttonTitle            many button titles
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  支持直接传入 model 或 NSDictionary 数据的初始化方法。必须设置titleKey，object中的titleKey字段将用于显示按钮title,
 *  参照普遍需求，传入object模式默认去除取消按钮。如果需要取消按钮可自己设置  isNeedCancelButton = YES;
 *  有取消按钮时，点击取消按钮  block 和 delegate 中返回 的 obj 为 nil。
 *
 *  @param title                  title string
 *  @param objArray               obj data array
 *  @param titleKey               用于显示按钮title, object中对应的 key
 *  @param destructiveButtonIndex 特殊按钮的 index
 *
 *  @return self;
 */
- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
                     titleKey:(NSString *)titleKey
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex;

- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
                     titleKey:(NSString *)titleKey;

/** other method */
- (void)setImageKey:(NSString *)imageKey imageType:(MKActionSheetButtonImageType)imageType;

- (void)addObject:(id)obj;
- (void)addButtonWithTitle:(NSString *)title;


/** show method */
/**
 *  just show, your need manual setting that block and delegate
 */
- (void)show;

- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;
- (void)showWithBlock:(MKActionSheetBlock)block;

/**
 *  if you init MKActionSheet by the model or NSDictionary way, this method will call back that selected object;
 *
 *  @param block  call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj )
 */
- (void)showWithParamBlock:(MKActionSheetParamBlock)block;

@end




#pragma mark - ***** MKActionSheetCell ******
@interface MKActionSheetCell : UITableViewCell
@property (nonatomic, weak) UIButton *btnCell;
@property (nonatomic, weak) UIView *separatorView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

