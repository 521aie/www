//
//  SignBillHeadItem.m
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillHeadItem.h"
#import "KindPay.h"

@implementation SignBillHeadItem

- (void)initWithData:(KindPay *)kindPayData
{
    kindPay = kindPayData;
    self.lblName.text=kindPay.name;
}

@end
