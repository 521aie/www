//
//  TDFBaseSettingService.m
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseSettingService.h"
#import "TDFBaseSettingRequestModel.h"

@implementation TDFBaseSettingService

+ (void)fetchBaseSettingListWithKindConfigCode:(NSString *)kindConfigCode completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBaseSettingRequestModel *requestModel = [[TDFBaseSettingRequestModel alloc] init];
    requestModel.actionPath = @"list";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kindConfigCode forKey:@"kind_config_code"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)saveBaseSettingListWithIdString:(NSString *)idString completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBaseSettingRequestModel *requestModel = [[TDFBaseSettingRequestModel alloc] init];
    requestModel.actionPath = @"save";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:idString forKey:@"ids_str"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
