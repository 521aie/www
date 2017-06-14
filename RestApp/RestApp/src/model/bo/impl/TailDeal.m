//
//  TailDeail.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TailDeal.h"

@implementation TailDeal

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return [NSString stringWithFormat:@"%d",self.val];
}

-(NSString*) obtainOrignName{
    return [NSString stringWithFormat:@"%d",self.val];
}

-(NSString*) obtainItemValue{
    return [NSString stringWithFormat:@"%d",self.dealVal];
}

@end
