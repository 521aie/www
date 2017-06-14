//
//  TDFAddChainPriceFormatViewController.h
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFMediator+ChainMenuModule.h"
#import "MenuPricePlanVo.h"
#import "EditItemText.h"
#import "EditItemView.h"
#import "ActionDetailTable.h"
#import "ZmTableCell.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "NSString+Estimate.h"
#import "TDFChainMenuService.h"
#define ADD_PRICE_FORMATINT 12
@interface TDFAddChainPriceFormatViewController : TDFRootViewController<ISampleListEvent>
@property (nonatomic,copy) void (^addPriceFormatCallBack)(BOOL orRefresh);
@property (nonatomic, strong)  EditItemText *nameEditItemText;
@property (nonatomic, strong) EditItemView *shopCountView;
@property (nonatomic, strong)  ActionDetailTable *shopGrid;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, strong) MenuPricePlanVo *vo;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL isContinue;
@property (nonatomic, strong)  UIButton *btnDel;

@end
