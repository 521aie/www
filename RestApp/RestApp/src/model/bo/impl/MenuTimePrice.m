//
//  MenuTimePrice.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimePrice.h"
#import "FormatUtil.h"

@implementation MenuTimePrice

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.menuName;
}

-(NSString*) obtainOrignName{
    return self.menuName;
}

-(NSString*) obtainItemValue{
    return [FormatUtil formatDouble4:self.price];
}

-(NSString *) obtainMenuId{
    return self.menuId;
}

-(void) dealloc
{
    self.menuName=nil;
	self.kindMenuName=nil;
}
@end
