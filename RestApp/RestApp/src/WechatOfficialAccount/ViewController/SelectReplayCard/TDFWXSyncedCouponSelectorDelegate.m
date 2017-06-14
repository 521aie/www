//
//  TDFWXSyncedCouponSelectorDelegate.m
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFAPIKit/TDFAPIKit.h>
#import "TDFSynchronizeCardInfoModel.h"
#import "TDFWXOfficialAccountActionPath.h"
#import "TDFCardSelectorItem.h"
#import "TDFWXSyncedCouponSelectorDelegate.h"

@implementation TDFWXSyncedCouponSelectorDelegate
- (instancetype)initWithWxId:(NSString *)wxId
selectedIndexForCouponsBlock:(NSInteger(^)(NSArray *coupons))selectedIndexForCouponsBlock
     finishSelectCouponBlock:(void(^)(TDFSynchronizeCardInfoModel *card))finishSelectCoupondBlock {
    if (self = [super init]) {
        self.wxId = wxId;
        self.selectedIndexForCouponsBlock = selectedIndexForCouponsBlock;
        self.finishSelectCoupondBlock = finishSelectCoupondBlock;
    }
    
    return self;
}

- (void)cardSelector:(TDFCardSelectorViewController *)cardSelector didFinishSelectCard:(id)card {
    if (self.finishSelectCoupondBlock) {
        self.finishSelectCoupondBlock(card);
    }
}

- (DHTTableViewItem<TDFCardSelectorItemProtocol> *)cardSelector:(TDFCardSelectorViewController *)cardSelector displayedItemForCard:(TDFSynchronizeCardInfoModel *)card {
    TDFCardSelectorItem *item = [TDFCardSelectorItem item];
    item.displayedTitle = card.cardName;
    return item;
}

- (TDFBaseAPI *)apiForCardSelector:(TDFCardSelectorViewController *)cardSelector {
    TDFGeneralAPI *api = [[TDFGeneralAPI alloc] init];
    api.requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXListCouponPromotion];
    api.requestModel.apiVersion = kTDFAPWXListCouponPromotionVersion;
    api.params[kTDFAPWXListCouponPromotionWXAppIdKey] = self.wxId;
    api.apiResponseReformBlock = ^id(__kindof TDFBaseAPI *api, id response) {
        return [NSArray yy_modelArrayWithClass:[TDFSynchronizeCardInfoModel class] json:response[@"data"]];
    };
    return api;
}

- (NSInteger)cardSelector:(TDFCardSelectorViewController *)cardSelector selectedIndexForCards:(NSArray *)cards {
    if (self.selectedIndexForCouponsBlock) {
        return self.selectedIndexForCouponsBlock(cards);
    }
    return NSNotFound;
}
@end
