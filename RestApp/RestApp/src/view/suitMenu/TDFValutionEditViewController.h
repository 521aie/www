//
//  TDFValutionEditViewController.h
//  RestApp
//
//  Created by xueyu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//


#import "TDFRootViewController.h"
#import "TDFMenuHitRuleVo.h"
typedef void (^Callbacks)();
@interface TDFValutionEditViewController : TDFRootViewController
@property (nonatomic, strong) TDFMenuHitRuleVo *menuVo;
@property (nonatomic, copy) NSString *suitMenuId;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, copy) Callbacks callback;
@property (nonatomic, assign) BOOL isReload;
@end
 
