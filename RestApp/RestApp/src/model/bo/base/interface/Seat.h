//
//  Seat.h
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSeat.h"
#import "INameValueItem.h"

#define SEAT_KIND_COMMON 1          //普通
#define SEAT_KIND_BALCONY 2         //包厢
#define SEAT_KIND_CARD 3            //卡座

@interface Seat : BaseSeat<INameValueItem, NSCopying>

@end
