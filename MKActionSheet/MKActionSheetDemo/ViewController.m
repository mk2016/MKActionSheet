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
#import "NSObject+MKASAdditions.h"

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
    [self.datasArray addObject:@"default UI delegate"];
    [self.datasArray addObject:@"default UI block and no cancel"];
    [self.datasArray addObject:@"init with titles、block and no title"];
    [self.datasArray addObject:@"init with titles、delegate"];
    [self.datasArray addObject:@"more then max show Count"];
    [self.datasArray addObject:@"init with modelArray、block"];
    [self.datasArray addObject:@"init with dictionary Array、delegate"];
    [self.datasArray addObject:@"multiselect"];
    
    [self.datasArray addObject:@"imageValueType:imageName、block"];
    [self.datasArray addObject:@"imageValueType:image delegate"];
    [self.datasArray addObject:@"imageValueType:imageUrl、delegate"];
    [self.datasArray addObject:@"imageValueType:imageUrl、block"];
    
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
        
//        
//        OtherModel *otherModel = [[OtherModel alloc] init];
//        otherModel.titleStr = [NSString stringWithFormat:@"other button %ld", (long)i];
//        otherModel.otherData = [NSString stringWithFormat:@"other Data %ld", (long)i];
//        otherModel.otherNum = @(i+100);
//        model.otherInfo = otherModel;
        
        [self.modelArray addObject:model];
    }
    
    //init dictionary data array
    self.dicArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
//        NSDictionary *otherDic = @{@"titleStr":[NSString stringWithFormat:@"other button %ld", (long)i],
//                                   @"otherData":[NSString stringWithFormat:@"other Data %ld", (long)i],
//                                   @"otherNum":@(i+100)
//                                   };
        NSDictionary *dic = @{@"titleStr"   :[NSString stringWithFormat:@"button %ld", (long)i],
                              @"testData"   :[NSString stringWithFormat:@"test data %ld", (long)i],
                              @"testNum"    :@(i),
//                              @"otherDic"   :otherDic,
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
    
    if ([cellTitle isEqualToString:@"default UI delegate"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"this is a longgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg title" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"] selectType:MKActionSheetSelectType_selected];
        sheet.tag = 100;
        sheet.selectedIndex = 2;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"default UI block and no cancel"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"无取消按钮样式" buttonTitleArray:@[@"button0", @"button1",@"button2",@"button3",@"button4"]];
        sheet.needCancelButton = NO;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
    }

    else if ([cellTitle isEqualToString:@"init with titles、block and no title"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitles:@"button0", @"button1",@"button2",@"button3",nil];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
    }
    
    else if ([cellTitle isEqualToString:@"init with titles、delegate"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"init titles by delegate" buttonTitles:@"button0", @"button1",@"button2",@"button3",nil];
        sheet.tag = 101;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"more then max show Count"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"设置 maxShowButtonCount 控制显示 按钮的最大数量，超过将以 tableView 的样式展示" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4",@"button5",@"button6",@"button7",@"button8",@"button9",@"button10"]];
        sheet.maxShowButtonCount = 5.6;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
        }];
    }
    
    else if ([cellTitle isEqualToString:@"init with modelArray、block"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.modelArray titleKey:@"titleStr"];
        sheet.destructiveButtonIndex = 0;
        sheet.destructiveButtonTitleColor = [UIColor greenColor];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"====buttonIndex:%ld",(long)buttonIndex);
            [self printLogWithModel:obj];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"init with dictionary Array、delegate"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.dicArray titleKey:@"titleStr"];
        sheet.destructiveButtonIndex = 3;
        sheet.destructiveButtonTitleColor = [UIColor blueColor];
        sheet.tag = 120;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"imageValueType:imageName、block"]) {
        MKActionSheet *sheet =[[MKActionSheet alloc] initWithTitle:@"imageValueType:imageName" objArray:self.modelArray titleKey:@"titleStr"];
        [sheet setImageKey:@"imageName" imageValueType:MKActionSheetButtonImageValueType_name];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"----------------------");
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            [self printLogWithModel:obj];
        }];
    }
    
    else if ([cellTitle isEqualToString:@"imageValueType:image delegate"]) {
        MKActionSheet *sheet =[[MKActionSheet alloc] initWithTitle:@"init with dictionary array,imageValueType:image、delegate" objArray:self.dicArray titleKey:@"titleStr"];
        [sheet setImageKey:@"imageName" imageValueType:MKActionSheetButtonImageValueType_name];
        sheet.tag = 130;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"imageValueType:imageUrl、delegate"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"imageValueType:imageUrl、delegate" objArray:self.modelArray titleKey:@"titleStr"];
        [sheet setImageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url];
        sheet.maxShowButtonCount = 3.6;
        sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
            [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
        };
        InfoModel *model = [[InfoModel alloc] init];
        model.titleStr = @"add button";
        model.testData = @"add testData";
        model.testNum = @(999);
        model.imageName = @"image_5";
        model.image = [UIImage imageNamed:model.imageName];
        model.imageUrl = @"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_5@2x.png";
        [sheet addButtonWithObj:model];
        sheet.tag = 300;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"multiselect"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"多选样式 delegate" objArray:self.modelArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        [sheet setImageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url];
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"imageValueType:imageUrl、block"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"多选样式 delegate" objArray:self.dicArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        sheet.tag = 301;
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"actionSheet:%@",actionSheet);
            NSLog(@"array:%@",array);
        }];
    }
    
    
    else if ([cellTitle isEqualToString:@"custom UI"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"custom UI" buttonTitleArray:@[@"button1", @"button2",@"button3",@"button4", @"button5",@"button6",@"button7"]];
        sheet.titleColor = [UIColor greenColor];
        sheet.titleFont = [UIFont boldSystemFontOfSize:24];
        sheet.titleAlignment = NSTextAlignmentLeft;
        sheet.buttonTitleColor = [UIColor redColor];
        sheet.buttonTitleFont = [UIFont boldSystemFontOfSize:14];
        sheet.buttonOpacity = 1;
        sheet.buttonHeight = 40.0f;
        sheet.buttonTitleAlignment = MKActionSheetButtonTitleAlignment_left;
        sheet.destructiveButtonTitleColor = [UIColor grayColor];
        sheet.destructiveButtonIndex = 2;
        sheet.cancelTitle = @"关闭";
        sheet.animationDuration = 0.2f;
        sheet.blurOpacity = 0.7f;
        sheet.blackgroundOpacity = 0.6f;
        sheet.needCancelButton = YES;
        sheet.maxShowButtonCount = 5.6;
        [sheet addButtonWithTitle:@"button add"];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex, id obj) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
        }];
    }

    else if ([cellTitle isEqualToString:@"change tableViewBackground View"]) {
        if (self.tableView.backgroundView) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bg"]];
        }
    }
}

