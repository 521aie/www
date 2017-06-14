//
//  PaymentModule.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainModule.h"
#import "ShopInfoVO.h"
#import <UIKit/UIKit.h>
#import "PaymentNoteView.h"
#import "OrderPayListView.h"
#import "PaymentTypeView.h"
#import "OrderPayDetailView.h"
#import "PayOrderListView.h"
@class PayOrderListView,PaymentTypeView;
@interface PaymentModule : UIViewController<INavigateEvent>
{
    MainModule *mainModule;
    TDFPaymentService *service;
}
@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) PaymentNoteView *paymentNoteView;
@property (nonatomic, strong) OrderPayListView *orderPayListView;
@property (nonatomic, strong) OrderPayDetailView *orderPayDetailView;
@property (nonatomic, strong) PayOrderListView *payOrderListView;
@property (nonatomic, strong) PaymentTypeView *paymentTypeView;

@property (nonatomic, assign) NSInteger shopType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)backMenu;

- (void)initOrderPayData:(ShopInfoVO *)shopInfo;

-(void)initPaymentType;

- (void)showView:(NSInteger)viewTag;

- (void)loadOrderPayDetailListView;

@end
