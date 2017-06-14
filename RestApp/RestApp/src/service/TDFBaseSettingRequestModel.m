//
//  TDFBaseSettingRequestModel.m
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseSettingRequestModel.h"

@implementation TDFBaseSettingRequestModel

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
    //    return @"http://10.1.5.223:8080/boss-api";
    //    return @"http://mock.2dfire-daily.com/mockjsdata/56";
}

- (NSString *)serviceName
{
    return @"config_set";
}

- (NSString *)apiVersion
{
    return @"v1";
}

- (TDFHTTPRequestSignType)signType
{
    return TDFHTTPRequestSignTypeBossAPI;
    //    return TDFHTTPRequestSignTypeNone;
}


@end
