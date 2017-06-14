//
//  DayOrderBillVO.m
//  RestApp
//
//  Created by zxh on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DayOrderBillVO.h"

@implementation DayOrderBillVO

-(NSString*) obtainItemId{
    return self.orderId;
}

-(NSString*) obtainItemName{
    return self.seatName;
}

-(NSString*) obtainOrignName{
    return self.seatName;
}

-(NSString*) obtainItemValue{
   return @"";
}

@end
