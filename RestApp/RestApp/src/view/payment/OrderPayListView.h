//
//  OrderPayListView.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChartItem.h"
#import "MJRefresh.h"
#import "SNChart.h"
#import "ShopInfoVO.h"
#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "XHAnimalUtil.h"
#import "EditItemView.h"
#import "RemoteResult.h"
#import "BusinessDayVO.h"
#import "MBProgressHUD.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "OrderPayListData.h"
#import "DatePickerClient.h"
#import "ISampleListEvent.h"
#import "IEditItemListEvent.h"
#import "TDFPaymentTypeVo.h"
#import "MJRefreshStateHeader.h"
#import "PayBillSummaryOfMonthVO.h"
#import "HomeView.h"
#import "NavButton.h"
@class PaymentModule,HomeView;
@interface OrderPayListView : TDFRootViewController<INavigateEvent,FooterListEvent>

{
    PaymentModule *parent;
    RemoteResult *paymentResult;
    RemoteResult *totalBillResult;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (strong, nonatomic) UILabel *unAccount;
@property (strong, nonatomic) UILabel *totalIncome;
@property (nonatomic, strong) UILabel *unAccountFeeLbl;
@property (nonatomic, strong) UIView *unBindView;
@property (nonatomic, strong) UITextView *lblHint;
@property (nonatomic, strong) UIButton *bindBtn;
@property (strong, nonatomic) UITextView *bindView;
@property (nonatomic, strong) UIView *accountContainer;
@property (strong, nonatomic) UILabel *warningTip;
@property (nonatomic, strong)NSArray *codeArray;
@property (nonatomic, strong)NSArray *childFunctionArr;
@property (nonatomic, strong) UIView *chartContainer;
@property (strong, nonatomic) NavButton3 *dateBtn;
@property (strong, nonatomic) UIView *chartView;
@property (strong, nonatomic) UIButton *consumeTxt;
@property (strong, nonatomic) UIButton *rechargeTxt;
@property (nonatomic, strong) UILabel *dailyReceiveLbl;
@property (nonatomic, strong) UILabel *dailyAccountLbl;
@property (nonatomic, strong) UILabel *dailyReceiveFeeLbl;
@property (nonatomic, strong) UILabel *dailyAccountFeeLbl;
@property (nonatomic, strong) UILabel *dailyAccountInfoLbl;
@property (nonatomic, strong) UILabel *monthReceiveFeeLbl;
@property (nonatomic, strong) UILabel *monthAccountFeeLbl;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *lblDayRight;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *imgMonthShow;
@property (nonatomic, strong) UIView *orderContainer;//当日营业流水容器.
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableDictionary *dayDic;  //日数据字典表.
@property (strong, nonatomic) UIView *paymentMethodLabel;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
//@property (nonatomic, assign) BOOL isAccount;
@property (nonatomic, strong) TDFPaymentTypeVo *payment;
@property (nonatomic, assign) BOOL isBackMenu;
@property (nonatomic, assign) NSInteger currYear;    //当前年.
@property (nonatomic, assign) NSInteger currMonth;   //当年月份.
@property (nonatomic, assign) NSInteger currDay;     //当前日期.
@property (nonatomic, strong) NSString *reChargeLabel;
@property (nonatomic, strong) HomeView *homeView;
@property (weak, nonatomic) IBOutlet NavButton2 *bankAccoutBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp;
-(void)loadShopInfo;
- (IBAction)btnMonthShowClick:(UIButton *)sender;
@end
