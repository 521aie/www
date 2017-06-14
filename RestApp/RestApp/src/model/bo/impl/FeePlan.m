//
//  FeePlan.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FeePlan.h"

@implementation FeePlan

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
    NSString* type=NSLocalizedString(@"无", nil);
    if (self.calBase!=CAL_BASE_NULL) {
        type=NSLocalizedString(@"服务费", nil);
    }
    if (self.minConsumeKind!=MIN_CONSUME_KIND_NULL) {
        if ([type isEqualToString:NSLocalizedString(@"无", nil)]) {
            type=NSLocalizedString(@"最低消费", nil);
        }else{
            type=[NSString stringWithFormat:NSLocalizedString(@"%@,最低消费", nil),type];
        }
    }
    return type;
}


@end