#pragma mark - ***** MKActionSheet delegate ******
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl{
    [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
}

- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100 || actionSheet.tag == 101) {
        NSLog(@"========== delegate ====");
        NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
        NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    }
}

- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex selectObj:(id)obj{
    NSLog(@"--------paramModel delegate -------------");
    NSLog(@"---actionSheet.tag:%ld",actionSheet.tag);
    NSLog(@"---buttonIndex:%ld",(long)buttonIndex);
    if (actionSheet.tag == 120 || actionSheet.tag == 130) {
        if (obj) {
            [self printLogWithModel:obj];
        }else{
            NSLog(@"is cancel button, obj = nil");
        }
        //or
        NSLog(@"-----------or");
        if (buttonIndex == self.modelArray.count) {
            NSLog(@"is cancel button, obj = nil");
        }else{
            [self printLogWithModel:obj];
        }
    }
}

- (void)actionSheet:(MKActionSheet *)actionSheet selectArray:(NSArray *)array{
//    if (actionSheet.tag == 300 || actionSheet.tag == 301) {
        NSLog(@"actionSheet:%@",actionSheet);
        NSLog(@"array:%@",array);
//    }
}

- (void)printLogWithModel:(id)obj{
    if (obj) {
        if ([obj isKindOfClass:[InfoModel class]]) {
            InfoModel *moel = (InfoModel*)obj;
            NSLog(@"obj.titleStr : %@",moel.titleStr);
            NSLog(@"obj.testData : %@",moel.testData);
            NSLog(@"obj.testNum  : %@",moel.testNum);
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSLog(@"obj is dic : %@", obj);
        }
  
    }
}

- (UIImage *)getDefaultIcon{
    return [UIImage imageNamed:@"image_5"];
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
