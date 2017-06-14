//
//  DicSysItem+Extension.m
//  RestApp
//
//  Created by Octree on 10/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DicSysItem+Extension.h"

@implementation DicSysItem (Extension)

+ (instancetype)itemWithId:(NSString *)_id name:(NSString *)name {

    DicSysItem *item = [[DicSysItem alloc] init];
    item.name = name;
    item._id = _id;
    return item;
}
@end
