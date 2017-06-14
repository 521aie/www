//
//  TDFGoodsRequestModel.m
//  RestApp
//
//  Created by happyo on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFGoodsRequestModel.h"
#import "TDFNetworkingConstants.h"

@implementation TDFGoodsRequestModel

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
//    return @"http://10.1.4.209:8080/boss-api";
}

- (NSString *)serviceName
{
    return @"menu";
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
