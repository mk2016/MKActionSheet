//
//  MKActionSheet.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheet.h"
#import "MKActionSheetCell.h"
#import "MKActionSheetAdd.h"
#import "Masonry.h"
#import "MKASRootViewController.h"

#ifndef MKActionSheetDefine
#define MKSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MKSCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MKSCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MKCOLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#define MKWEAKSELF typeof(self) __weak weakSelf = self;
#define MKBlockExec(block, ...) if (block) { block(__VA_ARGS__); };
#endif


#define MKAS_BUTTON_SEPARATOR_HEIGHT    0.3f
#define MKAS_BUTTON_TAG_BASE            100

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet()<UIScrollViewDelegate>
@property (nonatomic, assign) MKActionSheetSelectType selectType;               /*!< 选择模式：默认、单选(在初始选择的后面会有标示)、多选*/

@property (nonatomic, strong) NSMutableArray *buttonTitles;             /*!< button titles array */
@property (nonatomic, strong) NSMutableArray *objArray;                 /*!< objects array */

@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonViewsArray;
@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *cancelSeparatorView;

@property (nonatomic, assign) BOOL paramIsObject;                       /*!< init array is model or dictionary */

@property (nonatomic, assign) CGFloat sheetHeight;
@property (nonatomic, assign) BOOL isShow;
@end


@implementation MKActionSheet

#pragma mark - ***** init method ******

- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray{
    return [self initWithTitle:title buttonTitleArray:buttonTitleArray selectType:MKActionSheetSelectType_common];
}

- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray selectType:(MKActionSheetSelectType)selectType{
    if (self = [super init]) {
        _selectType = selectType;
        _title = title;
        _buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitleArray];
        [self initData];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title objArray:(NSArray *)objArray buttonTitleKey:(NSString *)buttonTitleKey{
    return [self initWithTitle:title objArray:objArray buttonTitleKey:buttonTitleKey selectType:MKActionSheetSelectType_common];
}

- (instancetype)initWithTitle:(NSString *)title objArray:(NSArray *)objArray buttonTitleKey:(NSString *)buttonTitleKey selectType:(MKActionSheetSelectType)selectType{
    return [self initWithTitle:title objArray:objArray buttonTitleKey:buttonTitleKey imageKey:nil imageValueType:MKActionSheetButtonImageValueType_none selectType:selectType];
}

- (instancetype)initWithTitle:(NSString *)title
                     objArray:(NSArray *)objArray
               buttonTitleKey:(NSString *)buttonTitleKey
                     imageKey:(NSString *)imageKey
               imageValueType:(MKActionSheetButtonImageValueType)imageValueType
                   selectType:(MKActionSheetSelectType)selectType{
    
    if (self = [super init]) {
        _selectType = selectType;
        _title = title;
        _titleKey = buttonTitleKey;
        _objArray = [[NSMutableArray alloc] initWithArray:objArray];
        _paramIsObject = YES;
        _imageKey = imageKey;
        _imageValueType = imageValueType;
        if (imageValueType != MKActionSheetButtonImageValueType_none) {
            NSAssert(imageKey && imageKey.length > 0, @"设置带 icon 图片的类型，imageKey 不能为nil 或者 空");
        }
        [self initData];
    }
    return self;
    
}

#pragma mark - ***** methods ******
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectType == MKActionSheetSelectType_selected) {
        _selectedIndex = selectedIndex;
    }else{
        NSAssert(NO, @"初始化 selectType = MKActionSheetSelectType_selected 时 设置 selectedIndex 才有效");
    }
}

- (void)addButtonWithTitle:(NSString *)title{
    NSAssert(!_paramIsObject, @"以 objArray 初始化时，不能直接添加 title, 请使用 addButtonWithObj:(id)obj");
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    [_buttonTitles addObject:title];
}

- (void)addButtonWithObj:(id)obj{
    NSAssert(_paramIsObject, @"不是由 objArray 初始化时，不能直接添加 object, 请使用 addButtonWithTitle:(NSString *)title");
    if (!_objArray) {
        _objArray = [[NSMutableArray alloc] init];
    }
    [_objArray addObject:obj];
}

