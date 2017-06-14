//
//  TDFWXMockRequestModel.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXMockRequestModel.h"

@implementation TDFWXMockRequestModel

@synthesize apiVersion = _apiVersion;

- (float)timeout {
    return 10.0;
}

- (TDFHTTPRequestType)requestType {
    
    return TDFHTTPRequestTypePOST;
}

- (NSString *)serverRoot {
    
    return @"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/235";
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
