//
//  TDFForwardGroup.m
//  RestApp
//
//  Created by Cloud on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFForwardGroup.h"

@implementation TDFForwardGroup

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"forwardCells" : [TDFForwardCells class]};
}

@end
