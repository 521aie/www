//
//  ChainBusDetailBoxView.h
//  RestApp
//
//  Created by iOS香肠 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KindPayDayStatMainVO.h"
#import "ChainBusinessStatisticsDay.h"
#import "ShopStatisticsMonthVo.h"
#import "ShopStatisticsDayVo.h"
#import "BusinessStatisticsVo.h"
#import "BusinessStatisticsVoList.h"
#import "ChainBusinessStatisticsMonth.h"

@class KindPayDayVO,BusinessSummaryVO ,BusinessStatisticsVo;
@interface ChainBusDetailBoxView : UIView

@property (nonatomic, strong) IBOutlet UIView *View;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *numContainer;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblSourceAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblProfitAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblBillNum;
@property (nonatomic, strong) IBOutlet UILabel *lblPeopleAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgAmout;
@property (nonatomic, strong) IBOutlet UIImageView *imgType;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIView* kindPayBox;
@property (weak, nonatomic) IBOutlet UILabel *monthlbl;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *totalStoreTitle;
@property (nonatomic, strong)KindPayDayStatMainVO *payMain;
@property (nonatomic ,strong) NSString *currentMonth;
@property (nonatomic ,strong) NSString *currentyear;
//控件初始化.
- (void)clearData:(NSString*)dayName;

//数据加载.

-(void) loadData:(NSString*)dayName summary:(BusinessStatisticsVo*)summary pays:(NSMutableArray*)pays date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum isday:(BOOL)isday;

-(void) loadDataMonth:(NSString*)dayName summary:(ChainBusinessStatisticsMonth*)summary shopPay:(ShopStatisticsMonthVo *)shopPay date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum;

-(void) loadDataBranch:(NSString*)dayName summary:(ChainBusinessStatisticsDay*)summary shopPay:(ShopStatisticsDayVo *)shopPay date:(NSString*)dateStr storeNme:(NSString *)storeNme totalStoresNum:(NSString *)totalStoresNum;
@end
