//
//  TDFForceKindMenuVo.m
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFForceKindMenuVo.h"
#import "TDFForceMenuVo.h"
@implementation TDFForceKindMenuVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"forceMenuVoList":[TDFForceMenuVo class]
             };
}
@end
