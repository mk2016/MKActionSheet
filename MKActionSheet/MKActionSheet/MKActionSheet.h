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



#pragma mark - ***** MKActionSheetHelper ******
@interface MKActionSheetHelper : NSObject

+ (void)sheetWithTitle:(NSString *)title
destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sheetWithTitle:(NSString *)title
                 block:(MKActionSheetBlock)block
          buttonTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sheetWithTitle:(NSString *)title
      buttonTitleArray:(NSArray *)buttonTitleArray
destructiveButtonIndex:(NSInteger)destructiveButtonIndex
                 block:(MKActionSheetBlock)block;

+ (void)sheetWithTitle:(NSString *)title
      buttonTitleArray:(NSArray *)buttonTitleArray
                 block:(MKActionSheetBlock)block;

@end






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
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, strong) UIFont *buttonTitleFont;
@property (nonatomic, strong) UIColor *buttonTitleColor;
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor;
@property (nonatomic, assign) CGFloat buttonHeight;         /*!< default: 48.0f*/
@property (nonatomic, assign) CGFloat animationDuration;    /*!< default: 0.3f */
@property (nonatomic, assign) CGFloat blackgroundOpacity;   /*!< default: 0.3f */
@property (nonatomic, assign) CGFloat blurOpacity;          /*!< default: 0.0f */

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
