//
//  SeatListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemList.h"
#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "DatePickerClient.h"
#import "ISampleListEvent.h"
#import "SignBillPayNoPayOptionTotalVO.h"
#import "TDFRootViewController.h"
#define SIGN_BILL_START_DATE 1
#define SIGN_BILL_END_DATE 2

@interface SignBillDateView : TDFRootViewController<INavigateEvent, IEditItemListEvent, DatePickerClient>
@property (nonatomic, copy)void(^callBack)(NSDate *startDate,NSDate *endDate);
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet EditItemList *startDateLst;
@property (nonatomic, strong) IBOutlet EditItemList *endDateLst;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

- (void)initWithDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (IBAction)confirmBtnClick:(id)sender;

@end
