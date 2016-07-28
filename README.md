[![Travis](https://img.shields.io/travis/mk2016/MKActionSheet.svg?style=flat)](https://travis-ci.org/mk2016/MKActionSheet)

# MKActionSheet

### MKActionSheet 底部为毛玻璃
####模仿微信样式，还支持 无标题，无取消按钮模式，多按钮支持tableView模式，可设定最多显示按钮个数（支持小数）

#### 可以多参数初始化
`MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitles:@"button11", @"button12",@"button13",@"button14",nil];`

#### 也可以数组初始化
`MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" buttonTitleArray:@[@"button21", @"button22",@"button23",@"button24"] destructiveButtonIndex:3];`

#### 支持 block 和 delegate
`- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;`
`- (void)showWithBlock:(MKActionSheetBlock)block;`

#### 可以根据自己的需求定制UI
`@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 */`
`@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title */`
`@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 */`
`@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 */`
`@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 */`
`@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< default: 48.0f*/`
`@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 */`
`@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 default: 0.3f */`
`@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 default: 0.0f */`
`@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 default: 0.3f */`
`@property (nonatomic, assign) BOOL isNeedCancelButton;              /*!< 是否需要取消按钮 */`
`@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 */`         

 ![image](https://github.com/mk2016/MKActionSheet/raw/master/Screenshots/1.png)
