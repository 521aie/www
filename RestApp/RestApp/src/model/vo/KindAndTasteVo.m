//
//  KindAndTasteVo.m
//  RestApp
//
//  Created by zishu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindAndTasteVo.h"

@implementation KindAndTasteVo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tasteList" : [Taste class]};
}
-(NSString*) obtainItemId
{
    return self.kindTasteId;
}

-(NSString*) obtainItemName
{
    return self.kindTasteName;
}

-(NSString*) obtainOrignName
{
    return self.kindTasteName;
}

-(NSString*) obtainItemValue
{
    return self.kindTasteName;
}

@end
