//
//  ViewController.m
//  MKActionSheet
//
//  Created by xiaomk on 16/6/1.
//  Copyright © 2016年 MK. All rights reserved.
//

#import "ViewController.h"
#import "MKActionSheet.h"
#import "InfoModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "MKActionSheetAdd.h"
#import "UIView+Toast.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;
@property (nonatomic, strong) NSMutableArray *datasArray;

@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *dicArray;

@property (nonatomic, weak) MKActionSheet *customTitleSheet;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"DEMO";
    
    [self initTestData];
    
    [self initTableViewDatas];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

}

- (void)initTestData{
    
    //init model data array
    self.modelArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i++) {
        InfoModel *model = [[InfoModel alloc] init];
        model.titleStr = [NSString stringWithFormat:@"button%ld", (long)i];
        model.testData = [NSString stringWithFormat:@"test data %ld", (long)i];
        model.testNum = @(i);
        model.imageName = [NSString stringWithFormat:@"image_%ld",(long)i];
        model.image = [UIImage imageNamed:model.imageName];
//        model.imageUrl = [NSString stringWithFormat:@"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_%ld@2x.png",(long)i];
        model.imageUrl = @"http://taoqi-saas-public-prod.oss-cn-shenzhen.aliyuncs.com/saas/default/png/20191120/1574220880064--1016255442.png";
        [self.modelArray addObject:model];
    }
    
    //init dictionary data array
    self.dicArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
  
        NSDictionary *dic = @{@"titleStr"   :[NSString stringWithFormat:@"button%ld", (long)i],
                              @"testData"   :[NSString stringWithFormat:@"test data %ld", (long)i],
                              @"testNum"    :@(i),
                              @"imageName"  :[NSString stringWithFormat:@"image_%ld",(long)i],
                              @"image"      :[UIImage imageNamed:[NSString stringWithFormat:@"image_%ld",(long)i]],
                              @"imageUrl"   : @"http://taoqi-saas-public-prod.oss-cn-shenzhen.aliyuncs.com/saas/default/png/20191120/1574220897629-324204560.png"
//                              @"imageUrl"   :[NSString stringWithFormat:@"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_%ld@2x.png",(long)i],
                              };
        [self.dicArray addObject:dic];
    }

}

- (void)initTableViewDatas{

    [self.sectionTitleArray removeAllObjects];
    [self.sectionTitleArray addObject:@"change bg image"];
    [self.sectionTitleArray addObject:@"3 selectType type default UI"];
    [self.sectionTitleArray addObject:@"3 selectType type have icon"];
    [self.sectionTitleArray addObject:@"Portrait and Landscape config"];
    [self.sectionTitleArray addObject:@"add button and reload"];
    [self.sectionTitleArray addObject:@"custom titleView & UI"];

    [self.datasArray removeAllObjects];
    
    NSMutableArray *section0 = @[].mutableCopy;
    {
        MKCellModel *model = [[MKCellModel alloc] init];
        model.title = @"change tableViewBackground image";
        [section0 addObject:model];
        [self.datasArray addObject:section0];
    }
    
    NSMutableArray *section1 = @[].mutableCopy;
    {
        MKCellModel *model1 = [[MKCellModel alloc] init];
        model1.title = @"selectType:_common";
        model1.detail = @"default UI & long title";
        [section1 addObject:model1];
        
        MKCellModel *model2 = [[MKCellModel alloc] init];
        model2.title = @"selectType:_selected";
        model2.detail = @"default UI & title = nil";
        [section1 addObject:model2];
        
        MKCellModel *model3 = [[MKCellModel alloc] init];
        model3.title = @"selectType:_multiselect";
        model3.detail = @"title default left , default no cancel butto";
        [section1 addObject:model3];
    }
    [self.datasArray addObject:section1];
    
    NSMutableArray *section2 = @[].mutableCopy;
    {
        MKCellModel *model1 = [[MKCellModel alloc] init];
        model1.title = @"selectType:_common & icon";
        model1.detail = @"imagetype: name & init with model Array";
        [section2 addObject:model1];
        
        MKCellModel *model2 = [[MKCellModel alloc] init];
        model2.title = @"selectType:_selected & icon";
        model2.detail = @"imagetype: image & init with dictionary Array";
        [section2 addObject:model2];
        
        MKCellModel *model3 = [[MKCellModel alloc] init];
        model3.title = @"selectType:_multiselect & icon";
        model3.detail = @"imagetype: url & init with dictionary Array";
        [section2 addObject:model3];
    }
    [self.datasArray addObject:section2];

    NSMutableArray *section3 = @[].mutableCopy;
    {
        MKCellModel *model1 = [[MKCellModel alloc] init];
        model1.title = @"max show buton count";
        model1.detail = @"dufault : Portrait:5.6 , Landscape:4.6";
        [section3 addObject:model1];
        
        MKCellModel *model2 = [[MKCellModel alloc] init];
        model2.title = @"custom Portrait & Landscape config";
        model2.detail = @"";
        [section3 addObject:model2];
        
        MKCellModel *model3 = [[MKCellModel alloc] init];
        model3.title = @"custom Portrait & Landscape config & icon";
        [section3 addObject:model3];
    }
    [self.datasArray addObject:section3];
    
    NSMutableArray *section4 = @[].mutableCopy;
    {
        MKCellModel *model1 = [[MKCellModel alloc] init];
        model1.title = @"delay add button";
        model1.detail = @"add button with title";
        [section4 addObject:model1];
        
        MKCellModel *model2 = [[MKCellModel alloc] init];
        model2.title = @"add button by manual";
        model2.detail = @"add button with objece";
        [section4 addObject:model2];
        
        MKCellModel *model3 = [[MKCellModel alloc] init];
        model3.title = @"reload with array";
        model3.detail = @"manual dismiss";

        [section4 addObject:model3];
        
    }
    [self.datasArray addObject:section4];

    NSMutableArray *section5 = @[].mutableCopy;
    {
        MKCellModel *model1 = [[MKCellModel alloc] init];
        model1.title = @"custom title View";
        model1.detail = @"change title view";
        [section5 addObject:model1];
        
        MKCellModel *model2 = [[MKCellModel alloc] init];
        model2.title = @"custom UI";
        [section5 addObject:model2];
    }
    [self.datasArray addObject:section5];

}

