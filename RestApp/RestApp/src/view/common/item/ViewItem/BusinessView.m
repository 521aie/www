//
//  BusinessView.m
//  RestApp
//
//  Created by zxh on 14-8-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NumberUtil.h"
#import "BusinessView.h"
#import "BusinessSummaryVO.h"

@implementation BusinessView

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"BusinessView" owner:self options:nil];
    [self addSubview:self.view];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds=YES;
}

-(void) clearData:(NSString*)dayName
{
    self.lblName.text=dayName;
    self.lblTotalAmout.text=NSLocalizedString(@"实收: -", nil);
    self.lblDiscountAmout.text=NSLocalizedString(@"折扣: -", nil);
    self.lblProfitAmout.text=NSLocalizedString(@"损益: -", nil);
    self.lblBillNum.text=NSLocalizedString(@"开单: -", nil);
    self.lblPeopleAmout.text=NSLocalizedString(@"人数: -", nil);
    self.lblAvgAmout.text=NSLocalizedString(@"人均: -", nil);
}

-(void) loadData:(NSString*)dayName summary:(BusinessSummaryVO*)summary
{
    self.lblName.text=dayName;
    self.lblTotalAmout.text=[NSString stringWithFormat:NSLocalizedString(@"实收: %@", nil), [self formatNumber:summary.totalAmount]];
    self.lblDiscountAmout.text=[NSString stringWithFormat:NSLocalizedString(@"折扣: %@", nil), [self formatNumber:summary.discountAmount]];
    self.lblProfitAmout.text=[NSString stringWithFormat:NSLocalizedString(@"损益: %@", nil), [self formatNumber:summary.profitAmount]];
    self.lblBillNum.text=[NSString stringWithFormat:NSLocalizedString(@"开单: %@", nil), [self formatInt:summary.billingNum unit:NSLocalizedString(@"张", nil)]];
    self.lblPeopleAmout.text=[NSString stringWithFormat:NSLocalizedString(@"人数: %@", nil), [self formatInt:summary.totalNum unit:NSLocalizedString(@"人", nil)]];
    self.lblAvgAmout.text=[NSString stringWithFormat:NSLocalizedString(@"人均: %@", nil), [self formatNumber:summary.aveConsume]];
}

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:NSLocalizedString(@"%0.2f元", nil),value];
    }
    return @"-";
}

- (NSString *)formatInt:(int)value unit:(NSString*)unit
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:@"%d%@",value,unit];
    }
    return @"-";
}

@end
