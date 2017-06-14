//
//  SignBillHeadItem.h
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindPay.h"

@interface SignBillHeadItem : UIView
{
    KindPay *kindPay;
}

@property (nonatomic, retain) IBOutlet UIView *panel;
@property (nonatomic, retain) IBOutlet UILabel *lblName;

- (void)initWithData:(KindPay *)kindPay;

@end
