//
//  TimeArrangeVO.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimeArrangeVO.h"
#import "DateUtils.h"

@implementation TimeArrangeVO

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
    NSString* val=[NSString stringWithFormat:@"%@-%@",[DateUtils formatTimeWithSecond:self.beginTime],[DateUtils formatTimeWithSecond:self.endTime]];
    return val;
}

-(NSString*) getBtimeStr{
    return [DateUtils formatTimeWithSecond:self.beginTime];
}
-(NSString*) getEtimeStr
{
    return [DateUtils formatTimeWithSecond:self.endTime];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @[@"id"]
             };
}

@end
