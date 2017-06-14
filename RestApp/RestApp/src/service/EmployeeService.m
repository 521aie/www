//
//  EmployeeSevice.m
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeService.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "RestConstants.h"

@implementation EmployeeService

//超级管理员
- (void)loadAdmin:(NSString*)eventType
{
    
}

- (void)updateAdmin:(User*)user actionIds:(NSMutableArray*)actionIds target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:user] forKey:@"userStr"];
    [param setObject:[JsonHelper arrTransJson:actionIds] forKey:@"extraActionIdsStr"];
    [super postSession:@"ios/employee!updateAdmin.action" param:param target:target callback:callback];
}

@end
