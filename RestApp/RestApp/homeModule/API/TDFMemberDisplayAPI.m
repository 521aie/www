//
//  TDFMemberDisplayAPI.m
//  Pods
//
//  Created by happyo on 2017/4/10.
//
//

#import "TDFMemberDisplayAPI.h"
#import "TDFDataCenter.h"

@interface TDFMemberDisplayAPI ()

@property (nonatomic, strong) TDFRequestModel *requestModel;

@end
@implementation TDFMemberDisplayAPI

- (NSDictionary *)apiRequestParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *yesterDay =[dateFormatter stringFromDate:date];
    
    dict[@"date"] = yesterDay;
    
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
        _requestModel.serviceName = @"/member_privilege/v3/member_level_distribution";
        _requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
        _requestModel.timeout = 8;
    }
    
    return _requestModel;
}


@end
