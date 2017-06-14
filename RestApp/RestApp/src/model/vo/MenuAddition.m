//
//  MenuAddition.m
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuAddition.h"
#import "FormatUtil.h"

@implementation MenuAddition

-(NSString*) obtainItemId{
    return self.menuId;
}

-(NSString*) obtainItemName{
    return self.name;
}
-(NSString*) obtainOrignName{
    return self.name;
}

-(NSString*) obtainItemValue{
    NSString* val=[NSString stringWithFormat:NSLocalizedString(@"加价:%@元", nil),[FormatUtil formatNumber:self.price]];
    return val;
}


@end
