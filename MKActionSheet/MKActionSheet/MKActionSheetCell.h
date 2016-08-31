//
//  MKActionSheetCell.h
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MKActionSheet_select_button_tag 100

#ifndef MKActionSheetDefine
#define MKSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MKSCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MKSCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MKCOLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#define MKWEAKSELF typeof(self) __weak weakSelf = self;
#define MKBlockExec(block, ...) if (block) { block(__VA_ARGS__); };
#endif

@interface MKActionSheetCell : UITableViewCell

@property (nonatomic, weak) UIButton *btnCell;
@property (nonatomic, weak) UIButton *btnSelect;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
