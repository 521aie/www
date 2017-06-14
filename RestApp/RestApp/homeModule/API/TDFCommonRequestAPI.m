//
//  TDFCommonRequestAPI.m
//  Pods
//
//  Created by happyo on 2017/4/7.
//
//

#import "TDFCommonRequestAPI.h"
#import "TDFDataCenter.h"

@interface TDFCommonRequestAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFCommonRequestAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    
    return dict;
}

- (TDFRequestModel *)apiRequestModel
{
    // 因为可能请求名会变
    self.requestModel.serviceName = self.serviceName;

    return self.requestModel;
}

- (TDFRequestModel *)requestModel
{
    if (!_requestModel) {
        _requestModel = [[TDFRequestModel alloc] init];
        _requestModel.requestType = TDFHTTPRequestTypePOST;
        _requestModel.serverRoot = kTDFBossAPI;
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
