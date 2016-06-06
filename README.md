[![Travis](https://img.shields.io/travis/mk2016/MKActionSheet.svg?style=flat)](https://travis-ci.org/mk2016/MKActionSheet)

# MKActionSheet

### 模仿微信ActionSheet 底部为毛玻璃

#### 可以多参数初始化
`MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" destructiveButtonIndex:3 buttonTitles:@"button31", @"button32",@"button33",@"button34", nil];`

#### 也可以数组初始化
`MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" buttonTitleArray:@[@"button21", @"button22",@"button23",@"button24"] destructiveButtonIndex:3];`

#### 支持 block 和 delegate
`- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;`

`- (void)showWithBlock:(MKActionSheetBlock)block;`

#### 可以根据自己的需求定制UI
`@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, strong) UIFont *buttonTitleFont;

@property (nonatomic, strong) UIColor *buttonTitleColor;

@property (nonatomic, assign) BOOL buttonOpacity; 

@property (nonatomic, strong) UIColor *destructiveButtonTitleColor;

@property (nonatomic, assign) CGFloat buttonHeight;

@property (nonatomic, assign) CGFloat animationDuration; 

@property (nonatomic, assign) CGFloat blackgroundOpacity;  

@property (nonatomic, assign) CGFloat blurOpacity; `         

 ![image](https://github.com/mk2016/MKActionSheet/raw/master/Screenshots/1.png)
