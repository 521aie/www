//
//  BusinessDetailPayHideBox.m
//  RestApp
//
//  Created by zxh on 14-11-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BusinessDetailPayHideBox.h"
#import "KindPayDayStatVO.h"
#import "INameValueItem.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"
#import "NumberUtil.h"
#import "UIHelper.h"

@implementation BusinessDetailPayHideBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BusinessDetailPayHideBox" owner:self options:nil];
        [self addSubview:self.view];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds=YES;
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"BusinessDetailPayHideBox" owner:self options:nil];
    [self addSubview:self.view];
    [self initUI];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds=YES;
}

- (void)initUI
{
    self.pageCount=1;
    self.scrollView.pagingEnabled=YES;
    
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.scrollsToTop=NO;
    self.scrollView.delegate=self;
    self.scrollView.tag=1;
    
    self.pageView.backgroundColor=[UIColor clearColor];
    self.pageView.numberOfPages=self.pageCount;
    
    self.pageView.currentPage=0;
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
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

-(void) loadData:(NSString*)dayName summary:(BusinessDayVO*)summary dayPay:(KindPayDayStatMainVO*)payTemp date:(NSString*)dateStr
{
    NSString *str =[NSString stringWithFormat:NSLocalizedString(@"%@日", nil),dateStr];
    self.lblDate.text=str;
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, dateStr.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path=@"icon_day.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    BOOL firstView=YES;
    for (UIView* temp in [self.scrollView subviews]) {
        if (!firstView) {
            [temp removeFromSuperview];
        }
        firstView=NO;
    }
    
    self.payMain=payTemp;
    self.pageCount=0;
    if(self.payMain!=nil && self.payMain.payList!=nil && self.payMain.payList.count>0){
        self.pageCount=(self.payMain.payList.count-1)/6+1;
    }
    self.pageCount=self.pageCount+1;
    self.pageView.numberOfPages=self.pageCount;
    [self createPages];
    self.pageView.currentPage=0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    self.scrollView.contentSize=CGSizeMake(310*self.pageCount, 108);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    if (!summary) {
        [self clearData:dayName];
        return;
    }
    self.lblName.text=dayName;
    self.lblSourceAmout.text= [self formatNumber:summary.sourceAmount];
    self.lblTotalAmout.text =[self formatNumber:summary.totalAmount];
    self.lblDiscountAmout.text=[self formatNumber:summary.discountAmount];
    self.lblProfitAmout.text=[self formatNumber:summary.profitAmount];
    self.lblBillNum.text=[self formatInt:summary.billingNum unit:NSLocalizedString(@"张", nil)];
    self.lblPeopleAmout.text=[self formatInt:summary.totalNum unit:NSLocalizedString(@"人", nil)];
    self.lblAvgAmout.text=[self formatNumber:(summary.sourceAmount-summary.discountAmount+summary.profitAmount)/summary.totalNum];

}

#pragma 滚动的翻页处理过程集合.
- (void)createPages
{
    CGRect pageRect=self.scrollView.frame;
    
    self.subViews = [[NSMutableArray alloc] init];
    [self.subViews addObject:self.totalView];
    if (self.pageCount==1) {
        return;
    }
    KindPayDayStatVO* vo;
    NSInteger pos=0;
    NSInteger count=0;
    NSInteger line=0;
    UIView* view;
    for (int i=1; i<self.pageCount; i++) {
        view=[[UIView alloc]initWithFrame:pageRect];
        
        if (i==self.pageCount-1) {
            count=self.payMain.payList.count-(self.pageCount-2)*6;
        } else {
            count=6;
        }
        line=(count-1)/3+1;
        pos=0;
        for (int p=0; p<line; p++) {
            for (int c=0; c<3; c++) {
                pos=p*3+c;
                if (pos>=count) {
                    break;
                }
                vo=[self.payMain.payList objectAtIndex:pos+(i-1)*6];
                [self createNewKindPay:vo row:p col:c view:view];
            }
        }
        
        [self.subViews addObject:view];
    }
}

- (void)createNewKindPay:(KindPayDayStatVO*)vo row:(int)row col:(int)col view:(UIView*)view
{
    UILabel* lblName=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 8+row*53, 88, 21)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=vo.name;
    lblName.textColor=[UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font= [UIFont systemFontOfSize:10];
    lblName.numberOfLines=0;
    [view addSubview:lblName];
    
    UILabel* lblVal=[[UILabel alloc]initWithFrame:CGRectMake(9+col*102, 28+row*53, 88, 21)];
    lblVal.backgroundColor=[UIColor clearColor];
    lblVal.text=[FormatUtil formatDouble3:vo.fee];
    lblVal.textColor=[UIColor whiteColor];
    lblVal.textAlignment=NSTextAlignmentLeft;
    lblVal.font= [UIFont boldSystemFontOfSize:16];
    lblVal.minimumFontSize = 10;
    lblVal.numberOfLines=0;
    [view addSubview:lblVal];
    
    if (col!=2) {
        UIView* line=[[UIView alloc] initWithFrame:CGRectMake(100+col*102, 14+row*53, 1, 35)];
        line.backgroundColor=[UIColor whiteColor];
        line.alpha = 0.300000011920929;
        [view addSubview:line];
    }
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (page < 0) {
        return;
    }
    if (page >=self.pageCount) {
        return;
    }
    
    UIView *controller = [self.subViews objectAtIndex:page];
    
    if (nil == controller.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.frame = frame;
        [self.scrollView addSubview:controller];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)sender
{
    if (self.pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageView.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

-(IBAction)pageChange:(id)sender
{
    NSInteger page = self.pageView.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGRect frame = self.scrollView.frame;
    CGRect rect = CGRectMake(pageWidth * page, 0, frame.size.width, frame.size.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
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
