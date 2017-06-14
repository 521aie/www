//
//  TDFHomeOldBusinessLogicAPI.m
//  RestApp
//
//  Created by happyo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHomeOldBusinessLogicAPI.h"
#import "TDFDataCenter.h"

@interface TDFHomeOldBusinessLogicAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFHomeOldBusinessLogicAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"app_code"] = self.appCode;
    dict[@"platform_type"] = self.platformType;
    dict[@"type"] = self.type;
    dict[@"j_session_id"] = self.jsessionId;
    
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
        _requestModel.serviceName = @"/homepage/v1/get_composite_biz_info";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
