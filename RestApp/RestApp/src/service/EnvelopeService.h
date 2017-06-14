//
//  SmsService.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Coupon.h"
#import "BaseService.h"

@interface EnvelopeService : BaseService

- (void)listEnvelopeDatatargetWithPage:(NSInteger)page  target:(id)target callback:(SEL)callback;


- (void)saveEnvelopeData:(Coupon *)coupon target:(id)target callback:(SEL)callback;


- (void)removeEnvelopeData:(NSInteger)couponId target:(id)target callback:(SEL)callback;
@end
