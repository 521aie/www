//
//  TDFShopCompareService.m
//  RestApp
//
//  Created by Cloud on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopCompareService.h"
#import "TDFResponseModel.h"
#import "TDFRequestModel.h"
#import "TDFHTTPClient.h"

@implementation TDFShopCompareService

//获取营业额对比值
+(void)checkShopBussinessCompareWithParam:(nullable NSMutableDictionary *)dic CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable res))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    
    //homepage/v1/shopturnover
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"turnover_compare";
    requestModel.serviceName =@"shop/statistics";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;//@"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/135/";
    requestModel.parameters = dic;
//    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@""};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
