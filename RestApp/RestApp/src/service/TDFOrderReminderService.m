//
//  TDFOrderReminderService.m
//  RestApp
//
//  Created by happyo on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderReminderService.h"
#import "TDFOrderReminderRequestModel.h"

@implementation TDFOrderReminderService

+ (void)fetchOrderReminderDetailWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFOrderReminderRequestModel *requestModel = [[TDFOrderReminderRequestModel alloc] init];
    requestModel.actionPath = @"get_view";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)modifyReminderSwithWithIsOn:(BOOL)isOn completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFOrderReminderRequestModel *requestModel = [[TDFOrderReminderRequestModel alloc] init];
    requestModel.actionPath = @"modify_switch";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSNumber numberWithBool:isOn] stringValue] forKey:@"status"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)deleteReminderFoodWithFoodId:(NSString *)foodId completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFOrderReminderRequestModel *requestModel = [[TDFOrderReminderRequestModel alloc] init];
    requestModel.actionPath = @"delete_menu";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:foodId forKey:@"menu_id"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchFoodSelectedListWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFOrderReminderRequestModel *requestModel = [[TDFOrderReminderRequestModel alloc] init];
    requestModel.actionPath = @"get_all_menus";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)saveReminderFoodListWithIds:(NSString *)idsString completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFOrderReminderRequestModel *requestModel = [[TDFOrderReminderRequestModel alloc] init];
    requestModel.actionPath = @"save_menus";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:idsString forKey:@"ids_str"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
