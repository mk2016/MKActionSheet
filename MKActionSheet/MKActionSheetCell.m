//
//  MKActionSheetCell.m
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheetCell.h"
#import "UIImage+MKASAdd.h"


@interface MKActionSheetCell(){
}
@property (nonatomic, weak) UIImageView *selectedImageView;

@end

@implementation MKActionSheetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MKActionSheetCell";
    MKActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MKActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initUI];
    }
    return cell;
}

- (void)initUI{
    
    //selected imageView
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6]]];
    [self addSubview:imgView];
    self.selectedImageView = imgView;
    
    //cell button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [self addSubview:btn];
    self.btnCell = btn;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    self.selectedImageView.hidden = highlighted;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectedImageView.frame = self.bounds;
    self.btnCell.frame = self.bounds;
    
    if (_btnSelect) {
        _btnSelect.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"btnSelect" : _btnSelect};
        NSArray *btnSelect_vfl_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btnSelect]-16-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
        NSArray *btnSelect_vfl_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnSelect]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
        [self addConstraints:btnSelect_vfl_H];
        [self addConstraints:btnSelect_vfl_V];
    }
    

}

- (UIButton *)btnSelect{
    if (!_btnSelect) {
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
        [self addSubview:selectBtn];
        _btnSelect = selectBtn;
    }
    return _btnSelect;
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
