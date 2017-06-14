//
//  SmallImageItem.m
//  RestApp
//
//  Created by Shaojianqing on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSString+Estimate.h"
#import "SignBillPayTotalItem.h"
#import "FormatUtil.h"
#import "DateUtils.h"

@implementation SignBillPayTotalItem

+ (SignBillPayTotalItem *)getInstance
{
    SignBillPayTotalItem *signBillPayTotalItem = [[[NSBundle mainBundle]loadNibNamed:@"SignBillPayTotalItem" owner:self options:nil]lastObject];
    return signBillPayTotalItem;
}

- (void)initWithSignBillNoPayVO:(SignBillNoPayVO *)data
{

    self.lblFee.text = [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil), data.fee];
    self.lblTime.text = [DateUtils formatTimeWithTimestamp:data.signDate type:TDFFormatTimeTypeChineseWithTime];
    self.lblTradeNo.text = [FormatUtil formatString:data.flowno];
    self.lblSigner.text = [FormatUtil formatString:data.signMemo];
}

- (void)initWithSignBillPayDetailVO:(SignBillPayDetailVO *)data
{
    self.lblFee.text = [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil), data.fee];
    self.lblTime.text = [DateUtils formatTimeWithTimestamp:data.payTime type:   TDFFormatTimeTypeChineseWithTime];
    self.lblTradeNo.text = [FormatUtil formatString:data.flowNo];
    self.lblSigner.text = [FormatUtil formatString:data.signMemo];
}

@end
