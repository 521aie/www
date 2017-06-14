//
//  TDFWXPayRequestModel.m
//  RestApp
//
//  Created by Octree on 14/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayRequestModel.h"

@implementation TDFWXPayRequestModel

@synthesize apiVersion = _apiVersion;

- (float)timeout {
    return 10.0;
}

- (TDFHTTPRequestType)requestType {
    
    return TDFHTTPRequestTypePOST;
}

- (NSString *)serverRoot {
    return kTDFBossAPI;
}

- (NSString *)serviceName {
    
    return @"wx_official_account";
}

- (NSString *)apiVersion {
    
    if (!_apiVersion) {
        return @"v1";
    }
    return _apiVersion;
}

- (TDFHTTPRequestSignType)signType {
    
    return TDFHTTPRequestSignTypeBossAPI;
}

@end
