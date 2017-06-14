//
//  BusinessPayDetailBox.m
//  RestApp
//
//  Created by zxh on 14-11-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NumberUtil.h"
#import "FormatUtil.h"
#import "FormatUtil.h"
#import "UIView+Sizes.h"
#import "KindPayDayVO.h"
#import "BusinessDayVO.h"
#import "NSString+Estimate.h"
#import "BusinessPayDetailBox.h"

@implementation BusinessPayDetailBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BusinessPayDetailBox" owner:self options:nil];
        [self addSubview:self.view];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds=YES;
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"BusinessPayDetailBox" owner:self options:nil];
    [self addSubview:self.view];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds=YES;
}

-(void) clearData:(NSString*)dayName
{
    self.lblName.text=dayName;
    self.lblSourceAmout.text=@" -";
    self.lblTotalAmout.text=@" -";
    
    self.lblDiscountAmout.text=@" -";
    self.lblProfitAmout.text=@" -";
    self.lblBillNum.text=@" -";
    self.lblPeopleAmout.text=@" -";
    self.lblAvgAmout.text=@" -";
}

-(void) loadData:(NSString*)dayName summary:(BusinessDayVO*)summary pays:(NSMutableArray*)pays date:(NSString*)dateStr
{
    NSRange range =[dayName rangeOfString:NSLocalizedString(@"月", nil)];
    self.lblDate.text =[dayName substringToIndex:range.location+range.length];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,self.lblDate.text.length-range.length)];
    self.lblDate.attributedText =aAttributedString;
     NSString* path =@"icon_month.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    [self removeKindPaySubViews];
    if (!summary) {
        [self clearData:dayName];
        return;
    }
    self.lblName.text=dayName;
    self.lblSourceAmout.text=[self formatNumber:summary.sourceAmount];
    self.lblTotalAmout.text =[self formatNumber:summary.totalAmount];
    self.lblDiscountAmout.text=[self formatNumber:summary.discountAmount];
    self.lblProfitAmout.text=[self formatNumber:summary.profitAmount];
    self.lblBillNum.text=[self formatInt:summary.billingNum unit:NSLocalizedString(@"张", nil)];
    self.lblPeopleAmout.text=[self formatInt:summary.totalNum unit:NSLocalizedString(@"人", nil)];
    self.lblAvgAmout.text=[self formatNumber:(summary.sourceAmount-summary.discountAmount+summary.profitAmount)/summary.totalNum];
    
    NSInteger count=0;
    if (pays!=nil && pays.count>0) {
        count=pays.count;
    }
    NSInteger line=(count-1)/3+1;
    NSInteger boxHeight=(191 +line*53+17);
    [self.view setHeight:boxHeight];
    [self.kindPayBox setHeight:line*80];
    [self setHeight:boxHeight];
    [self.bgView setHeight:boxHeight];
    
    KindPayDayVO* vo;
    int pos=0;
    for (int p=0; p<line; p++) {
        for (int i=0; i<3; i++) {
            pos=p*3+i;
            if (pos>=count) {
                break;
            }
            vo=[pays objectAtIndex:(p*3+i)];
            [self createNewKindPay:vo row:p col:i];
        }
    }
}

- (void)createNewKindPay:(KindPayDayVO*)vo row:(NSInteger)row col:(NSInteger)col
{
    UILabel* lblName=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, row*53, 88, 21)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=vo.name;
    lblName.textColor=[UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font= [UIFont systemFontOfSize:10];
    lblName.numberOfLines=0;
    [self.kindPayBox addSubview:lblName];
    
    UILabel* lblVal=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 20+row*53, 88, 21)];
    lblVal.backgroundColor=[UIColor clearColor];
    lblVal.text=[FormatUtil formatDouble3:vo.fee];
    lblVal.textColor=[UIColor whiteColor];
    lblVal.textAlignment=NSTextAlignmentLeft;
    lblVal.font= [UIFont boldSystemFontOfSize:15];
    lblVal.numberOfLines=0;
    [self.kindPayBox addSubview:lblVal];
    
    if (col!=2) {
        UIView* line=[[UIView alloc] initWithFrame:CGRectMake(100+col*102, row*53, 1, 35)];
        line.backgroundColor=[UIColor whiteColor];
        line.alpha = 0.300000011920929;
        [self.kindPayBox addSubview:line];
    }
}

//移除所有的子视图从支付类型容器里.
- (void)removeKindPaySubViews
{
    for (UIView* view in [self.kindPayBox subviews]) {
        [view removeFromSuperview];
    }
}

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatDoubleWithSeperator:value];
    }
    return @"-";
}

- (NSString *)formatInt:(int)value unit:(NSString*)unit
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatIntWithSeperator:value];
    }
    return @"-";
}

@end
