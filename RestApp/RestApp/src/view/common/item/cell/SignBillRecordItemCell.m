//
//  MenuTimePriceCell.m
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillRecordItemCell.h"
#import "SignBillDetailView.h"
#import "MenuTimePrice.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "FormatUtil.h"
#import "DateUtils.h"

@implementation SignBillRecordItemCell

- (void)initWithData:(SignBill *)data target:(SignBillRecordView *)target;
{
    if (data != nil) {
        signBillRecordView = target;
        [self.lblStatus.layer setBorderWidth:1.0];
        [self.lblStatus.layer setCornerRadius:4.0];
        [self.lblStatus.layer setBorderColor:[UIColor colorWithRed:30.0/255.0 green:155.0/255.0 blue:57.0/255.0 alpha:1.0 ].CGColor];
        self.lblFee.text = [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil), data.realFee];
        self.lblTime.text = [DateUtils formatTimeWithTimestamp:data.payTime type:TDFFormatTimeTypeChinese];
        
        self.lblSigner.text = [FormatUtil formatString:data.company];
    }
}

@end
