//
//  BaseSetingView.h
//  RestApp
//
//  Created by 果汁 on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemBase.h"
#import "ConfigVO.h"
#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "INavigateEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "TDFRootViewController.h"
#import "FooterListEvent.h"
#import "ShopInfoVO.h"
#import "Coupon.h"
#define RS_PRE_PAY 2
#define RS_ORDER_TXT 3
@class SettingService,NavigateTitle2,EditItemRadio,FooterListView,RemoteResult;
@class ConfigVO,MBProgressHUD;
@interface BaseSetingView : TDFRootViewController<INavigateEvent,FooterListEvent,IEditItemListEvent,OptionPickerClient,IEditItemRadioEvent>
{
    SettingService *service;
    
    RemoteResult *paymentResult;
    
}
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIView *titleDiv;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, strong)  EditItemList *lsTypesetting;
@property (nonatomic, strong)  EditItemRadio *rdoShowPrice;
@property (nonatomic, strong)  EditItemRadio *rdoOrderTxt;
@property (nonatomic, strong)  EditItemRadio *rdoWaitMenu;
@property (nonatomic, strong)  EditItemRadio *rdoServerStyle;
@property (nonatomic, strong)  EditItemRadio *rdoPackMenu;
@property (nonatomic, strong)  EditItemRadio *rdoPerPay;//桌码
@property (nonatomic, strong)  EditItemRadio *rdoShopPay;//店码
@property (nonatomic, strong)  EditItemRadio *rdoPrintMenu;
@property (nonatomic, strong)  FooterListView *footView;
@property (nonatomic, strong)  EditItemRadio *rdoMenuCode;
@property (strong, nonatomic)  EditItemRadio *rdoCoupon;
@property (strong, nonatomic)  EditItemList *lsCoupon;
@property (strong, nonatomic)  EditItemRadio *rdoSendCoupon;
@property (strong, nonatomic)  EditItemList *lsSendCoupon;


@property (strong, nonatomic)  EditItemRadio *goodsTop;//商品置顶
@property (nonatomic,strong) ConfigVO *isTopGoods;//商品置顶配置

@property (strong, nonatomic)  EditItemRadio *rdoPositionJudgeSwitch;


@property (nonatomic,strong) ConfigVO* isShowPrice;

@property (nonatomic, strong) ConfigVO *isShowOrderNum;
@property (nonatomic, strong) ConfigVO *isShowClearFood;
@property (nonatomic, strong) ConfigVO *isShowCustomerComment;
@property (nonatomic, strong) ConfigVO *isShowDiscountRechargePop;
@property (nonatomic, strong) ConfigVO *isShowDiscountPop;
@property (nonatomic ,strong) ConfigVO *isShowCustomerOrderPop;
@property (nonatomic,strong) ConfigVO* isShowOrderMark;
@property (nonatomic,strong) ConfigVO* isPerpay;
@property (nonatomic,strong) ConfigVO* isPerShopPay;
@property (nonatomic,strong) ConfigVO* isMenuType;
@property (nonatomic,strong) ConfigVO* isWait;
@property (nonatomic,strong) ConfigVO* isPack;
@property (nonatomic,strong) ConfigVO* isServing;
@property (nonatomic,strong) ConfigVO* isPrint;
@property (nonatomic,strong) ConfigVO* invoiceConfig;
@property (nonatomic,strong) ConfigVO* isSkinSpace;
@property (nonatomic,strong) ConfigVO* elecInvoiceConfig;
@property (nonatomic,strong) ShopInfoVO *shopInfoVO;
@property (nonatomic,strong) ConfigVO* isOpenPositionJudge;
@property (nonatomic,assign) BOOL isConfigFinish;
@property (nonatomic,assign) BOOL isSystemConfigFinish;

-(void) initMainView;

-(void) loadData;

@end
