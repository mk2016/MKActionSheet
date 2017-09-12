//
//  MKActionSheet.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKActionSheet.h"
#import "MKActionSheetAdd.h"
#import "MKASRootViewController.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

#define MKActionSheet_WindowLevel       UIWindowLevelStatusBar - 1
#define MKAS_BUTTON_SEPARATOR_HEIGHT    (1 / [UIScreen mainScreen].scale)
#define MKAS_BUTTON_TAG_BASE            100
#define MKAS_BUTTON_SELECT_TAG          999

#pragma mark - ***** MKActionSheet ******
@interface MKActionSheet()<UIScrollViewDelegate>
@property (nonatomic, assign) MKActionSheetSelectType selectType;                   /*!< 选择模式：默认、单选(在初始选择的后面会有标示)、多选*/
//object Array
@property (nonatomic, copy) NSString *titleKey;                                     /*!< 传入为object array 时 指定 title 的字段名 */
@property (nonatomic, copy) NSString *imageKey;                                     /*!< 传入为object array 时 指定 button image 对应的字段名 */
@property (nonatomic, assign) MKActionSheetButtonImageValueType imageValueType;     /*!< imageKey对应的类型：image、imageName、imageUrl */

@property (nonatomic, strong) MKASOrientationConfig *configPortrait;    /*!< 竖屏 配置 */
@property (nonatomic, strong) MKASOrientationConfig *configLandscape;   /*!< 横屏 配置 */
@property (nonatomic, strong) MKASOrientationConfig *currentConfig;     /*!< 当前配置 */

@property (nonatomic, copy) NSString *title;                            /*!< 标题 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;             /*!< button titles array */
@property (nonatomic, strong) NSMutableArray *objArray;                 /*!< objects array */

@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, weak) UIView *customTitleView;                    /*!< 自定义标题View */

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonViewsArray;

@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *cancelSeparatorView;

@property (nonatomic, copy) MKActionSheetCustomTitleViewLayoutBlock customTitleViewLayoutBlock;

@property (nonatomic, assign) BOOL paramIsObject;           /*!< init array is model or dictionary */
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL initSuccess;
@end


@implementation MKActionSheet

#pragma mark - ***** init method ******
/** init with titles array */
- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray selectType:(MKActionSheetSelectType)selectType{
    if (self = [super init]) {
        _selectType = selectType;
        _title = title;
        _buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitleArray];
        [self initData];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray{
    return [self initWithTitle:title buttonTitleArray:buttonTitleArray selectType:MKActionSheetSelectType_common];
}

/** init with objects array */
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
               imageValueType:(MKActionSheetButtonImageValueType)imageValueType{
    return [self initWithTitle:title objArray:objArray buttonTitleKey:buttonTitleKey imageKey:imageKey imageValueType:imageValueType selectType:MKActionSheetSelectType_common];
}

/** init data */
- (void)initData{
    _windowLevel = MKActionSheet_WindowLevel;
    _enabledForBgTap = YES;
    _manualDismiss = NO;
    
    _animationDuration = 0.3f;
    _blurOpacity = 0.3f;
    _blackgroundOpacity = 0.3f;
    
    _titleColor = MKCOLOR_RGBA(100.0f, 100.0f, 100.0f, 1.0f);
    _titleFont = [UIFont systemFontOfSize:14];
    _titleMargin = 20.0f;
    
    _buttonTitleColor = MKCOLOR_RGBA(51.0f,51.0f,51.0f,1.0f);
    _buttonTitleFont = [UIFont systemFontOfSize:18.0f];
    _buttonOpacity = 0.6;
    _buttonImageRightSpace = 12.f;
    
    _destructiveButtonIndex = -1;
    _destructiveButtonTitleColor = MKCOLOR_RGBA(250.0f, 10.0f, 10.0f, 1.0f);
    
    _needCancelButton = YES;
    _cancelTitle = @"取消";
    
    _selectedIndex = -1;
    _multiselectConfirmButtonTitle = @"确定";
    _multiselectConfirmButtonTitleColor = MKCOLOR_RGBA(100.0f, 100.0f, 100.0f, 1.0f);


    //以 object array 初始化，默认没有取消按钮
    if (_paramIsObject) {
        self.needCancelButton = NO;
    }
    
    // 根据 selectType 和 方向 初始化默认样式
    if (self.configPortrait == nil) {
        self.configPortrait = [[MKASOrientationConfig alloc] init];
        if (_selectType == MKActionSheetSelectType_multiselect || _selectType == MKActionSheetSelectType_selected) {       //多选 样式， title 默认 居左对齐，无取消按钮
            self.configPortrait.titleAlignment = NSTextAlignmentLeft;
            self.configPortrait.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
            self.configPortrait.maxShowButtonCount = 5.6;
        }
    }
    
    if (self.configLandscape == nil) {
        self.configLandscape = [[MKASOrientationConfig alloc] init];
        if (_selectType == MKActionSheetSelectType_multiselect || _selectType == MKActionSheetSelectType_selected) {       //多选 样式， title 默认 居左对齐，无取消按钮
            self.configLandscape.titleAlignment = NSTextAlignmentCenter;
            self.configLandscape.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_center;
        }
    }
   
    [self updateConfigByOrientation];
}

- (void)updateConfigByOrientation{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        self.currentConfig = self.configLandscape;
        self.scrollView.contentSize = CGSizeMake(MKSCREEN_HEIGHT, self.buttonTitles.count*(self.currentConfig.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT));
    }else{
        self.currentConfig = self.configPortrait;
        self.scrollView.contentSize = CGSizeMake(MKSCREEN_WIDTH, self.buttonTitles.count*(self.currentConfig.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT));
    }
}

