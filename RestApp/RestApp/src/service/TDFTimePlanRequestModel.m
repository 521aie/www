//
//  TDFTimePlanRequestModel.m
//  RestApp
//
//  Created by happyo on 2016/12/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTimePlanRequestModel.h"

@implementation TDFTimePlanRequestModel

- (float)timeout
{
    return 15.0;
}

- (TDFHTTPRequestType)requestType
{
    return TDFHTTPRequestTypePOST;
}

- (NSString *)serverRoot
{
    return kTDFBossAPI;
}

- (NSString *)serviceName
{
    return @"open_time_plan";
}

- (NSString *)apiVersion
{
    return @"v1";
}

- (TDFHTTPRequestSignType)signType
{
    return TDFHTTPRequestSignTypeBossAPI;
}

@end
