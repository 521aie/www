//
//  BillModifyService.m
//  RestApp
//
//  Created by 栀子花 on 16/5/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BillModifyService.h"
#import "Area.h"
#import "Platform.h"
#import "JsonHelper.h"
#import "JSONKit.h"
#import "RestConstants.h"

@implementation BillModifyService
//查询账单优化配置
- (void)queryBillModifyInfoWithtaskType:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"IS_HIDE_ACCOUNT" forKey:@"code"];
    [super postBossAPI:@"/boss/v1/get_config" param:param target:target callback:callback];
}

//保存账单优化任务
-(void) saveBillModifyTarget:(NSDictionary *)billDict  target:(id)target Callback:(SEL)callback{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[billDict JSONString] forKey:@"task_json"];
    [super postBossAPI:@"/billoptimization/v1/save_task" param:param target:target callback:callback];
}

//查询账单优化任务
- (void)queryBillModifyWithInfo:(int)taskType target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%d",taskType] forKey:@"task_type"];
    [super postBossAPI:@"/billoptimization/v1/get_task" param:param target:target callback:callback];
}
//清除账单优化任务
- (void)clearBillModify:(int)task_type target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%d",task_type] forKey:@"task_type"];
    [super postBossAPI:@"/billoptimization/v1/clear_task" param:param target:target callback:callback];

}

@end
