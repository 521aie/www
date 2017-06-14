//
//  ShopEvaluateViewData.m
//  RestApp
//
//  Created by iOS香肠 on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "ShopEvaluateViewData.h"
#import "ShopEvaluateItemData.h"

@implementation ShopEvaluateViewData

+ (ShopEvaluateViewData *)convertToShopEvaluateViewData:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        ShopEvaluateViewData *shopEvaluateViewData = [[ShopEvaluateViewData alloc]init];
        shopEvaluateViewData.shopName = [ObjectUtil getStringValue:dictionary key:@"shopName"];
        shopEvaluateViewData.taste = [ObjectUtil getDoubleValue:dictionary key:@"taste"];
        shopEvaluateViewData.speed = [ObjectUtil getDoubleValue:dictionary key:@"speed" ];
        shopEvaluateViewData.experienceCount =[ObjectUtil getDoubleValue:dictionary key:@"experienceCount"];
        shopEvaluateViewData.goodPercent = [ObjectUtil getStringValue:dictionary key:@"goodPercent"];
        shopEvaluateViewData.environment = [ObjectUtil getDoubleValue:dictionary key:@"environment"];
        shopEvaluateViewData.shopReportVoList = [[NSMutableArray alloc]init];
        NSArray *shopReportArray = [ObjectUtil getArryValue:dictionary key:@"shopReportVoList"];
        for (NSDictionary *dict in shopReportArray) {
           ShopEvaluateItemData *data = [[ShopEvaluateItemData alloc]init];
           data.title = [ObjectUtil getStringValue:dict key:@"title"];
           data.badCount = [ObjectUtil getIntegerValue:dict key:@"badCount"];
           data.goodCount = [ObjectUtil getIntegerValue:dict key:@"goodCount"];
           data.taste = [ObjectUtil getDoubleValue:dict key:@"taste"];
           data.speed = [ObjectUtil getDoubleValue:dict key:@"speed"];
           data.environment = [ObjectUtil getDoubleValue:dict key:@"environment"];
           data.goodStatus =[ObjectUtil getIntegerValue:dict key:@"goodStatus"];
           data.badStatus = [ObjectUtil getIntegerValue:dict key:@"badStatus"];
           data.tasteStatus = [ObjectUtil getIntegerValue:dict key:@"tasteStatus"];
           data.speedStatus = [ObjectUtil getIntegerValue:dict key:@"speedStatus"];
            data.environmentStatus = [ObjectUtil getIntegerValue:dict key:@"environmentStatus"];
           [shopEvaluateViewData.shopReportVoList addObject:data];
        }
        
        return shopEvaluateViewData;
    }
    return  nil;
}

+ (NSMutableArray *)convertToShopEvaluateViewDataList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[ShopEvaluateViewData convertToShopEvaluateViewData:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
