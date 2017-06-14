//
//  TDFCardSelectorViewController.h
//  RestApp
//
//  Created by tripleCC on 2017/5/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>
#import <TDFAPIKit/TDFAPIKit.h>

#import "TDFCardSelectorItemProtocol.h"

@class TDFCardSelectorViewController;
@protocol TDFCardSelectorViewControllerDelegete <NSObject>
@required

- (TDFBaseAPI *)apiForCardSelector:(TDFCardSelectorViewController *)cardSelector;
- (void)cardSelector:(TDFCardSelectorViewController *)cardSelector didFinishSelectCard:(id)card;
- (DHTTableViewItem <TDFCardSelectorItemProtocol> *)cardSelector:(TDFCardSelectorViewController *)cardSelector displayedItemForCard:(id)card;

@optional
- (NSInteger)cardSelector:(TDFCardSelectorViewController *)cardSelector selectedIndexForCards:(NSArray *)cards;

@end

@interface TDFCardSelectorViewController : TDFRootViewController
- (instancetype)initWithTitle:(NSString *)title;
@property (weak, nonatomic) id <TDFCardSelectorViewControllerDelegete> delegate;
@end