/** init data */
- (void)initData{
    _windowLevel = MKActionSheet_WindowLevel;
    _enableBgTap = YES;

    //默认样式
    _titleColor = MKCOLOR_RGBA(100.0f, 100.0f, 100.0f, 1.0f);
    _titleFont = [UIFont systemFontOfSize:14];
    _titleAlignment = NSTextAlignmentCenter;
    
    _buttonTitleColor = MKCOLOR_RGBA(51.0f,51.0f,51.0f,1.0f);
    _buttonTitleFont = [UIFont systemFontOfSize:18.0f];
    _buttonOpacity = 0.6;
    _buttonHeight = 48.0f;
    _buttonTitleAlignment = MKActionSheetButtonTitleAlignment_center;

    _destructiveButtonTitleColor = MKCOLOR_RGBA(250.0f, 10.0f, 10.0f, 1.0f);
    _destructiveButtonIndex = -1;
    _cancelTitle = @"取消";
    _titleMargin = 20.0f;
    _animationDuration = 0.3f;
    _blurOpacity = 0.3f;
    _blackgroundOpacity = 0.3f;
    _maxShowButtonCount = 5.6;
    _needCancelButton = YES;
    _showSeparator = YES;
    _separatorLeftMargin = 0;
    
    
    _multiselectConfirmButtonTitleColor = MKCOLOR_RGBA(100.0f, 100.0f, 100.0f, 1.0f);
    
    //以 object array 初始化，默认没有取消按钮
    if (_paramIsObject) {
        _needCancelButton = NO;
    }
    
    // 根据 selectType 初始化默认样式
    if (_selectType == MKActionSheetSelectType_multiselect || _selectType == MKActionSheetSelectType_selected) {       //多选 样式， title 默认 居左对齐，无取消按钮
        _titleAlignment = NSTextAlignmentLeft;
        _buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
        _needCancelButton = NO;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        _titleAlignment = NSTextAlignmentCenter;
        _buttonTitleAlignment = MKActionSheetButtonTitleAlignment_center;
    }
}

#pragma mark - ***** show methods******
- (void)showWithBlock:(MKActionSheetBlock)block{
    NSAssert(_selectType != MKActionSheetSelectType_multiselect, @"多选样式 应该使用 showWithMultiselectBlock: 方法");
    _block = block;
    [self show];
}

- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock{
    NSAssert(_selectType == MKActionSheetSelectType_multiselect, @"非多选模式，应该使用 showWithBlock: 方法");
    _multiselectBlock = multiselectblock;
    [self show];
}

#pragma mark - ***** dismiss ******
/** 点击取消按钮 */
- (void)btnCancelOnclicked:(UIButton *)sender{
    NSInteger index = sender.tag;
    [self dismissWithButtonIndex:index];
}

- (void)dismissWithButtonIndex:(NSInteger)index{
    if (self.selectType == MKActionSheetSelectType_multiselect) {
        //多选样式下 只有 取消按钮才会走这里
        MKBlockExec(self.multiselectBlock, self, nil);
    }else{
        MKBlockExec(self.block, self, index)
    }
    [self dismiss];
}

/** 多选确认按钮 */
- (void)confirmButtonOnclick:(UIButton *)sender{
    
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.buttonTitles.count; i++) {
        NSString *title = [self.buttonTitles objectAtIndex:i];
        if (title.mkas_selected) {
            if (self.paramIsObject){
                [selectedArray addObject:[self.objArray objectAtIndex:i]];
            }else{
                [selectedArray addObject:[self.buttonTitles objectAtIndex:i]];
            }
        }
    }
    MKBlockExec(self.multiselectBlock, self, selectedArray);
    [self dismiss];
}



- (void)show{
    if (_paramIsObject) {
        NSAssert(_titleKey && _titleKey.length > 0, @"titleKey 不能为nil 或者 空, 必须是有效的 NSString");
        NSAssert(_objArray, @"_objArray 不能为 nil");
        for (id obj in _objArray) {
            id titleValue = [obj valueForKey:_titleKey];
            if (!titleValue || ![titleValue isKindOfClass:[NSString class]]) {
                NSAssert(NO, @"obj.titleKey 必须为 有效的 NSString");
            }
        }
        _buttonTitles = [_objArray valueForKey:_titleKey];
    }
    
    if (_blackgroundOpacity < 0.1f) {
        _blackgroundOpacity = 0.1f;
    }
    
    [self setupMainView];
    self.isShow = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.shadeView.alpha = self.blackgroundOpacity;
        self.shadeView.userInteractionEnabled = YES;
        [self layoutIfNeeded];
    } completion:nil];
}



