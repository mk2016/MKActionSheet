# MKActionSheet

[![Travis](https://img.shields.io/travis/mk2016/MKActionSheet.svg?style=flat)](https://travis-ci.org/mk2016/MKActionSheet)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/MKActionSheet.svg)](http://cocoadocs.org/docsets/MKActionSheet)
[![CocoaPods](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/mk2016/MKActionSheet/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/MKActionSheet.svg)](http://cocoadocs.org/docsets/MKActionSheet)
[![MKDev](https://img.shields.io/badge/blog-MK-brightgreen.svg)](https://mk2016.github.io/)

## 多样式 ActionSheet
 * 高斯模糊效果
 * 支持无标题、无取消按钮样式
 * 支持带默认选中模式
 * 支持多选模式
 * 支持带 icon 图片样式
 * 支持多按钮，可设置最大显示数量（支持小数），超过最大数量，以tableView模式显示
 * 支持 Model 或 NSDictionary 数组初始化
 * 支持 block 
 
#### 先上效果图
 ![image](https://github.com/mk2016/MKActionSheet/raw/master/Screenshots/gif2.gif)


##添加
* cocoapods  
  pod 'MKActionSheet', '~> 1.4.1'

* Manually (手动导入)  
  只需将 MKActionSheet 文件添加到项目中即可


## 用法 详细用法参见demo
#### 1.4.0 版本之后 化烦为简 去除 delegate 用法, 适配到iOS8。  需要delegate或者想支持iOS7可以使用V1.3.2版本。
 * 支持 block 
 * 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。
 * 现默认使用不新建window的模式，
 * 但如果您的项目使用了多个window,当顶部window不是keywindow时，sheetView会被顶部window遮住。
 * 此时建议 将 needNewWindow 设置为 YES; 并在项目info.plist 中 新增 “View controller-based status bar appearance” 设置为 NO。
 * 这样也可以让 status bar 不变色
 
```
//单选 block
- (void)showWithBlock:(MKActionSheetBlock)block;
//多选 block
- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock;
```

* 普通样式，多参数初始化
 
```
 MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"初始化title为nil，将显示不带title样式。title" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"]];
sheet.destructiveButtonIndex = 3;
[sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
	NSLog(@"buttonIndex:%ld",(long)buttonIndex);
}];
```

* 对象数组初始化，支持 model 和 NSDictionary 数组。titleKey是对象中用来显示按钮title对应的字段。
 
```
MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"对象数组初始换" objArray:self.modelArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
[sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
	NSLog(@"array:%@",array);
}];
```

* selectType 用于控制选择类型，不同类型的UI样式也不同
 
```
typedef NS_ENUM(NSInteger, MKActionSheetSelectType) {
    MKActionSheetSelectType_common    = 1,      //默认样式
    MKActionSheetSelectType_selected,           //默认带有一个 已选择的 选项
    MKActionSheetSelectType_multiselect,        //多选 样式
};
```

* 带icon图标的样式

```
MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil objArray:self.dicArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
[sheet setImageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url];
sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
	[button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
        };
[sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
	NSLog(@"actionSheet:%@",actionSheet);
	NSLog(@"array:%@",array);
}];
//
// setImageKey:(NSString *)imageKey imageValueType:(MKActionSheetButtonImageValueType)imageValueType;

//imageKey：对象中对应图片的字段， imageValueType：imageKey字段对应的类型
typedef NS_ENUM(NSInteger, MKActionSheetButtonImageValueType) {
    MKActionSheetButtonImageValueType_none = 0,        //default
    MKActionSheetButtonImageValueType_image,
    MKActionSheetButtonImageValueType_name,
    MKActionSheetButtonImageValueType_url,
};
```

##### 带icon图标的样式，imageValueType 为 url 时加载图片的方法。
 * 由于大家可能在项目中使用的加载图片的框架不一样，为了不增加使用MKActionSheet控件的成本。将加载url图片的方法 用block 回调出来让大家自己实现。以下是以比较常用的SDWebimage为例。

```
//button: 要被设置icon的按钮, imageUrl:图片的URL, 既前面设置的 ImageKey 的值，且imageValueType 为 MKActionSheetButtonImageValueType_url。
//
//block
sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
	[button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
};

```


#### 可以根据自己的需求定制UI
```
/**  custom UI */
@property (nonatomic, assign) CGFloat windowLevel;
@property (nonatomic, assign) BOOL enableBgTap;                     /*!< 蒙版是否可以点击 收起*/
@property (nonatomic, weak) UIViewController *currentVC;            /*!< 当前viewController 控制 stabar 保持当前样式 */
//title
@property (nonatomic, weak) UIView *customTitleView;                /*!< 自定义标题View */
@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 [default: RGBA(100.0f, 100.0f, 100.0f, 1.0f)]*/
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 [default: sys 14] */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 [default: center] */
//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 [default:RBGA(51.0f, 51.0f, 51.0f, 1.0f)] */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 [default: sys 18] */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 [default: 0.6] */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< 按钮高度 [default: 48.0f] */
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title 对齐方式 [default: center] */
//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 [default:-1]*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 [default:RBGA(250.0f, 10.0f, 10.0f, 1.0f)]*/
//cancel Title
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title [dafault:取消] */
//action sheet
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title 边距 [default: 20] */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 [default: 0.0f] */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 [default: 0.3f] */
@property (nonatomic, assign,getter=isNeedCancelButton) BOOL needCancelButton;  /*!< 是否需要取消按钮 */
@property (nonatomic, assign,getter=isShowSeparator) BOOL showSeparator;        /*!< 是否显示分割线 [default: YES]*/
@property (nonatomic, assign) CGFloat separatorLeftMargin;          /*!< 分割线离左边的边距 [default:0] */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 [default:5.6，全部显示,可设置成 0] */
//object Array
@property (nonatomic, copy) NSString *titleKey;                     /*!< 传入为object array 时 指定 title 的字段名 */
@property (nonatomic, copy) NSString *imageKey;                     /*!< 传入为object array 时 指定button image对应的字段名 */
@property (nonatomic, assign) MKActionSheetButtonImageValueType imageValueType;   /*!< imageKey对应的类型：image、imageName、imageUrl */
//set image name
@property (nonatomic, copy) NSString *selectedBtnImageName;         /*!< 带默认选中模式，选中图片的名字 */
@property (nonatomic, copy) NSString *selectBtnImageNameNormal;     /*!< 多选模式，选择按钮非选中状态图片 */
@property (nonatomic, copy) NSString *selectBtnImageNameSelected;   /*!< 多选模式，选择按钮选中状态图片 */
//selected
@property (nonatomic, assign) NSInteger selectedIndex;              /*!< 默认选中的button index, 带默认选中样式 */
//multiselect
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< 多选 确定按钮 颜色 */
```


<font color=#DC143C size=4 face="黑体">建议可以根据需求自定义几种样式的类调用方法，在项目中直接使用。例：</font>

```
+ (void)sheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray destructiveButtonIndex:(NSInteger)destructiveButtonIndex block:(MKActionSheetBlock)block{
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:title buttonTitleArray:buttonTitleArray];
    sheet.needCancelButton = YES;
    sheet.buttonTitleFont = [UIFont systemFontOfSize:17];
    sheet.buttonTitleColor = [UIColor redColor];
    sheet.buttonOpacity = 1;
    sheet.buttonHeight = 40.0f;
    sheet.destructiveButtonTitleColor = [UIColor grayColor];
    sheet.animationDuration = 0.2f;
    sheet.blackgroundOpacity = 0.0f;
    sheet.blurOpacity = 0.7f;
    sheet.tag = 200;
    [sheet showWithBlock:block];
}
```
 
 
## 版本记录
### V1.4.1
 * fix: blurOpacity 设置毛玻璃透明度无效的bug 
### V1.4.0
 * 去除 delegate 模式
 * 适配到iOS8
 * 模态改为使用 UIVisualEffectView，优化样式。

### V1.3.0
 * 新增属性
 ```
 @property (nonatomic, assign) BOOL enableBgTap;                     /*!< 蒙版是否可以点击 收起*/
 @property (nonatomic, assign) BOOL needNewWindow;                   /*!< 是否新建window 默认为 NO */
```
 * 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。
 * 现默认使用不新建window的模式，
 * 但如果您的项目使用了多个window,当顶部window不是keywindow时，sheetView会被顶部window遮住。
 * 此时建议 将 needNewWindow 设置为 YES; 并在项目info.plist 中 新增 “View controller-based status bar appearance” 设置为 NO。
 * 这样也可以让 status bar 不变色
 
 感谢 [@leshengping](https://github.com/leshengping) 的建议和反馈 
 
### V1.2.0
 * 默认最大显示按钮个数为5.6, 既 maxShowButtonCount 默认为 5.6;
 * 添加自定义属性
 
```
@property (nonatomic, assign,getter=isShowSeparator) BOOL showSeparator;    /*!< 是否显示分割线 [default: YES]*/
@property (nonatomic, assign) CGFloat separatorLeftMargin;          /*!< 分割线离左边的边距 [default:0] */
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< 多选 确定按钮 颜色 */
 ```
 * 添加 界面展示前后的 delegate 和 block
 
 ```
 /** before and after animation delegate */
 - (void)willPresentActionSheet:(MKActionSheet *)actionSheet;    /*!< before animation and showing view */
 - (void)didPresentActionSheet:(MKActionSheet *)actionSheet;     /*!< after animation */
 - (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; /*!< before animation and hiding view */
 - (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  /*!< after animation */
 - (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithSelectArray:(NSArray *)selectArray; /*!< before animation and hiding view */
 - (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithSelectArray:(NSArray *)selectArray;  /*!< after animation */
 /** before and after animation block */
 @property (nonatomic, copy) MKActionSheetWillPresentBlock willPresentBlock;
 @property (nonatomic, copy) MKActionSheetDidPresentBlock didPresentBlock;
 @property (nonatomic, copy) MKActionSheetWillDismissBlock willDismissBlock;
 @property (nonatomic, copy) MKActionSheetDidDismissBlock didDismissBlock;
 @property (nonatomic, copy) MKActionSheetWillDismissMultiselectBlock willDismissMultiselectBlock;
 @property (nonatomic, copy) MKActionSheetDidDismissMultiselectBlock didDismissMultiselectBlock;
 ```
 
### V1.1.1
 * 高斯模糊效果
 * 支持无标题、无取消按钮样式
 * 支持带默认选中模式
 * 支持多选模式
 * 支持带 icon 图片样式
 * 支持多按钮，可设置最大显示数量（支持小数），超过最大数量，以tableView模式显示
 * 支持 Model 或 NSDictionary 数组初始化
 * 支持 block 和 delegate
 * 添加 cocoapod
 

### V1.0.3
 * MKActionSheet 基础功能，高斯模糊效果。
 * 支持无title、无取消按钮样式。
 * 支持自定义UI样式
 * 支持 block 和 delegate

 
 MIT License
-----------
```
Copyright (c) 2016 MK Xiao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
