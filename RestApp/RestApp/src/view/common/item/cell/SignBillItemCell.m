//
//  MenuTimePriceCell.m
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillItemCell.h"
#import "MenuTimePrice.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "FormatUtil.h"

@implementation SignBillItemCell

- (void)initWithData:(SignBillPayNoPayOptionTotalVO *)data
{
    self.data = data;
    if (data != nil) {
        self.lblName.text = [FormatUtil formatString2:self.data.name];
        [self.lblStatus.layer setBorderWidth:1.0];
        [self.lblStatus.layer setCornerRadius:4.0];
        [self.lblStatus.layer setBorderColor:[UIColor redColor].CGColor];
        self.lblCount.text = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil), (unsigned long)self.data.payCount];
        self.lblAmount.text = [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil), self.data.fee];
    }
}

@end
