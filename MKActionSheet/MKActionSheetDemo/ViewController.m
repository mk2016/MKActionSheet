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
#import "NSObject+MKASAdditions.h"
#import "UIView+Toast.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MKActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *dicArray;

@property (nonatomic, weak) MKActionSheet *customTitleSheet;
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
    
    [self initTableViewDatas];
}

- (void)initTestData{
    
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

- (void)initTableViewDatas{

    //tableView dataSource
    self.datasArray = [[NSMutableArray alloc] init];
    self.detailArray = [[NSMutableArray alloc] init];

    [self.datasArray addObject:@"change tableViewBackground View"];
    [self.detailArray addObject:@"改变TableView 背景"];

    [self.datasArray addObject:@"selectType:-common"];
    [self.detailArray addObject:@"普通样式，block用例"];

    [self.datasArray addObject:@"selectType:-selected"];
    [self.detailArray addObject:@"带默认选择样中，block用例，默认居左、无取消按钮，可设置"];

    [self.datasArray addObject:@"selectType:-multiselect"];
    [self.detailArray addObject:@"多选样式，block用例，默认居左、无取消按钮，可设置"];

    [self.datasArray addObject:@"imageValueType:imageName、block"];
    [self.detailArray addObject:@"带icon 样式，图片字段类型为 imageName，block用例,无分割线"];

    [self.datasArray addObject:@"imageValueType:image delegate"];
    [self.detailArray addObject:@"带icon 样式，图片字段类型为 image，delegate用例"];
    
    [self.datasArray addObject:@"imageValueType:imageUrl delegate"];
    [self.detailArray addObject:@"带icon 样式，图片字段类型为 imageUrl，delegate用例"];
    
    [self.datasArray addObject:@"imageValueType:imageUrl、block 无 title"];
    [self.detailArray addObject:@"带icon 样式，图片字段类型为 imageUrl，block用例"];
    
    [self.datasArray addObject:@"set maxShowButtonCount"];
    [self.detailArray addObject:@"设置显示最大按钮数，超过最大数量，已tableView样式展示"];
    
    [self.datasArray addObject:@"model array、block"];
    [self.detailArray addObject:@"model 数组初始化，block用例，默认没有 取消 按钮"];
    
    [self.datasArray addObject:@"dictionary array、delegate"];
    [self.detailArray addObject:@"字段 数组初始化，delegate用例，默认没有 取消 按钮"];
    
    [self.datasArray addObject:@"custom title View"];
    [self.detailArray addObject:@"自定义 title view"];
    
    [self.datasArray addObject:@"custom UI"];
    [self.detailArray addObject:@"自定义UI"];
    
}

#pragma mark - ***** UITableView delegate ******

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cellTitle = [self.datasArray objectAtIndex:indexPath.row];

    typeof(self) __weak weakSelf = self;
    //普通样式 delegate
    if ([cellTitle isEqualToString:@"selectType:-common"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"初始化title为nil，将显示不带title样式。this is a longgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg title" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"]];
        sheet.destructiveButtonIndex = 3;
        sheet.willPresentBlock = ^(MKActionSheet *sheet){
            NSLog(@"willPresentBlock");
        };
        sheet.didPresentBlock = ^(MKActionSheet *sheet){
            NSLog(@"didPresentBlock");
        };
        sheet.willDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
            NSLog(@"willDismissBlock");
        };
        sheet.didDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
            NSLog(@"didDismissBlock");
        };
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
        }];
    }
    
    //带默认选中 按钮  样式
    else if ([cellTitle isEqualToString:@"selectType:-selected"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"带默认选中样式，设置 selectedIndex 默认选中第几个按钮,默认居左、无取消按钮，可设置" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4"] selectType:MKActionSheetSelectType_selected];
        sheet.selectedIndex = 2;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
        }];
    }
    
    //多选样式 无图片
    else if ([cellTitle isEqualToString:@"selectType:-multiselect"]) {
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"多选样式 delegate， 默认居左、无取消按钮，可设置" objArray:self.modelArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        sheet.willPresentBlock = ^(MKActionSheet *sheet){
            NSLog(@"willPresentBlock");
        };
        sheet.didPresentBlock = ^(MKActionSheet *sheet){
            NSLog(@"didPresentBlock");
        };
        sheet.willDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
            NSLog(@"willDismissBlock");
        };
        sheet.didDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
            NSLog(@"didDismissBlock");
        };
        sheet.willDismissMultiselectBlock = ^(MKActionSheet* actionSheet, NSArray *array){
            NSLog(@"willDismissMultiselectBlock");
        };
        sheet.didDismissMultiselectBlock = ^(MKActionSheet* actionSheet, NSArray *array){
            NSLog(@"didDismissMultiselectBlock");
        };
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }
    
    //带 icon 图片 imageValueType:imageName   block
    else if ([cellTitle isEqualToString:@"imageValueType:imageName、block"]) {
        MKActionSheet *sheet =[[MKActionSheet alloc] initWithTitle:@"imageValueType:imageName 无分割线" objArray:self.modelArray titleKey:@"titleStr"];
        [sheet setImageKey:@"imageName" imageValueType:MKActionSheetButtonImageValueType_name];
        sheet.showSeparator = NO;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"buttonIndex:%ld",(long)buttonIndex);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
        }];
    }
    
    //带 icon 图片 imageValueType:image  delegate,  selectType:-selected, 字段数组初始化
    else if ([cellTitle isEqualToString:@"imageValueType:image delegate"]) {
        MKActionSheet *sheet =[[MKActionSheet alloc] initWithTitle:@"init with dictionary array,imageValueType:image、delegate. selectType:-selected" objArray:self.dicArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_selected];
        [sheet setImageKey:@"image" imageValueType:MKActionSheetButtonImageValueType_image];
        sheet.selectedIndex = 0;
        sheet.separatorLeftMargin = sheet.titleMargin;
        sheet.needCancelButton = YES;
        [sheet showWithDelegate:self];
    }
    
    //带 icon 图片 imageValueType:imageUrl、delegate
    else if ([cellTitle isEqualToString:@"imageValueType:imageUrl delegate"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"imageValueType:imageUrl、delegate 分割线设置边距" objArray:self.modelArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        [sheet setImageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url];
        sheet.needCancelButton = YES;
        sheet.maxShowButtonCount = 0;
        sheet.separatorLeftMargin = 60;
        sheet.multiselectConfirmButtonTitleColor = [UIColor redColor];
        sheet.titleColor = [UIColor blueColor];
        
        //添加 对象
        InfoModel *model = [[InfoModel alloc] init];
        model.titleStr = @"add button";
        model.testData = @"add testData";
        model.testNum = @(999);
        model.imageName = @"image_5";
        model.image = [UIImage imageNamed:model.imageName];
        model.imageUrl = @"https://github.com/mk2016/MKActionSheet/raw/MKActionSheet_dev/Resource/image_5@2x.png";
        [sheet addButtonWithObj:model];
        
        [sheet showWithDelegate:self];
    }
    
    //带 icon 图片 多选样式  imageValueType:imageUrl、block
    else if ([cellTitle isEqualToString:@"imageValueType:imageUrl、block 无 title"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil objArray:self.dicArray titleKey:@"titleStr" selectType:MKActionSheetSelectType_multiselect];
        [sheet setImageKey:@"imageUrl" imageValueType:MKActionSheetButtonImageValueType_url];
        sheet.buttonImageBlock = ^(MKActionSheet* actionSheet, UIButton *button, NSString *imageUrl){
//            [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[weakSelf getDefaultIcon]];
            [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[weakSelf getDefaultIcon]];
        };
        [sheet showWithMultiselectBlock:^(MKActionSheet *actionSheet, NSArray *array) {
            NSLog(@"actionSheet:%@",actionSheet);
            NSLog(@"array:%@",array);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)array.count]];
        }];
    }

    
    //设置最大显示按钮数
    else if ([cellTitle isEqualToString:@"set maxShowButtonCount"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"设置 maxShowButtonCount 控制显示 按钮的最大数量，超过将以 tableView 的样式展示" buttonTitleArray:@[@"button0", @"button1", @"button2",@"button3",@"button4",@"button5",@"button6",@"button7",@"button8",@"button9",@"button10"]];
        sheet.maxShowButtonCount = 6.6;
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"===buttonIndex:%ld",(long)buttonIndex);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"buttonIndex : %ld " ,(long)buttonIndex]];
        }];
    }
    

    // 模型 数组初始化  block
    else if ([cellTitle isEqualToString:@"model array、block"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array,默认没有取消按钮" objArray:self.modelArray titleKey:@"titleStr"];
        sheet.destructiveButtonIndex = 0;
        sheet.destructiveButtonTitleColor = [UIColor greenColor];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
            NSLog(@"====buttonIndex:%ld",(long)buttonIndex);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"button Index : %ld " ,(long)buttonIndex]];
        }];
    }
    
    // 字典 数组初始化  block
    else if ([cellTitle isEqualToString:@"dictionary array、delegate"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:@"create with models array" objArray:self.dicArray titleKey:@"titleStr"];
        sheet.destructiveButtonIndex = 3;
        sheet.destructiveButtonTitleColor = [UIColor blueColor];
        sheet.needCancelButton = YES;
        [sheet showWithDelegate:self];
    }
    
    else if ([cellTitle isEqualToString:@"custom title View"]){
        MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:nil buttonTitleArray:@[@"button1", @"button2",@"button3",@"button4", @"button5",@"button6",@"button7"]];
        self.customTitleSheet = sheet;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        titleView.backgroundColor = [UIColor redColor];
        
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.text = @"自定义titleView";
        labTitle.textColor = [UIColor greenColor];
        labTitle.font = [UIFont boldSystemFontOfSize:17];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:labTitle];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(titleView);
            make.centerY.equalTo(titleView);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"title button" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor greenColor];
        [btn addTarget:self action:@selector(btnTitleOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(titleView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
        
        [sheet setCustomTitleView:titleView];
        [sheet showWithDelegate:self];
    }
    
    //自定义UI
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
        sheet.separatorLeftMargin = 20;
        [sheet addButtonWithTitle:@"button add"];
        [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
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

#pragma mark - ***** MKActionSheet delegate ******
- (void)actionSheet:(MKActionSheet *)actionSheet button:(UIButton *)button imageUrl:(NSString *)imageUrl{
    [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[self getDefaultIcon]];
}

//单选
- (void)actionSheet:(MKActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"didClickButtonAtIndex");

//    if (actionSheet.selectType != MKActionSheetSelectType_multiselect) {
        NSLog(@"========== delegate ====");
        NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
        NSLog(@"buttonIndex:%ld",(long)buttonIndex);
        [self.view makeToast:[NSString stringWithFormat:@"button Index : %ld" ,(long)buttonIndex]];
//    }
}

//多选
- (void)actionSheet:(MKActionSheet *)actionSheet selectArray:(NSArray *)selectArray{
    NSLog(@"selectArray");
    if (actionSheet.selectType == MKActionSheetSelectType_multiselect) {
        NSLog(@"actionSheet:%@",actionSheet);
        NSLog(@"array:%@",selectArray);
        [self.view makeToast:[NSString stringWithFormat:@"array count : %ld ",(unsigned long)selectArray.count]];
    }
}

- (UIImage *)getDefaultIcon{
    return [UIImage imageNamed:@"image_5"];
}

- (void)willPresentActionSheet:(MKActionSheet *)actionSheet{
    NSLog(@"willPresentActionSheet");
}

- (void)didPresentActionSheet:(MKActionSheet *)actionSheet{
    NSLog(@"didPresentActionSheet");
}

- (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"willDismissWithButtonIndex");
}

- (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"didDismissWithButtonIndex");
}

- (void)actionSheet:(MKActionSheet *)actionSheet willDismissWithSelectArray:(NSArray *)selectArray{
    NSLog(@"willDismissWithSelectArray");
}

- (void)actionSheet:(MKActionSheet *)actionSheet didDismissWithSelectArray:(NSArray *)selectArray{
    NSLog(@"didDismissWithSelectArray");
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = self.datasArray[indexPath.row];
    cell.detailTextLabel.text = self.detailArray[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray.count ? self.datasArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
