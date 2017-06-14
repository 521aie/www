//
//  ChainBusDetailBoxView.m
//  RestApp
//
//  Created by iOS香肠 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "NumberUtil.h"
#import "FormatUtil.h"
#import "FormatUtil.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"
#import "KindPayDayVO.h"
#import "BusinessDayVO.h"
#import "KindPayDayStatVO.h"
#import "NSString+Estimate.h"
#import "BusinessPayDetailBox.h"
#import "BusinessStatisticsVo.h"
#import "BusinessStatisticsVoList.h"
#import "ChainBusDetailBoxView.h"

@implementation ChainBusDetailBoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ChainBusDetailBoxView" owner:self options:nil];
        self.View.frame=CGRectMake(0, 0, SCREEN_WIDTH, 350);
        [self addSubview:self.View];
        self.layer.cornerRadius =5;
        self.layer.masksToBounds=YES;
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ChainBusDetailBoxView" owner:self options:nil];
    self.frame=CGRectMake(0, SCREEN_HEIGHT-350, SCREEN_WIDTH, 350);
    self.View.frame=CGRectMake(0, 0, SCREEN_WIDTH, 350);
    [self addSubview:self.View];
    
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

-(void) loadDataMonth:(NSString*)dayName summary:(ChainBusinessStatisticsMonth*)summary shopPay:(ShopStatisticsMonthVo *)shopPay date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum
{
    [self removeKindPaySubViews];
    self.lblSubTitle.text = storeNme;
    self.totalStoreTitle.text = totalStoresNum;
    NSRange range =[dayName rangeOfString:NSLocalizedString(@"月", nil)];
    self.lblDate.text =[dayName substringToIndex:range.location+range.length];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,self.lblDate.text.length-range.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path =@"icon_month.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (!summary) {
        [self clearData:dayName];
    }
    self.lblName.text=dayName;
    self.lblSourceAmout.text=[self formatNumber:summary.sourceAmount];
    if (summary == nil) {
        self.lblTotalAmout.text = @"-";
    }else{
        if ([self formatNumber:summary.actualAmount].integerValue >= 0  ) {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"+%@",[self formatNumber:summary.actualAmount]];
        }
        else if ([self formatNumber:summary.actualAmount].integerValue < 0 )
        {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"%@",[self formatNumber:summary.actualAmount]];
        }
    }
    [self.lblAvgAmout sizeToFit];
    self.lblDiscountAmout.text=[self formatNumber:summary.discountAmount];
    self.lblProfitAmout.text=[self formatNumber:summary.profitLossAmount];
    self.lblBillNum.text=[self formatInt:summary.orderCount unit:NSLocalizedString(@"张", nil)];
    self.lblPeopleAmout.text=[self formatInt:summary.mealsCount unit:NSLocalizedString(@"人", nil)];
    self.lblAvgAmout.text=[self formatNumber:summary.actualAmountAvg];
    
    NSArray *pays = shopPay.paymentVoList;
    NSInteger count=0;
    if (pays!=nil && pays.count>0) {
        count=pays.count;
    }
    NSInteger line=(count-1)/3+1;
    NSInteger boxHeight;
    if (!count==0) {
        boxHeight =(191+line*53+17+40);
    }
    else
    {
        boxHeight =(191+line*53+17);
    }
    [self.View setHeight:boxHeight];
    [self.kindPayBox setHeight:line*80];
    [self setHeight:boxHeight];
    [self.bgView setHeight:boxHeight];
    
    NSMutableDictionary* dic;
    int pos=0;
    for (int p=0; p<line; p++) {
        for (int i=0; i<3; i++) {
            pos=p*3+i;
            if (pos>=count) {
                break;
            }
            dic = [pays objectAtIndex:(p*3+i)];
            ChainPaymentStatisticsMonth *vo = [[ChainPaymentStatisticsMonth alloc] initWithDictionary:dic];
            [self createNewKindPayMonth:vo row:p col:i];
        }
    }
}

- (void)createNewKindPayMonth:(ChainPaymentStatisticsMonth*)vo row:(NSInteger)row col:(NSInteger)col
{
    UILabel* lblName=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, row*53, 88, 21)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text= vo.payKindName;
    lblName.textColor=[UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font= [UIFont systemFontOfSize:10];
    lblName.numberOfLines=0;
    [self.kindPayBox addSubview:lblName];
    UILabel* lblVal=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 20+row*53, 88, 21)];
    lblVal.backgroundColor=[UIColor clearColor];
    lblVal.text=[FormatUtil formatDouble3:vo.payAmount];
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

