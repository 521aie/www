//
//  TDFTakeMealModel.m
//  RestApp
//
//  Created by happyo on 16/10/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTakeMealModel.h"

@implementation TDFTakeMealModel

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
//    return @"http://10.1.5.217:8080/boss-api";
}

- (NSString *)serviceName
{
    return @"advertisement";
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
