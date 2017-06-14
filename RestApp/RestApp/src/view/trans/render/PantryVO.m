//
//  PantryVO.m
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "PantryVO.h"
#import "PantryPlan.h"
@implementation PantryVO

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pantryPlans" : [PantryPlan class]};
}

-(NSString*) obtainItemId
{
    return self.pantryId;
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
    return [NSString stringWithFormat:@"%@",self.printerIp];
}

@end