#pragma mark - ***** methods ******
- (void)setPortraitConfig:(MKASOrientationConfig *)config{
    if (config) {
        self.configPortrait = config;
        [self updateConfigByOrientation];
    }
}

- (void)setLandscapeConfig:(MKASOrientationConfig *)config{
    if (config) {
        self.configLandscape = config;
        [self updateConfigByOrientation];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectType == MKActionSheetSelectType_selected) {
        _selectedIndex = selectedIndex;
    }else{
        NSAssert(NO, @"初始化 selectType = MKActionSheetSelectType_selected 时 设置 selectedIndex 才有效");
    }
}

#pragma mark - ***** add & remove & reload *****
- (void)addButtonWithButtonTitle:(NSString *)title{
    NSAssert(!_paramIsObject, @"以 objArray 初始化时，不能直接添加 title, 请使用 addButtonWithObj:(id)obj");
    if (title) {
        [self.buttonTitles addObject:title];
        [self updateScrollViewAndLayout];
    }
}

- (void)removeButtonWithButtonTitle:(NSString *)title{
    if (title) {
        MKWEAKSELF
        [self.buttonTitles enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:title]) {
                [weakSelf removeButtonWithIndex:idx];
                return ;
            }
        }];
    }
}

- (void)addButtonWithObj:(id)obj{
    NSAssert(_paramIsObject, @"不是由 objArray 初始化时，不能直接添加 object, 请使用 addButtonWithButtonTitle:(NSString *)title");
    if (obj) {
        [self.objArray addObject:obj];
        [self updateScrollViewAndLayout];
    }
}

- (void)removeButtonWithObj:(id)model{
    MKWEAKSELF
    [self.objArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == model) {
            [weakSelf removeButtonWithIndex:idx];
            return ;
        }
    }];
}

- (void)removeButtonWithIndex:(NSInteger)index{
    if (self.buttonViewsArray.count > index) {
        [[self.buttonViewsArray objectAtIndex:index] removeFromSuperview];
    }
    if (self.buttonTitles.count > index) {
        [self.buttonTitles removeObjectAtIndex:index];
    }
    if (_paramIsObject && self.objArray.count > index) {
        [self.objArray removeObjectAtIndex:index];
    }
    [self updateScrollViewAndLayout];
}

- (void)reloadWithTitleArray:(NSArray *)titleArray{
    NSAssert(!_paramIsObject, @"以 objArray 初始化时， 请使用 reloadWithObjArray:");
    if (titleArray && titleArray.count > 0) {
        [self.buttonTitles removeAllObjects];
        [self.buttonTitles addObjectsFromArray:titleArray];
        [self updateScrollViewAndLayout];
    }
}

- (void)reloadWithObjArray:(NSArray *)objArray{
    NSAssert(_paramIsObject, @"不是由 objArray 初始化时， 请使用 reloadWithTitleArray:");
    if (objArray && objArray.count > 0) {
        [self.objArray removeAllObjects];
        [self.objArray addObjectsFromArray:objArray];
        [self updateScrollViewAndLayout];
    }
}

