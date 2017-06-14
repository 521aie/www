//
//  TDFPantryRequestModel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPantryRequestModel.h"

@implementation TDFPantryRequestModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestType = TDFHTTPRequestTypePOST;
        self.signType = TDFHTTPRequestSignTypeBossAPI;
        self.serverRoot = kTDFBossAPI;
        self.serviceName = @"pantry";
        self.apiVersion = @"v1";
    }
    return self;
}

+ (instancetype)modelWithActionPath:(NSString *)actionPath
{
    TDFPantryRequestModel *model = [[self alloc] init];
    model.actionPath = actionPath;
    return model;
}

- (void)setParameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParams = parameters.mutableCopy ? : [NSMutableDictionary dictionary];
    mutableParams[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    [super setParameters:mutableParams];
}

@end
