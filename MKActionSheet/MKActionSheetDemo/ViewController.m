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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MKActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *dicArray;
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
    
    [self initTestData];
}

- (void)initTestData{
    //tableView dataSource
    self.datasArray = [[NSMutableArray alloc] init];
    [self.datasArray addObject:@"change tableViewBackground View"];
    [self.datasArray addObject:@"have icon style: imageName"];
    [self.datasArray addObject:@"have icon style: image"];
    [self.datasArray addObject:@"have icon style: imageUrl 、delegate"];
    [self.datasArray addObject:@"have icon style: imageUrl 、block"];
    [self.datasArray addObject:@"init with Block"];
    [self.datasArray addObject:@"init with delegate and no title"];
    [self.datasArray addObject:@"button Titles"];
    [self.datasArray addObject:@"more then max show Count"];
    [self.datasArray addObject:@"no cancel"];
    
    [self.datasArray addObject:@"custom UI"];
    [self.datasArray addObject:@"modelArray show with block"];
    [self.datasArray addObject:@"modelArray show with paramBlock"];
    [self.datasArray addObject:@"param with model and have cancel button"];
    [self.datasArray addObject:@"param with Dictionary"];
    
    
    
    //init model data array
    self.modelArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        InfoModel *model = [[InfoModel alloc] init];
        model.titleStr = [NSString stringWithFormat:@"button %ld", (long)i];
        model.testData = [NSString stringWithFormat:@"test data %ld", (long)i];
        model.testNum = @(i);
        model.imageName = [NSString stringWithFormat:@"image_%ld",(long)i];
        model.image = [UIImage imageNamed:model.imageName];
        model.imageUrl = [NSString stringWithFormat:@"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_%ld@2x.png",(long)i];
        
        
        OtherModel *otherModel = [[OtherModel alloc] init];
        otherModel.titleStr = [NSString stringWithFormat:@"other button %ld", (long)i];
        otherModel.otherData = [NSString stringWithFormat:@"other Data %ld", (long)i];
        otherModel.otherNum = @(i+100);
        model.otherInfo = otherModel;
        
        [self.modelArray addObject:model];
    }
    
    //init dictionary data array
    self.dicArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        NSDictionary *otherDic = @{@"titleStr":[NSString stringWithFormat:@"other button %ld", (long)i],
                                   @"otherData":[NSString stringWithFormat:@"other Data %ld", (long)i],
                                   @"otherNum":@(i+100)
                                   };
        NSDictionary *dic = @{@"titleStr"   :[NSString stringWithFormat:@"button %ld", (long)i],
                              @"testData"   :[NSString stringWithFormat:@"test data %ld", (long)i],
                              @"testNum"    :@(i),
                              @"otherDic"   :otherDic,
                              @"imageName"  :[NSString stringWithFormat:@"image_%ld",(long)i],
                              @"image"      :[UIImage imageNamed:[NSString stringWithFormat:@"image_%ld",(long)i]],
                              @"imageUrl"   :[NSString stringWithFormat:@"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_%ld@2x.png",(long)i],
                              };
        [self.dicArray addObject:dic];
    }

}

