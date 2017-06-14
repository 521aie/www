//
//  TDFBusinessService.m
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessService.h"
#import "TDFBusinessRequestModel.h"
#import "TDFBusinessSpellRequestModel.h"

@implementation TDFBusinessService

+ (void)fetchHomeBusinessSummaryWithMonthDate:(NSString *)monthDate completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_month_days";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:monthDate forKey:@"month"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchV2HomeBusinessSummaryWithMonthDate:(NSString *)monthDate completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_month_days";
    requestModel.apiVersion = @"v2";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:monthDate forKey:@"month"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchDayBusinessDetailWithMonthDate:(NSString *)monthDate completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_days_detail";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:monthDate forKey:@"date"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchV2DayBusinessDetailWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_days_detail";
    requestModel.apiVersion = @"v2";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchMonthBusinessDetailWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_month_detail";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchRecentMonthsBusinessDetailWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_months_detail";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


+ (void)fetchBusinessSpellWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFBusinessSpellRequestModel *requestModel = [[TDFBusinessSpellRequestModel alloc] init];
    requestModel.actionPath = @"list_time_arrange";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)saveBusinessSpellWithSpellString:(NSString *)spellString completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessSpellRequestModel *requestModel = [[TDFBusinessSpellRequestModel alloc] init];
    requestModel.actionPath = @"save_time_arrange";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:spellString forKey:@"time_arrange_str"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)removeBusinessSpellWithSpellId:(NSString *)spellId completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessSpellRequestModel *requestModel = [[TDFBusinessSpellRequestModel alloc] init];
    requestModel.actionPath = @"remove_time_arrange";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:spellId forKey:@"id"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)removeBusinessSpellWithSpellIds:(NSString *)spellIdsJson completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessSpellRequestModel *requestModel = [[TDFBusinessSpellRequestModel alloc] init];
    requestModel.actionPath = @"remove_time_arranges";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:spellIdsJson forKey:@"ids_str"];
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fecthPayInfoWithDate:(NSString *)date
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                       isAll:(BOOL)isAll
               completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_pay_statistics";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"day"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:[[NSNumber numberWithBool:isAll] stringValue] forKey:@"isAll"];

    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fecthV2PayInfoWithDate:(NSString *)date
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                       isAll:(BOOL)isAll
               completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_pay_statistics";
    requestModel.apiVersion = @"v2";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"day"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:[[NSNumber numberWithBool:isAll] stringValue] forKey:@"isAll"];
    
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fecthPayDetailWithDate:(NSString *)date
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                         isAll:(BOOL)isAll
                     kindPayId:(NSString *)kindPayId
                       pageNum:(NSInteger)pageNum
                 completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_pay_history";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"day"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:[[NSNumber numberWithBool:isAll] stringValue] forKey:@"isAll"];
    [params setObject:kindPayId forKey:@"kindPayIds"];
    [params setObject:[@(pageNum) stringValue] forKey:@"pageIndex"];
    [params setObject:[@(20) stringValue] forKey:@"pageSize"];
    
    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fecthV2PayDetailWithDate:(NSString *)date
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                         isAll:(BOOL)isAll
                     kindPayId:(NSString *)kindPayId
                          type:(NSString *)type
                       pageNum:(NSInteger)pageNum
                 completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"list_pay_history";
    requestModel.apiVersion = @"v2";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"day"] = date;
    params[@"startTime"] = startTime;
    params[@"endTime"] = endTime;
    params[@"isAll"] = [[NSNumber numberWithBool:isAll] stringValue];
    params[@"kindPayIds"] = kindPayId?kindPayId:@"";
    params[@"pageIndex"] = [@(pageNum) stringValue];
    params[@"pageSize"] = [@(20) stringValue];
    params[@"type"] = type;

    requestModel.parameters = params;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchPayTypeImageUrlWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFBusinessRequestModel *requestModel = [[TDFBusinessRequestModel alloc] init];
    requestModel.actionPath = @"get_kindpay_images";

    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

@end
