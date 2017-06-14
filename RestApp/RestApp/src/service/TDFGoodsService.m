//
//  TDFGoodsService.m
//  RestApp
//
//  Created by happyo on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFGoodsService.h"
#import "TDFGoodsRequestModel.h"
//#import "TDFDataCenter.h"

@implementation TDFGoodsService

+ (void)fetchFoodUnitWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFGoodsRequestModel *requestModel = [[TDFGoodsRequestModel alloc] init];
    requestModel.actionPath = @"query_unit";
    
//    requestModel.parameters = @{@"entity_id" : [TDFDataCenter sharedInstance].entityId};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];

}

+ (void)addFoodUnitWithName:(NSString *)foodUnitStr completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFGoodsRequestModel *requestModel = [[TDFGoodsRequestModel alloc] init];
    requestModel.actionPath = @"save_unit";
    
    requestModel.parameters = @{@"unit_desc" : foodUnitStr};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)deleteFoodUnitWithName:(NSString * _Nonnull)foodUnitStr completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFGoodsRequestModel *requestModel = [[TDFGoodsRequestModel alloc] init];
    requestModel.actionPath = @"remove_unit";
    
    requestModel.parameters = @{@"unit_desc" : foodUnitStr};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
