//
//  Target_ShopToChainModule.m
//  RestApp
//
//  Created by 刘红琳 on 2017/3/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_ShopToChainModule.h"
#import "TDFOpenChainViewController.h"
@implementation Target_ShopToChainModule
///开通连锁首页
- (UIViewController *)Action_nativeOpenChainViewController:(NSDictionary *)params
{
    TDFOpenChainViewController *viewController = [[TDFOpenChainViewController alloc]init];
    return viewController;
}
@end
