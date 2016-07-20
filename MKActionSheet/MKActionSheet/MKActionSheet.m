//
//  MKActionSheet.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheet.h"
#import "MKBlurView.h"

#ifndef MKActionSheetDefine
#define MKSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MKSCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MKSCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MKCOLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#endif

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* buttonTitles;
@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *blurView;

@end


@implementation MKActionSheet


+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray destructiveButtonIndex:(NSInteger)destructiveButtonIndex block:(MKActionSheetBlock)block{
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray destructiveButtonIndex:destructiveButtonIndex];
    [sheet showWithBlock:block];
}

+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray block:(MKActionSheetBlock)block{
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray];
    [sheet showWithBlock:block];
}

+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray isNeedCancelButton:(BOOL)isNeedCancelButton block:(MKActionSheetBlock)block{
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray];
    sheet.isNeedCancelButton = isNeedCancelButton;
    [sheet showWithBlock:block];
}

+ (void)sheetWithTitle:(NSString *)title destructiveButtonIndex:(NSInteger)destructiveButtonIndex block:(MKActionSheetBlock)block buttonTitles:(NSString *)buttonTitle, ... {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (buttonTitle) {
        [tempArray addObject:buttonTitle];
    }
    if (buttonTitle) {
        va_list args;
        va_start(args, buttonTitle);
        NSString *btnTitle;
        while ((btnTitle = va_arg(args, NSString *))) {
            [tempArray addObject:btnTitle];
        }
        va_end(args);
    }
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:tempArray destructiveButtonIndex:destructiveButtonIndex];
    [sheet showWithBlock:block];
}

+ (void)sheetWithTitle:(NSString *)title block:(MKActionSheetBlock)block buttonTitles:(NSString *)buttonTitle, ... {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (buttonTitle) {
        [tempArray addObject:buttonTitle];
    }
    if (buttonTitle) {
        va_list args;
        va_start(args, buttonTitle);
        NSString *btnTitle;
        while ((btnTitle = va_arg(args, NSString *))) {
            [tempArray addObject:btnTitle];
        }
        va_end(args);
    }
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:tempArray];
    [sheet showWithBlock:block];
}




/** init method */
- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray{
    if (self = [super init]) {
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitleArray];
        self.destructiveButtonIndex = -1;
        [self initData];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray destructiveButtonIndex:(NSInteger)destructiveButtonIndex{
    if (self = [super init]) {
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitleArray];
        self.destructiveButtonIndex = destructiveButtonIndex;
        [self initData];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSString *)buttonTitle, ... {
    if (self = [super init]) {
        self.title = title;
        self.destructiveButtonIndex = -1;
        self.buttonTitles = [[NSMutableArray alloc] init];
        if (buttonTitle) {
            [self.buttonTitles addObject:buttonTitle];
        }
        if (buttonTitle) {
            va_list args;
            va_start(args, buttonTitle);
            NSString *btnTitle;
            while ((btnTitle = va_arg(args, NSString *))) {
                [self.buttonTitles addObject:btnTitle];
            }
            va_end(args);
        }
        [self initData];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title destructiveButtonIndex:(NSInteger)destructiveButtonIndex buttonTitles:(NSString *)buttonTitle, ... {
    if (self = [super init]) {
        self.title = title;
        self.destructiveButtonIndex = destructiveButtonIndex;
        self.buttonTitles = [[NSMutableArray alloc] init];
        if (buttonTitle) {
            [self.buttonTitles addObject:buttonTitle];
        }
        if (buttonTitle) {
            va_list args;
            va_start(args, buttonTitle);
            NSString *btnTitle;
            while ((btnTitle = va_arg(args, NSString *))) {
                [self.buttonTitles addObject:btnTitle];
            }
            va_end(args);
        }
        [self initData];
    }
    return self;
}


#pragma mark - ***** methods ******
- (void)initData{
    _cancelTitle = @"取消";
    _buttonTitleFont = [UIFont systemFontOfSize:18.0f];
    _buttonTitleColor = MKCOLOR_RGBA(51.0f,51.0f,51.0f,1.0f);
    _destructiveButtonTitleColor = MKCOLOR_RGBA(250.0f, 10.0f, 10.0f, 1.0f);
    _buttonHeight = 48.0f;
    _animationDuration = 0.3f;
    _blackgroundOpacity = 0.3f;
    _blurOpacity = 0.0f;
    _titleColor = MKCOLOR_RGBA(100.0f, 100.0f, 100.0f, 1.0f);
    _buttonOpacity = 0.6;
    _isNeedCancelButton = YES;
    _maxShowButtonCount = 5.8;
}


- (void)addButtonWithTitle:(NSString *)title{
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    [_buttonTitles addObject:title];
}

#pragma mark - ***** show ******
- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate{
    if (delegate) {
        self.delegate = delegate;
    }
    [self show];
}


- (void)showWithBlock:(MKActionSheetBlock)block{
    if (block) {
        self.block = block;
    }
    [self show];
}

- (void)show{
    if (self.blackgroundOpacity < 0.1f) {
        self.blackgroundOpacity = 0.1f;
    }
    
    [self setupMainView];
    self.bgWindow.hidden = NO;
    [self.bgWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:self.blackgroundOpacity];
        [self.shadeView setUserInteractionEnabled:YES];

        CGRect frame = self.tableView.frame;
        frame.origin.y = MKSCREEN_HEIGHT - frame.size.height;
        self.tableView.frame = frame;
    } completion:nil];
}

#pragma mark - ***** dismiss ******
- (void)dismiss{
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:0];
        [self.shadeView setUserInteractionEnabled:NO];

        CGRect frame = self.tableView.frame;
        frame.origin.y += frame.size.height;
        self.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.bgWindow.hidden = YES;
    }];
}

