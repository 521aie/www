//
//  PlateBranchVo.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PlateBranchVo.h"
#import "NSString+Estimate.h"

@implementation PlateBranchVo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"plateShopVoList" : [PlateShopVoList class]};
}

-(NSString*) obtainItemId
{
    return self.branchEntityId;
}

-(NSString*) obtainItemName
{
    if ([NSString isNotBlank:self.brandName]) {
        return self.brandName;
    }
    return self.branchName;
}

-(NSString*) obtainOrignName
{
    if ([NSString isNotBlank:self.brandName]) {
        return self.brandName;
    }
    return self.branchName;
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

- (BOOL)isEqual:(id)object
{
    return [self.plateShopVoList isEqual:[(PlateBranchVo *)object plateShopVoList]];
}
@end
