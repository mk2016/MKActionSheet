//
//  MKFPSStatus.h
//  MKFPSStatus
//
//  Created by xiaomk on 16/6/27.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKFPSStatus : NSObject

+ (MKFPSStatus *)sharedInstance;

- (void)open;
- (void)openOnView:(UIView *)view frame:(CGRect)frame;

- (void)close;
@end
