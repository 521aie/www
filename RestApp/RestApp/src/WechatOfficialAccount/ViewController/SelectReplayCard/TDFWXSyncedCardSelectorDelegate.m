//
//  TDFWXSyncedCardSelectorDelegate.m
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFSynchronizeCardInfoModel.h"
#import "TDFWXOfficialAccountActionPath.h"
#import "TDFCardSelectorItem.h"
#import "TDFWXSyncedCardSelectorDelegate.h"

@implementation TDFWXSyncedCardSelectorDelegate
- (instancetype)initWithWxId:(NSString *)wxId
  selectedIndexForCardsBlock:(NSInteger(^)(NSArray *cards))selectedIndexForCardsBlock
       finishSelectCardBlock:(void(^)(TDFSynchronizeCardInfoModel *card))finishSelectCardBlock {
    if (self = [super init]) {
        self.wxId = wxId;
        self.selectedIndexForCardsBlock = selectedIndexForCardsBlock;
        self.finishSelectCardBlock = finishSelectCardBlock;
    }
    
    return self;
}

- (void)cardSelector:(TDFCardSelectorViewController *)cardSelector didFinishSelectCard:(id)card {
    if (self.finishSelectCardBlock) {
        self.finishSelectCardBlock(card);
    }
}

- (DHTTableViewItem<TDFCardSelectorItemProtocol> *)cardSelector:(TDFCardSelectorViewController *)cardSelector displayedItemForCard:(TDFSynchronizeCardInfoModel *)card {
    TDFCardSelectorItem *item = [TDFCardSelectorItem item];
    item.displayedTitle = card.cardName;
    return item;
}

- (TDFBaseAPI *)apiForCardSelector:(TDFCardSelectorViewController *)cardSelector {
    TDFGeneralAPI *api = [[TDFGeneralAPI alloc] init];
    api.requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXKindCardList];
    api.requestModel.apiVersion = kTDFAPWXKindCardListVersion;
    api.params[kTDFAPWXKindCardListWXAppIdKey] = self.wxId;
    api.apiResponseReformBlock = ^id(__kindof TDFBaseAPI *api, id response) {
        return [NSArray yy_modelArrayWithClass:[TDFSynchronizeCardInfoModel class] json:response[@"data"]];
    };
    return api;
}

- (NSInteger)cardSelector:(TDFCardSelectorViewController *)cardSelector selectedIndexForCards:(NSArray *)cards {
    if (self.selectedIndexForCardsBlock) {
        return self.selectedIndexForCardsBlock(cards);
    }
    return NSNotFound;
}
@end
