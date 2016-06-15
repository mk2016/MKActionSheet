//
//  MKActionSheet.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheet.h"

#ifndef MKActionSheetDefine
#define MKSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MKSCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MKSCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MKCOLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#endif




#pragma mark - ***** MKActionSheetHelper ******
@implementation MKActionSheetHelper

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

+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray destructiveButtonIndex:(NSInteger)destructiveButtonIndex block:(MKActionSheetBlock)block{
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray destructiveButtonIndex:destructiveButtonIndex];
    [sheet showWithBlock:block];
}

+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray block:(MKActionSheetBlock)block{
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray];
    [sheet showWithBlock:block];
}

@end







#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet()
@property (nonatomic, strong) NSMutableArray* buttonTitles;
@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *blurView;

@end


@implementation MKActionSheet

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
    
    UIColor *lineColor = MKCOLOR_RGBA(0.0f, 0.0f, 0.0f, 0.1f);
    
    UIImage *tImg = [self imageWithColor:MKCOLOR_RGBA(255, 255, 255, 0)];
    UIImage *bImg = [self imageWithColor:MKCOLOR_RGBA(255, 255, 255, self.buttonOpacity)];
    
    CGFloat titleHeight = 0;
    if (self.title) {
        titleHeight = 36.0f;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > MKSCREEN_WIDTH - 30.f) {
            titleHeight = 56.0f;
        }
        
        UIView* titleBgView = [[UIView alloc] init];
        titleBgView.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, titleHeight);
        [self.sheetView addSubview:titleBgView];
        
        UIImageView *titleBgImg = [[UIImageView alloc] initWithImage:bImg];
        titleBgImg.frame = titleBgView.bounds;
        [titleBgView addSubview:titleBgImg];
        
        UILabel* labTitle = [[UILabel alloc] init];
        labTitle.text = self.title;
        labTitle.numberOfLines = 2.0f;
        labTitle.textColor = self.titleColor;
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = [UIFont systemFontOfSize:13.0f];
        labTitle.frame = CGRectMake(15.0f, 0.0f, MKSCREEN_WIDTH - 30.0f, titleBgView.frame.size.height);
        [titleBgView addSubview:labTitle];
    }
    
 

    if (self.buttonTitles.count) {
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            CGFloat lineY = titleHeight + (self.buttonHeight+0.5) * i;

            UIView *line = [[UIView alloc] init];
            line.backgroundColor = lineColor;
            line.frame = CGRectMake(0, lineY, MKSCREEN_WIDTH, 0.5f);
            [self.sheetView addSubview:line];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.titleLabel.font = self.buttonTitleFont;
            [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            if (i == self.destructiveButtonIndex) {
                [btn setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
            }
            
            [btn setBackgroundImage:bImg forState:UIControlStateNormal];
            [btn setBackgroundImage:tImg forState:UIControlStateHighlighted];
            
            btn.frame = CGRectMake(0, lineY+0.5, MKSCREEN_WIDTH, self.buttonHeight);
            [self.sheetView addSubview:btn];
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = lineColor;
        line.frame = CGRectMake(0, titleHeight + (self.buttonHeight+0.5) * self.buttonTitles.count, MKSCREEN_WIDTH, 0.5);
        [self.sheetView addSubview:line];
    }
    
    //取消按钮
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:bImg forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:tImg forState:UIControlStateHighlighted];
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = self.buttonTitleFont;
    cancelBtn.tag = self.buttonTitles.count;
    [cancelBtn addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnY = titleHeight + (0.5f + self.buttonHeight) * self.buttonTitles.count + 6.0f;
    cancelBtn.frame = CGRectMake(0, btnY, MKSCREEN_WIDTH, self.buttonHeight);
    [self.sheetView addSubview:cancelBtn];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = lineColor;
    line.frame = CGRectMake(0, btnY-0.5, MKSCREEN_WIDTH, 0.5);
    [self.sheetView addSubview:line];
    
    CGFloat sheetViewH = btnY + self.buttonHeight;
    self.sheetView.frame = CGRectMake(0, MKSCREEN_HEIGHT, MKSCREEN_WIDTH, sheetViewH);
    
    self.blurView = [[UIView alloc] initWithFrame:self.sheetView.bounds];
    [self.blurView setClipsToBounds:YES];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:self.blurView.bounds];
    [self.blurView.layer insertSublayer:[bar layer] atIndex:0];
    [self.sheetView addSubview:self.blurView];
    [self.sheetView sendSubviewToBack:self.blurView];
    [self setBlurAlpha:self.blurOpacity];
}

- (void)setBlurAlpha:(CGFloat)alpha{
    unsigned long numComponents = CGColorGetNumberOfComponents([[self.blurView backgroundColor] CGColor]);
    if (numComponents == 4){
        const CGFloat *components = CGColorGetComponents([[self.blurView backgroundColor] CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        [self.blurView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    }else{
        [self.blurView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
    }
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


