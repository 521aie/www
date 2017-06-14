//
//  WeixinPayPanel.m
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeView.h"
#import "ShopInfoVO.h"
#import "UIView+Sizes.h"
#import "RemoteResult.h"
#import "WeixinPayPanel.h"

@implementation WeixinPayPanel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeView = homeViewTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.background.layer.cornerRadius = 4;
    self.background.backgroundColor = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.weixinPayBtn = [CMButton createCMButton:self x:0 y:0 w:self.view.width h:self.view.height];
    [self.view addSubview:self.weixinPayBtn];
}

- (void)initDataView
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        ShopInfoVO *shopInfo = [[ShopInfoVO alloc] initWithDictionary:data[@"data"]];
        if (shopInfo!=nil) {
            if (shopInfo.isOurWx == 1) {
                self.background.backgroundColor = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
                self.lblNotOpenWXPayTitle.text = @"";
                self.lblNotOpenWXPayDetail.text = @"";
                self.lblOpenWXPay.text = NSLocalizedString(@"微信支付账户余额及明细", nil);
            } else if (shopInfo.isOurWx == 0) {
                self.background.backgroundColor = [[UIColor alloc]initWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
                self.lblNotOpenWXPayDetail.text = NSLocalizedString(@"立即绑定收款账户，否则顾客微信支付的钱无法及时到账", nil);
                self.lblNotOpenWXPayTitle.text = NSLocalizedString(@"微信支付于12月1日开通，您还未绑定收款账户！", nil);
                self.lblOpenWXPay.text=@"";
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)touchUpInside:(CMButton *)button
{
    if (button==self.weixinPayBtn) {
        [homeView forwardWeixinPay];
    }
}

@end
