//
//  TDFSmartOrderModel.m
//  RestApp
//
//  Created by BK_G on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSmartOrderModel.h"

@implementation TDFSmartOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionGroupList" : [TDFSmartOrderGroupModel class]};
}

@end
