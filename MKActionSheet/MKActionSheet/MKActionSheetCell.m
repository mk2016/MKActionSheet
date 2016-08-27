//
//  MKActionSheetCell.m
//  MKActionSheet
//
//  Created by xiaomk on 16/8/5.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheetCell.h"
#import "UIImage+MKExtension.h"


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
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:MKCOLOR_RGBA(255, 255, 255, 0.6)]];
    [self addSubview:imgView];
    self.selectedImageView = imgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel sizeToFit];
    self.titleLabel = titleLabel;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    self.selectedImageView.hidden = highlighted;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectedImageView.frame = self.bounds;
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *formatH;
    NSDictionary *views;
    if (_iconButton || _btnSelect) {
        if (_iconButton && _btnSelect) {
            views = @{@"title"      : _titleLabel,
                      @"icon"       : _iconButton,
                      @"btnSelect"  : _btnSelect};
            formatH = @"H:[icon][title][btnSelect]";
        }else if (_iconButton){
            views = @{@"title"      : _titleLabel,
                      @"icon"       : _iconButton};
            formatH = @"H:[icon][title]|";
        }else if (_btnSelect){
            views = @{@"title"      : _titleLabel,
                      @"btnSelect"  : _btnSelect
                      };
            formatH = [NSString stringWithFormat:@"H:|-%f-[title][btnSelect]", _titleMargin];
        }
    }else{
        views = @{@"title" : _titleLabel};
        formatH = [NSString stringWithFormat:@"H:|-%f-[title]|", _titleMargin];
    }
    NSArray *title_vfl_H = [NSLayoutConstraint constraintsWithVisualFormat:formatH
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    
    NSArray *title_vfl_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    [self addConstraints:title_vfl_H];
    [self addConstraints:title_vfl_V];
    
    
    if (_iconButton) {
        _iconButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *icon_vfl_H = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[icon(<=60)][title]",_titleMargin]
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
        
        NSArray *icon_vfl_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[icon]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
        [self addConstraints:icon_vfl_H];
        [self addConstraints:icon_vfl_V];
    }
    
    if (_btnSelect) {
        _btnSelect.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *selectBtn_vfl_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[title][btnSelect]-16-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
        
        NSArray *selectBtn_vfl_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnSelect]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
        [self addConstraints:selectBtn_vfl_H];
        [self addConstraints:selectBtn_vfl_V];
    }
    
    
   
}

- (UIButton *)iconButton{
    if (!_iconButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        _iconButton = btn;
    }
    return _iconButton;
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
