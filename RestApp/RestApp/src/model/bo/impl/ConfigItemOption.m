//
//  ConfigItemOption.m
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigItemOption.h"

@implementation ConfigItemOption

-(NSString*) obtainItemId{
    return self.value;
}
-(NSString*) obtainItemName{
    return self.memo;
}
-(NSString*) obtainOrignName{
    return self.memo;
}

@end
