//
//  MKActionSheetCell.m
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheetCell.h"


@implementation MKActionSheetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MKActionSheetCell";
    MKActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MKActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:btn];
        cell.btnCell = btn;
        
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *btnConstraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(btn)];
        
        NSArray *btnConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(btn)];
        [cell addConstraints:btnConstraints_H];
        [cell addConstraints:btnConstraints_V];
        
        //select button
        NSString *bundle = [[NSBundle bundleForClass:self.class] pathForResource:@"MKActionSheet" ofType:@"bundle"];
        NSString *selectImgPath0 = [bundle stringByAppendingPathComponent:@"img_select_0.png"];
        NSString *selectImgPath1 = [bundle stringByAppendingPathComponent:@"img_select_1.png"];
        NSString *selectImgPath2 = [bundle stringByAppendingPathComponent:@"img_selected.png"];
        UIImage *selectImg0 = [UIImage imageWithContentsOfFile:selectImgPath0];
        UIImage *selectImg1 = [UIImage imageWithContentsOfFile:selectImgPath1];
        UIImage *selectImg2 = [UIImage imageWithContentsOfFile:selectImgPath2];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.tag = MKActionSheet_select_button_tag;
        selectBtn.userInteractionEnabled = NO;
        [selectBtn setImage:selectImg0 forState:UIControlStateNormal];
        [selectBtn setImage:selectImg1 forState:UIControlStateSelected];
        [selectBtn setImage:selectImg1 forState:UIControlStateHighlighted];
        [selectBtn setImage:selectImg2 forState:UIControlStateDisabled];
        cell.btnSelect = selectBtn;
        [btn addSubview:cell.btnSelect];
        
        selectBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectBtn]-16-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(selectBtn)];
        
        NSArray *constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selectBtn]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(selectBtn)];
        [btn addConstraints:constraints_H];
        [btn addConstraints:constraints_V];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
