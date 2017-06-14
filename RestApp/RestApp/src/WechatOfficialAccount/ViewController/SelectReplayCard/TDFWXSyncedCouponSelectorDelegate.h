//
//  TDFWXSyncedCouponSelectorDelegate.h
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFCardSelectorViewController.h"
@interface TDFWXSyncedCouponSelectorDelegate : NSObject <TDFCardSelectorViewControllerDelegete>
@property (strong, nonatomic) NSString *wxId;
@property (copy, nonatomic) NSInteger (^selectedIndexForCouponsBlock)(NSArray *cards);
@property (copy, nonatomic) void (^finishSelectCoupondBlock)(TDFSynchronizeCardInfoModel *card);

- (instancetype)initWithWxId:(NSString *)wxId
selectedIndexForCouponsBlock:(NSInteger(^)(NSArray *coupons))selectedIndexForCouponsBlock
     finishSelectCouponBlock:(void(^)(TDFSynchronizeCardInfoModel *card))finishSelectCoupondBlock;
@end
