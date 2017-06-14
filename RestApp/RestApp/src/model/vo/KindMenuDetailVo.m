//
//  KindMenuDetailVo.m
//  RestApp
//
//  Created by zishu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuDetailVo.h"

@implementation KindMenuDetailVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"additionKindMenuVoList" : [AdditionKindMenuVo class],
             @"kindAndTasteVoList":[KindAndTasteVo class]};
}

@end
