//
//  MKASOrientationConfig.m
//  MKActionSheet
//
//  Created by xmk on 2017/5/19.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKASOrientationConfig.h"

@implementation MKASOrientationConfig
- (instancetype)init{
    if (self = [super init]) {
        _titleAlignment = NSTextAlignmentCenter;
        _buttonTitleAlignment = MKActionSheetButtonTitleAlignment_center;
        _buttonHeight = 48.0f;
        _maxShowButtonCount = 4.6;
    }
    return self;
}

@end