- (void)updateScrollViewAndLayout{
    if (self.initSuccess) {
        [self setupScrollView];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}

- (void)setCustomTitleView:(UIView *)view makeConstraints:(MKActionSheetCustomTitleViewLayoutBlock)block{
    if (view == nil) {
        return;
    }
    [_customTitleView removeFromSuperview];
    _customTitleView = nil;
    _customTitleView = view;
    [self.titleView addSubview:_customTitleView];
    _customTitleViewLayoutBlock = block;
    if (_customTitleViewLayoutBlock == nil) {
        CGRect tempFrame = _customTitleView.frame;
        if (tempFrame.origin.x != 0 || tempFrame.origin.y != 0 || tempFrame.size.width != 0 || tempFrame.size.height != 0) {
            _customTitleViewLayoutBlock = ^(MASConstraintMaker *make, UIView *superview) {
                make.left.equalTo(superview).offset(tempFrame.origin.x);
                make.top.equalTo(superview).offset(tempFrame.origin.y);
                make.width.mas_equalTo(tempFrame.size.width);
                make.height.mas_equalTo(tempFrame.size.height);
                make.bottom.equalTo(superview);
            };
        }
    }
    if (self.initSuccess) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    
}


#pragma mark - ***** show methods ******
- (void)showWithBlock:(MKActionSheetBlock)block{
    NSAssert(_selectType != MKActionSheetSelectType_multiselect, @"multiselect style, place use: showWithMultiselectBlock:");
    _block = block;
    [self show];
}

- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock{
    NSAssert(_selectType == MKActionSheetSelectType_multiselect, @"single select style，place use showWithBlock:");
    _multiselectBlock = multiselectblock;
    [self show];
}

- (void)show{
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


#pragma mark - ***** dismiss ******
/** 点击取消按钮 */
- (void)btnCancelOnclicked:(UIButton *)sender{
    NSInteger index = sender.tag;
    [self dismissWithButtonIndex:index];
}

/** 单选 点击按钮 */
- (void)btnClick:(UIButton *)sender{
    NSInteger index = sender.tag-MKAS_BUTTON_TAG_BASE;
    if (self.selectType == MKActionSheetSelectType_multiselect){    //多选
        NSString *title = [self.buttonTitles objectAtIndex:index];
        title.mkas_selected = !title.mkas_selected;
        UIView *view = self.buttonViewsArray[index];
        UIButton *btn = [view viewWithTag:MKAS_BUTTON_SELECT_TAG];
        btn.selected = title.mkas_selected;
    }else if(self.selectType == MKActionSheetSelectType_selected){
        self.selectedIndex = index;
        [self dismissWithButtonIndex:index];
    }else{
        [self dismissWithButtonIndex:index];
    }
}

- (void)dismissWithButtonIndex:(NSInteger)index{
    if (self.selectType == MKActionSheetSelectType_multiselect) {
        //多选样式下 只有 取消按钮才会走这里
        MKBlockExec(self.multiselectBlock, self, nil);
    }else{
        MKBlockExec(self.block, self, index)
    }
    [self chekcManualDismiss];
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
    [self chekcManualDismiss];
}

- (void)chekcManualDismiss{
    if (self.manualDismiss) {
        return;
    }
    [self dismiss];
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
    [self updateConfigByOrientation];
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
    
    if (self.needCancelButton) {
        [self.cancelView addSubview:self.cancelButton];
        [self.cancelButton addSubview:self.cancelSeparatorView];
    }

    //UIScrollView
    [self setupScrollView];

    //title
    if (self.selectType == MKActionSheetSelectType_multiselect && !self.title) {
        self.title = @"";
    }

    if (self.title){
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
    
    [self.bgWindow.rootViewController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgWindow.rootViewController.view);
    }];
    [_bgWindow layoutIfNeeded];
}

- (void)setupScrollView{
    //UIScrollView
    if (_paramIsObject) {
        NSAssert(_titleKey && _titleKey.length > 0, @"titleKey 不能为nil 或者 空, 必须是有效的 NSString");
        NSAssert(_objArray, @"_objArray 不能为 nil");
        for (id obj in _objArray) {
            id titleValue = [obj valueForKey:_titleKey];
            if (!titleValue || ![titleValue isKindOfClass:[NSString class]]) {
                NSAssert(NO, @"obj.titleKey 必须为 有效的 NSString");
            }
            _buttonTitles = [[NSMutableArray alloc] initWithArray:[_objArray valueForKey:_titleKey]];
        }
    }
    self.scrollView.contentSize = CGSizeMake(MKSCREEN_WIDTH, self.buttonTitles.count*(self.currentConfig.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT));
    if (self.buttonViewsArray.count > 0) {
        [self.buttonViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttonViewsArray removeAllObjects];
    }
    
    for (NSInteger i = 0; i < self.buttonTitles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:view];
        [self.buttonViewsArray addObject:view];
        CGRect viewFrame = CGRectMake(0, self.currentConfig.buttonHeight*i, MKSCREEN_WIDTH, self.currentConfig.buttonHeight);
        view.frame = viewFrame;
        
        UIButton *btn = [self createButton];
        [view addSubview:btn];
        btn.frame = CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height-MKAS_BUTTON_SEPARATOR_HEIGHT);
        btn.tag = i + MKAS_BUTTON_TAG_BASE;
        [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.destructiveButtonIndex) {
            [btn setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
        }
        
        if (self.selectType != MKActionSheetSelectType_common) {
            UIButton *btnSelect = [self createSelectButton];
            [view addSubview:btnSelect];
            
            [btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-16);
                make.centerY.equalTo(view);
            }];
        
            if (self.selectType == MKActionSheetSelectType_selected){ //单选
                if (self.selectedBtnImageName && self.selectedBtnImageName.length > 0) {
                    [btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateDisabled];
                }
                btnSelect.hidden = YES;
                btnSelect.enabled = NO;
                if (self.selectedIndex == i) {
                    btnSelect.hidden = NO;
                }
            }else if (self.selectType == MKActionSheetSelectType_multiselect) {   //多选
                if (self.selectBtnImageNameNormal && self.selectBtnImageNameNormal.length > 0) {
                    [btnSelect setImage:[UIImage imageNamed:self.selectedBtnImageName] forState:UIControlStateNormal];
                }
                if (self.selectBtnImageNameSelected && self.selectBtnImageNameSelected.length > 0) {
                    [btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateSelected];
                    [btnSelect setImage:[UIImage imageNamed:self.selectBtnImageNameSelected] forState:UIControlStateHighlighted];
                }
                btnSelect.hidden = NO;
                NSString *title = [self.buttonTitles objectAtIndex:i];
                btnSelect.selected = title.mkas_selected;
            }
        }
        
        if (self.paramIsObject && self.imageKey && self.imageKey.length > 0 && self.imageValueType) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, _buttonImageRightSpace, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, _buttonImageRightSpace);
            id obj = [self.objArray objectAtIndex:i];
            id imageValue = [obj valueForKey:self.imageKey];
            
            if (self.imageValueType == MKActionSheetButtonImageValueType_name) {
                if ([imageValue isKindOfClass:[NSString class]]) {
                    [btn setImage:[UIImage imageNamed:imageValue] forState:UIControlStateNormal];
                }
            }else if (self.imageValueType == MKActionSheetButtonImageValueType_image){
                if ([imageValue isKindOfClass:[UIImage class]]) {
                    [btn setImage:imageValue forState:UIControlStateNormal];
                }
            }else if (self.imageValueType == MKActionSheetButtonImageValueType_url){
                if ([imageValue isKindOfClass:[NSString class]] || [imageValue isKindOfClass:[NSURL class]]) {
                    NSURL *url = nil;
                    if ([imageValue isKindOfClass:[NSString class]]) {
                        url = [NSURL URLWithString:imageValue];
                    }else if ([imageValue isKindOfClass:[NSURL class]]){
                        url = imageValue;
                    }
                    [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:self.placeholderImage];
                }
            }
        }
        [self updateButtonConstraints:btn];

    }
}

