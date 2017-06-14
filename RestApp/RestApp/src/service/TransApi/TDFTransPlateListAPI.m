//
//  TDFTransPlateListAPI.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTransPlateListAPI.h"
#import "TDFPantryRequestModel.h"
#import <YYModel.h>

@interface TDFTransPlateListAPI()

@property (strong, nonatomic) TDFRequestModel *requestModel;

@end

@implementation TDFTransPlateListAPI
- (TDFRequestModel *)apiRequestModel {
    return self.requestModel;
}

- (NSDictionary *)apiRequestParams {
    return self.params;
}

- (id)apiReformResponse:(id)response {
    return [NSArray yy_modelArrayWithClass:[TDFOldPlateModel class] json:response[@"data"]];
}

- (TDFRequestModel *)requestModel {
    if (!_requestModel) {
        _requestModel = [TDFPantryRequestModel modelWithActionPath:@"query_all_plate_list"];
    }
    
    return _requestModel;
}

- (NSMutableDictionary *)params {
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    
    return _params;
}

@end
