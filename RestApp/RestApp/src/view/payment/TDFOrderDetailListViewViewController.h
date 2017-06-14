//
//  TDFOrderDetailListViewViewController.h
//  RestApp
//
//  Created by 栀子花 on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "TDFRootViewController.h"
#import "TDFPaymentTypeVo.h"
@interface TDFOrderDetailListViewViewController : TDFRootViewController
@property (nonatomic, strong) NSString *str;
@property (nonatomic , strong) TDFPaymentTypeVo *payment;
@property (nonatomic, assign) BOOL isShow;
@end