- (void)dismiss{
    if (self.selectType == MKActionSheetSelectType_multiselect) {
        for (NSString *title in self.buttonTitles) {
            title.mkas_selected = NO;
        }
    }
    self.isShow = NO;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:0];
        [self.shadeView setUserInteractionEnabled:NO];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
        self.bgWindow.hidden = YES;
        self.bgWindow = nil;
    }];
}



#pragma mark - ***** setup UI ******
- (void)statusBarOrientationChange:(NSNotification *)notification{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        NSLog(@"LR");
    }if (orientation == UIInterfaceOrientationPortrait){
        NSLog(@"P");
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setupMainView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    [self addSubview:self.shadeView];
    [self addSubview:self.sheetView];
    
    self.blurView.backgroundColor = MKCOLOR_RGBA(100, 100, 100, _blurOpacity);
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.blurView addSubview:effectView];
    [self.sheetView addSubview:self.blurView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.blurView);
    }];

    [self.sheetView addSubview:self.titleView];
    [self.sheetView addSubview:self.scrollView];
    [self.sheetView addSubview:self.cancelView];
    
    
    if (self.isNeedCancelButton) {
        [self.cancelView addSubview:self.cancelButton];
        [self.cancelButton addSubview:self.cancelSeparatorView];
    }

    //UIScrollView
    self.scrollView.contentSize = CGSizeMake(MKSCREEN_WIDTH, self.buttonTitles.count *(self.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)-MKAS_BUTTON_SEPARATOR_HEIGHT);
    [self.buttonViewsArray removeAllObjects];
    for (NSInteger i = 0; i < self.buttonTitles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:view];
        [self.buttonViewsArray addObject:view];
        CGRect viewFrame = CGRectMake(0, (self.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)*i, MKSCREEN_WIDTH, self.buttonHeight);
        view.frame = viewFrame;
        
        UIButton *btn = [self createButton];
        [view addSubview:btn];
        btn.frame = CGRectMake(0, 0, viewFrame.size.width, self.buttonHeight);
        btn.tag = i + MKAS_BUTTON_TAG_BASE;
        [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
        if (i == self.destructiveButtonIndex) {
            [btn setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
        }
//
//        UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
//        if (self.selectType == MKActionSheetSelectType_multiselect) {   //多选
//            btnSelect.hidden = NO;
//            NSString *title = [self.buttonTitles objectAtIndex:i];
//            btnSelect.selected = title.mkas_selected;
//            
//            if (self.selectBtnImageNameNormal && self.selectBtnImageNameNormal.length > 0) {
//                [btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateNormal];
//            }
//            if (self.selectBtnImageNameSelected && self.selectBtnImageNameSelected.length > 0) {
//                [btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateSelected];
//                [btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateHighlighted];
//            }
//        }else if (self.selectType == MKActionSheetSelectType_selected){ //单选
//            btnSelect.hidden = YES;
//            btnSelect.enabled = NO;
//            if (self.selectedIndex == i) {
//                btnSelect.hidden = NO;
//            }
//            
//            if (self.selectedBtnImageName && self.selectedBtnImageName.length > 0) {
//                [btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateDisabled];
//            }
//        }
    }
    
    //title
    if (self.selectType == MKActionSheetSelectType_multiselect && !self.title) {
        self.title = @"";
    }

    if (self.title || self.customTitleView) {
        if (self.customTitleView) {
            [self.customTitleView removeFromSuperview];
            [self.titleView addSubview:self.customTitleView];
        }else if (self.title){
            [self.titleView addSubview:self.titleLabel];
            self.titleLabel.text = self.title;
                
            if (self.selectType == MKActionSheetSelectType_multiselect) {
                [self.titleView addSubview:self.confirmButton];
                UIView *leftLine = [[UIView alloc] init];
                leftLine.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.2);
                [_confirmButton addSubview:leftLine];
                
                [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.centerY.equalTo(self.confirmButton);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(20);
                }];
            }
        }
    }
    
    
    
    
    [self.bgWindow.rootViewController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgWindow.rootViewController.view);
    }];
    [_bgWindow layoutIfNeeded];

    
 



  
    

    
