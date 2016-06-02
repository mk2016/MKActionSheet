//
//  ViewController.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "ViewController.h"
#import "MKActionSheet.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MKActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
    [self.view addSubview:self.tableView];
    
    self.datasArray = [[NSMutableArray alloc] init];
    [self.datasArray addObject:@"MKActionSheet by Block"];
    [self.datasArray addObject:@"MKActionSheet by Delegate"];
    [self.datasArray addObject:@"MKActionSheet by buttonTitleArray"];
    [self.datasArray addObject:@"MKActionSheet by custom UI"];
    [self.datasArray addObject:@"MKActionSheetHelper by buttonTitles"];
    [self.datasArray addObject:@"MKActionSheetHelper by buttonTitleArray"];
    [self.datasArray addObject:@"change tableViewBackground View"];

}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = self.datasArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"this is a long titleeeeeeeeeeeeeeeeeeeeeeeeeeee" destructiveButtonIndex:3 buttonTitles:@"button1", @"button2",@"button3",@"button4",nil];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
        
    }else if (indexPath.row == 1){
        
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitles:@"button11", @"button12",@"button13",@"button14",nil];
        sheet.delegate = self;
        sheet.tag = 100;
        [sheet show];
        
    }else if (indexPath.row == 2){
        
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" buttonTitleArray:@[@"button21", @"button22",@"button23",@"button24"] destructiveButtonIndex:3];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
        
    }else if (indexPath.row == 3){
        
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" destructiveButtonIndex:3 buttonTitles:@"button31", @"button32",@"button33",@"button34", nil];
        [sheet addButtonWithTitle:@"button99"];
        sheet.cancelTitle = @"remove";
        sheet.buttonTitleFont = [UIFont systemFontOfSize:20];
        sheet.buttonTitleColor = [UIColor redColor];
        sheet.buttonOpacity = 0.3;
        sheet.buttonHeight = 60.0f;
        sheet.destructiveButtonTitleColor = [UIColor grayColor];
        sheet.animationDuration = 0.1f;
        sheet.blackgroundOpacity = 0.0f;
        sheet.blurOpacity = 0.7f;
        sheet.delegate = self;
        sheet.tag = 200;
        [sheet show];
        
    }else if (indexPath.row == 4){
        [MKActionSheetHelper sheetWithTitle:@"title" destructiveButtonIndex:0 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        } buttonTitles:@"button41", @"button42",@"button43",@"button44", nil];
        
    }else if (indexPath.row == 5){
        [MKActionSheetHelper sheetWithTitle:@"title" buttonTitleArray:@[@"button51", @"button52",@"button53",@"button54"] block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
    }else if (indexPath.row == 6) {
        if (self.tableView.backgroundView) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
        }
    }
}

- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"==============================");
    NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray.count ? self.datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
