//
//  SeatEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemTitle.h"
#import "MessageBox.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import <UIKit/UIKit.h>
#import "SystemService.h"
#import "MBProgressHUD.h"
#import "INavigateEvent.h"
#import "FooterListView.h"
#import "NavigateTitle2.h"
#import "NumberInputClient.h"
#import "SignBillPayTotalVO.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "SignBillPayNoPayOptionTotalVO.h"
#import "TDFRootViewController.h"
#define EVENT_PAY_FEE_INPUT 1
#define EVENT_KINDPAY_SELECT 2

#define SIGNBILL_PAYMODE @"SIGNBILL_PAYMODE";

@interface SignBillPayView : TDFRootViewController<INavigateEvent, FooterListEvent, IEditItemListEvent, NumberInputClient, OptionPickerClient, MessageBoxClient>
{
    
    SystemService *sysService;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemList *lstKindPay;
@property (nonatomic, strong) IBOutlet EditItemView *txtResultFee;
@property (nonatomic, strong) IBOutlet EditItemList *lstPayFee;
@property (nonatomic, strong) IBOutlet EditItemText *txtMemo;
@property (nonatomic, strong) SignBillPayNoPayOptionTotalVO *signBillPayNoPayOptionTotal;
@property (nonatomic, strong) NSMutableArray *kindPayList;
@property (nonatomic, strong) NSMutableArray *payIdSet;
@property (nonatomic, strong) SignBillPayTotalVO *payTptalVO;

- (void)initWithData:(SignBillPayTotalVO *)signBillPayTotalVO signBillPayNoPayOptionTotal:(SignBillPayNoPayOptionTotalVO *)signBillPayNoPayOptionTotal payIdSet:(NSMutableArray *)payIdSet;

- (IBAction)confirmPayBtnClick:(id)sender;

@end
