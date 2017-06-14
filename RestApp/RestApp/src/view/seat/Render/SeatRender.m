//
//  SeatRender.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SeatRender.h"
#import "Seat.h"
#import "Area.h"
#import "NSString+Estimate.h"
#import "NameItemVO.h"
@implementation SeatRender

+(NSString*) formatSeatKind:(int)kind
{
    NSString* kindName=kind==SEAT_KIND_COMMON?NSLocalizedString(@"散座", nil):(kind==SEAT_KIND_BALCONY?NSLocalizedString(@"包厢", nil):NSLocalizedString(@"卡座", nil));
    return kindName;
}

+(NSString*) seatDetailFormat:(Seat*)seat
{
    NSString* kind=[SeatRender formatSeatKind:seat.seatKind];
    return [NSString stringWithFormat:NSLocalizedString(@"%@，%d人桌", nil),kind,seat.adviseNum];
}

+(NSString*) formatArea:(NSString*)areaId areas:(NSMutableArray*)areas
{
    if ([NSString isBlank:areaId] || areas==nil || areas.count==0) {
        return @"";
    }
    for (Area* area in areas) {
        if ([area._id isEqualToString:areaId]) {
            return area.name;
        }
    }
    return @"";
}

+(NSMutableArray*) listKind
{
    NSMutableArray *arr=[NSMutableArray array];
    
    NameItemVO* vo=[[NameItemVO new] initWithVal:NSLocalizedString(@"散座", nil) andId:[NSString stringWithFormat:@"%d",SEAT_KIND_COMMON]];
    vo.itemValue = vo.itemId;
    [arr addObject:vo];
    
    vo=[[NameItemVO new] initWithVal:NSLocalizedString(@"包厢", nil) andId:[NSString stringWithFormat:@"%d",SEAT_KIND_BALCONY]];
    vo.itemValue = vo.itemId;
    [arr addObject:vo];
    
    vo=[[NameItemVO new] initWithVal:NSLocalizedString(@"卡座", nil) andId:[NSString stringWithFormat:@"%d",SEAT_KIND_CARD]];
    vo.itemValue = vo.itemId;
    [arr addObject:vo];
    
    return arr;
}

@end
