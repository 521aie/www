//
//  KindMenuStyleVO.m
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuStyleVO.h"

@implementation KindMenuStyleVO

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.kindMenuName;
}
-(NSString*) obtainOrignName{
    return self.kindMenuName;
}

-(NSString*) obtainItemValue{
    return self.styleName;
}


@end
