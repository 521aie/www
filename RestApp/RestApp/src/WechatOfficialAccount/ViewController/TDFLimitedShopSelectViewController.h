//
//  TDFLimitedShopSelectViewController.h
//  RestApp
//
//  Created by happyo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
@class ShopVO;
@class BranchShopVo;
@class TDFLimitedShopSelectViewController;

@protocol TDFLimitedShopSelectViewControllerDelegate <NSObject>

// selectedShop为空表示没有选择的
- (void)viewController:(TDFLimitedShopSelectViewController *)viewController didSelectedShop:(ShopVO *)selectedShop;

@end

@interface TDFLimitedShopSelectViewController : TDFRootViewController

@property (nonatomic, weak) id<TDFLimitedShopSelectViewControllerDelegate> delegate;

@property (nonatomic, copy) NSArray<BranchShopVo *> *shopList;


@end
