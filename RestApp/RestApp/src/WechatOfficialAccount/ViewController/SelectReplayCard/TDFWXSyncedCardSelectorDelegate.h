//
//  TDFWXSyncedCardSelectorDelegate.h
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFCardSelectorViewController.h"

@class TDFSynchronizeCardInfoModel;
@interface TDFWXSyncedCardSelectorDelegate : NSObject <TDFCardSelectorViewControllerDelegete>
@property (strong, nonatomic) NSString *wxId;
@property (copy, nonatomic) NSInteger (^selectedIndexForCardsBlock)(NSArray *cards);
@property (copy, nonatomic) void (^finishSelectCardBlock)(TDFSynchronizeCardInfoModel *card);

- (instancetype)initWithWxId:(NSString *)wxId
  selectedIndexForCardsBlock:(NSInteger(^)(NSArray *cards))selectedIndexForCardsBlock
       finishSelectCardBlock:(void(^)(TDFSynchronizeCardInfoModel *card))finishSelectCardBlock;
@end
