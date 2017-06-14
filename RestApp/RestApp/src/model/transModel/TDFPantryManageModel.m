//
//  TDFPantryManageModel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPantryManageModel.h"
#import "Pantry.h"
@implementation TDFPantryManageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pantryList" : [Pantry class],
             };
}


@end
