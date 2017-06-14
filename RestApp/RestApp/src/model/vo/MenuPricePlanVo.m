//
//  MenuPricePlanVo.m
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "MenuPricePlanVo.h"

@implementation MenuPricePlanVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"simpleBranchVoList" : [SimpleBranchVo class]};
}
-(NSString*) obtainItemId
{
    return self.pricePlanId;
}

-(NSString*) obtainItemName
{
    return self.pricePlanName;
}

-(NSString*) obtainOrignName
{
    return self.pricePlanName;
}

-(NSString*) obtainItemValue
{
    return nil;
}

@end
