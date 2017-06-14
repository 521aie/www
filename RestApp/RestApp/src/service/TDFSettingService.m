//
//  TDFSettingService.m
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSettingService.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "KindConfigConstants.h"
#import "JSONKit.h"

@implementation TDFSettingService

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

///获取必选商品列表
- (nullable NSURLSessionDataTask *)getMustSelectGoodsList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/query_force_menu_list" params:nil];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

///获取所有商品列表（必选商品设置用）
- (nullable NSURLSessionDataTask *)getAllSelectGoodsList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/query_force_menu_all_list" params:nil];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;

}

///保存必选商品设置
- (nullable NSURLSessionDataTask *)saveForceMenuWith:(nonnull NSDictionary *)param and:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/save_force_menu" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }

    }];
    return task;
}

///删除必选商品
- (nullable NSURLSessionDataTask *)deleteForceMenuWith:(nonnull NSDictionary *)param and:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/remove_force_menu" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;
}

- (nullable NSURLSessionDataTask *)getBoxSelectList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                         failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
   TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/get_packing_boxes" params:nil];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"]integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey: NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

///得到贷款公司列表
- (nullable NSURLSessionDataTask *)getLoanCompanyListWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"loan/v1/get_loan_company_list" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;
    
}

/**
 *   保存自动领券开关设置
 */

- (nullable NSURLSessionDataTask *)savePacketWithParam:(NSDictionary *)params
                                                           sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                          failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"promotion/v1/set_auto_send_and_coupon_batch" params:params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;

}



///保存贷款协议
- (nullable NSURLSessionDataTask *)saveLoanAgreementWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"loan/v1/save_loan_agreement" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;
    
}

//获取商户贷款状态
- (nullable NSURLSessionDataTask *)getShopLoanStatusWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"loan/v1/get_shop_Loan_status" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;
}

//向服务器发送点击分享链接的类型
- (nullable NSURLSessionDataTask *)sendHistoryWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock{
    TDFRequestModel *requestModel = [self getRequestModelPath:@"0.gif" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
        
    }];
    return task;
}
- (TDFRequestModel *)getRequestModelPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypeGET;
    requestModel.serverRoot = @"http://trace.2dfire-daily.com/";
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [[Platform Instance] getkey:SESSION_KEY];
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

