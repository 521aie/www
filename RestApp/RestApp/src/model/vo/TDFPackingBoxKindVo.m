//
//  TDFPackingBoxKindVo.m
//  RestApp
//
//  Created by 栀子花 on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPackingBoxKindVo.h"
#import "TDFPackingBoxVo.h"
@implementation TDFPackingBoxKindVo
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"packingBoxVoList":[TDFPackingBoxVo class]
             
             };
}
@end
