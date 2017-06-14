//
//  TDFShopUpgradeBrandModel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopUpgradeBrandModel.h"

@implementation TDFShopUpgradeBrandModel
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
