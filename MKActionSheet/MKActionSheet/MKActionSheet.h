//
//  MKActionSheet.h
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKActionSheet;
typedef void(^MKActionSheetBlock)(MKActionSheet* actionSheet, NSInteger buttonIndex );

#pragma mark - ***** MKActionSheetDelegate ******
@protocol MKActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex;
@end

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet : UIView

@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 */
@property (nonatomic, copy) MKActionSheetBlock block;               /*!< 点击按钮回调 */
@property (nonatomic, weak) id <MKActionSheetDelegate> delegate;    /*!< 代理 */

/**  custom UI */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 */
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title */
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< default: 48.0f*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 default: 0.3f */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 default: 0.0f */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 default: 0.3f */
@property (nonatomic, assign) BOOL isNeedCancelButton;              /*!< 是否需要取消按钮 */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 */


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
                 block:(MKActionSheetBlock)block;

+ (void)sheetWithTitle:(NSString *)title
destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sheetWithTitle:(NSString *)title
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;





/** init method */
- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray;

- (instancetype)initWithTitle:(NSString *)title
             buttonTitleArray:(NSArray *)buttonTitleArray
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex;

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString *)title
       destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

/** show method */
- (void)show;
- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;
- (void)showWithBlock:(MKActionSheetBlock)block;

- (void)addButtonWithTitle:(NSString *)title;

@end




#pragma mark - ***** MKActionSheetCell ******
@interface MKActionSheetCell : UITableViewCell
@property (nonatomic, weak) UIButton *btnCell;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

