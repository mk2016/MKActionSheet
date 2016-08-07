//
//  MKActionSheetCell.h
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKActionSheetCell : UITableViewCell

@property (nonatomic, weak) UIButton *btnCell;
@property (nonatomic, weak) UIButton *btnSelect;
//@property (nonatomic, weak) UIImageView *separatorView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
