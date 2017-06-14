//
//  SeatRender.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Seat;
@interface SeatRender : NSObject

+(NSMutableArray*) listKind;

+(NSString*) formatSeatKind:(int)kind;
+(NSString*) seatDetailFormat:(Seat*)seat;

+(NSString*) formatArea:(NSString*)areaId areas:(NSMutableArray*)areas;


@end
