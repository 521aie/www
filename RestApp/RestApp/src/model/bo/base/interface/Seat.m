//
//  Seat.m
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Seat.h"

@implementation Seat

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.name;
}
-(NSString*) obtainOrignName{
    return self.name;
}

-(NSString*) obtainItemValue{
    return nil;
}
-(NSString*) obtainHeadId
{
    return self.areaId;
}

-(NSString*) obtainItemSpell
{
    return self.code;
}

-(NSString*) obtainItemCode
{
    return self.code;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    Seat *seat = [[Seat allocWithZone:zone] init];
    
    seat.areaId = self.areaId;
    seat._id = self._id;
    seat.name = self.name;
    seat.code = self.code;
    seat.adviseNum = self.adviseNum;
    seat.seatKind = self.seatKind;
    seat.sortCode = self.sortCode;
    seat.memo = self.memo;
    seat.isReserve = self.isReserve;
    seat.lastVer = self.lastVer;
    
    return seat;
}
@end
