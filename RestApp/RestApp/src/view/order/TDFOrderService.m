//
//  TDFOrderService.m
//  RestApp
//
//  Created by iOS香肠 on 16/9/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderService.h"
#import "TDFRequestModel.h"
#import "RestConstants.h"
#import "TDFHTTPClient.h"
#import "RestAppConstants.h"
#import "Platform.h"

@implementation TDFOrderService

+(void)orderGetplanPlantId:(NSString *)idStr CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"get_plan_config";
    requestModel.serviceName =@"intelligence";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{@"plan_id" : idStr, @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}
    
+ (void)orderPlantSave:(NSString *_Nullable)plantStr CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"save_plan_config";
    requestModel.serviceName =@"intelligence";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{@"plan_config_json" : plantStr, @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)getPlantId:(NSString *_Nullable)plantId mealtcount:(NSString*)mealstcount   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"reset_plan_config";
    requestModel.serviceName =@"intelligence";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{@"plan_id" : plantId, @"meals_count" :mealstcount ,@"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)getOrderMenuId:(NSString *_Nullable)menuId   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"get_labels";
    requestModel.serviceName =@"intelligence";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{@"menu_id" : menuId,@"session_key" : [[Platform Instance] getkey:SESSION_KEY],@"app_key" : APP_API_KEY };
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


+ (void)getOrderWithoutMenuId:(NSString *_Nullable)menuId   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"get_empty_labels";
    requestModel.serviceName =@"intelligence";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{@"app_key" : APP_API_KEY,@"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}
@end
