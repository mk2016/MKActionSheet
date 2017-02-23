//
//  NSObject+MKASAdd.m
//  MKActionSheet
//
//  Created by xiaomk on 16/8/6.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "NSObject+MKASAdd.h"
#import <objc/runtime.h>

@implementation NSObject (MKASAdditions)

- (void)setMk_selected:(BOOL)mk_selected{
    objc_setAssociatedObject(self, @selector(mk_selected), @(mk_selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mk_selected{
    NSNumber *selected = objc_getAssociatedObject(self, @selector(mk_selected));
    return [selected boolValue];
}

@end
