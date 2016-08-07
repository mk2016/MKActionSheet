//
//  MKFPSStatus.h
//  MKFPSStatus
//
//  Created by xiaomk on 16/6/27.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MKFPSStatusWindowLevel UIWindowLevelStatusBar+90

@interface MKFPSStatus : UIWindow

+ (MKFPSStatus *)sharedInstance;

- (void)open;
- (void)close;
@end
