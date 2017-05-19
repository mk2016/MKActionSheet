//
//  MKFPSStatus.m
//  MKFPSStatus
//
//  Created by xiaomk on 16/6/27.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKFPSStatus.h"

@interface MKFPSStatus(){
    CADisplayLink   *_displayLink;
    NSTimeInterval  _lastTime;
    NSUInteger      _count;
}

@property (nonatomic, strong)UILabel *fpsLabel;
@end

@implementation MKFPSStatus

+ (instancetype)sharedInstance {
    static MKFPSStatus *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[MKFPSStatus alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // fpsLabel
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-50)/2+50, 3, 54, 16)];
        _fpsLabel.font = [UIFont systemFontOfSize:13];
        _fpsLabel.textColor = [UIColor colorWithRed:0.33 green:0.84 blue:0.43 alpha:1.00];
        _fpsLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.layer.cornerRadius = 2;
        _fpsLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval interval = link.timestamp - _lastTime;
    if (interval < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / interval;
    _count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    _fpsLabel.text = text;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    _fpsLabel.textColor = color;
}

- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}

#pragma mark - ***** Open ******
- (void)open{
    [_fpsLabel removeFromSuperview];
    UIView* bgView = [UIApplication sharedApplication].keyWindow;
    [bgView addSubview:_fpsLabel];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_fpsLabel];
    [_displayLink setPaused:NO];
}

- (void)openOnView:(UIView *)view frame:(CGRect)frame{
    [_fpsLabel removeFromSuperview];
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-50)/2+50, 3-20, 54, 16);
    }
    
    [view addSubview:_fpsLabel];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_fpsLabel];
    _fpsLabel.frame = frame;
    [_displayLink setPaused:NO];
}

- (void)close{
    [_displayLink setPaused:YES];
    [_fpsLabel removeFromSuperview];
}

- (void)dealloc{
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
