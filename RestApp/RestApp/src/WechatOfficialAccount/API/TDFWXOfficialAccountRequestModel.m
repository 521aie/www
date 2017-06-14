//
//  TDFWXOfficialAccountRequestModel.m
//  RestApp
//
//  Created by tripleCC on 2017/5/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXOfficialAccountRequestModel.h"

@implementation TDFWXOfficialAccountRequestModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestType = TDFHTTPRequestTypePOST;
        self.signType = TDFHTTPRequestSignTypeBossAPI;
        self.serverRoot = kTDFBossAPI;
        self.serviceName = @"wx_official_account";
        self.timeout = 16.0;
    }
    return self;
}

+ (instancetype)modelWithActionPath:(NSString *)actionPath {
    TDFWXOfficialAccountRequestModel *model = [[self alloc] init];
    model.actionPath = actionPath;
    return model;
}
@end
