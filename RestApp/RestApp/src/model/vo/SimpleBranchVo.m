//
//  SimpleBranchVo.m
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "SimpleBranchVo.h"

@implementation SimpleBranchVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"simpleShopVoList" : [SimpleShopVo class]};
}


-(NSString*) obtainItemId
{
    return self.branchId;
}

-(NSString*) obtainItemName
{
    return self.branchName;
}

-(NSString*) obtainOrignName
{
    return self.branchName;
}

-(NSString*) obtainItemValue
{
    return nil;
}

-(BOOL) obtainIsSelect
{
    return self.selected;
}

- (void) setIsSelect:(BOOL)isSelect
{
    _selected = isSelect;
}

- (NSString *)obtainParentName
{
    return @"";
}

- (BOOL)isEqual:(id)object
{
    return [self.simpleShopVoList isEqual:[(SimpleBranchVo *)object simpleShopVoList]];
}
@end
