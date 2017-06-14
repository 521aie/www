//
//  TDFMenuHitRuleVo.m
//  RestApp
//
//  Created by xueyu on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuHitRuleVo.h"

@implementation TDFMenuHitRuleVo

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"items" : [TDFMenuItem class]
             };
}
-(NSString*) obtainItemId{
  
    return self.ruleId;
}

-(NSString*) obtainItemName{
 
    TDFMenuItem *item1 = [self.items firstObject];
    TDFMenuItem *item2 = [self.items lastObject];
    return [NSString stringWithFormat:@"%@+%@",item1.menuName,item2.menuName];
}

-(NSString*) obtainOrignName{

    TDFMenuItem *item1 = [self.items firstObject];
    TDFMenuItem *item2 = [self.items lastObject];
    return [NSString stringWithFormat:@"%@+%@",item1.menuName,item2.menuName];
}

-(NSString*) obtainItemValue{
    if (self.price > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"+%0.1f元", nil),self.price];
    }
    return [NSString stringWithFormat:NSLocalizedString(@"%.1f元", nil),self.price];
}
@end



@implementation TDFMenuItem

-(NSString*) obtainItemName{
    
       return self.menuName;
}

-(NSString*) obtainItemId{
    
    return self.menuId;
}
@end








@implementation TDFMenuDetailVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [TDFMenuItem class]
             };
}

-(NSString*) obtainItemId{
    return self.menuDetailId;
}

-(NSString*) obtainItemName{
    return self.name;
}
-(NSArray *) obtainItems{
    return self.items;
}
@end
