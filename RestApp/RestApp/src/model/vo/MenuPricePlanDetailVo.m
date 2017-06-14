//
//  MenuPricePlanDetailVo.m
//  RestApp
//
//  Created by zishu on 16/10/18.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "MenuPricePlanDetailVo.h"

@implementation MenuPricePlanDetailVo
-(NSString*) obtainItemId
{
    return self.pricePlanId;
}

-(NSString*) obtainItemName
{
    return self.pricePlanName;
}

-(NSString*) obtainOrignName
{
    return self.pricePlanName;
}

-(NSString*) obtainItemValue
{ 
    NSArray *arr = [self.menuPrice componentsSeparatedByString:@"."];

    if (arr.count >1) {
        if ([[arr lastObject] length] > 2) {
            if([self.menuPrice rangeOfString:@".00"].location !=NSNotFound)
            {
               return [NSString stringWithFormat:@"%.f",self.menuPrice.doubleValue];
            }else{
                return [NSString stringWithFormat:@"%.2f",self.menuPrice.doubleValue];
            }
        }
         return [NSString stringWithFormat:@"%.2f",self.menuPrice.doubleValue];
    }
    return [NSString stringWithFormat:@"%d",self.menuPrice.intValue];

}

-(BOOL *) obtainIsChange
{
    return self.isChange;
}
@end
