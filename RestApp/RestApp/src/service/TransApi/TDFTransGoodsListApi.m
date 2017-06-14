//
//  TDFTransGoodsListApi.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTransGoodsListApi.h"
#import "TDFTransRequestModel.h"
#import "TDFShopSynchGroupModel.h"
#import <YYModel.h>

@interface TDFTransGoodsListApi()
@property (strong, nonatomic) TDFRequestModel *requestModel;
@end

@implementation TDFTransGoodsListApi
- (TDFRequestModel *)apiRequestModel {
    return self.requestModel;
}

- (NSDictionary *)apiRequestParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"remove_chain"] = [NSString stringWithFormat:@"%d",self.removeChain];
    params[@"plate_entity_id"] = self.plateEntityId;
    return params;
}

- (id)apiReformResponse:(id)response {
    return [NSArray yy_modelArrayWithClass:[TDFShopSynchGroupModel class] json:response[@"data"]];
}

- (TDFRequestModel *)requestModel {
    if (!_requestModel) {
        _requestModel = [TDFTransRequestModel modelWithActionPath:@"item_list"];
    }
    return _requestModel;
}

@end
