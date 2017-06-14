//
//  TDFSmartOrderController.h
//  RestApp
//
//  Created by BK_G on 2017/1/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

typedef void(^SmartBlock)();

@interface TDFSmartOrderController : TDFRootViewController

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) SmartBlock callBack;

@end