-(void) loadDataBranch:(NSString*)dayName summary:(ChainBusinessStatisticsDay*)summary shopPay:(ShopStatisticsDayVo *)shopPay date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum

{
    [self removeKindPaySubViews];
    self.lblSubTitle.text = storeNme;
    self.totalStoreTitle.text = totalStoresNum;
    NSString *str;
    NSRange range =[dayName rangeOfString:NSLocalizedString(@"月", nil)];
    NSRange rang1 =[dayName rangeOfString:NSLocalizedString(@"日", nil)];
    str =[dayName substringWithRange:NSMakeRange(range.location +range.length, rang1.location-1)];
    NSRange rang2 =[str rangeOfString:NSLocalizedString(@"日", nil)];
    
    NSString *detestr =[str substringToIndex:rang2.location];
    detestr =[NSString stringWithFormat:NSLocalizedString(@"%@日", nil),detestr];
    self.lblDate.text=detestr;
    self.monthlbl.text =[DateUtils getWeek1:dateStr];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,self.lblDate.text.length-1)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path=@"icon_day.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (!summary) {
        [self clearData:dayName];
        // return;
    }
    
    self.lblName.text=dayName;
    [self removeKindPaySubViews];
    self.lblSourceAmout.text=[self formatNumber:summary.sourceAmount];
    if (summary == nil) {
        self.lblTotalAmout.text = @"-";
    }else{
        if ([self formatNumber:summary.actualAmount].integerValue >= 0  ) {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"+%@",[self formatNumber:summary.actualAmount]];
        }
        else if ([self formatNumber:summary.actualAmount].integerValue < 0 )
        {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"%@",[self formatNumber:summary.actualAmount]];
        }
        NSMutableAttributedString * aAttributedString1 = [[NSMutableAttributedString alloc] initWithString:self.lblTotalAmout.text];
        [aAttributedString1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28] range:NSMakeRange(0,[self formatNumber:summary.actualAmount].length+1)];
        self.lblTotalAmout.attributedText =aAttributedString1;
    }
    [self.lblAvgAmout sizeToFit];
    self.lblDiscountAmout.text=[self formatNumber:summary.discountAmount];
    self.lblProfitAmout.text=[self formatNumber:summary.profitLossAmount];
    self.lblBillNum.text=[self formatInt:summary.orderCount unit:NSLocalizedString(@"张", nil)];
    self.lblPeopleAmout.text=[self formatInt:summary.mealsCount unit:NSLocalizedString(@"人", nil)];
    self.lblAvgAmout.text=[self formatNumber:summary.actualAmountAvg];
    
    NSArray *pays = shopPay.paymentVoList;
    NSInteger count=0;
    if (pays!=nil && pays.count>0) {
        count=pays.count;
    }
    NSInteger line=(count-1)/3+1;
    NSInteger boxHeight;
    if (!count==0) {
        boxHeight =(191+line*53+17+40);
    }
    else
    {
        boxHeight =(191+line*53+17);
    }
    [self.View setHeight:boxHeight];
    [self.kindPayBox setHeight:line*80];
    [self setHeight:boxHeight];
    [self.bgView setHeight:boxHeight];
    
    NSMutableDictionary* dic;
    int pos=0;
    for (int p=0; p<line; p++) {
        for (int i=0; i<3; i++) {
            pos=p*3+i;
            if (pos>=count) {
                break;
            }
            dic = [pays objectAtIndex:(p*3+i)];
            ChainPaymentStatisticsDay *vo = [[ChainPaymentStatisticsDay alloc] initWithDictionary:dic];
            [self createNewKindPayDay:vo row:p col:i];
        }
    }
    
    
}

- (void)createNewKindPayDay:(ChainPaymentStatisticsDay*)vo row:(NSInteger)row col:(NSInteger)col
{
    UILabel* lblName=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, row*53, 88, 21)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text= vo.payKindName;
    lblName.textColor=[UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font= [UIFont systemFontOfSize:10];
    lblName.numberOfLines=0;
    [self.kindPayBox addSubview:lblName];
    UILabel* lblVal=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 20+row*53, 88, 21)];
    lblVal.backgroundColor=[UIColor clearColor];
    lblVal.text=[FormatUtil formatDouble3:vo.payAmount];
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

