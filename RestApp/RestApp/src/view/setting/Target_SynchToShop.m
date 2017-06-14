//
//  Target_SynchToShop.m
//  RestApp
//
//  Created by chaiweiwei on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_SynchToShop.h"

@implementation Target_SynchToShop

- (UIViewController *)Action_nativeSynchToShopViewController:(NSDictionary *)params {
    TDFChainIssueCenterViewController *VC = [[TDFChainIssueCenterViewController alloc] init];
    return VC;
}

- (UIViewController *)Action_nativeSynchFetchFromChainViewController:(NSDictionary *)params {
    TDFShopIssueCenterViewController *VC = [[TDFShopIssueCenterViewController alloc] init];
    return VC;
}
@end
