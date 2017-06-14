//
//  TDFMemberSearchAPI.m
//  RestApp
//
//  Created by happyo on 2017/4/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMemberSearchAPI.h"
#import "TDFRequestModel.h"

@interface TDFMemberSearchAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFMemberSearchAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"keyword"] = self.keyword;
    dict[@"isOnlySearchMobile"] = self.isMobile;
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
        _requestModel.serviceName = @"member/v1/query_customer_info";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
