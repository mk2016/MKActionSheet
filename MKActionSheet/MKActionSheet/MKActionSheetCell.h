//
//  MKActionSheetCell.h
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MKActionSheet_select_button_tag 100

@interface MKActionSheetCell : UITableViewCell

@property (nonatomic, weak) UIButton *btnCell;
@property (nonatomic, weak) UIButton *btnSelect;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
