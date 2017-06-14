//
//  MenuTimePriceCell.m
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillNoPayItemCell.h"
#import "SignBillDetailView.h"
#import "MenuTimePrice.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "FormatUtil.h"
#import "DateUtils.h"

@implementation SignBillNoPayItemCell

- (void)initWithData:(SignBillNoPayVO *)data payIdSet:(NSArray *)payIdSet target:(SignBillDetailView *)target
{
    self.data = data;
    if (data != nil) {
        signBillDetailView = target;

        self.lblFee.text = [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil), self.data.fee];
        self.lblTime.text = [DateUtils formatTimeWithTimestamp:self.data.signDate type:TDFFormatTimeTypeChineseWithTime];

        self.lblTradeNo.text = [FormatUtil formatString2:self.data.flowno];
        self.lblSigner.text = [FormatUtil formatString2:self.data.signMemo];
        [self.lblStatus.layer setBorderWidth:1.0];
        [self.lblStatus.layer setCornerRadius:4.0];
        [self.lblStatus.layer setBorderColor:[UIColor redColor].CGColor];
        if (payIdSet!=nil && [payIdSet containsObject:data.payId]) {
            self.imgSelect.image = [UIImage imageNamed:@"ico_check.png"];
        } else {
            self.imgSelect.image = [UIImage imageNamed:@"ico_uncheck.png"];
        }
    }
}

- (IBAction)selectBtnClick:(id)sender
{
    if ([signBillDetailView isSelectItem:self.data.payId]) {
        [signBillDetailView deSelectItem:self.data.payId];
        self.imgSelect.image = [UIImage imageNamed:@"ico_uncheck.png"];
    } else {
        [signBillDetailView selectItem:self.data.payId];
        self.imgSelect.image = [UIImage imageNamed:@"ico_check.png"];
    }
}

- (IBAction)itemBtnClick:(id)sender
{
    [signBillDetailView selectSignBill:self.data];
}

@end
