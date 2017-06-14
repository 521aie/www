//
//  Target_ChainModule.m
//  RestApp
//
//  Created by chaiweiwei on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_ChainModule.h"
#import "SystemUtil.h"
#import "ChainBusinessView.h"

@implementation Target_ChainModule

- (UIViewController *)Action_nativeChainBusinessViewController:(NSDictionary *)params {
    ChainBusinessView *viewController = [[ChainBusinessView alloc] init];
    return viewController;
}
@end
