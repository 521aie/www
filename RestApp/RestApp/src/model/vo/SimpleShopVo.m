//
//  SimpleShopVo.m
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "SimpleShopVo.h"

@implementation SimpleShopVo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"switchList" : [TDFSwitchModel class]};
}


-(NSString*) obtainItemId
{
    return self.entityId;
}

-(NSString*) obtainItemName
{
    return self.name;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

-(NSString*) obtainItemValue
{
    return self.menuPricePlanName;
}

-(BOOL) obtainIsSelect
{
    return self.selected;
}

- (void) setIsSelect:(BOOL)isSelect
{
    _selected = isSelect;
}

@end
