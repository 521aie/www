//
//  PaymentTypeView.h
//  RestApp
//
//  Created by xueyu on 16/4/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
#import "NavButton.h"
#import "NavigateTitle2.h"
#import "PaymentModule.h"
#import "ShopInfoVO.h"
#import <libextobjc/EXTScope.h>
#import "TDFPaymentService.h"
#import "TDFRootViewController.h"
@interface PaymentTypeView : TDFRootViewController<INavigateEvent>
{
    PaymentModule *parent;
}


@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (nonatomic, strong) NavigateTitle2 *titleBox;

@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *unAcount;

@property (strong, nonatomic) UILabel *dayIncomeTitle;

@property (strong, nonatomic) UILabel *dayIncome;

@property (strong, nonatomic) UILabel *dayAcountTitle;

@property (strong, nonatomic) UILabel *dayAcount;

@property (strong, nonatomic) UILabel *rate;

@property (strong, nonatomic) UILabel *monthIncome;

@property (strong, nonatomic) UILabel *monthAcount;

@property (strong, nonatomic) UIView *sumPanel;

@property (strong, nonatomic) UIView *feePanel;

@property (strong, nonatomic) UIView *sumBackView;

@property (strong, nonatomic) UIView *unbindingView;

@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UITextView *bindingView;

@property (strong, nonatomic) UIView *buttonsPanel;

@property (strong, nonatomic) UIButton *buttonBank;
@property (weak, nonatomic) IBOutlet NavButton2 *bindingAccountBtn;

@property (nonatomic, strong)ShopInfoVO *shopInfo;

@property (nonatomic, strong)NSString *date;

@property (nonatomic, strong)NSArray *menus;
@property (nonatomic, strong)NSArray *codeArray;
@property (nonatomic, strong)NSArray *childFunctionArr;
@property (strong, nonatomic) UILabel *totalUnCountMoneyLabel;

@property (strong, nonatomic) UILabel *monthIncomeMonryLabel;

@property (strong, nonatomic) UITextView *unBindTipTextView;
@property (nonatomic ,strong) NSString *reChargeLabel;
@property (nonatomic, strong) HomeView *homeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parent;
-(void)initData:(ShopInfoVO *)shopInfo menu:(NSArray *)menus;
-(void)loadData;
@end
