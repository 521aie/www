//
//  PlateMenuVoList.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateMenuVoList.h"

@implementation PlateMenuVoList
-(NSString*) obtainItemId
{
    return self.menuId;
}

-(NSString*) obtainItemName
{
    return self.menuName;
}

-(NSString*) obtainOrignName
{
    return self.menuName;
}

-(NSString*) obtainItemValue
{
    return @"";
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