//    
//    if (self.title || self.customTitleView) {
//  
//        
//        if (self.customTitleView) {
//            [self.customTitleView removeFromSuperview];
//            [self.titleView addSubview:self.customTitleView];
//            [self.customTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.titleView);
//            }];
//        }else if (self.title){
//            [self.titleView addSubview:self.titleLabel];
//            
//            UIView *separator = [[UIView alloc] init];
//            separator.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.2);
//            [self.titleView addSubview:separator];
//            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(self.titleView);
//                make.height.mas_equalTo(0.5);
//            }];
//            
//            CGFloat titleLabWidth = MKSCREEN_WIDTH - self.titleMargin*2;
//            if (self.selectType == MKActionSheetSelectType_multiselect) {
//                titleLabWidth = titleLabWidth-80-4+self.titleMargin;
//                [self.titleView addSubview:self.confirmButton];
//            }
//            CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(titleLabWidth, MAXFLOAT)
//                                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                                               attributes:@{NSFontAttributeName: self.titleLabel.font}
//                                                                  context:nil].size;
//            self.sheetHeight += titleSize.height+20;
//
//            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.equalTo(self.sheetView);
//                make.bottom.equalTo(self.tableView.mas_top);
//                make.height.mas_equalTo(titleSize.height+20);
//            }];
//            
//    
//            
//            if (self.selectType == MKActionSheetSelectType_multiselect) {
//                [self.titleView addSubview:self.confirmButton];
//                
//                [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self.titleView);
//                    make.width.mas_equalTo(80);
//                    make.right.equalTo(self.titleView);
//                }];
//                
//                
//                UIView *leftLine = [[UIView alloc] init];
//                leftLine.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.2);
//                [_confirmButton addSubview:leftLine];
//                
//                [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.centerY.equalTo(self.confirmButton);
//                    make.width.mas_equalTo(1);
//                    make.height.mas_equalTo(20);
//                }];
//                [[UIDevice currentDevice] identifierForVendor];
//                [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self.titleView);
//                    make.left.equalTo(self.titleView).offset(self.titleMargin);
//                    make.right.equalTo(self.confirmButton.mas_left).offset(-4);
//                }];
//            }
//        }
//    }
}

- (void)btnClick:(UIButton *)sender{
    NSLog(@"%ld", (long)sender.tag);
}

- (void)updateConstraints{
    
    [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.sheetView.mas_top);
    }];
    
    if (self.isShow) {
        [self.sheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }else{
        [self.sheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
    }
    
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sheetView);
    }];
    
    //titleView
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.sheetView);
    }];
    
    if (self.customTitleView) {
        [self.customTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleView);
        }];
    }else if (self.title){
        if (self.selectType == MKActionSheetSelectType_multiselect) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.titleView);
                    make.width.mas_equalTo(80);
                    make.right.equalTo(self.titleView);
                }];
                
                [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.titleView);
                    make.left.equalTo(self.titleView).offset(self.titleMargin);
                    make.right.equalTo(self.confirmButton.mas_left).offset(-4);
                }];
            }];
        }else{
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleView);
                make.left.equalTo(self.titleView).offset(self.titleMargin);
                make.right.equalTo(self.titleView).offset(-self.titleMargin);
                make.top.equalTo(self.titleView).offset(10);
                make.bottom.equalTo(self.titleView).offset(-10);
            }];
        }
    }else{
        [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.sheetView);
            make.height.mas_equalTo(0.1);
        }];
    }
    
    [self.cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.sheetView);
    }];
    
    if (self.isNeedCancelButton) {
        self.cancelView.hidden = NO;
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.cancelView);
            make.height.mas_equalTo(self.buttonHeight);
        }];
        
        [self.cancelSeparatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.cancelView);
            make.bottom.equalTo(self.cancelButton.mas_top);
            make.height.mas_equalTo(6);
        }];
    }else{
        self.cancelView.hidden = YES;
        [self.cancelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.sheetView);
            make.top.equalTo(self.scrollView.mas_bottom);
            make.height.mas_equalTo(0.1);
        }];
    }

    
    CGFloat maxCount = self.buttonTitles.count;
    if (self.maxShowButtonCount > 0) {
        maxCount = self.buttonTitles.count > self.maxShowButtonCount ? self.maxShowButtonCount : self.buttonTitles.count;
    }
    CGFloat viewH = maxCount * (self.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)-MKAS_BUTTON_SEPARATOR_HEIGHT;
