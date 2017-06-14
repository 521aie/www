//
//  KindPayDetail.m
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPayDetail.h"

@implementation KindPayDetail

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
+(id) options_class{
    return NSClassFromString(@"KindPayDetailOption");
}

@end
