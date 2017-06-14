//
//  Pantry.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Pantry.h"
#import "ObjectUtil.h"
#import "PantryPlan.h"
@implementation Pantry

-(NSString*) obtainItemId
{
    return self._id;
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
    return self.printerIp?self.printerIp:@"";
}

+(id) pantryPlans_class
{
   return NSClassFromString(@"PantryPlan");
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pantryPlans" : [PantryPlan class]};
}

- (void)setPantryId:(NSString *)pantryId
{
    _pantryId  = pantryId;
    self._id  = pantryId;
}

-(void)dealloc
{
    self.producePlanStr=nil;
}

@end

@implementation AreaPantry

-(NSString*) obtainItemId
{
    return self._id;
}

-(NSString*) obtainItemName
{
    

    return self.areaNameListStr;
}
-(NSString*) obtainOrignName
{
    return [NSString stringWithFormat:@"%@",self.areaNameListStr];
}
-(NSString*) obtainItemValue
{
    return [NSString stringWithFormat:@"%@",self.ipAddress];
}

@end