- (void)delayTask:(float)time onTimeEnd:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - ***** UITableView delegate ******

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= self.datasArray.count) {
        return;
    }
    if (indexPath.row >= [self.datasArray[indexPath.section] count]) {
        return;
    }
    
    MKCellModel *model = self.datasArray[indexPath.section][indexPath.row];
    NSString *cellTitle = model.title;
    MK_WEAK_SELF
    if ([cellTitle isEqualToString:@"selectType:_common"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"init with longgggggggg gggggggggggggggggggggggggggggggggggg title \n default UI" buttonTitleArray:@[@"button0", @"button1", @"button2"]];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button index: %ld" ,(long)buttonIndex]];
        }];
    }
    
    //带默认选中 按钮  样式
    else if ([cellTitle isEqualToString:@"selectType:_selected"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3"] selectType:MKActionSheetSelectType_selected];
        sheet.selectedIndex = 2;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
        }];
    }
    
    //多选样式 无图片
    else if ([cellTitle isEqualToString:@"selectType:_multiselect"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@" titiititititiit " objArray:self.modelArray buttonTitleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
            [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }

    else if ([cellTitle isEqualToString:@"selectType:_common & icon"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil objArray:self.modelArray buttonTitleKey:@"titleStr" imageKey:@"imageName" imageValueType:MKActionSheetButtonImageValueType_name];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button index: %ld" ,(long)buttonIndex]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"selectType:_selected & icon"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil objArray:self.dicArray buttonTitleKey:@"titleStr" imageKey:@"image" imageValueType:MKActionSheetButtonImageValueType_image selectType:MKActionSheetSelectType_selected];
        sheet.selectedIndex = 1;
        sheet.needCancelButton = YES;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button index: %ld" ,(long)buttonIndex]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"selectType:_multiselect & icon"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"load url image"
                                                           objArray:self.dicArray
                                                     buttonTitleKey:@"titleStr"
                                                           imageKey:@"imageUrl"
                                                     imageValueType:MKActionSheetButtonImageValueType_url
                                                         selectType:MKActionSheetSelectType_multiselect];
        sheet.loadUrlImageblock = ^(MKActionSheet *actionSheet, UIButton *button, NSInteger index, NSURL *imageUrl) {
            [button sd_setImageWithURL:imageUrl forState:UIControlStateNormal];
        };
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"max show buton count"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4",@"button5",@"button6"] selectType:MKActionSheetSelectType_selected];
        sheet.selectedIndex = 2;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"custom Portrait & Landscape config"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom config" objArray:self.dicArray buttonTitleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        
        MKASOrientationConfig *portraitConfig = [[MKASOrientationConfig alloc] init];
        portraitConfig.titleAlignment = NSTextAlignmentCenter;
        portraitConfig.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
        portraitConfig.buttonHeight = 48.0f;
        portraitConfig.maxShowButtonCount = 4.6;
        
        MKASOrientationConfig *landscapeConfig = [[MKASOrientationConfig alloc] init];
        landscapeConfig.titleAlignment = NSTextAlignmentRight;
        landscapeConfig.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_right;
        landscapeConfig.buttonHeight = 36.0f;
        landscapeConfig.maxShowButtonCount = 3.6;
        [sheet setPortraitConfig:portraitConfig];
        [sheet setLandscapeConfig:landscapeConfig];
        
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"custom Portrait & Landscape config & icon"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom config" objArray:self.dicArray buttonTitleKey:@"titleStr" imageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url selectType:MKActionSheetSelectType_multiselect];
        
        MKASOrientationConfig *portraitConfig = [[MKASOrientationConfig alloc] init];
        portraitConfig.titleAlignment = NSTextAlignmentRight;
        portraitConfig.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_right;
        portraitConfig.buttonHeight = 48.0f;
        portraitConfig.maxShowButtonCount = 4.6;
        
        MKASOrientationConfig *landscapeConfig = [[MKASOrientationConfig alloc] init];
        landscapeConfig.titleAlignment = NSTextAlignmentLeft;
        landscapeConfig.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
        landscapeConfig.buttonHeight = 36.0f;
        landscapeConfig.maxShowButtonCount = 3.6;
        [sheet setPortraitConfig:portraitConfig];
        [sheet setLandscapeConfig:landscapeConfig];
        
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"delay add button"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"title" buttonTitleArray:@[@"button0", @"button1"]];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button index: %ld" ,(long)buttonIndex]];
        }];
        
        [self delayTask:0.1 onTimeEnd:^{
            [sheet addButtonWithButtonTitle:[NSString stringWithFormat:@"add delay 0.1 second"]];
        }];
        [self delayTask:0.5 onTimeEnd:^{
            [sheet addButtonWithButtonTitle:[NSString stringWithFormat:@"add delay 0.5 second"]];
        }];
        [self delayTask:1 onTimeEnd:^{
            [sheet addButtonWithButtonTitle:[NSString stringWithFormat:@"add delay 1 second"]];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"add button by manual"]){
        InfoModel *model1 = [[InfoModel alloc] init];
        model1.titleStr = [NSString stringWithFormat:@"add button 3"];
        model1.testData = [NSString stringWithFormat:@"test data"];
        model1.testNum = @(3);
        model1.imageName = [NSString stringWithFormat:@"image_3"];
        model1.image = [UIImage imageNamed:model1.imageName];
        model1.imageUrl = [NSString stringWithFormat:@"http://taoqi-saas-public-prod.oss-cn-shenzhen.aliyuncs.com/saas/default/png/20191120/1574220909014--1291393306.png"];
        
        InfoModel *model2 = [[InfoModel alloc] init];
        model2.titleStr = [NSString stringWithFormat:@"add button 4"];
        model2.testData = [NSString stringWithFormat:@"test data"];
        model2.testNum = @(3);
        model2.imageName = [NSString stringWithFormat:@"image_4"];
        model2.image = [UIImage imageNamed:model2.imageName];
        model2.imageUrl = [NSString stringWithFormat:@"http://taoqi-saas-public-prod.oss-cn-shenzhen.aliyuncs.com/saas/default/png/20191120/1574220920214--437715014.png"];
        
        
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@" titiititititiit "
                                                           objArray:self.modelArray
                                                     buttonTitleKey:@"titleStr"
                                                           imageKey:@"imageUrl"
                                                     imageValueType:MKActionSheetButtonImageValueType_url
                                                         selectType:MKActionSheetSelectType_multiselect];
        
        [sheet addButtonWithObj:model1];
        sheet.loadUrlImageblock = ^(MKActionSheet *actionSheet, UIButton *button, NSInteger index, NSURL *imageUrl) {
            [button sd_setImageWithURL:imageUrl forState:UIControlStateNormal];
        };
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"actionSheet:%@",actionSheet);
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];

        }];
        [sheet addButtonWithObj:model2];
    
    }
    
    
    else if ([cellTitle isEqualToString:@"reload with array"]){
        NSMutableArray *titlesAry = [[NSMutableArray alloc] initWithObjects:@"add 1", @"add 2", @"add 3", nil];
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"manual dismiss" buttonTitleArray:titlesAry];
        sheet.manualDismiss = YES;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
            if (buttonIndex < 3) {
                [titlesAry addObject:@"new button"];
                [sheet reloadWithTitleArray:titlesAry];
            }else{
                [sheet dismiss];
            }
        }];
    }

    

    
    else if ([cellTitle isEqualToString:@"custom title View"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:@[@"button1", @"button2",@"button3",@"button4"]];
        self.customTitleSheet = sheet;
        sheet.manualDismiss = YES;
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor redColor];
        
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.text = @"自定义titleView";
        labTitle.textColor = [UIColor greenColor];
        labTitle.font = [UIFont boldSystemFontOfSize:17];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:labTitle];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"title button" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor greenColor];
        [btn addTarget:self action:@selector(btnTitleOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(titleView);
            make.centerX.equalTo(titleView);
            make.bottom.equalTo(btn.mas_top);
        }];
    
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
            make.top.equalTo(labTitle.mas_bottom);
        }];
        
        [sheet setCustomTitleView:titleView makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.left.right.top.equalTo(superview);
            make.bottom.equalTo(superview);
            make.height.mas_equalTo(100);
        }];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor blueColor];
            [sheet setCustomTitleView:view makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
                make.edges.equalTo(superview);
                make.height.mas_equalTo(120);
            }];
        }];
  
    }
    
    //自定义UI
    else if ([cellTitle isEqualToString:@"custom UI"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom UI" buttonTitleArray:@[@"button1", @"button2",@"button3",@"button4", @"button5",@"button6",@"button7"]];
        sheet.titleColor = [UIColor greenColor];
        sheet.titleFont = [UIFont boldSystemFontOfSize:24];
        sheet.buttonTitleColor = [UIColor redColor];
        sheet.buttonTitleFont = [UIFont boldSystemFontOfSize:14];
        sheet.buttonOpacity = 1;
        sheet.destructiveButtonTitleColor = [UIColor grayColor];
        sheet.destructiveButtonIndex = 2;
        sheet.cancelTitle = @"关闭";
        sheet.animationDuration = 0.2f;
        sheet.blurOpacity = 0.7f;
        sheet.blackgroundOpacity = 0.6f;
        sheet.needCancelButton = YES;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
        }];
    }

    else if ([cellTitle isEqualToString:@"change tableViewBackground image"]) {
        if (self.tableView.backgroundView) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
        }
    }
}

