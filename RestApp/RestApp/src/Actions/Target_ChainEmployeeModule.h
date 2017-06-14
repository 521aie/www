//
//  Target_ChainEmployeeModule.h
//  RestApp
//
//  Created by zishu on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_ChainEmployeeModule : NSObject

//连锁/分公司员工列表:zishu
- (UIViewController *)Action_nativeChainEmployeeListViewController:(NSDictionary *)params;

//连锁/分公司员工筛选:zishu
- (UIViewController *)Action_nativeChainMemberSearchViewController:(NSDictionary *)params;

//连锁/分公司员工职级列表:zishu
- (UIViewController *)Action_nativeChainRoleListViewController:(NSDictionary *)params;

//连锁/分公司员工职级详情:zishu
- (UIViewController *)Action_nativeChainRoleEditViewController:(NSDictionary *)params;

//火掌柜连锁/分公司员工高级设置门店/品牌/分公司选择页面:zishu
- (UIViewController *)Action_nativeChainSelectListViewController:(NSDictionary *)params;

//火掌柜连锁/分公司员工职级权限选择页面:zishu
- (UIViewController *)Action_nativeChainSelectBatchRoleViewController:(NSDictionary *)params;

//火掌柜连锁/分公司员工密码修改页面:zishu
- (UIViewController *)Action_nativeChainEditPassViewController:(NSDictionary *)params;
@end
