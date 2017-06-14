//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "Platform.h"
#import "UIHelper.h"
#import "ImageBox.h"
#import "CouponSum.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "CouponRule.h"
#import "JsonHelper.h"
#import "CouponShop.h"
#import "MessageBox.h"
#import "RemoteEvent.h"
#import "DataBarItem.h"
#import "SystemEvent.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "MarketModule.h"
#import "RestConstants.h"
#import "EventConstants.h"
#import "ServiceFactory.h"
#import "TDFKabawService.h"
#import "QRCodeGenerator.h"
#import "EnvelopeDetailView.h"
#import "UMSocialWechatHandler.h"

@implementation EnvelopeDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].envelopeService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self initMainView];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"红包详情", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_DELETE];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:ENVELOPE_LIST_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
    } else if (event==DIRECT_RIGHT) {
        [self removeEnvelope];
    }
}

- (void)initMainView
{
    [self.usageBarChart initWithAppearance:[UIColor clearColor]];
    [self.sendBarChart initWithAppearance:[UIColor clearColor]];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)loadData:(NSInteger)couponId
{
    [[TDFKabawService new] getEnvelopeDetailById:couponId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        
        NSDictionary *dictionary = [data objectForKey:@"data"];
        coupon = [Coupon convertToCoupon:dictionary];
        
        [self renderEnvelopeDetailInfo];
        [self renderEnvelopeSummaryInfo];
        
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

-(void) loadFinish:(RemoteResult*) result
{
    [hud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) deleteFinish:(RemoteResult*) result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [parent showView:ENVELOPE_LIST_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
    [parent.envelopeListView loadDatas];
}

- (void)remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSDictionary *dictionary = [map objectForKey:@"data"];
    coupon = [Coupon convertToCoupon:dictionary];
    
    [self renderEnvelopeDetailInfo];
    [self renderEnvelopeSummaryInfo];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)renderEnvelopeDetailInfo
{
    self.priceLbl.text = [NSString stringWithFormat:@"%0.0f", coupon.price];
    self.envelopPriceLbl.text = [NSString stringWithFormat:NSLocalizedString(@"红包面额：%0.0f元", nil), coupon.price];
    self.publishNumLbl.text = [NSString stringWithFormat:NSLocalizedString(@"发行数量：%ld个", nil), (long)coupon.totalQuantity];
    self.envelopePeriodLbl.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至%@", nil), [DateUtils formatTimeWithTimestamp:coupon.endTime type:TDFFormatTimeTypeChineseWithWeek]];
    self.envelopePublishLbl.text = [NSString stringWithFormat:NSLocalizedString(@"已领取%li个,已使用%li个", nil), (long)coupon.receiveQuantity, (long)coupon.useQuantity];
    self.expandRuleLbl.text = [NSString stringWithFormat:NSLocalizedString(@"使用规则：消费满%0.0f元可使用", nil), coupon.consumeMoney];
    self.periodLbl.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至：%@", nil), [DateUtils formatTimeWithTimestamp:coupon.endTime type:TDFFormatTimeTypeChineseWithWeek]];
    
    if (coupon.receiveQuantity>=coupon.totalQuantity) {
        self.statusLbl.text = NSLocalizedString(@"已领完", nil);
        self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
        self.priceLbl.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
        self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
    } else {
        if (coupon.status==STATUS_COUPON_NORMAL) {
            self.statusLbl.text = NSLocalizedString(@"可领取", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_icon.png"];
            self.priceLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:34.0/255.0 alpha:1.0];
        } else if (coupon.status==STATUS_COUPON_PAUSE) {
            self.statusLbl.text = NSLocalizedString(@"已停发", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
            self.priceLbl.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        } else if (coupon.status==STATUS_COUPON_CANCEL) {
            self.statusLbl.text = NSLocalizedString(@"已过期", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
            self.priceLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        }
    }
    
    if ([ObjectUtil isNotEmpty:coupon.shopList]) {
        CouponShop *shop=[JsonHelper dicTransObj:[coupon.shopList objectAtIndex:0] obj:[CouponShop alloc]];
        self.shopNameLbl.text = shop.shopName;
        self.usageShopLbl.text = [NSString stringWithFormat:NSLocalizedString(@"适用店铺：%@", nil), shop.shopName];
    } else {
        self.shopNameLbl.text = @"";
        self.usageShopLbl.text = NSLocalizedString(@"适用店铺：--", nil);
    }
    
    [self.priceLbl sizeToFit];
    
    CGRect unitFrame = self.unitLbl.frame;
    unitFrame.origin.x = self.priceLbl.frame.origin.x + self.priceLbl.frame.size.width;
    self.unitLbl.frame = unitFrame;
}

- (void)renderEnvelopeSummaryInfo
{
    for (UIView *view in self.summaryContainer.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat yAxis = 0;
    if ([ObjectUtil isNotEmpty:coupon.ruleList]) {
        NSDictionary *expandRuleDic = [coupon.ruleList objectAtIndex:0];
        CouponRule *expandRule = [CouponRule intWithDictionary:expandRuleDic];
        self.expandLbl.hidden = NO;
        self.expandLbl.text = [NSString stringWithFormat:NSLocalizedString(@"红包增值：分享%@次，增值为%@元", nil), expandRule.rule, expandRule.value];
        
        NSInteger deliverNum = 0, maxDeliverNum = expandRule.rule.intValue*coupon.totalQuantity+coupon.totalQuantity;
        for (NSDictionary *sumDic in coupon.couponSum) {
            CouponSum *couponSum = [CouponSum intWithDictionary:sumDic];
            NSString *ruleInfo = [NSString stringWithFormat:NSLocalizedString(@"%0.0f元红包：%d个已被领取，%d个已被使用", nil), couponSum.price, couponSum.receiveQuantity, couponSum.useQuantity];
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = [ruleInfo sizeWithFont:font constrainedToSize:CGSizeMake(300, 60) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, 300, size.height)];
            label.font = font;
            label.text = ruleInfo;
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor darkTextColor];
            [self.summaryContainer addSubview:label];
            deliverNum += (couponSum.receiveQuantity+couponSum.clickQuantity);
            yAxis+=size.height;
        }
        
        NSString *deliverInfo = [NSString stringWithFormat:NSLocalizedString(@"%ld人参与了红包传播，最大可参与人数%ld人", nil), (long)deliverNum, (long)maxDeliverNum];
        self.envelopeDeliverLbl.text = deliverInfo;
        DataBarItem *dataBarItem1 = [[DataBarItem alloc]initWithData:NSLocalizedString(@"最大可参与人数", nil) barColor:[UIColor whiteColor] quantity:maxDeliverNum];
        DataBarItem *dataBarItem2 = [[DataBarItem alloc]initWithData:NSLocalizedString(@"已参与人数", nil) barColor:[UIColor colorWithRed:253.0/255.0 green:153.0/255.0 blue:9.0/255.0 alpha:1.0] quantity:deliverNum];
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:dataBarItem1, dataBarItem2, nil];
        [self.sendBarChart buildBarChart:array];
        self.sendBarChart.hidden = NO;
        self.envelopeTitleLbl.hidden = NO;
        self.envelopeDeliverLbl.hidden = NO;
    } else {
        self.expandLbl.text =NSLocalizedString(@"红包增值：--", nil);
        self.expandLbl.hidden = YES;
        self.sendBarChart.hidden = YES;
        self.envelopeTitleLbl.hidden = YES;
        self.envelopeDeliverLbl.hidden = YES;
    }
    
    NSString *summaryInfo = [NSString stringWithFormat:NSLocalizedString(@"合计：发行数量%ld个，%ld个已被领取，%ld个已被使用", nil), (long)coupon.totalQuantity, (long)coupon.receiveQuantity, (long)coupon.useQuantity];
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [summaryInfo sizeWithFont:font constrainedToSize:CGSizeMake(300, 60) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, 300, size.height)];
    summaryLabel.textAlignment = NSTextAlignmentLeft;
    summaryLabel.textColor = [UIColor darkTextColor];
    summaryLabel.numberOfLines = 0;
    summaryLabel.text = summaryInfo;
    summaryLabel.font = font;
    [self.summaryContainer addSubview:summaryLabel];
    
    CGRect frame = self.summaryContainer.frame;
    frame.size.height = yAxis + size.height;
    self.summaryContainer.frame = frame;
    
    DataBarItem *dataBarItem1 = [[DataBarItem alloc]initWithData:NSLocalizedString(@"发行量", nil) barColor:[UIColor whiteColor] quantity:coupon.totalQuantity];
    DataBarItem *dataBarItem2 = [[DataBarItem alloc]initWithData:NSLocalizedString(@"已领", nil) barColor:[UIColor colorWithRed:253.0/255.0 green:153.0/255.0 blue:9.0/255.0 alpha:1.0] quantity:coupon.receiveQuantity];
    DataBarItem *dataBarItem3 = [[DataBarItem alloc]initWithData:NSLocalizedString(@"已用", nil) barColor:[UIColor colorWithRed:189.0/255.0 green:0 blue:4.0/255.0 alpha:1.0] quantity:coupon.useQuantity];
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:dataBarItem1, dataBarItem2, dataBarItem3, nil];
    [self.usageBarChart buildBarChart:array];
    [self updateViewSize];
}

