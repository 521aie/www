//
//  PlateMenuDetailVo.m
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateMenuDetailVo.h"

@implementation PlateMenuDetailVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"plateMenuVos" : [PlateMenuVo class]};
}
-(NSString*) obtainItemId
{
    return self.kindMenuId;
}

-(NSString*) obtainItemName;
{
    return self.kindMenuName;
}
-(NSString*) obtainOrignName
{
   return self.kindMenuName;
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

-(NSString*) obtainParentName
{
    return self.parentKindMenuName;
}
@end
