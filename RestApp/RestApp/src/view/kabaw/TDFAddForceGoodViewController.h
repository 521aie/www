//
//  TDFAddForceGoodViewController.h
//  RestApp
//
//  Created by hulatang on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "TDFForceMenuVo.h"
#import "TDFMediator+KabawModule.h"
typedef void (^CallBack) (id data);
@interface TDFAddForceGoodViewController : TDFRootViewController
@property (nonatomic, strong)TDFForceMenuVo *forceMenuVo;
@property (nonatomic, assign)TDFStatus status;
@property (nonatomic, copy)CallBack callBack;
@end
