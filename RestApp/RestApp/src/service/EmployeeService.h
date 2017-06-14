//
//  EmployeeSevice.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"
#import "BaseService.h"
#import "Role.h"
#import "Employee.h"
#import "User.h"

@interface EmployeeService : BaseService
     //角色权限
//超级管理员
-(void) loadAdmin:(NSString*)eventType;

-(void) updateAdmin:(User*)user actionIds:(NSMutableArray*)actionIds  target:(id)target callback:(SEL)callback;
;

//连锁门店信息
-(void)listAllStoresuseId:(NSString *)useId target:(id)target callback:(SEL)callback;

@end
