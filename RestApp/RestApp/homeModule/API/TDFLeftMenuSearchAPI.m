//
//  TDFLeftMenuSearchAPI.m
//  RestApp
//
//  Created by happyo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLeftMenuSearchAPI.h"
#import "TDFDataCenter.h"

@interface TDFLeftMenuSearchAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFLeftMenuSearchAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"keyword"] = self.keyword;
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
        _requestModel.serviceName = @"/homepage/v1/search_function";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
