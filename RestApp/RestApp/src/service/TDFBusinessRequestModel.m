//
//  TDFBusinessRequestModel.m
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessRequestModel.h"

@implementation TDFBusinessRequestModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.apiVersion = @"v1";
    }
    
    return self;
}

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
    return @"shop/statistics";
}

- (TDFHTTPRequestSignType)signType
{
    return TDFHTTPRequestSignTypeBossAPI;
}

@end
