//
//  TDFWXPayTrader.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayTraderModel.h"

@implementation TDFWXPayTraderModel

/**
 *  YYModel
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

@end


@implementation TDFTraderModel


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}


@end
