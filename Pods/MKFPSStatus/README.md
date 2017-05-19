# MKFPSStatus

[![CocoaPods Version](https://img.shields.io/cocoapods/v/MKFPSStatus.svg)](http://cocoadocs.org/docsets/MKFPSStatus)
[![CocoaPods](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/mk2016/MKFPSStatus/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/MKFPSStatus.svg)](http://cocoadocs.org/docsets/MKFPSStatus)
[![MKDev](https://img.shields.io/badge/blog-MK-brightgreen.svg)](https://mk2016.github.io/)
####用于显示当前的FPS,给app性能提供直观的显示，为app的UI性能优化提供参考。

###导入
* cocoapods  
	pod 'MKFPSStatus', '~> 1.0.3'
	
* Manually (手动导入)  
 	将 MKFPSStatus 文件导入你的项目中，#import "MKFPSStatus.h" 即可

###用法
在 appDelegate.m 中
```
#import "MKFPSStatus.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //other code
#ifdef DEBUG
    [[MKFPSStatus sharedInstance] open];
#endif
    return YES;
}
```

###效果图
 ![image](https://github.com/mk2016/MKFPSStatus/raw/master/Screenshots/0.png)
 ![image](https://github.com/mk2016/MKFPSStatus/raw/master/Screenshots/1.png)
 
 
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
