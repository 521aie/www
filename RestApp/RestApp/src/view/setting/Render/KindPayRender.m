//
//  KindPayRender.m
//  RestApp
//
//  Created by zxh on 14-4-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPayRender.h"
#import "KindPay.h"

@implementation KindPayRender

+(NSMutableArray*) listType
{
    NSMutableArray *arr=[NSMutableArray array];
    
    //现金.
    KindPay* kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"现金", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.isCharge=BASE_TRUE;
    kindPay.kind=KIND_CASH;
    [arr addObject:kindPay];
    
    //银行卡
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"银行卡", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.kind=KIND_CARD;
    [arr addObject:kindPay];
    
//    //挂账
//    kindPay=[KindPay new];
//    kindPay.name=NSLocalizedString(@"挂账", nil);
//    kindPay.isInclude=BASE_TRUE;
//    kindPay.isSignBill=BASE_TRUE;
//    kindPay.isExtra=BASE_TRUE;
//    kindPay.kind=KIND_CREDIT_ACCOUNT;
//    [arr addObject:kindPay];
    
    //自己发行的处置卡.
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"自己发行的储值卡", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.isCard=BASE_TRUE;
    kindPay.kind=KIND_SAVING_CARD;
    [arr addObject:kindPay];
    
    //由客房结算
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"由客房结算", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.isThirdPart=BASE_TRUE;
    kindPay.kind=KIND_THIRDPART_PAY;
    [arr addObject:kindPay];
    
    //优惠券
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"优惠券", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.kind=KIND_VOUCHER;
    [arr addObject:kindPay];
    
    //免单
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"免单", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.kind=KIND_FREE_BILL;
    [arr addObject:kindPay];
    
    //代金券
    kindPay = [KindPay new];
    kindPay.name = NSLocalizedString(@"代金券", nil);
    kindPay.isInclude = BASE_TRUE;
    kindPay.kind = KIND_COUPON;
    [arr addObject:kindPay];

    
    kindPay=[KindPay new];
    kindPay.name=NSLocalizedString(@"其他", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.kind=KIND_OTHER;
    [arr addObject:kindPay];
    
    
    
    return arr;
}

+ (NSString *)obtainKindPayKindName:(int)kind {

    for (KindPayVO *kindPay in [self listType]) {
        if(kindPay.kind == kind){
            return kindPay.name;
        }
    }
    return nil;
}

+(KindPayVO *)getThridPayType:(int)kind
{
    KindPayVO* kindPay=[KindPayVO new];
    kindPay.name=NSLocalizedString(@"网络支付", nil);
    kindPay.isInclude=BASE_TRUE;
    kindPay.kind=KIND_OTHER;
    return kindPay;
}

+(KindPayVO*) obtainKindPayType:(int)kind{
    NSMutableArray* list=[self listType];
    for (KindPayVO* vo in list) {
        if (vo.kind==kind) {
            return vo;
        }
    }
    return nil;
}

@end
