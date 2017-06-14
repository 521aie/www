//
//  TDFHealthCheckAlertViewController.h
//  RestApp
//
//  Created by xueyu on 2016/12/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "TDFRootViewController.h"
#import "TDFHealthCheckDetailModel.h"
@interface TDFHealthCheckAlertViewController : UIViewController
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) TDFHealthCheckDetailModel *detailModel;

@end