//    self.scrollView.frame = CGRectMake(0, self.titleView.bounds.size.height, MKSCREEN_WIDTH, viewH);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.sheetView);
        make.height.mas_equalTo(viewH);
        make.top.equalTo(self.titleView.mas_bottom).offset(0.5);
        make.bottom.equalTo(self.cancelView.mas_top);
    }];
    
    for (NSInteger i = 0; i < self.buttonViewsArray.count; i++) {
        UIView *view = self.buttonViewsArray[i];
        view.frame = CGRectMake(0, (self.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)*i, MKSCREEN_WIDTH, self.buttonHeight);
        UIButton *btn = [view viewWithTag:i + MKAS_BUTTON_TAG_BASE];
        if (btn) {
            btn.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, self.buttonHeight);
        }
    }
    
    
    [super updateConstraints];
    
    
}








//#pragma mark - ***** UITableView delegate ******
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MKActionSheetCell *cell = [MKActionSheetCell cellWithTableView:tableView buttonAlpha:_buttonOpacity];
//    
//    if (indexPath.row >= self.buttonTitles.count) {
//        return cell;
//    }
//    
//    [cell.btnCell setTitle:self.buttonTitles[indexPath.row] forState:UIControlStateNormal];
//    [cell.btnCell setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
//    cell.btnCell.titleLabel.font = self.buttonTitleFont;
//
//    if (indexPath.row == self.destructiveButtonIndex) {
//        [cell.btnCell setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
//    }
//    
//    
//    if (self.selectType == MKActionSheetSelectType_multiselect) {   //多选
//        cell.btnSelect.hidden = NO;
//        NSString *title = [self.buttonTitles objectAtIndex:indexPath.row];
//        cell.btnSelect.selected = title.mkas_selected;
//        
//        if (self.selectBtnImageNameNormal && self.selectBtnImageNameNormal.length > 0) {
//            [cell.btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateNormal];
//        }
//        if (self.selectBtnImageNameSelected && self.selectBtnImageNameSelected.length > 0) {
//            [cell.btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateSelected];
//            [cell.btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateHighlighted];
//        }
//    }else if (self.selectType == MKActionSheetSelectType_selected){ //单选
//        cell.btnSelect.hidden = YES;
//        cell.btnSelect.enabled = NO;
//        if (self.selectedIndex == indexPath.row) {
//            cell.btnSelect.hidden = NO;
//        }
//        
//        if (self.selectedBtnImageName && self.selectedBtnImageName.length > 0) {
//            [cell.btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateDisabled];
//        }
//    }
//    
//    
//    
//    
//    if (self.paramIsObject && self.imageKey && self.imageKey.length > 0 && self.imageValueType) {
//        self.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
//        
//        id obj = [self.objArray objectAtIndex:indexPath.row];
//        id imageValue = [obj valueForKey:self.imageKey];
//        
//        if (self.imageValueType == MKActionSheetButtonImageValueType_name) {
//            if ([imageValue isKindOfClass:[NSString class]]) {
//                [cell.btnCell setImage:[UIImage imageNamed:imageValue] forState:UIControlStateNormal];
//            }
//        }else if (self.imageValueType == MKActionSheetButtonImageValueType_image){
//            if ([imageValue isKindOfClass:[UIImage class]]) {
//                [cell.btnCell setImage:imageValue forState:UIControlStateNormal];
//            }
//        }else if (self.imageValueType == MKActionSheetButtonImageValueType_url){
//            //由于加载url图片需要导入 SDWebImage，而且有些人在项目中用的也不一定是SDWebImage, 或用不到此类型，
//            //为了不增加 使用MKActionSheet 的成本，加载url 图片  用一个block 或 delegate 回调出去，根据大家自己的实际情况设置 图片，并设置自己的默认图片。
//            if ([imageValue isKindOfClass:[NSString class]]) {
//                MKBlockExec(self.buttonImageBlock, self, cell.btnCell, imageValue);
//            }
//        }
//        
//        [cell.btnCell setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
//    }
//    
//    if (self.buttonTitleAlignment == MKActionSheetButtonTitleAlignment_left) {
//        cell.btnCell.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [cell.btnCell setContentEdgeInsets:UIEdgeInsetsMake(0, self.titleMargin, 0, 0)];
//    }else if (self.buttonTitleAlignment == MKActionSheetButtonTitleAlignment_right){
//        cell.btnCell.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [cell.btnCell setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.titleMargin)];
//    }
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSInteger index = indexPath.row;
//    
//    if (self.selectType == MKActionSheetSelectType_multiselect){    //多选
//        NSString *title = [self.buttonTitles objectAtIndex:index];
//        title.mkas_selected = !title.mkas_selected;
//        [self.tableView reloadData];
//    }else if(self.selectType == MKActionSheetSelectType_selected){
//        self.selectedIndex = index;
//        [self.tableView reloadData];
//        [self dismissWithButtonIndex:index];
//    }else{
//        [self dismissWithButtonIndex:index];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.buttonTitles.count > 0 ? self.buttonTitles.count : 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.buttonHeight;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsMake(0, self.separatorLeftMargin, 0, 0)];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsMake(0, self.separatorLeftMargin, 0, 0)];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, self.separatorLeftMargin, 0, 0)];
//    }
//}


