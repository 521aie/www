//
//  TDFKindPayAddCouponViewController.h
//  RestApp
//
//  Created by chaiweiwei on 2017/2/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFVoucher.h"

@interface TDFKindPayAddCouponViewController : TDFRootViewController

@property (nonatomic,copy) NSString *kindPayId;
@property (nonatomic,copy) NSArray *voucherList;

@property (nonatomic,copy) void (^addCouponCallBack)(TDFVoucher *voucherVo);

@end
