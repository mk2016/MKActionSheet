//
//  NSObject+MKASAdditions.m
//  MKActionSheet
//
//  Created by xiaomk on 16/8/6.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "NSObject+MKASAdditions.h"
#import <objc/runtime.h>

@implementation NSObject (MKASAdditions)

- (void)setMk_isSelect:(BOOL)mk_isSelect{
    objc_setAssociatedObject(self, @selector(mk_isSelect), @(mk_isSelect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mk_isSelect{
    NSNumber *mk_isSelect = objc_getAssociatedObject(self, @selector(mk_isSelect));
    return [mk_isSelect boolValue];
}

@end