- (void)updateButtonConstraints:(UIButton *)btn{
    if (self.currentConfig.buttonTitleAlignment == MKActionSheetButtonTitleAlignment_left) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, self.titleMargin, 0, 0)];
    }else if (self.currentConfig.buttonTitleAlignment == MKActionSheetButtonTitleAlignment_right){
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (self.selectType == MKActionSheetSelectType_selected || self.selectType == MKActionSheetSelectType_multiselect) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.titleMargin+60)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.titleMargin)];
        }
    }else if (self.currentConfig.buttonTitleAlignment == MKActionSheetButtonTitleAlignment_center){
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setContentEdgeInsets:UIEdgeInsetsZero];
    }
}

- (void)updateConstraints{
    self.initSuccess = YES;
    
    [self.shadeView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.blurView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sheetView);
    }];
    
    //titleView
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.sheetView);
    }];
    
    if (self.customTitleView) {
        [self.customTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            MKBlockExec(self.customTitleViewLayoutBlock, make, self.titleView);
        }];
    } else if (self.title){
        self.titleLabel.textAlignment = self.currentConfig.titleAlignment;
        if (self.selectType == MKActionSheetSelectType_multiselect) {
            [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleView);
                make.width.mas_equalTo(80);
                make.right.equalTo(self.titleView);
                make.top.bottom.equalTo(self.titleView);
            }];
            
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleView);
                make.left.equalTo(self.titleView).offset(self.titleMargin);
                make.right.equalTo(self.confirmButton.mas_left).offset(-4);
                make.top.equalTo(self.titleView).offset(10);
                make.bottom.equalTo(self.titleView).offset(-10);
            }];
        }else{
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
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
            make.height.mas_equalTo(0);
        }];
    }
    
    
    [self.cancelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.sheetView);
    }];
    
    if (self.needCancelButton) {
        self.cancelView.hidden = NO;
        self.cancelButton.tag = _buttonTitles.count;
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.cancelView);
            make.height.mas_equalTo(self.currentConfig.buttonHeight);
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
    if (self.currentConfig.maxShowButtonCount > 0) {
        maxCount = self.buttonTitles.count > self.currentConfig.maxShowButtonCount ? self.currentConfig.maxShowButtonCount : self.buttonTitles.count;
    }
    CGFloat viewH = maxCount * (self.currentConfig.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)-MKAS_BUTTON_SEPARATOR_HEIGHT;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.sheetView);
        make.height.mas_equalTo(viewH);
        make.top.equalTo(self.titleView.mas_bottom).offset(MKAS_BUTTON_SEPARATOR_HEIGHT);
        make.bottom.equalTo(self.cancelView.mas_top);
    }];
    
    for (NSInteger i = 0; i < self.buttonViewsArray.count; i++) {
        UIView *view = self.buttonViewsArray[i];
        view.frame = CGRectMake(0, (self.currentConfig.buttonHeight+MKAS_BUTTON_SEPARATOR_HEIGHT)*i, MKSCREEN_WIDTH, self.currentConfig.buttonHeight);
        UIButton *btn = [view viewWithTag:i + MKAS_BUTTON_TAG_BASE];
        if (btn) {
            btn.frame = CGRectMake(0, 0, MKSCREEN_WIDTH, self.currentConfig.buttonHeight);
            [self updateButtonConstraints:btn];
        }
    }
    [super updateConstraints];
}








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
        if (_enabledForBgTap) {
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
        [_cancelButton addTarget:self action:@selector(btnCancelOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage mkas_imageWithColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:_buttonOpacity]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage mkas_imageWithColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.1]] forState:UIControlStateHighlighted];
    [btn setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font = _buttonTitleFont;
    return btn;
}

