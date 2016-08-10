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
 * 支持 block 和 delegate
 
#### 先上效果图
 ![image](https://github.com/mk2016/MKActionSheet/raw/master/Screenshots/gif2.gif)


##添加
* cocoapods

* Manually (手动导入)  
  只需将 MKActionSheet 文件添加到项目中即可


##用法 详细用法参见demo
* 支持 block 和 delegate

```
//单选 block
- (void)showWithBlock:(MKActionSheetBlock)block;
//多选 block
- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock;

//delegate
- (void)showWithDelegate:(id <MKActionSheetDelegate>)delegate;

/**
 *  单选 delegage
 *  @param buttonIndex 被点击按钮的 index
 */
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex;

/**
 *  多选样式 的delegate 点击确认后 返回 选中的 array， 如果有 取消 按钮，取消按钮返回的 array 为nil
 *  @param array       被选中的button 对应数据的 array
 */
- (void)actionSheet:(MKActionSheet *)actionSheet selectArray:(NSArray *)array;

/**
 *  带icon图片，imageKey 对应的 图片类型是 URL方式， 调用此回调 设置图片
 *  @param button      要设置图片的 button
 *  @param imageUrl    图片的URL， 即 object 对应 的 imageKey 字段
 */
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl;
```

* 普通样式，多参数初始化， block
 
```
 MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"初始化title为nil，将显示不带title样式。title" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"]];
sheet.destructiveButtonIndex = 3;
[sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
	NSLog(@"buttonIndex:%ld",(long)buttonIndex);
}];
```

* 普通样式，数组初始化， delegate
 
```
MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"]];
sheet.selectedIndex = 2;
[sheet showWithDelegate:self];
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

* 带icon图标的样式，imageValueType 为 url 时加载图片的方法。
  - 由于大家可能在项目中使用的加载图片的框架不一样，为了不增加使用MKActionSheet控件的成本。将加载url图片的方法 用block和delegate 回调出来让大家自己实现。以下是以比较常用的SDWebimage为例。

```
//button: 要被设置icon的按钮, imageUrl:图片的URL, 既前面设置的 ImageKey 的值，且imageValueType 为 MKActionSheetButtonImageValueType_url。
//
//block
sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
	[button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
};
//
//delegete
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl{
    [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
}
```


#### 可以根据自己的需求定制UI
```
/**  custom UI */
//title
@property (nonatomic, copy) NSString *title;                        /*!< 标题 */
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 */
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;       /*!< 标题 对齐方式 */
//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 */
@property (nonatomic, assign) CGFloat buttonHeight;                 /*!< default: 48.0f*/
@property (nonatomic, assign) MKActionSheetButtonTitleAlignment buttonTitleAlignment;   /*!< button title 对齐方式 */
//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< 特殊按钮位置 */
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< 特殊按钮颜色 */
//cancel Title
@property (nonatomic, copy) NSString  *cancelTitle;                 /*!< 取消按钮 title */
//action sheet
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title 边距 */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 default: 0.3f */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 default: 0.0f */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 default: 0.3f */
@property (nonatomic, assign,getter=isNeedCancelButton) BOOL needCancelButton;              /*!< 是否需要取消按钮 */
@property (nonatomic, assign) CGFloat maxShowButtonCount;           /*!< 显示按钮最大个数，支持小数 默认-1，全部显示*/
@property (nonatomic, assign) NSInteger selectedIndex;       /*!< 默认选中的button index, 带默认选中样式 */
//object Array
@property (nonatomic, copy) NSString *titleKey;                     /*!< 传入为object array 时 指定 title 的字段名 */
@property (nonatomic, copy) NSString *imageKey;                     /*!< 传入为object array 时 指定button image对应的字段名 */
@property (nonatomic, assign) MKActionSheetButtonImageValueType imageValueType;   /*!< imageKey对应的类型：image、imageName、imageUrl */
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
 
### V1.1.0
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
