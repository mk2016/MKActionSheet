//
//  MKASRootViewController.m
//  MKActionSheet
//
//  Created by xmk on 2017/5/5.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKASRootViewController.h"

@interface MKASRootViewController ()

@end

@implementation MKASRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersStatusBarHidden{
    if (self.vc) {
        return [self.vc prefersStatusBarHidden];
    }else{
        return [super prefersStatusBarHidden];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.vc) {
        return [self.vc preferredStatusBarStyle];
    }else{
        return [super preferredStatusBarStyle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
