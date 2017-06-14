//
//  MainButton.m
//  RestApp
//
//  Created by zxh on 14-8-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "Platform.h"
#import "MainButton.h"
#import "UIMenuAction.h"
#import "MenuSelectHandle.h"
#import "NSString+Estimate.h"
#import "ActionConstants.h"
#import "RestConstants.h"
@implementation MainButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"MainButton" owner:self options:nil];
    [self addSubview:self.view];
    self.lblName.textAlignment = NSTextAlignmentCenter;
    self.lblName.font = [UIFont systemFontOfSize:11];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)loadData:(UIMenuAction *)menu delegate:(HomeModule *)homeModule
{
    if (menu==nil) {
        [self setHidden:YES];
        return;
    }
    [self setHidden:NO];
    self.menu = menu;
    self.homeModule = homeModule;
    self.lblName.text=menu.name;
//    self.badgeImageView.hidden = !menu.showBadge;
    
    if ([menu.code isEqualToString:PAD_PAYMENT]) {
        if ([[Platform Instance]lockAct:PAD_WEIXIN_DETAL]&&[[Platform Instance]lockAct:PAD_WEIXIN_SUM]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
            [self.imgLock setHidden:NO];
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
//    else if ([self.menu.code isEqual:PAD_BRAND_PAYMENT])
//    {
//        if ([[Platform Instance]lockAct:PHONE_BRAND_THIRD_PAY_DETAL]&&[[Platform Instance]lockAct:PHONE_BRAND_THIRD_PAY_SUM]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
//            [self.imgLock setHidden:NO];
//        }
//        else
//        {
//            [self.imgLock setHidden:YES];
//        }
//    }
    else if ([self.menu.code isEqual:PAD_BRAND_MEMBER])
    {
        if ([[Platform Instance]lockAct:PHONE_BRAND_KIND_CARD]&&[[Platform Instance]lockAct:PHONE_BRAND_CHARGE_DISCOUNT]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
            [self.imgLock setHidden:NO];
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
//    else if ([self.menu.code isEqual:PAD_BRAND_MEMBER])
//    {
//        if ([[Platform Instance]lockAct:PHONE_BRAND_KIND_CARD]&&[[Platform Instance]lockAct:PHONE_BRAND_SHOP_MANAGE]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
//            [self.imgLock setHidden:NO];
//        }
//        else
//        {
//            [self.imgLock setHidden:YES];
//        }
//    }
    
    
    
    else if ([self.menu.code isEqual:PAD_MEMBER])
    {
        if ([[Platform Instance] lockAct:PAD_DEGREE_EXCHANGE]&&[[Platform Instance] lockAct:PAD_CHARGE_DISCOUNT]&&[[Platform Instance] lockAct:PAD_KIND_CARD]&&[[Platform Instance] lockAct:PHONE_MEMBER_LIST]&&[[Platform Instance] lockAct:PHONE_CARD_CHANGE]&&[[Platform Instance] lockAct:PAD_MAKE_CARD]&&[[Platform Instance] lockAct:PAD_CONSUME_DETAIL]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
            [self.imgLock setHidden:NO];
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
    else if([menu.code isEqualToString:PAD_REPORT] ){
        if ([[Platform Instance]lockAct:MEMBER_REPORT]&&[[Platform Instance]lockAct:CARD_CONSUME_DETAIL_REPORT]&&[[Platform Instance]lockAct:PAD_CARD_ACTIVATE_REPORT]&&[[Platform Instance]lockAct:PAD_DETAIL_CARD_REPORT]&&[[Platform Instance]lockAct: CARD_DISCOUNT_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_CHARGE_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_DEGREE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_COUNT_REPORT]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]&&[[Platform Instance]lockAct:PHONE_BUSINESS_REPORT]&&[[Platform Instance]lockAct:PHONE_HOUR_REPORT])
        { [self.imgLock setHidden:NO];
        }  else
        {
            [self.imgLock setHidden:YES];
        }
    } else if([menu.code isEqualToString:PHONE_SUPPLY_CHAIN]){
        
        [self.imgLock setHidden:YES];
        
//        if ([[Platform Instance]lockAct:PHONE_SUPPLY_CHAIN]){
//            [self.imgLock setHidden:NO];
//        } else{
//           [self.imgLock setHidden:YES];
//        }
    
    }
    
    else
    {
        [self.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menu.code])];
    }
    if ([NSString isNotBlank:menu.img]) {
        UIImage *img = [UIImage imageNamed:menu.img];
        self.btnImg.image=img;
    } else {
        self.btnImg.image=nil;
    }
    
    
    
}

- (IBAction)btnMenuClick:(id)sender
{
    if ([[Platform Instance] isNetworkOk]) {
        
        if ([self.menu.code  isEqual:PAD_PAYMENT] ) {
            if ([[Platform Instance]lockAct:PAD_WEIXIN_DETAL]&&[[Platform Instance]lockAct:PAD_WEIXIN_SUM]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
            }
            else
            {
                [self.homeModule selectModule:self.menu];
             }
        }
        else  if ([self.menu.code  isEqual:PAD_BRAND_MEMBER] ) {
            if ([[Platform Instance]lockAct:PHONE_BRAND_KIND_CARD]&&[[Platform Instance]lockAct:PHONE_BRAND_CHARGE_DISCOUNT]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
            }
            else
            {
                [self.homeModule selectModule:self.menu];
            }
        }
        else  if ([self.menu.code  isEqual:PAD_BRAND_MEMBER] ) {
            if ([[Platform Instance]lockAct:PHONE_BRAND_KIND_CARD]&&[[Platform Instance]lockAct:PHONE_BRAND_SHOP_MANAGE]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
            }
            else
            {
                [self.homeModule selectModule:self.menu];
            }
        }
//        else  if ([self.menu.code  isEqual:PAD_BRAND_PAYMENT] ) {
//            if ([[Platform Instance]lockAct:PHONE_BRAND_THIRD_PAY_DETAL]&&[[Platform Instance]lockAct:PHONE_BRAND_THIRD_PAY_SUM]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
//                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
//            }
//            else
//            {
//                [self.homeModule selectModule:self.menu];
//            }
//        }
         else  if ([self.menu.code  isEqual:PHONE_SUPPLY_CHAIN] ) {
             NSURL *url = [NSURL URLWithString:@"TDFSupplyChainApp://"];
             if ([[UIApplication sharedApplication] canOpenURL:url]) {
                 [[UIApplication sharedApplication] openURL:url];
             } else{
                 
                 BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
                 
                 if (!showRestApp) return;
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请安装'二维火供应链'", nil)
                                                                                          message:NSLocalizedString(@"前往App Store下载二维火供应链", nil)
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                 [alertController addAction:cancelAction];
                 
                 UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     NSString *url = @"http://itunes.apple.com/us/app/id1124011735";
                     
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                 }];
                 
                 [alertController addAction:confirmAction];
                 
                 UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
                 
                 [rootViewController presentViewController:alertController animated:YES completion:nil];
             }
             return;
//            if ([[Platform Instance]lockAct:PHONE_SUPPLY_CHAIN]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
//                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
//            }
//            else
//            {
//                
//                
//            }
        }
          else if ([self.menu.code isEqual:PAD_MEMBER])
        {
            if ([[Platform Instance] lockAct:PAD_DEGREE_EXCHANGE]&&[[Platform Instance] lockAct:PAD_CHARGE_DISCOUNT]&&[[Platform Instance] lockAct:PAD_KIND_CARD]&&[[Platform Instance] lockAct:PAD_MAKE_CARD]&&[[Platform Instance] lockAct:PAD_CONSUME_DETAIL]&&[[Platform Instance] lockAct:PHONE_MEMBER_LIST]&&[[Platform Instance] lockAct:PHONE_CARD_CHANGE]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
            }
            else
            {
                [self.homeModule selectModule:self.menu];
            }
         }
        else if ([self.menu.code isEqual:PAD_REPORT])
        {
            if ([[Platform Instance]lockAct:MEMBER_REPORT]&&[[Platform Instance]lockAct:CARD_CONSUME_DETAIL_REPORT]&&[[Platform Instance]lockAct:PAD_CARD_ACTIVATE_REPORT]&&[[Platform Instance]lockAct:   PAD_DETAIL_CARD_REPORT]&&[[Platform Instance]lockAct: CARD_DISCOUNT_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_CHARGE_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_DEGREE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_COUNT_REPORT]&&[[Platform Instance]lockAct:PHONE_BUSINESS_REPORT]&&[[Platform Instance]lockAct:PHONE_HOUR_REPORT]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"])
            {
                
                    [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
                            }
            else
            {
                 [self.homeModule selectModule:self.menu];
            }
           
        }
        else if ([self.menu.code isEqualToString:PHONE_KOUBEI_SHOP ])
        {
            if ([[Platform Instance]lockAct:PHONE_KOUBEI_SHOP])
            {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
            }
            else
            {
                NSURL *url = [NSURL URLWithString:@"alipaym://"];
                
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"“口碑商家”应用是支付宝口碑为各位商家提供的移动端管理工具，轻松完成支付宝收款，创建和管理线上门店，发布运营活动，帮助线下商家更好地吸引新用户、留住老用户、提升品牌影响力。您希望下载“口碑商家”应用吗？", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"安装应用", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/kou-bei-shang-jia/id796778475?mt=8"];
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }];
                    
                    [alertController addAction:confirmAction];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
                    
                    [viewController presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
        else if ([[Platform Instance] lockAct:self.menu.code]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),self.menu.name]];
        }
        else {
            [self.homeModule selectModule:self.menu];
        }
    } else {
        [AlertBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil)];
    }
}

@end