#pragma mark - ***** lazy ******
- (UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:MKSCREEN_BOUNDS];
        _bgWindow.windowLevel = _windowLevel;
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.hidden = NO;
        MKASRootViewController *rootVC = [[MKASRootViewController alloc] init];
        _bgWindow.rootViewController = rootVC;
        if (_currentVC) {
            rootVC.vc = _currentVC;
        }
    }
    return _bgWindow;
}

- (UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc] init];
        [_shadeView setBackgroundColor:MKCOLOR_RGBA(0, 0, 0, 1)];
        [_shadeView setUserInteractionEnabled:NO];
        [_shadeView setAlpha:0];
        if (_enableBgTap) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
            [_shadeView addGestureRecognizer:tap];
        }
    }
    return _shadeView;
}

- (UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] init];
        [_sheetView setBackgroundColor:[UIColor clearColor]];
    }
    return _sheetView;
}

- (UIView *)blurView{
    if (!_blurView) {
        _blurView = [[UIView alloc] init];
    }
    return _blurView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = MKCOLOR_RGBA(255, 255, 255, _buttonOpacity);
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = _titleColor;
        _titleLabel.textAlignment = _titleAlignment;
        _titleLabel.font = _titleFont;
    }
    return _titleLabel;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:self.multiselectConfirmButtonTitleColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton addTarget:self action:@selector(confirmButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
//        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)cancelView{
    if (!_cancelView) {
        _cancelView = [[UIView alloc] init];
    }
    return _cancelView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [self createButton];
        [_cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        _cancelButton.tag = _buttonTitles.count;
        [_cancelButton addTarget:self action:@selector(btnCancelOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage mkas_imageWithColor:[UIColor colorWithRed:255.f green:255.f blue:255.f alpha:_buttonOpacity]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage mkas_imageWithColor:[UIColor colorWithRed:255.f green:255.f blue:255.f alpha:0.1]] forState:UIControlStateHighlighted];
    [btn setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font = _buttonTitleFont;
    return btn;
}

- (UIView *)cancelSeparatorView{
    if (!_cancelSeparatorView) {
        _cancelSeparatorView = [[UIView alloc] init];
        _cancelSeparatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    }
    return _cancelSeparatorView;
}


- (NSMutableArray *)buttonViewsArray{
    if (!_buttonViewsArray) {
        _buttonViewsArray = @[].mutableCopy;
    }
    return _buttonViewsArray;
}

@end



