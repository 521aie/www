//
//  TDFTimePlanService.m
//  RestApp
//
//  Created by happyo on 2016/12/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTimePlanService.h"
#import "TDFTimePlanRequestModel.h"

@implementation TDFTimePlanService

+ (void)fetchOpenTimeWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFTimePlanRequestModel *requestModel = [[TDFTimePlanRequestModel alloc] init];
    requestModel.actionPath = @"find_open_time_plan";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
