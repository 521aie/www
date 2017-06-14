//
//  TDFSunofKitchenService.m
//  RestApp
//
//  Created by suckerl on 2017/6/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSunofKitchenService.h"
#import "TDFRequestModel.h"
#import "TDFHTTPClient.h"
#import "TDFResponseModel.h"
#import "TDFDataCenter.h"

@implementation TDFSunofKitchenService

- (TDFRequestModel *)getRequestModelWithName:(NSString *)name path:(NSString *)path version:(NSString *)version params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = name;
    requestModel.apiVersion = version;
    requestModel.actionPath = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

- (NSURLSessionDataTask *)getlistSunofKitchenWithSucessBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
   
    TDFRequestModel *requestModel = [self getRequestModelWithName:@"sun_kitchen" path:@"list" version:@"v1" params:nil];
   
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSLog(@"model : %@",model);
            
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
