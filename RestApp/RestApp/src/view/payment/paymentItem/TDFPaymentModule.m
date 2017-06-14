//
//  TDFPaymentModule.m
//  RestApp
//
//  Created by xueyu on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentModule.h"
#import "TDFPaymentTypeVo.h"
#import "Platform.h"
#import "RestConstants.h"
#import "ShopInfoVO.h"
@implementation TDFPaymentModule
+(NSMutableArray *)menuActions:(ShopStatusVo *)shopInfo{
    
    NSMutableArray *menus = [[NSMutableArray alloc]init];
    
    TDFPaymentTypeVo *action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"微信", nil) detail:NSLocalizedString(@"微信收款明细", nil)img:@"ico_epay_weixin.png" typeCode:@"1" paymentType:Weixin code:ORDER_PAY_LIST_VIEW];
    if (shopInfo.displayWxPay) {
        [menus addObject:action];
    }
    if (shopInfo.displayAlipay&&shopInfo.alipayStatus) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"支付宝", nil) detail:NSLocalizedString(@"支付宝收款明细", nil)img:@"ico_epay_alipay.png" typeCode:@"2" paymentType:Alipay code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }
    
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"0"]) {
        if (shopInfo.displayFund) {
            action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"二维火", nil) detail:NSLocalizedString(@"二维火收款明细", nil)img:@"ico_epay_tdf@2x.png" typeCode:@"4" paymentType:Packet code:ORDER_PAY_LIST_VIEW];
            [menus addObject:action];
        }
    }
    if (shopInfo.displayQQ) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"QQ钱包", nil) detail:NSLocalizedString(@"QQ钱包收款明细", nil)img:@"ico_epay_QQ@2x.png" typeCode:@"5" paymentType:QQ code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }

    return menus;
}

+(NSMutableArray *)menuActionsWithShopVo:(ShopInfoVO *)shopInfo{
    
    NSMutableArray *menus = [[NSMutableArray alloc]init];
    
    TDFPaymentTypeVo *action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"微信", nil) detail:NSLocalizedString(@"微信收款明细", nil)img:@"ico_epay_weixin.png" typeCode:@"1" paymentType:Weixin code:ORDER_PAY_LIST_VIEW];
    if (shopInfo.displayWxPay) {
        [menus addObject:action];
    }
    if (shopInfo.displayAlipay&&shopInfo.alipayStatus) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"支付宝", nil) detail:NSLocalizedString(@"支付宝收款明细", nil)img:@"ico_epay_alipay.png" typeCode:@"2" paymentType:Alipay code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }
    
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"0"]) {
        if (shopInfo.displayFund) {
            action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"二维火", nil) detail:NSLocalizedString(@"二维火收款明细", nil)img:@"ico_epay_tdf@2x.png" typeCode:@"4" paymentType:Packet code:ORDER_PAY_LIST_VIEW];
            [menus addObject:action];
        }
    }
    if (shopInfo.displayQQ) {
        action = [[TDFPaymentTypeVo alloc]initWithName:NSLocalizedString(@"QQ钱包", nil) detail:NSLocalizedString(@"QQ钱包收款明细", nil)img:@"ico_epay_QQ@2x.png" typeCode:@"5" paymentType:QQ code:ORDER_PAY_LIST_VIEW];
        [menus addObject:action];
    }
    
    return menus;
}

@end
