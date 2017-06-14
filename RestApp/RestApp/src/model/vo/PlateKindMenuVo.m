//
//  PlateKindMenuVo.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateKindMenuVo.h"

@implementation PlateKindMenuVo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"plateMenuVoList" : [PlateMenuVoList class]};
}

-(NSString*) obtainItemId
{
    return self.kindMenuId;
}

-(NSString*) obtainItemName
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

-(BOOL) obtainIsSelect
{
    return self.isSelected;
}

- (void) setIsSelect:(BOOL)isSelect
{
    _isSelected = isSelect;
}

- (NSString *)obtainParentName
{
    return @"";
}
@end