- (IBAction)shareWeixinFriend:(id)sender
{
    NSString *shareInfo = @"";
    NSString *title = @"";
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    if (coupon.enableRule==0) {
        title = NSLocalizedString(@"有钱大家一起花！", nil);
        shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，有钱大家一起花！", nil), shopName, coupon.price];
    } else if (coupon.enableRule==1) {
        if ([ObjectUtil isNotEmpty:coupon.ruleList]) {
            NSDictionary *expandRuleDic = [coupon.ruleList objectAtIndex:0];
            CouponRule *expandRule = [CouponRule intWithDictionary:expandRuleDic];
            title = NSLocalizedString(@"帮我滚大红包！", nil);
            shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，还差%@人帮忙变成%@元红包", nil), shopName, coupon.price, expandRule.rule, expandRule.value];
        } else {
            title = NSLocalizedString(@"有钱大家一起花！", nil);
            shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，有钱大家一起花！", nil), shopName, coupon.price];
        }
    }
    
//    NSString *url = [NSString stringWithFormat:kTDFEnvelopeURL, (long)coupon._id];
//    [UMSocialWechatHandler setWXAppId:WEIXIN_AppId appSecret:WEIXIN_AppSecret url:url];
//    [UMSocialData defaultData].extConfig.wechatSessionData.url =url;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMANALYTICS_KEY
//                                      shareText:shareInfo
//                                     shareImage:[UIImage imageNamed:@"hongbao.jpg"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, nil]
//                                       delegate:nil];
}

