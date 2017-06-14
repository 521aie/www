//
//  TDFShopToChainService.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopToChainService.h"

@implementation TDFShopToChainService

- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 8;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

//开通连锁
- (NSURLSessionDataTask *)createBrandWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"shop/v1/create_brand" params:param];
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

//创建新门店
- (NSURLSessionDataTask *)activeCodeWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"activation/v1/active_code" params:param];
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

//保存修改信息
- (NSURLSessionDataTask *)amodifyShopInfoWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"shop/organization/v1/modify_shop_info" params:param];
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

//发送邀请门店验证码
- (NSURLSessionDataTask *)sendInviteShopVerCodeWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"shop/organization/v1/send_invite_shop_ver_code" params:param];
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

//邀请门店加入
- (NSURLSessionDataTask *)inviteShopWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"shop/organization/v1/invite_shop" params:param];
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