- (TDFRequestModel *)getPostRequestModelPath:(NSString *)path params:(NSDictionary *)params{
    
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
/**
 *  店家LOGO 查询
 */
- (void)loadShopLogoImageWithCallBack:(void (^)(TDFResponseModel *))callBack{
 
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"shop";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"get_shop_logo";
    requestModel.parameters =  @{@"session_key":[[Platform Instance] getkey:SESSION_KEY]
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        
        if (response.error) {
            callBack(response);
            return ;
        }
        
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}

/**
 *  店家LOGO save
 */
- (void)saveShopLogoImageWithShopImage:(nonnull NSString *)shopImage callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"shop";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"save_shop_logo";
    requestModel.parameters =  @{@"shopImgStr":shopImage,
                                 @"session_key":[[Platform Instance] getkey:SESSION_KEY]
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        if (response.error) {
            callBack(response);
            return ;
        }
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}

- (nullable NSURLSessionDataTask *)obtainBaseShopDetailSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
     param[@"shopCode"] = [[Platform Instance] getkey:SHOP_CODE];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_info/v1/find_base_shop_info" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)saveBaseShopDetail:(ShopDetail *_Nonnull)shopdetail sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    [param setObject:[JsonHelper transJson:shopdetail] forKey:@"shop_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_info/v1/save_base_shop_info" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listDiscountPlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/list_discount_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) loadOpenTimePlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"open_time_plan/v1/find_open_time_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateOpenTimePlan:(OpenTimePlan *_Nonnull)plan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
     [param setObject:[JsonHelper transJson:plan] forKey:@"open_time_plan_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"open_time_plan/v1/save_open_time_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listTimeArrangeSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"time_arrange/v1/list_time_arrange" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveTimeArrange:(TimeArrangeVO *_Nonnull)timeArrange sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    [param setObject:[JsonHelper transJson:timeArrange] forKey:@"time_arrange_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"time_arrange/v1/save_time_arrange" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeTimeArrange:(NSString *_Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setObject:objId forKey:@"idsStr"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"time_arrange/v1/remove_time_arrange" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listSignBillKindPaySucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"base_sign_bill/v1/list_sign_bill" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveSignBillKindPay:(KindPay*_Nonnull)kindPay signers:(NSMutableArray*_Nonnull)signers sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:kindPay] forKey:@"kind_pay_str"];
    [param setObject:[JsonHelper arrTransJson:signers] forKey:@"signer_names_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"base_sign_bill/v1/save_sign_bill" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateSignBillKindPay:(KindPay*_Nonnull)kindPay signers:(NSMutableArray*_Nonnull)signers signerIds:(NSMutableArray*_Nonnull)signerIds  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:kindPay] forKey:@"kind_pay_str"];
    [param setObject:[JsonHelper arrTransJson:signers] forKey:@"signer_names_str"];
    [param setObject:[JsonHelper arrTransJson:signerIds] forKey:@"signer_ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"base_sign_bill/v1/update_sign_bill" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveKindPayDetailOption:(KindPayDetailOption*_Nonnull)option  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    [param setObject:[JsonHelper transJson:option] forKey:@"kind_pay_detail_option_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay_detail_option/v1/credit_save" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateKindPayDetailOption:(KindPayDetailOption*_Nonnull)option  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{

    NSMutableDictionary *param  = [[ NSMutableDictionary  alloc] init];
    [param setObject:[JsonHelper transJson:option] forKey:@"kind_pay_detail_option_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay_detail_option/v1/credit_update" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveKindPay:(KindPay*_Nonnull)kindPay  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:kindPay] forKey:@"kind_pay_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/save_kind_pay" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateKindPay:(KindPay*_Nonnull)kindPay  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
     [param setObject:[kindPay transToJsonString] forKey:@"kind_pay_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/update_kind_pay" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}


- (nullable NSURLSessionDataTask *) saveVoucher:(NSDictionary *_Nonnull)param  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/save_voucher" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}


- (nullable NSURLSessionDataTask *) deleteVoucher:(NSDictionary *_Nonnull)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/remove_voucher" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeKindPays:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"kind_pay_ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/remove_batch" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) sortKindPays:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"kind_pay_ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay/v1/sort_kind_pay" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listSignBillDetailOption:(NSString *_Nonnull)kindPayId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:kindPayId forKey:@"kind_pay_id"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay_detail_option/v1/list_kind_pay_detail_option" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeKindPayDetailOptions:(NSMutableArray*_Nonnull)ids  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay_detail_option/v1/remove_kind_pay_detail_option" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
    
}

- (nullable NSURLSessionDataTask *) saveSignBillRelation:(NSString *)kindPayId signers:(NSString *)signer sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"kind_pay_id"] = kindPayId;
    param[@"signer_name"] = signer;
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"base_sign_bill/v1/save_sign_bill_relation" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
    
}


- (nullable NSURLSessionDataTask *) sortKindPayDetailOptions:(NSMutableArray*_Nonnull)ids detailId:(NSString*_Nonnull)detailId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
//    [param setObject:detailId forKey:@"kindPayDetailId"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_pay_detail_option/v1/sort_kind_pay_detail_option" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listShopTemplateSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_template/v2/list_all_shop_template" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateShopTemplate:(ShopTemplate*_Nonnull)shopTemplate sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:shopTemplate] forKey:@"shop_template_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_template/v1/update_shop_template" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listPrintTemplateVOs:(NSString*_Nonnull)templateType lineWidth:(NSString*_Nonnull)width  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:templateType forKey:@"template_type"];
    [param setObject:width forKey:@"line_width"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_template/v1/find_print_template" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listLinkManSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"sms-link-man/v1/list_sms-link-man" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listDicItem:(NSString*_Nonnull)code sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:code forKey:@"dic_code"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"dic_item/v2/list_dic_item" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveDicItem:(DicItem*_Nonnull)dicItem code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:dicItem] forKey:@"dic_item_str"];
    [param setObject:code forKey:@"dic_code"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"dic_item/v1/save_dic_item" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeDicItems:(NSMutableArray*_Nonnull)ids code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    if ([NSString isNotBlank:code]) {
          [param setObject:code forKey:@"dic_code"];
    }
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"dic_item/v1/remove_dic_item" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) sortDicItems:(NSMutableArray*_Nonnull)ids code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    [param setObject:code forKey:@"dic_code"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"dic_item/v1/sort_dic_item" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;

}

- (nullable NSURLSessionDataTask *)listTailDealSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
     NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param [@"kind_config_code"]  = ZERO_CONFIG;
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"zero_deal/v2/list_zero_deal" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)  aveTailDeal:(TailDeal*_Nonnull)tailDeal sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:tailDeal] forKey:@"tail_deal_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"tail_deal/v1/save_tail_deal" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeTailDeals:(NSMutableArray*_Nonnull)idLIst sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:idLIst] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"tail_deal/v1/remove_tail_deal" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listReasonsSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"special_reason/v2/list_special_reason" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listKindMenuStyleSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind_menu_style/v1/list_kind_menu_style" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateKindMenuStyle:(KindMenuStyleVO* _Nonnull)kindMenuStyleVO sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:kindMenuStyleVO] forKey:@"kindMenuStyleVOStr"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"kind-menu-style/v1/update_kind_menu_style" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) editDiscountPlanItemId:(NSString *_Nonnull)itemId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:itemId forKey:@"discount_plan_id"];
    [param setObject:@"true" forKey:@"is_menu_discount"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/edit_discount_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)  saveDiscountPlan:(DiscountPlan*_Nonnull)discountPlan isAllKind:(NSString*_Nonnull)isAllKindStr userIds:(NSMutableArray*_Nonnull)userIds kindIds:(NSMutableArray*_Nonnull)kindIds menuIds:(NSMutableArray*_Nonnull)menuIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dic = [discountPlan dictionaryData];
    NSString *returnString = [dic JSONString];
    [param setObject:returnString forKey:@"discount_plan_str"];
    [param setObject:isAllKindStr forKey:@"is_all_kind"];
    [param setObject:[JsonHelper arrTransJson:userIds] forKey:@"user_ids_str"];
    [param setObject:[JsonHelper arrTransJson:kindIds] forKey:@"kind_ids_str"];
    [param setObject:[JsonHelper arrTransJson:menuIds] forKey:@"menu_ids_str"];
    [param setObject:@"true" forKey:@"is_menu_discount"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/save_discount_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateDiscountPlan:(DiscountPlan*_Nonnull)discountPlan isAllKind:(NSString*_Nonnull)isAllKindStr userIds:(NSMutableArray*_Nonnull)userIds kindIds:(NSMutableArray*_Nonnull)kindIds menuIds:(NSMutableArray*_Nonnull)menuIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dic = [discountPlan dictionaryData];
    NSString *jsonString = [dic JSONString];
    param[@"discount_plan_str"] = jsonString;
    param[@"is_all_kind"] = [NSString isNotBlank:isAllKindStr]?isAllKindStr:@"";
    param[@"user_ids_str"] = [JsonHelper arrTransJson:userIds];
    param[@"kind_ids_str"] = [JsonHelper arrTransJson:kindIds];
    param[@"menu_ids_str"] = [JsonHelper arrTransJson:menuIds];
    param[@"is_menu_discount"] = @"true";

    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/update_discount_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeDiscountPlan:(NSString*_Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:objId forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/remove_discount_plan" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) sortDiscountPlans:(NSMutableArray*)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"discount_plan/v1/sort_discount_plan" params:param];
     NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
      return task;
}



- (nullable NSURLSessionDataTask *) cancelBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_bind/v1/cancel_shop_bind" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) searchQueueBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"1" forKey:@"type"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_bind/v1/is_cancel_shop_bind" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;

}

