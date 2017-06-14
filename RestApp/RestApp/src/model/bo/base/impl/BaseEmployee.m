//
//  Employee.m
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseEmployee.h"

@implementation BaseEmployee

-(void)dealloc{
    self.departmentId=nil;
    self.name=nil;
    self.mobile=nil;
    self.idCard=nil;
    self.spell=nil;
    self.birthday=nil;
    self.inDate=nil;
    self.attachmentId = nil;
}
@end
