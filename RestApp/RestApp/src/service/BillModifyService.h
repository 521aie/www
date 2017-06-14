//
//  BillModifyService.h
//  RestApp
//
//  Created by 栀子花 on 16/5/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface BillModifyService : BaseService

//查询账单优化配置
- (void)queryBillModifyInfoWithtaskType:(id)target callback:(SEL)callback;
//保存账单优化任务(自动，手动)
-(void) saveBillModifyTarget:(NSDictionary *)billDict  target:(id)target Callback:(SEL)callback;
//查询账单优化任务
- (void)queryBillModifyWithInfo:(int)taskType target:(id)target callback:(SEL)callback;
//清除账单优化任务
-(void)clearBillModify:(int)task_type target:(id)target callback:(SEL)callback;



@end
