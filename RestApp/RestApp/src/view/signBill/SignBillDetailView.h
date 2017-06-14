//
//  SeatListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignBillNoPayVO.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "ISampleListEvent.h"
#import "SignBillPayNoPayOptionTotalVO.h"
#import "TDFRootViewController.h"
@interface SignBillDetailView : TDFRootViewController<INavigateEvent,ISampleListEvent,FooterListEvent,UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UILabel *queryDateLbl;

@property (nonatomic, strong) NSMutableArray *payIdSet;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *signBillNoPayList;

@property (nonatomic, strong) SignBillPayNoPayOptionTotalVO *signBillPayNoPayOptionTotalVO;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic) BOOL hasData;
@property (nonatomic) int currPage;      //当前页.
@property (nonatomic) int pageNum;       //总页数.
@property (nonatomic) int act;           //行为.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)loadSignBillData:(SignBillPayNoPayOptionTotalVO *)signBillPayNoPayOptionTotalVO;

- (void)querySignBillList:(NSDate *)startDate endDate:(NSDate *)endDate;

- (IBAction)signDateBtnClick:(id)sender;

- (BOOL)isSelectItem:(NSString *)payId;

- (void)deSelectItem:(NSString *)payId;

- (void)selectItem:(NSString *)payId;

- (void)selectSignBill:(SignBillNoPayVO *)SignBillNoPay;

-(IBAction)helpBtnClick:(id)sender;

-(IBAction)checkAllBtnClick:(id)sender;

-(IBAction)unCheckAllBtnClick:(id)sender;

-(IBAction)payBackBtnClick:(id)sender;

@end
