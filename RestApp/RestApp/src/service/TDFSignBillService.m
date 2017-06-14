//
//  TDFSignBillService.m
//  RestApp
//
//  Created by iOS香肠 on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSignBillService.h"
#import "TDFRequestModel.h"
#import "Platform.h"
#import "ObjectUtil.h"
#import "DateUtils.h"
#import "JsonHelper.h"
#import "JSONKit.h"
#import "NSString+Estimate.h"
#import "RestConstants.h"
#import "TDFHTTPClient.h"
#import "TDFResponseModel.h"
@implementation TDFSignBillService

- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [[Platform Instance] getkey:SESSION_KEY];
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

- (NSURLSessionDataTask *)getRequestSessionDataTaskWithRequestModel:(TDFRequestModel *)requestModel sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock
{
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *)listSignBillPeopleNoPayList:(SignBillPayNoPayOptionTotalVO *_Nonnull)signBillVo page:(NSInteger)page startDate:(NSDate *_Nonnull)startDate endDate:(NSDate *_Nonnull)endDate sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
     NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    if ([ObjectUtil isNotNull:signBillVo.kindPayDetailOptionId]) {
        [param setObject:signBillVo.kindPayDetailOptionId forKey:@"person_id"];
    }
    if ([NSString isNotBlank:signBillVo.kindPayId]) {
        [param setObject:signBillVo.kindPayId forKey:@"kind_pay_id"];
    }
    if ([NSString isNotBlank:signBillVo.payIdsStr]) {
        NSArray *payIdStr  =  [signBillVo.payIdsStr componentsSeparatedByString:@","];
        NSString *jsonIdStr  =  [JsonHelper arrTransJson:payIdStr];
        [param setObject:jsonIdStr forKey:@"pay_ids"];
    }
    if ([ObjectUtil isNotNull:startDate]) {
        [param setObject:[DateUtils formatTimeWithDate:startDate type:TDFFormatTimeTypeYearMonthDay] forKey:@"start_date"];
    }
    if ([ObjectUtil isNotNull:endDate]) {
        [param setObject:[DateUtils formatTimeWithDate:endDate type:TDFFormatTimeTypeYearMonthDay] forKey:@"end_date"];
    }
    
    NSString *entityId = [[Platform Instance]getkey:ENTITY_ID];
    NSString *pageStr = [NSString stringWithFormat:@"%li", (long)page];
    param[@"entityId"] = entityId;
    param[@"page"] = pageStr;
   // param[@"pageSize"] = @"20";
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/no_pay_list_single" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;

}

- (nullable NSURLSessionDataTask *)listSignBillListSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/no_pay_list" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)listSignBillOptNoPayList:(NSMutableArray *_Nonnull)payIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *entityId = [[Platform Instance]getkey:ENTITY_ID];
    [param setObject:entityId forKey:@"entityId"];
   // [param setObject:[ObjectUtil array2String:payIds] forKey:@"pay_ids_str"];
     [param setObject:[JsonHelper arrTransJson:payIds] forKey:@"pay_ids_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/query_opt_no_pays" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)saveSignBillPayList:(NSMutableArray *_Nonnull)payIdSet signBill:(SignBillVO *_Nonnull)signBill sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[signBill dictionaryData] JSONString] forKey:@"sign_bill_json"];
    [param setObject:[JsonHelper arrTransJson:payIdSet] forKey:@"pay_ids_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/save_bill" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)listSignBillPayList:(NSInteger)page sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *pageStr = [NSString stringWithFormat:@"%li", (long)page];
    [param setObject:pageStr forKey:@"page"];
    //[param setObject:@"20" forKey:@"pageSize"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/processed_bill_list" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)findSignBillDetail:(NSString *_Nonnull)signBillId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"1" forKey:@"notPc"];
    [param setObject:signBillId forKey:@"sign_bill_id"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/processed_bill_detail" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)removeSignBillDetail:(NSString *_Nonnull)signBillId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSArray *idList = [[NSArray alloc] initWithObjects:signBillId , nil];
    NSString *idStr  =  [JsonHelper arrTransJson:idList];
    [param setObject:idStr forKey:@"sign_bill_ids"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sign_bill/v1/remove" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

@end
