//
//  TDFLeftMenuDisplayAPI.m
//  RestApp
//
//  Created by happyo on 2017/4/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLeftMenuDisplayAPI.h"
#import "TDFDataCenter.h"

@interface TDFLeftMenuDisplayAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFLeftMenuDisplayAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // 页面代码	string	homepage,left,right
    dict[@"page_code"] = @"left";
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
        //        _requestModel.serverRoot = kTDFBossAPI;
        _requestModel.serverRoot = @"http://10.1.6.219:8080/boss-api";
        _requestModel.serviceName = @"homepage/v1/list_page_info";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}
@end
