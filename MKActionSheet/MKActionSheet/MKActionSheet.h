//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 全局枚举
typedef NS_ENUM(NSInteger, MKActionSheetParamType) {
    MKActionSheetParamType_common    = 1,        //default
    MKActionSheetParamType_model,                //model or NSDictionary
};

typedef NS_ENUM(NSInteger, MKActionSheetButtonTitleAlignment) {
    MKActionSheetButtonTitleAlignment_center = 1,        //default
    MKActionSheetButtonTitleAlignment_left,
    MKActionSheetButtonTitleAlignment_right,
};

@class MKActionSheet;
typedef void(^MKActionSheetBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex );
typedef void(^MKActionSheetParamBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex, id obj );

#pragma mark - ***** MKActionSheetDelegate ******
@protocol MKActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex selectModel:(id)obj;

@end


#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 */
@property (nonatomic, copy) MKActionSheetBlock block;               /*!< 点击按钮回调 */
@property (nonatomic, copy) MKActionSheetParamBlock paramBlock;     /*!< 点击按钮回调带参数 */
@property (nonatomic, weak) id <MKActionSheetDelegate> delegate;    /*!< 代理 */

/**  custom UI */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 */
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< default: 48.0f*/
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 */
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 default: 0.3f */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 default: 0.0f */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 default: 0.3f */
@property (nonatomic, assign) BOOL isNeedCancelButton;              /*!< 是否需要取消按钮 */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 */
@property (nonatomic, copy) NSString *titleKey;                     /*!< 传入为model array 时 指定 title 的字段名 */


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
 *  支持直接传入 model 或 NSDictionary 数据的初始化方法。必须设置titleKey，model中的titleKey字段将用于显示按钮title,
 *  参照普遍需求，传入model模式默认去除取消按钮。如果需要取消按钮可自己设置  isNeedCancelButton = YES;
 *  有取消按钮时，点击取消按钮  block 和 delegate 中返回 的 obj 为 nil。
 *
 *  @param title      title string
 *  @param modelArray model data array. 支持 model or NSDic
 *  @param titleKey   用于显示按钮title, Model中对应的key
 *  @param paramBlock call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj )
 */
+ (void)sheetWithTitle:(NSString *)title
            modelArray:(NSArray *)modelArray
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
 *  支持直接传入 model 或 NSDictionary 数据的初始化方法。必须设置titleKey，model中的titleKey字段将用于显示按钮title,
 *  参照普遍需求，传入model模式默认去除取消按钮。如果需要取消按钮可自己设置  isNeedCancelButton = YES;
 *  有取消按钮时，点击取消按钮  block 和 delegate 中返回 的 obj 为 nil。
 *
 *  @param title                  title string
 *  @param modelArray             model data array
 *  @param titleKey               用于显示按钮title, Model中对应的 key
 *  @param destructiveButtonIndex 特殊按钮的 index
 *
 *  @return self;
 */
- (instancetype)initWithTitle:(NSString *)title
                   modelArray:(NSArray *)modelArray
                     titleKey:(NSString *)titleKey
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex;

    
/** show method */
/**
 *  just show, your need manual setting that block and delegate
 */
- (void)show;

- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;
- (void)showWithBlock:(MKActionSheetBlock)block;

/**
 *  if you init MKActionSheet by the model or NSDictionary way, this method will call back that selected model or NSDictionary;
 *
 *  @param block  call back (MKActionSheet* actionSheet, NSInteger buttonIndex, id obj )
 */
- (void)showWithParamBlock:(MKActionSheetParamBlock)block;

- (void)addButtonWithTitle:(NSString *)title;
- (void)addDataModel:(id)model;
@end




#pragma mark - ***** MKActionSheetCell ******
@interface MKActionSheetCell : UITableViewCell
@property (nonatomic, weak) UIButton *btnCell;
@property (nonatomic, weak) UIView *separatorView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

