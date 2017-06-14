//
//  TDFPaymentStatusViewController.h
//  RestApp
//
//  Created by 栀子花 on 2016/11/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "TDFRootViewController.h"

@interface TDFPaymentStatusViewController : TDFRootViewController


@property (nonatomic,assign)NSInteger status;
@property (nonatomic, strong)NSArray *menus;
@end
