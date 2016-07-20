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
@interface MKActionSheet()<UITableViewDelegate, UITableViewDataSource>{
    CGFloat _titleViewH;    /*!< title view height */
}

@property (nonatomic, strong) NSMutableArray* buttonTitles; /*!< button titles array */
@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

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
    _maxShowButtonCount = 5.6;
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

        CGRect frame = self.sheetView.frame;
        frame.origin.y = MKSCREEN_HEIGHT - frame.size.height;
        self.sheetView.frame = frame;
    } completion:nil];
}

#pragma mark - ***** dismiss ******
- (void)dismiss{
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:0];
        [self.shadeView setUserInteractionEnabled:NO];

        CGRect frame = self.sheetView.frame;
        frame.origin.y += frame.size.height;
        self.sheetView.frame = frame;
        
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
    [self addSubview:self.sheetView];
    [self.sheetView addSubview:self.tableView];

    CGFloat sheetViewH = 0;

    if (self.title) {
        [self.sheetView addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
    
        CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MKSCREEN_WIDTH-32, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: self.titleLabel.font}
                                              context:nil].size;
        
        self.titleLabel.frame = CGRectMake(16, 8, MKSCREEN_WIDTH-32, titleSize.height);
        self.titleView.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, titleSize.height+16);
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.size.height-0.7, MKSCREEN_WIDTH, 0.7)];
        separatorView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.2);
        [self.titleView addSubview:separatorView];
        
        sheetViewH += self.titleView.frame.size.height;

    }
    
    CGFloat maxCount = self.buttonTitles.count > self.maxShowButtonCount ? self.maxShowButtonCount : self.buttonTitles.count;
    CGFloat tableViewH = maxCount * self.buttonHeight;
    
    self.tableView.frame = CGRectMake(0, sheetViewH, MKSCREEN_WIDTH, tableViewH);

    sheetViewH += tableViewH;
    
    if (self.isNeedCancelButton) {
        sheetViewH += self.buttonHeight + 6;
        
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y+self.tableView.frame.size.height, MKSCREEN_WIDTH, self.buttonHeight + 6)];
        [cancelView addSubview:self.cancelButton];
        [self.sheetView addSubview:cancelView];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MKSCREEN_WIDTH, 6)];
        sepView.backgroundColor = MKCOLOR_RGBA(100, 100, 100, 0.1);
        [cancelView addSubview:sepView];
        
        CALayer *topBorderLayer = [CALayer layer];
        topBorderLayer.frame = CGRectMake(0, 0, sepView.frame.size.width, 0.5);
        topBorderLayer.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.1).CGColor;
        [sepView.layer addSublayer:topBorderLayer];
        
        CALayer *botBorderLayer = [CALayer layer];
        botBorderLayer.frame = CGRectMake(0, sepView.frame.size.height - 0.5, sepView.frame.size.width, 0.5);
        botBorderLayer.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.1).CGColor;
        [sepView.layer addSublayer:botBorderLayer];
        
    }
    
    self.sheetView.frame = CGRectMake(0, MKSCREEN_HEIGHT, MKSCREEN_WIDTH, sheetViewH);
    self.blurView = [[MKBlurView alloc] initWithFrame:self.sheetView.bounds];
    [self.blurView setAlpha:self.blurOpacity];
    [self.sheetView addSubview:self.blurView];
    [self.sheetView sendSubviewToBack:self.blurView];
    
    [self.tableView reloadData];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKActionSheetCell *cell = [MKActionSheetCell cellWithTableView:tableView];
    cell.separatorView.frame = CGRectMake(0, self.buttonHeight-0.5, MKSCREEN_WIDTH, 0.5);
    
    cell.btnCell.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, self.buttonHeight-0.5);
    [cell.btnCell setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity)] forState:UIControlStateNormal];
    [cell.btnCell setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, 0)] forState:UIControlStateHighlighted];
    [cell.btnCell addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCell.titleLabel.font = self.buttonTitleFont;
    [cell.btnCell setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    
    cell.btnCell.tag = indexPath.row;
    [cell.btnCell setTitle:self.buttonTitles[indexPath.row] forState:UIControlStateNormal];
    
    if (indexPath.row == self.destructiveButtonIndex) {
        [cell.btnCell setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
    }
    
    if (indexPath.row == self.buttonTitles.count - 1) {
        cell.separatorView.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttonTitles.count > 0 ? self.buttonTitles.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.buttonHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
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


- (UIView*)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] init];
        [_sheetView setBackgroundColor:[UIColor clearColor]];
    }
    return _sheetView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = self.buttonHeight;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity);
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity)] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:MKCOLOR_RGBA(255, 255, 255, 0)] forState:UIControlStateHighlighted];
        [_cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = self.buttonTitleFont;
        _cancelButton.tag = self.buttonTitles.count;
        [_cancelButton addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(0, 6, MKSCREEN_WIDTH, self.buttonHeight);
    }
    return _cancelButton;
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
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.1);
        [cell addSubview:separatorView];
        cell.separatorView = separatorView;
        
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