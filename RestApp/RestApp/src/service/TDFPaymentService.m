//
//  TDFPaymentService.m
//  RestApp
//
//  Created by zishu on 16/8/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentService.h"

@implementation TDFPaymentService

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

//查询指定月微信账单分页
- (NSURLSessionDataTask *)getRecordByDayWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"bill/v1/get_payment_record_by_day" params:param];
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

//查询微信账单详情
- (NSURLSessionDataTask *)getTotalBillsMoneyWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"bill/v1/total_by_month" params:param];
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

//修改店铺电子支付信息
- (NSURLSessionDataTask *)applyElectronicPaymentWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/online/v1/modify_online_pay_info" params:param];
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

//查询银行开户支行
- (NSURLSessionDataTask *)getSubBanksWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/bank/v1/get_sub_banks" params:param];
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

//查询银行对应城市
- (NSURLSessionDataTask *)getCitiesWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/bank/v1/get_cities" params:param];
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

//查询店铺对应城市
- (NSURLSessionDataTask *)getShopCitiesWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/area/v1/get_cities" params:param];
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

//查询银行对应省
- (NSURLSessionDataTask *)getProvinceWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/bank/v1/get_province" params:param];
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

//查询店铺对应省
- (NSURLSessionDataTask *)getShopProvinceWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/area/v1/get_province" params:param];
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


//查询开户银行列表
- (NSURLSessionDataTask *)getBanksWithParam:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/bank/v1/get_banks" params:nil];
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

//查询店铺电子支付信息
- (NSURLSessionDataTask *)getElectronicPaymentWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/online/v1/get_online_pay_info" params:param];
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

//店铺状态
- (NSURLSessionDataTask *)getShopStatusWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pay/online/v1/get_shop_status" params:param];
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
@end
