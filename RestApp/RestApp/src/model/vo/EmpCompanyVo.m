//
//  EmpCompanyVo.m
//  RestApp
//
//  Created by chaiweiwei on 16/7/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmpCompanyVo.h"
#import "MemberUserArrayVo.h"

@implementation EmpCompanyVo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"brandVo": @"brandVo",
             @"branchVoList": @"branchVoList",
             @"shopVoList": @"shopVoList",
             };
}

+ (NSValueTransformer *)shopVoListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MemberUserArrayVo class]];
}

+ (NSValueTransformer *)brandVoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberUserVo class]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if(self) {
        self.branchVoList = [BranchTreeVo convertToBranchTreeVoList:dictionaryValue[@"branchVoList"]];
    }
    return self;
}
@end
