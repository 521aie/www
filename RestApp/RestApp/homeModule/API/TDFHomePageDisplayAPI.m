//
//  TDFHomePageDisplayAPI.m
//  Pods
//
//  Created by happyo on 2017/4/7.
//
//

#import "TDFHomePageDisplayAPI.h"
#import "TDFDataCenter.h"

@interface TDFHomePageDisplayAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFHomePageDisplayAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"page_code"] = self.pageCode;
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
        _requestModel.serviceName = @"homepage/v1/list_page_info";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

@end
