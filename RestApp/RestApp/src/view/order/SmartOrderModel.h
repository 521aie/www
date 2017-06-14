//
//  SmartOrder.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModule.h"
#import "SpecEditView.h"
#import "SpecListView.h"
#import "SpecialTagModule.h"

#import "SmartOrderSettingRNModel.h"


@class OrderListView,orderSetView,orderRecommendView,orderRdDetailView,orderRemindView,TDFOrderRdDetailViewController,TDFOrderGoodsSetViewController;

@interface SmartOrderModel : SpecialTagModule

{
    MainModule *mainModel;
}
@property (nonatomic ,strong)OrderListView *orderListView;
@property (nonatomic ,strong)orderSetView *orderSetView;
@property (nonatomic ,strong)TDFOrderRdDetailViewController *tdfOrderRd;
@property (nonatomic ,strong)orderRecommendView *orderRecommendView;
@property (nonatomic ,strong)orderRdDetailView *orderRdDetailView;
@property (nonatomic ,strong)orderRemindView *orderRemindView;
@property (nonatomic ,strong) UINavigationController *rootController;
@property (nonatomic ,strong)SmartOrderSettingRNModel *smartOrderSettingRNModel; //智能二期react native
@property (nonatomic, copy)void(^back)();
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)controller;
- (void)loadData;
-(void)backMenu;
- (void)showView:(NSInteger) viewTag;
@end
