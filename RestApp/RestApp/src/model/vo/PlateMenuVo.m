//
//  PlateMenuVo.m
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateMenuVo.h"

@implementation PlateMenuVo
-(NSString*) obtainItemId
{
    return self.menuId;
}

-(NSString*) obtainItemName;
{
    return self.menuName;
}
-(NSString*) obtainOrignName
{
    return self.menuName;
}
-(NSString*) obtainItemValue
{
    return nil;
}

-(BOOL)obtainIsSelect
{
    return self.isSelected;
}

- (void) setIsSelect:(BOOL)isSelect
{
    _isSelected = isSelect;
}

@end
