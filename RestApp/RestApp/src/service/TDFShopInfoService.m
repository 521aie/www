//
//  TDFShopInfoService.m
//  RestApp
//
//  Created by happyo on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopInfoService.h"
#import "TDFShopInfoRequestModel.h"

@implementation TDFShopInfoService

+ (void)fetchShopInfoWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFShopInfoRequestModel *requestModel = [[TDFShopInfoRequestModel alloc] init];
    requestModel.actionPath = @"find_base_shop_info";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)saveShopInfoWithShopString:(NSString *)shopString completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFShopInfoRequestModel *requestModel = [[TDFShopInfoRequestModel alloc] init];
    requestModel.actionPath = @"save_base_shop_info";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:shopString forKey:@"shop_str"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
