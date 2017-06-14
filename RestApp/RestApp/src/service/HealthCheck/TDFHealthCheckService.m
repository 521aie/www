//
//  TDFHealthCheckService.m
//  RestApp
//
//  Created by xueyu on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFHTTPClient.h"
#import "TDFDataCenter.h"
#import "TDFRequestModel.h"
#import "TDFHealthCheckService.h"
#import "Platform.h"
#import "RestConstants.h"
@implementation TDFHealthCheckService

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


- (nullable NSURLSessionDataTask *)getHealthCheckSettingWithCallBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"health_check";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"get_settings";
    requestModel.parameters =  @{ @"session_key":[TDFDataCenter sharedInstance].sessionKey
                                 }.mutableCopy;
  NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
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
    return task;
}



- (nullable NSURLSessionDataTask *)saveHealthCheckSettingWithData:(nonnull NSString *)dataString callback:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"health_check";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"save_settings";
    requestModel.parameters =  @{@"setting_data": dataString,
                                 @"session_key":[TDFDataCenter sharedInstance].sessionKey
                                  }.mutableCopy;
  NSURLSessionDataTask *task =  [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
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
    return task;
}


- (nullable NSURLSessionDataTask *)getHealthCheckDetailWithResultId:(nonnull NSString *)resultId itemCode:(nonnull NSString *)itemCode callback:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"health_check";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"get_detail";
    requestModel.parameters =  @{@"result_id": resultId,
                                 @"item_code":itemCode,
                                 @"session_key":[TDFDataCenter sharedInstance].sessionKey
                                 }.mutableCopy;
   NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
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
    return task;
}

/**
 * 体检项目
 */
- (nullable NSURLSessionDataTask *)getHealthCheckSettingInfoSucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                           failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"health_check/v1/get_result" params:nil];
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

/**
 * 体检历史数据
 */
- (nullable NSURLSessionDataTask *)getHealthCheckHistoryInfoWithResultID:(nonnull NSString *)resultID
                                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                                 failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"health_check/v1/get_history_result" params:@{@"result_id":resultID}];
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

/**
 * /health_check/v1/get_history_score
 */
- (nullable NSURLSessionDataTask *)getHealthCheckHistoryScoreSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"health_check/v1/get_history_score" params:nil];
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
