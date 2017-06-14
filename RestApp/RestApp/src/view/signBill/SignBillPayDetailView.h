//
//  SeatEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBill.h"
#import "ItemTitle.h"
#import "EditItemView.h"
#import <UIKit/UIKit.h>
#import "MessageBoxClient.h"
#import "INavigateEvent.h"
#import "FooterListView.h"
#import "NavigateTitle2.h"
#import "MBProgressHUD.h"
#import "TDFRootViewController.h"

@interface SignBillPayDetailView : TDFRootViewController<INavigateEvent, FooterListEvent, MessageBoxClient>

@property (nonatomic, strong) void(^callBack)(void);
@property (nonatomic, strong) UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) ItemTitle *baseTitle;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *lbLsignBillMan;
@property (nonatomic, strong) UILabel *lbLsignBillCount;
@property (nonatomic, strong) UILabel *lbLsignBillFee;
@property (nonatomic, strong) UILabel *lbLsignBillRealFee;
@property (nonatomic, strong) UILabel *lbLsignBillKindPayName;
@property (nonatomic, strong) UILabel *lbLsignBillMemo;
@property (nonatomic, strong) UILabel *lbLsignBillPayTime;
@property (nonatomic, strong) UILabel *lbLsignBillPayer;
@property (nonatomic, strong) ItemTitle *listTitle;
@property (nonatomic, strong) UIView *listContainer;
@property (nonatomic, strong) SignBill *signBill;

- (IBAction)cancelBtnClick:(id)sender;

@end
