//
//  MKUIHelper.m
//  MKToolsKit
//
//  Created by xmk on 16/9/23.
//  Copyright © 2016年 mk. All rights reserved.
//

#import "MKUIHelper.h"
#import <MessageUI/MessageUI.h>

@implementation MKUIHelper

#pragma mark - ***** top View ******
+ (UIView *)getTopView{
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

#pragma mark - ***** current ViewController ******
/** default include presentedViewController */
+ (UIViewController *)getCurrentViewController{
    return [self getCurrentViewControllerWithWindowLevel:UIWindowLevelNormal includePresentedVC:YES];
}

+ (UIViewController *)getCurrentViewControllerIsIncludePresentedVC:(BOOL)isIncludePVC{
    return [self getCurrentViewControllerWithWindowLevel:UIWindowLevelNormal includePresentedVC:isIncludePVC];
}

+ (UIViewController *)getCurrentViewControllerWithWindowLevel:(CGFloat)windowLevel includePresentedVC:(BOOL)isIncludePVC{
    UIViewController *result = nil;
    
    if (isIncludePVC) {
        result = [self getPresentedViewController];
        if (result) {
            return result;
        }
    }
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != windowLevel) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            if (window.windowLevel == windowLevel) {
                topWindow = window;
            }
        }
    }
    
    UIView *rootView;
    NSArray *subViews = [topWindow subviews];
    if (subViews.count) {
        rootView = [subViews objectAtIndex:0];
    }else{
        rootView = topWindow;
    }
    
    id nextResponder = [rootView nextResponder];
    //    UIWindow* nextResWindow;
    //    if ([nextResponder isKindOfClass:[UIWindow class]]) {
    //        nextResWindow = (UIWindow*)nextResponder;
    //    }
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        //    }else if (nextResWindow != nil && [nextResponder respondsToSelector:@selector(rootViewController)] && nextResWindow.rootViewController != nil){
        //        result = nextResWindow.rootViewController;
    }else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
        NSAssert(NO, @"MKToolsKit: Could not find a root view controller.");
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)result;
        result = nav.topViewController;
    }
    return result;
}

+ (UIViewController *)getPresentedViewController{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    UIViewController *topVC = nil;
    if (appRootVC.presentedViewController) {
        if (![appRootVC.presentedViewController isKindOfClass:[UIAlertController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[UIImagePickerController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[MFMessageComposeViewController class]]){
            topVC = appRootVC.presentedViewController;
            
            if (topVC && [topVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)topVC;
                topVC = nav.topViewController;
            }
        }
    }
    return topVC;
}


@end