- (nullable NSURLSessionDataTask *) cancelQueueBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_bind/v1/cancel_queue_bind" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)  listFeePlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"setting/fee_plan/v1/get_fee_plans" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) listAreaFeePlanId:(NSString *_Nonnull)feePlanId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject: feePlanId forKey:@"fee_plan_id"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"setting/fee_plan/v1/get_areas" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) removeFeePlan:(NSString* _Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:objId forKey:@"fee_plan_id"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"setting/fee_plan/v1/remove" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) saveFeePlan:(FeePlan*_Nonnull)feePlan ids:(NSMutableArray*_Nonnull)ids area:(AreaFeePlan*_Nonnull)areaFeePlan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:feePlan] forKey:@"fee_plan_json"];
    [param setObject:[JsonHelper transJson:areaFeePlan] forKey:@"area_fee_plan_json"];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"area_ids_json"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"setting/fee_plan/v1/save" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *) updateFeePlan:(FeePlan*_Nonnull)feePlan ids:(NSMutableArray*_Nonnull)ids area:(AreaFeePlan*_Nonnull)areaFeePlan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:feePlan] forKey:@"fee_plan_json"];
    [param setObject:[JsonHelper transJson:areaFeePlan] forKey:@"area_fee_plan_json"];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"area_ids_json"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"setting/fee_plan/v1/update" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
    
}

- (nullable NSURLSessionDataTask *)  listConfig:(NSString *_Nonnull)kindCode sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:kindCode forKey:@"kind_config_code"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"config_set/v1/list" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
    
}


- (nullable NSURLSessionDataTask *) saveConfig:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"config_set/v1/save" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;

}

- (nullable NSURLSessionDataTask *) loadPrintPara:(NSString *_Nonnull)kindCode sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:kindCode forKey:@"kind_config_code"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"print_paras/v1/list" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)savePrintParaConfig:(NSMutableArray*_Nonnull)ids shopLogo:(NSString *_Nonnull)logo memo:(NSString*_Nonnull)shopMemo sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    [param setObject:shopMemo forKey:@"shop_memo"];
    NSString *path ;
    if ([NSString isNotBlank:logo]) {
        [param setObject:logo forKey:@"shop_logo"];
        path  = @"config_set/v1/save_print_para_with_img";
    }
    else{
        path  =  @"config_set/v1/save_print_para";
    }
    TDFRequestModel *requestModel = [self getPostRequestModelPath:path params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;
    
}

- (nullable NSURLSessionDataTask *)saveShopImgFilePath:(NSString *_Nonnull)filePath  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSString *path;
    if ([NSString isBlank:path] ) {
      path  = @"";
    }
    NSMutableDictionary *param  = [[NSMutableDictionary  alloc] init];
    [param setObject:path forKey:@"file_path"];
    TDFRequestModel *requestModel = [self getPostRequestModelPath:@"shop_info/v1/update_shop_logo" params:param];
    NSURLSessionDataTask *task =  [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:sucessBlock failure:failureBlock];
    return task;

}


@end
