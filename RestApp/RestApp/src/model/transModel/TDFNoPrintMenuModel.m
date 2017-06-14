//
//  TDFNoPrintMenuModel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFNoPrintMenuModel.h"
#import "KindMenu.h"
#import "SampleMenuVO.h"

@implementation TDFNoPrintMenuModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pantryKindMenuVOs" : [KindMenu class],@"pantryMenuVOs" : [SampleMenuVO class]
             };
}
@end
