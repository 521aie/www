//
//  CouponEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Coupon.h"
#import <UIKit/UIKit.h>
#import "DataBarChart.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "INavigateEvent.h"
#import "EnvelopeService.h"
#import "MessageBoxClient.h"

@class MarketModule;
@interface EnvelopeDetailView : UIViewController<INavigateEvent, MessageBoxClient>
{
    MarketModule *parent;
    
    EnvelopeService *service;
    
    MBProgressHUD *hud;
    
    Coupon *coupon;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UILabel *shopNameLbl;
@property (nonatomic, strong) IBOutlet UILabel *priceLbl;
@property (nonatomic, strong) IBOutlet UILabel *unitLbl;
@property (nonatomic, strong) IBOutlet UILabel *envelopPriceLbl;
@property (nonatomic, strong) IBOutlet UILabel *expandLbl;
@property (nonatomic, strong) IBOutlet UILabel *publishNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *usageShopLbl;
@property (nonatomic, strong) IBOutlet UILabel *expandRuleLbl;
@property (nonatomic, strong) IBOutlet UILabel *periodLbl;
@property (nonatomic, strong) IBOutlet UILabel *statusLbl;
@property (nonatomic, strong) IBOutlet UIImageView *statusImg;
@property (nonatomic, strong) IBOutlet UIView *summaryContainer;
@property (nonatomic, strong) IBOutlet UILabel *envelopePeriodLbl;
@property (nonatomic, strong) IBOutlet UILabel *envelopePublishLbl;
@property (nonatomic, strong) IBOutlet UILabel *envelopeDeliverLbl;
@property (nonatomic, strong) IBOutlet UILabel *envelopeTitleLbl;
@property (nonatomic, strong) IBOutlet UIView *detailInfoContainer;
@property (nonatomic, strong) IBOutlet UIView *summaryInfoContainer;
@property (nonatomic, strong) IBOutlet DataBarChart *usageBarChart;
@property (nonatomic, strong) IBOutlet DataBarChart *sendBarChart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;

- (void)loadData:(NSInteger)couponId;

- (IBAction)shareWeixinFriend:(id)sender;

- (IBAction)shareWeixinLine:(id)sender;

- (IBAction)showCodeImage:(id)sender;

- (IBAction)sharePasteboard:(id)sender;

@end