-(void) loadData:(NSString*)dayName summary:(BusinessStatisticsVo*)summary pays:(NSMutableArray*)pays date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum isday:(BOOL)isday
{
   
    self.lblSubTitle.text = storeNme;
    self.totalStoreTitle.text = totalStoresNum;
    if (isday) {
        NSString *str =[dateStr substringFromIndex:6];
        NSString *str1 =[NSString stringWithFormat:@"%ld",str.integerValue];
        self.lblDate.text =[NSString stringWithFormat:NSLocalizedString(@"%@日", nil),str1] ;
        self.currentyear =[dateStr substringToIndex:4];
        self.currentMonth =[dateStr substringWithRange:NSMakeRange(4, 2)];
        self.monthlbl.text =[DateUtils getWeeKName:[self convertWeek:str.integerValue]];
         self.monthlbl.hidden =NO;
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
        [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,str1.length)];
        self.lblDate.attributedText =aAttributedString;
        NSString* path =@"icon_day.png";
        [self.imgType setImage:[UIImage imageNamed:path]];
    }
    else
    {
   
    self.lblDate.text =[NSString stringWithFormat:NSLocalizedString(@"%@月", nil),dateStr];
    self.monthlbl.hidden =YES;
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,dateStr.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path =@"icon_month.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    }
    if (!summary) {
        [self clearData:dayName];
    }
    [self removeKindPaySubViews];
    self.lblName.text=dayName;
    self.lblSourceAmout.text=[self formatNumber:summary.sourceAmount];
    if (summary == nil) {
        self.lblTotalAmout.text = @"-";
    }else{
        if ([self formatNumber:summary.actualAmount].integerValue >= 0  ) {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"+%@",[self formatNumber:summary.actualAmount]];
        }
        else if ([self formatNumber:summary.actualAmount].integerValue < 0 )
        {
            self.lblTotalAmout.text =[NSString stringWithFormat:@"%@",[self formatNumber:summary.actualAmount]];
        }
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblTotalAmout.text];
        [aAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28] range:NSMakeRange(0,[self formatNumber:summary.actualAmount].length+1)];
        self.lblTotalAmout.attributedText =aAttributedString;
    }
     [self.lblAvgAmout sizeToFit];
    self.lblDiscountAmout.text=[self formatNumber:summary.discountAmount];
    self.lblProfitAmout.text=[self formatNumber:summary.profitLossAmount];
    self.lblBillNum.text=[self formatInt:summary.orderCount unit:NSLocalizedString(@"张", nil)];
    self.lblPeopleAmout.text=[self formatInt:summary.mealsCount unit:NSLocalizedString(@"人", nil)];
    self.lblAvgAmout.text=[self formatNumber:summary.actualAmountAvg];
    
    NSInteger count=0;
    if (pays!=nil && pays.count>0) {
        count=pays.count;
    }
    NSInteger line=(count-1)/3+1;
    NSInteger boxHeight;
    if (!count==0) {
        boxHeight =(191+line*53+17+40);
    }
    else
    {
        boxHeight =(191+line*53+17);
    }
    [self.View setHeight:boxHeight];
    [self.kindPayBox setHeight:line*80];
    [self setHeight:boxHeight];
    [self.bgView setHeight:boxHeight];
    NSMutableDictionary *vo;
    int pos=0;
    for (int p=0; p<line; p++) {
        for (int i=0; i<3; i++) {
            pos=p*3+i;
            if (pos>=count) {
                break;
            }
            vo=[pays objectAtIndex:(p*3+i)];
            BusinessStatisticsVoList *busVOList =[[BusinessStatisticsVoList alloc]initWithDictionary:vo];
            [self createNewKindPay1:busVOList row:p col:i];
        }
    }
}

- (void)createNewKindPay1:(BusinessStatisticsVoList*)vo row:(NSInteger)row col:(NSInteger)col
{
    UILabel* lblName=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, row*53, 88, 21)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=[NSString stringWithFormat:@"%@",vo.payKindName];
    lblName.textColor=[UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font= [UIFont systemFontOfSize:10];
    lblName.numberOfLines=0;
    [self.kindPayBox addSubview:lblName];
    UILabel* lblVal=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 20+row*53, 88, 21)];
    lblVal.backgroundColor=[UIColor clearColor];
    lblVal.text=[FormatUtil formatDouble3:vo.payAmount];
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

- (NSInteger)convertWeek:(NSInteger)day
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[self convertDate:day]];
    return [comps weekday];
}

- (NSDate*)convertDate:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:self.currentMonth.integerValue];
    [comps setDay:day];
    [comps setYear:self.currentyear.integerValue];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar dateFromComponents:comps];
}


@end
