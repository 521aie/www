//
//  ShopEvaluateViewData.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

@interface ShopEvaluateViewData : NSObject

@property (nonatomic ,strong) NSString *shopName;
@property (nonatomic ,assign) NSInteger experience;
@property (nonatomic ,strong) NSString *experienceType;
@property (nonatomic ,assign) NSInteger experienceCount;
@property (nonatomic ,assign) double taste;
@property (nonatomic ,assign) double speed;
@property (nonatomic ,assign) double environment;
@property (nonatomic ,strong) NSString *goodPercent;
@property (nonatomic ,strong) NSMutableArray *shopReportVoList;

+(ShopEvaluateViewData *)convertToShopEvaluateViewData:(NSDictionary *)dictionary;

+(NSMutableArray *)convertToShopEvaluateViewDataList:(NSArray *)list;

@end
