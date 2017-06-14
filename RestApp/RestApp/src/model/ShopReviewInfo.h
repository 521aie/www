//
//  ShopReviewInfo.h
//  RestApp
//
//  Created by Octree on 18/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "ShopImg.h"
typedef NS_ENUM(NSInteger, ShopReviewState) {
    
    ShopReviewStateNone,       // 从未提交过审核
    ShopReviewStateWaiting,    // 等待审核
    ShopReviewStateAccept,     // 审核通过
    ShopReviewStateReject,     // 审核失败
};

@interface ShopReviewInfo : NSObject

@property (nonatomic, strong) ShopImg *shopLogoImg;//Logo照片

@property (nonatomic ,copy) NSString *linkEmail;//联系人邮箱

@property (nonatomic ,copy) NSString *linkName;//联系人名

@property (nonatomic ,copy) NSString *linkTel;//联系人电话


@property (copy, nonatomic) NSString *_id;
//@property (copy, nonatomic) NSString *code;          // 编号
@property (copy, nonatomic) NSString *entityId;
@property (copy, nonatomic) NSString *name;         // 名称
@property (copy, nonatomic) NSString *phone;        // 电话
@property (copy, nonatomic) NSString *memo;         // 备注
//@property (copy, nonatomic) NSString *reason;
@property (copy, nonatomic) NSString *introduce;    // 介绍
@property (nonatomic) ShopReviewState status;       //
@property (copy, nonatomic) NSString *businessTime; // 营业时间
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (copy, nonatomic) NSString *countryId;
@property (copy, nonatomic) NSString *provinceId;
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSString *townId;

@property (copy, nonatomic) NSString *countryName;
@property (copy, nonatomic) NSString *provinceName;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *townName;

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *mapAddress;

@property (copy, nonatomic) NSString *avgPrice;
@property (nonatomic) NSUInteger createTime;

@property (nonatomic) double logoLongitude;
@property (nonatomic) double logoLatitude;
@property (copy, nonatomic) NSArray *imgLists;  // [ Dictionary ]
@property (copy, nonatomic) NSArray *tagLists;  // [ Dictionary ]

@property (nonatomic) NSUInteger opTime;

@property (copy, nonatomic) NSString *specialTag;

@property (copy, nonatomic, readonly) NSString *statusTitle;
@property (copy, nonatomic, readonly) NSString *statusDetail;


- (NSDictionary *)doorImageDictionary;

@end




