# MKActionSheet

[![Travis](https://img.shields.io/travis/mk2016/MKActionSheet.svg?style=flat)](https://travis-ci.org/mk2016/MKActionSheet)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/MKActionSheet.svg)](http://cocoadocs.org/docsets/MKActionSheet)
[![CocoaPods](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/mk2016/MKActionSheet/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/MKActionSheet.svg)](http://cocoadocs.org/docsets/MKActionSheet)
[![MKDev](https://img.shields.io/badge/blog-MK-brightgreen.svg)](https://mk2016.github.io/)

## 多样式 ActionSheet
 * 高斯模糊效果
 * 支持横屏
 * 支持无标题、无取消按钮样式
 * 支持带默认选中模式
 * 支持多选模式
 * 支持带 icon 图片样式
 * 支持多按钮，可设置最大显示数量（支持小数），超过最大数量滚动
 * 支持 Model 或 NSDictionary 数组初始化
 * 支持 block 
 * 支持动态添加 button
 * 支持动态 修改 titleView
 
#### 先上效果图
 ![image](https://github.com/mk2016/MKActionSheet/raw/master/Screenshots/gif2.gif)


## 使用
* cocoapods  
  pod 'MKActionSheet', '~> 2.0.2'

* Manually (手动导入)  
  只需将 MKActionSheet 文件添加到项目中即可
  
* 依赖
  Masonry ~> 1.0.2   
  SDWebImage ~> 4.0.0

## 用法 详细用法参见demo
##### 1.4.0 版本之后 化烦为简 去除 delegate 用法, 适配到iOS8。  需要delegate或者想支持iOS7可以使用V1.3.2版本。
##### 2.0.1 版本重构了代码，后支持横屏 和之前版本有较大差异，旧版升级上来的请检查是否需要修改你的代码
##### 有使用者反馈，status bar原来白色会变为黑色，这是由于新建了 window 导致的。 可以将 currentVC 设置为当前 viewController

 
```
//单选 block
- (void)showWithBlock:(MKActionSheetBlock)block;
//多选 block
- (void)showWithMultiselectBlock:(MKActionSheetMultiselectBlock)multiselectblock;
```

##### 枚举
* selectType
```
 typedef NS_ENUM(NSInteger, MKActionSheetSelectType) {
    MKActionSheetSelectType_common  = 1,        //default
    MKActionSheetSelectType_selected,           //have a selected button
    MKActionSheetSelectType_multiselect,        //multiselect
};
```
* button title Alignment
```
typedef NS_ENUM(NSInteger, MKActionSheetButtonTitleAlignment) {
    MKActionSheetButtonTitleAlignment_center    = 1,        //default
    MKActionSheetButtonTitleAlignment_left,
    MKActionSheetButtonTitleAlignment_right,
};
```
 
* button image value type
 ```
typedef NS_ENUM(NSInteger, MKActionSheetButtonImageValueType) {
    MKActionSheetButtonImageValueType_none      = 1,        //default
    MKActionSheetButtonImageValueType_image,
    MKActionSheetButtonImageValueType_name,
    MKActionSheetButtonImageValueType_url,
};
 ```
* 普通样式，多参数初始化
 
```
   MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" buttonTitleArray:@[@"button0", @"button1", @"button2"]];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        }];
```

* 对象数组初始化，支持 model 和 NSDictionary 数组。titleKey是对象中用来显示按钮title对应的字段。
 
```
  MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@" titiititititiit " objArray:self.modelArray buttonTitleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
            [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
        }];
```

* 带icon图标的样式

```
 MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil objArray:self.modelArray buttonTitleKey:@"titleStr" imageKey:@"imageName" imageValueType:MKActionSheetButtonImageValueType_name];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        }];
        

MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"load url image" objArray:self.dicArray buttonTitleKey:@"titleStr" imageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url selectType:MKActionSheetSelectType_multiselect];
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
```



#### 可以根据自己的需求定制UI
```
/**  custom UI */
@property (nonatomic, assign) CGFloat windowLevel;          /*!< default: UIWindowLevelStatusBar - 1 */
@property (nonatomic, weak) UIViewController *currentVC;    /*!< current viewController, for statusBar keep the same style */
@property (nonatomic, assign) BOOL enabledForBgTap;         /*!< default: YES */
@property (nonatomic, assign) BOOL manualDismiss;           /**  [default: NO]. if set 'YES', you need calling the method of 'dismiss' to hide actionSheet by manual */

/** action sheet */
@property (nonatomic, assign) CGFloat animationDuration;            /*!< 动画化时间 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blurOpacity;                  /*!< 毛玻璃透明度 [default: 0.3f] */
@property (nonatomic, assign) CGFloat blackgroundOpacity;           /*!< 灰色背景透明度 [default: 0.3f] */

//title
@property (nonatomic, strong) UIColor *titleColor;                  /*!< 标题颜色 [default: RGBA(100.0f, 100.0f, 100.0f, 1.0f)]*/
@property (nonatomic, strong) UIFont *titleFont;                    /*!< 标题字体 [default: sys 14] */
@property (nonatomic, assign) CGFloat titleMargin;                  /*!< title side spacee [default: 20] */

//button
@property (nonatomic, strong) UIColor *buttonTitleColor;            /*!< 按钮 titile 颜色 [default:RBGA(51.0f, 51.0f, 51.0f, 1.0f)] */
@property (nonatomic, strong) UIFont  *buttonTitleFont;             /*!< 按钮 字体 [default: sys 18] */
@property (nonatomic, assign) CGFloat buttonOpacity;                /*!< 按钮透明度 [default: 0.6] */
@property (nonatomic, assign) CGFloat buttonImageRightSpace;        /*!< 带图片样式 图片右边离 title 的距离 [default: 12.f] */

//destructive Button
@property (nonatomic, assign) NSInteger destructiveButtonIndex;     /*!< [default:-1]*/
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor; /*!< [default:RBGA(250.0f, 10.0f, 10.0f, 1.0f)]*/

//cancel Title
@property (nonatomic, assign) BOOL needCancelButton;                /*!< 是否需要取消按钮 */
@property (nonatomic, copy) NSString *cancelTitle;                 /*!< cancel button title [dafault:取消] */


//MKActionSheetSelectType_selected
@property (nonatomic, assign) NSInteger selectedIndex;              /*!< selected button index */
@property (nonatomic, copy) NSString *selectedBtnImageName;         /*!< image name for selected button  */

//MKActionSheetSelectType_multiselect
@property (nonatomic, copy) NSString *selectBtnImageNameNormal;     /*!< image name for select button normal state */
@property (nonatomic, copy) NSString *selectBtnImageNameSelected;   /*!< image name for select button selected state )*/
@property (nonatomic, strong) NSString *multiselectConfirmButtonTitle;      /*!< confirm button title */
@property (nonatomic, strong) UIColor *multiselectConfirmButtonTitleColor;  /*!< confirm button title color */
@property (nonatomic, strong) UIImage *placeholderImage;
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
### V2.0.2
 * 依赖 SDWebImage 版本改为当前最新的V4.0.0
### V2.0.1
 * 重构，支持横屏，动态添加 button
 * PS:此版本有重大改动，旧版升级上来的，请检查代码
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
