//
//  PlateShopVoList.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateShopVoList.h"


@implementation PlateShopVoList

-(NSString*) obtainItemId
{
    return self.shopEntityId;
}

-(NSString*) obtainItemName
{
    return self.shopName;
}

-(NSString*) obtainOrignName
{
    return self.shopName;
}

-(NSString*) obtainItemValue
{
    NSString *str   = [ NSString stringWithFormat:@"%d",self.joinMode];
    return  str;
}

-(BOOL) obtainIsSelect
{
    return self.isSelected;
}

- (void) setIsSelect:(BOOL)isSelect
{
    _isSelected = isSelect;
}



@end