- (UIImage *)getDefaultIcon{
    return [UIImage imageNamed:@"image_5"];
}

- (void)btnTitleOnclick:(UIButton *)sender{
    [self.view makeToast:@"custom title button onclicked"];
    [self.customTitleSheet dismiss];
    
//    if (self.customTitleSheet.delegate && [self.customTitleSheet.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:)]) {
//        [self.customTitleSheet.delegate actionSheet:self.customTitleSheet didClickButtonAtIndex:0];
//    }
//    if (self.customTitleSheet.block) {
//        self.customTitleSheet.block(self.customTitleSheet, 0);
//    }
}


#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.numberOfLines = 0;
    }
    if (indexPath.section < self.datasArray.count) {
        if (indexPath.row < [self.datasArray[indexPath.section] count]) {
            MKCellModel *model = self.datasArray[indexPath.section][indexPath.row];
            cell.textLabel.text = model.title;
            cell.detailTextLabel.text = model.detail;
        }
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.datasArray.count) {
        return [self.datasArray[section] count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MK_SCREEN_WIDTH, 30)];
    view.backgroundColor = MK_COLOR_RGBA(255, 255, 255, 0.3);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, MK_SCREEN_WIDTH-32, 30)];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:14];
    if (section < self.sectionTitleArray.count) {
        lab.text = self.sectionTitleArray[section];
    }
    [view addSubview:lab];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSMutableArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[].mutableCopy;
    }
    return _sectionTitleArray;
}

- (NSMutableArray *)datasArray{
    if (!_datasArray) {
        _datasArray = @[].mutableCopy;
    }
    return _datasArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@implementation MKCellModel
@end
