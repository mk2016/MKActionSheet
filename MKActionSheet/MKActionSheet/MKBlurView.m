//
//  MKBlurView.m
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "MKBlurView.h"

@interface MKBlurView ()
@property (nonatomic, strong) UIToolbar * blurBar;
@end

@implementation MKBlurView

/** general initializer */
- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

/** use with Storyboard */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setClipsToBounds:YES];
    self.backgroundColor = [UIColor clearColor];
    if (!_blurBar) {  // lazy instantiate
        _blurBar = [[UIToolbar alloc] initWithFrame:[self bounds]];
        [self.layer insertSublayer:[self.blurBar layer] atIndex:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.blurBar setFrame:[self bounds]];
}

#pragma mark - ***** method ******
- (void)setColor:(UIColor *)color{
    [self setBackgroundColor:color];
}

- (void)setAlpha:(CGFloat)alpha{
    unsigned long numComponents = CGColorGetNumberOfComponents([[self backgroundColor] CGColor]);
    if (numComponents == 4){
        const CGFloat *components = CGColorGetComponents([[self backgroundColor] CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        [self setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    }else{
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
    }
}

@end