#pragma mark - ***** UITableView delegate ******

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cellTitle = [self.datasArray objectAtIndex:indexPath.row];
    
    
    if ([cellTitle isEqualToString:@"change tableViewBackground View"]) {
        if (self.tableView.backgroundView) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
        }
    }
    
    else if ([cellTitle isEqualToString:@"init with Block"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"this is a longgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg title" destructiveButtonIndex:3 buttonTitles:@"button1", @"button2",@"button3",@"button4",nil];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
        
    }
    
    else if ([cellTitle isEqualToString:@"init with delegate and no title"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitles:@"button11", @"button12",@"button13",@"button14",nil];
        sheet.tag = 100;
        sheet.delegate = self;
        [sheet show];
//        [sheet showWithDelegate:self];
        
    }
    
    else if ([cellTitle isEqualToString:@"button Titles"]) {
        [MKActionSheet sheetWithTitle:@"title" destructiveButtonIndex:0 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        } buttonTitles:@"button41", @"button42",@"button43",@"button44", nil];
        
    }

    else if ([cellTitle isEqualToString:@"more then max show Count"]){
        [MKActionSheet sheetWithTitle:@"title" buttonTitleArray:@[@"button1", @"button2",@"button3",@"button4",@"button5",@"button6",@"button7",@"button8",@"button9",@"button10"]
                   isNeedCancelButton:YES maxShowButtonCount:5.6 block:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
                       NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
                   }];
    }

    else if ([cellTitle isEqualToString:@"no cancel"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom UI" destructiveButtonIndex:3 buttonTitles:@"button1", @"button2",@"button3",@"button4",@"button5",@"button6",@"button7",@"button8",@"button9",@"button10", nil];
        [sheet addButtonWithTitle:@"this a add Button"];
        sheet.maxShowButtonCount = 5.6;
        sheet.isNeedCancelButton = NO;
        [sheet show];
        
    }

    else if ([cellTitle isEqualToString:@"custom UI"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom UI" destructiveButtonIndex:3 buttonTitles:@"button31", @"button32",@"button33",@"button34", nil];
        sheet.isNeedCancelButton = YES;
        sheet.titleColor = [UIColor greenColor];
        sheet.titleAlignment = NSTextAlignmentLeft;
        sheet.cancelTitle = @"关闭";
        sheet.buttonTitleColor = [UIColor redColor];
        sheet.buttonTitleFont = [UIFont boldSystemFontOfSize:14];
        sheet.buttonOpacity = 1;
        sheet.buttonHeight = 40.0f;
        sheet.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
        sheet.destructiveButtonTitleColor = [UIColor grayColor];
        sheet.animationDuration = 0.2f;
        sheet.blurOpacity = 0.7f;
        sheet.blackgroundOpacity = 0.6f;
        [sheet addButtonWithTitle:@"button add"];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
        }];
        
    }

    else if ([cellTitle isEqualToString:@"modelArray show with block"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:2];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"----------------------");
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            InfoModel *model = [self.modelArray objectAtIndex:buttonIndex];
            if (model) {
                NSLog(@"obj.titleStr:%@",model.titleStr);
                NSLog(@"obj.testData:%@",model.testData);
                NSLog(@"obj.testNum:%@",model.testNum);
            }
        }];
    }

    else if ([cellTitle isEqualToString:@"modelArray show with paramBlock"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:3];
        [sheet showWithParamBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, InfoModel *obj) {
            NSLog(@"----------------------");
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            NSLog(@"obj.titleStr:%@",obj.titleStr);
            NSLog(@"obj.testData:%@",obj.testData);
            NSLog(@"obj.testNum:%@",obj.testNum);
        }];
    }
    
    else if ([cellTitle isEqualToString:@"param with model and have cancel button"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:3];
        sheet.isNeedCancelButton = YES;
        sheet.tag = 200;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"param with Dictionary"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.dicArray titleKey:@"titleStr" destructiveButtonIndex:3];
        sheet.isNeedCancelButton = YES;
        [sheet showWithParamBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, NSDictionary *dic) {
            NSLog(@"----------------------");
            if (dic) {
                NSLog(@"buttonIndex:%ld",(long)buttonIndex);
                NSLog(@"dic : %@",dic);
            }else{
                NSLog(@"is cancel button, obj = nil");
            }
            
            //or
            NSLog(@"-----------or-----------");
            if (buttonIndex == self.modelArray.count) {
                NSLog(@"is cancel button, obj = nil");
            }else{
                NSLog(@"buttonIndex:%ld",(long)buttonIndex);
                NSLog(@"dic : %@",dic);
            }
        }];
    }
    
    else if ([cellTitle isEqualToString:@"have icon style: imageName"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"have icon style: imageName" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:0];
        [sheet setImageKey:@"imageName" imageType:MKActionSheetButtonImageType_name];
        [sheet showWithParamBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, InfoModel *obj) {
            NSLog(@"----------------------");
            if (obj) {
                NSLog(@"buttonIndex:%ld",(long)buttonIndex);
                NSLog(@"obj.titleStr:%@",obj.titleStr);
                NSLog(@"obj.testData:%@",obj.testData);
                NSLog(@"obj.testNum:%@",obj.testNum);
            }
        }];
    }
    
    else if ([cellTitle isEqualToString:@"have icon style: image"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"have icon style: image" objArray:self.dicArray titleKey:@"titleStr" destructiveButtonIndex:0];
        [sheet setImageKey:@"image" imageType:MKActionSheetButtonImageType_image];
        sheet.isNeedCancelButton = YES;
        [sheet showWithParamBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, NSDictionary *dic) {
            NSLog(@"----------------------");
            if (dic) {
                NSLog(@"buttonIndex:%ld",(long)buttonIndex);
                NSLog(@"dic : %@",dic);
            }else{
                NSLog(@"is cancel button, obj = nil");
            }
        }];
    }
    
    else if ([cellTitle isEqualToString:@"have icon style: imageUrl 、delegate"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"have icon style: imageUrl" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:0];
        [sheet setImageKey:@"imageUrl" imageType:MKActionSheetButtonImageType_url];
        sheet.titleAlignment = NSTextAlignmentLeft;
        sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
            [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_5"]];
        };
        sheet.tag = 300;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"have icon style: imageUrl 、block"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"have icon style: imageUrl" objArray:self.modelArray titleKey:@"titleStr" destructiveButtonIndex:-1];
        [sheet setImageKey:@"imageUrl" imageType:MKActionSheetButtonImageType_url];
        sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
            [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_5"]];
        };
        [sheet showWithParamBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, InfoModel *obj) {
            if (obj) {
                NSLog(@"buttonIndex:%ld",(long)buttonIndex);
                NSLog(@"obj.titleStr:%@",obj.titleStr);
                NSLog(@"obj.testData:%@",obj.testData);
                NSLog(@"obj.testNum:%@",obj.testNum);
            }
        }];
    }
}

#pragma mark - ***** MKActionSheet delegate ******
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl{
    if (actionSheet.tag == 300) {
        [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_5"]];
    }
}

- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"==========delegate====================");
    NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
}

- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex selectObj:(InfoModel *)obj{
    if (actionSheet.tag == 200) {
        NSLog(@"---------delegate -------------");
        if (obj) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            NSLog(@"obj.titleStr:%@",obj.titleStr);
            NSLog(@"obj.testData:%@",obj.testData);
            NSLog(@"obj.testNum:%@",obj.testNum);
        }else{
            NSLog(@"is cancel button, obj = nil");
        }
        
        //or
        NSLog(@"-----------or");
        if (buttonIndex == self.modelArray.count) {
            NSLog(@"is cancel button, obj = nil");
        }else{
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            NSLog(@"obj.titleStr:%@",obj.titleStr);
            NSLog(@"obj.testData:%@",obj.testData);
            NSLog(@"obj.testNum:%@",obj.testNum);
        }
    }else if (actionSheet.tag == 300){
        if (obj) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            NSLog(@"obj.titleStr:%@",obj.titleStr);
            NSLog(@"obj.testData:%@",obj.testData);
            NSLog(@"obj.testNum:%@",obj.testNum);
        }
    }
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