- (IBAction)shareWeixinLine:(id)sender
{
    NSString *shareInfo = @"";
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString *title = @"";
    if (coupon.enableRule==0) {
        title = NSLocalizedString(@"有钱大家一起花！", nil);
        shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，有钱大家一起花！", nil), shopName, coupon.price];
    } else if (coupon.enableRule==1) {
        if ([ObjectUtil isNotEmpty:coupon.ruleList]) {
            NSDictionary *expandRuleDic = [coupon.ruleList objectAtIndex:0];
            CouponRule *expandRule = [CouponRule intWithDictionary:expandRuleDic];
            title = NSLocalizedString(@"帮我滚大红包！", nil);
            shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，还差%@人帮忙变成%@元红包", nil), shopName, coupon.price, expandRule.rule, expandRule.value];
        } else {
            title = NSLocalizedString(@"有钱大家一起花！", nil);
            shareInfo = [NSString stringWithFormat:NSLocalizedString(@"我获得“%@”%0.0f元红包一个，有钱大家一起花！", nil), shopName, coupon.price];
        }
    }
    
    NSString *url = [NSString stringWithFormat:kTDFEnvelopeURL, (long)(long)coupon._id];
//    [UMSocialWechatHandler setWXAppId:WEIXIN_AppId appSecret:WEIXIN_AppSecret url:url];
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMANALYTICS_KEY
//                                      shareText:shareInfo
//                                     shareImage:[UIImage imageNamed:@"hongbao.jpg"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline, nil]
//                                       delegate:nil];
}

- (IBAction)showCodeImage:(id)sender
{
    NSString *url = [NSString stringWithFormat:kTDFEnvelopeURL, (long)(long)coupon._id];
    [ImageBox show:[QRCodeGenerator qrImageForString:url imageSize:240]];
}

- (IBAction)sharePasteboard:(id)sender
{
    NSString *url = [NSString stringWithFormat:kTDFEnvelopeURL, (long)(long)coupon._id];
    [[UIPasteboard generalPasteboard] setPersistent:YES];
    [[UIPasteboard generalPasteboard] setValue:url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    [AlertBox show:NSLocalizedString(@"红包链接已经复制到剪贴版了哦！", nil)];
}

- (void)removeEnvelope
{
    NSString *tipInfo = NSLocalizedString(@"确定要删除这个红包吗？删除后，用户就无法领到这个红包了。但是已经领过的这个红包，还可以正常使用。", nil);
    [MessageBox show:tipInfo client:self];
}

- (void)confirm
{
    [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil), coupon.name] andView:self.view andHUD:hud];
//    [service removeEnvelopeData:coupon._id event:REMOTE_DELETE_ENVELOPE];
    [service removeEnvelopeData:coupon._id target:self callback:@selector(deleteFinish:)];
}

- (void)updateViewSize
{
    CGFloat detailYAxis = 0;
    for (UIView *view in self.detailInfoContainer.subviews) {
        if (view.hidden == NO) {
            CGRect frame = view.frame;
            frame.origin.y = detailYAxis;
            view.frame = frame;
            detailYAxis+=frame.size.height;
        }
    }
    
    CGRect containerFrame = self.summaryInfoContainer.frame;
    containerFrame.size.height = detailYAxis;
    self.detailInfoContainer.frame = containerFrame;
    
    CGFloat viewYAxis = 0;
    for (UIView *view in self.summaryInfoContainer.subviews) {
        if (view.hidden == NO) {
            CGRect frame = view.frame;
            frame.origin.y = viewYAxis;
            view.frame = frame;
            viewYAxis+=frame.size.height;
        }
    }
    
    containerFrame = self.summaryInfoContainer.frame;
    containerFrame.size.height = viewYAxis;
    self.summaryInfoContainer.frame = containerFrame;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
