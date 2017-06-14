//
//  TDFBarcodeService.m
//  RestApp
//
//  Created by doubanjiang on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBarcodeService.h"
#import "TDFHTTPClient.h"
#import "Platform.h"
#import "TDFResponseModel.h"
#import "TDFDataCenter.h"
#import "RestConstants.h"
#import "NSString+Estimate.h"

@implementation TDFBarcodeService

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

- (NSURLSessionDataTask *)barcodeLoginWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/scan/v1/scan_code" params:param];
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

- (NSURLSessionDataTask *)loginConfirmWithParam:(NSDictionary *)param sucess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/scan/v1/login" params:param];
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
/***口碑获取授权二维码*/
+(void)kouBeiGetAuthQRCodeCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"get_koubei_coupon_qrcode_url";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@""};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}
@end
