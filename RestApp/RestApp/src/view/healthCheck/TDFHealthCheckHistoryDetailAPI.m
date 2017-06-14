//
//  TDFHealthCheckHistoryDetailAPI.m
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryDetailAPI.h"

@interface TDFHealthCheckHistoryDetailAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFHealthCheckHistoryDetailAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"result_id"] = self.resultId;
    dict[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    
    return dict;
}

- (TDFRequestModel *)apiRequestModel
{
    return self.requestModel;
}

- (TDFRequestModel *)requestModel
{
    if (!_requestModel) {
        _requestModel = [[TDFRequestModel alloc] init];
        _requestModel.requestType = TDFHTTPRequestTypePOST;
        _requestModel.serverRoot = kTDFBossAPI;
        _requestModel.serviceName = @"/health_check/v1/get_history_report";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
