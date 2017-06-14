//
//  Target_SignBillModule.h
//  RestApp
//
//  Created by 黄河 on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_SignBillModule : NSObject
///挂账处理
- (UIViewController *)Action_nativeSignBillViewController:(NSDictionary *)params;

///已还款挂账单
- (UIViewController *)Action_nativeSignBillRecordViewController:(NSDictionary *)params;

///还款详情
- (UIViewController *)Action_nativeSignBillPayDetailViewController:(NSDictionary *)params;

//加载添加挂账单详细信息
- (UIViewController *)Action_nativeSignBillDetailViewController:(NSDictionary *)params;

//加载添加挂账日期界面
- (UIViewController *)Action_nativeSignBillDateViewController:(NSDictionary *)params;

//加载挂账确认界面
- (UIViewController *)Action_nativeSignBillConfirmViewController:(NSDictionary *)params;

//加载挂账还款界面
- (UIViewController *)Action_nativeSignBillPayViewController:(NSDictionary *)params;
@end
