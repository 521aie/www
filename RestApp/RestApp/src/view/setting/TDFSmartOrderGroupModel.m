//
//  TDFSmartOrderGroupModel.m
//  RestApp
//
//  Created by BK_G on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSmartOrderGroupModel.h"

@implementation TDFSmartOrderGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"funcFieldValues" : [TDFSmartOrderFieldModel class]};
}

@end