- (void)btnOnclicked:(UIButton *)sender{
    [self dismiss];
    if (self.block) {
        self.block(self, sender.tag);
    }
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickButtonAtIndex:sender.tag];
    }
}


#pragma mark - ***** setup UI ******
- (void)setupMainView{
    self.frame = MKSCREEN_BOUNDS;
    [self addSubview:self.shadeView];
    [self addSubview:self.tableView];
    

    CGFloat tableViewH = 0;

    if (self.title) {
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity);
        
        UILabel* labTitle = [[UILabel alloc] init];
        labTitle.text = self.title;
        labTitle.numberOfLines = 0;
        labTitle.textColor = self.titleColor;
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = [UIFont systemFontOfSize:13.0f];
        [headView addSubview:labTitle];
        
        CGSize titleSize = [labTitle.text boundingRectWithSize:CGSizeMake(MKSCREEN_WIDTH-32, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: labTitle.font}
                                              context:nil].size;
        labTitle.frame = CGRectMake(16, 8, MKSCREEN_WIDTH-32, titleSize.height);
        headView.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, titleSize.height+16);
        
        self.tableView.tableHeaderView = headView;
        
        tableViewH += headView.frame.size.height;

    }
    
    CGFloat maxCount = self.buttonTitles.count > self.maxShowButtonCount ? self.maxShowButtonCount : self.buttonTitles.count;
    tableViewH += maxCount * self.buttonHeight;
    
    if (self.isNeedCancelButton) {
        tableViewH += self.buttonHeight + 6;
    }
    
    self.tableView.frame = CGRectMake(0, MKSCREEN_HEIGHT, MKSCREEN_WIDTH, tableViewH);
    self.blurView = [[MKBlurView alloc] initWithFrame:self.tableView.bounds];
    [self.blurView setAlpha:self.blurOpacity];
    self.tableView.backgroundView = self.blurView;

    [self.tableView reloadData];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKActionSheetCell *cell = [MKActionSheetCell cellWithTableView:tableView];
    
    cell.btnCell.frame = CGRectMake(0, 0.5, MKSCREEN_WIDTH, self.buttonHeight-0.5);
    [cell.btnCell setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity)] forState:UIControlStateNormal];
    [cell.btnCell setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, 0)] forState:UIControlStateHighlighted];
    [cell.btnCell addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCell.titleLabel.font = self.buttonTitleFont;
    [cell.btnCell setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    
    if (indexPath.section == 0) {
        cell.btnCell.tag = indexPath.row;
        [cell.btnCell setTitle:self.buttonTitles[indexPath.row] forState:UIControlStateNormal];

        if (indexPath.row == self.destructiveButtonIndex) {
            [cell.btnCell setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
        }
    }else if (indexPath.section == 1){
        cell.btnCell.tag = self.buttonTitles.count;
        [cell.btnCell setTitle:self.cancelTitle forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isNeedCancelButton ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.buttonTitles.count > 0 ? self.buttonTitles.count : 0;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.buttonHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 6;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = MKCOLOR_RGBA(100, 100, 100, 0.1);
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MKSCREEN_WIDTH, 0.5)];
        separatorView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.15);
        [view addSubview:separatorView];
        
        return view;
    }
    return nil;
}

#pragma mark - ***** lazy ******
- (UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:MKSCREEN_BOUNDS];
        _bgWindow.windowLevel = UIWindowLevelStatusBar;
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}

- (UIView*)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc] init];
        [_shadeView setFrame:MKSCREEN_BOUNDS];
        [_shadeView setBackgroundColor:MKCOLOR_RGBA(0, 0, 0, 1)];
        [_shadeView setUserInteractionEnabled:NO];
        [_shadeView setAlpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_shadeView addGestureRecognizer:tap];
    }
    return _shadeView;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = self.buttonHeight;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end








#pragma mark - ***** MKActionSheepCell ******
@implementation MKActionSheetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MKActionSheetCell";
    MKActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MKActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MKSCREEN_WIDTH, 0.5)];
        separatorView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.1);
        [cell addSubview:separatorView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:btn];
        cell.btnCell = btn;
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