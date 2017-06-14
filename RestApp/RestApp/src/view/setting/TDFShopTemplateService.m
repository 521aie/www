//
//  TDFShopTemplateService.m
//  RestApp
//
//  Created by BK_G on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopTemplateService.h"
#import "TDFHTTPClient.h"
#import "TDFRequestModel.h"

//#define TDFBOSSSSSSS @"http://mock.2dfire-daily.com/mockjsdata/77"


@implementation TDFShopTemplateService

//获取标签打印列表
+ (void)query_template_function_listCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.serviceName =@"shop_template";
    requestModel.apiVersion =@"v1";
    requestModel.actionPath = @"query_template_function_list";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"page_index"] = @"1";
    param[@"page_size"] = @"20";
    
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

//查询智能点菜收银单模版
+ (void)query_template_function_detailWithCode:(NSString *)code andFieldCode:(NSString *)fieldCode andFieldValue:(NSString *)fieldValue CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.serviceName =@"shop_template";
    requestModel.apiVersion =@"v1";
    requestModel.actionPath = @"query_template_function_detail";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    param[@"function_code"] = code;
    
    if (fieldCode) {
        
        param[@"func_field_code"] = fieldCode;
    }
    if (fieldValue) {
        
        param[@"func_field_value"] = fieldValue;
    }
    
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

//保存智能点菜收银单模版
+ (void)save_template_functionWithModel:(NSString *)model CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.serviceName =@"shop_template";
    requestModel.apiVersion =@"v1";
    requestModel.actionPath = @"save_template_function";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"field_value_str"] = model;
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
