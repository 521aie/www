//
//  TDFHealthCheckHistoryPageAPI.m
//  RestApp
//
//  Created by happyo on 2017/5/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryPageAPI.h"

@interface TDFHealthCheckHistoryPageAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFHealthCheckHistoryPageAPI

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
        _requestModel.serviceName = @"health_check/v1/get_history_reports";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}

- (id)apiReformResponse:(id)response
{
    return response[@"data"][@"historyReports"];
}

- (NSInteger)apiCurrentPageSizeForResponse:(id)response
{
    NSArray *dataList = response[@"data"][@"historyReports"];
    
    return dataList.count;
}

@end
