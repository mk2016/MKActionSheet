//
//  MKASRootViewController.m
//  MKActionSheet
//
//  Created by xmk on 2016/12/2.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "MKASRootViewController.h"
#import "MKASUIHelper.h"

@interface MKASRootViewController ()

@end

@implementation MKASRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden{
    [super prefersStatusBarHidden];
    return [self.vc prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    [super preferredStatusBarStyle];
    return [self.vc preferredStatusBarStyle];
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
