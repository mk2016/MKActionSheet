//
//  InfoModel.h
//  MKActionSheet
//
//  Created by xiaomk on 16/8/4.
//  Copyright © 2016年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OtherModel;
@interface InfoModel : NSObject
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *testData;
@property (nonatomic, copy) NSNumber *testNum;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) OtherModel *otherInfo;
@end


@interface OtherModel : NSObject
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *otherData;
@property (nonatomic, copy) NSNumber *otherNum;
@end