- (UIButton *)createSelectButton{
    NSString *bundle = [[NSBundle bundleForClass:self.class] pathForResource:@"MKActionSheet" ofType:@"bundle"];
    NSString *selectImgPath0 = [bundle stringByAppendingPathComponent:@"img_select_0.png"];
    NSString *selectImgPath1 = [bundle stringByAppendingPathComponent:@"img_select_1.png"];
    NSString *selectImgPath2 = [bundle stringByAppendingPathComponent:@"img_selected.png"];
    UIImage *selectImg0 = [UIImage imageWithContentsOfFile:selectImgPath0];
    UIImage *selectImg1 = [UIImage imageWithContentsOfFile:selectImgPath1];
    UIImage *selectImg2 = [UIImage imageWithContentsOfFile:selectImgPath2];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.tag = MKAS_BUTTON_SELECT_TAG;
    selectBtn.userInteractionEnabled = NO;
    [selectBtn setImage:selectImg0 forState:UIControlStateNormal];
    [selectBtn setImage:selectImg1 forState:UIControlStateSelected];
    [selectBtn setImage:selectImg1 forState:UIControlStateHighlighted];
    [selectBtn setImage:selectImg2 forState:UIControlStateDisabled];
    return selectBtn;
}

- (UIView *)cancelSeparatorView{
    if (!_cancelSeparatorView) {
        _cancelSeparatorView = [[UIView alloc] init];
        _cancelSeparatorView.backgroundColor = [UIColor clearColor];
    }
    return _cancelSeparatorView;
}


- (NSMutableArray *)buttonViewsArray{
    if (!_buttonViewsArray) {
        _buttonViewsArray = @[].mutableCopy;
    }
    return _buttonViewsArray;
}

- (NSMutableArray *)buttonTitles{
    if (!_buttonTitles) {
        _buttonTitles = @[].mutableCopy;
    }
    return _buttonTitles;
}

- (NSMutableArray *)objArray{
    if (!_objArray) {
        _objArray = @[].mutableCopy;
    }
    return _objArray;
}
@end



