//
//  TDFBusinessFlowViewController.m
//  RestApp
//
//  Created by happyo on 2016/11/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessFlowViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFPickerItem.h"
#import "DHTTableViewManager.h"
#import "TDFBusinessService.h"
#import "TDFResponseModel.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFShowPickerStrategy.h"
#import "YYModel.h"
#import "TDFBusinessSpellModel.h"
#import "TDFPayInfoModel.h"
#import "TDFBusinessFlowHeaderView.h"
#import "TDFBusinessPayDetailItem.h"
#import "Platform.h"
#import "TDFMediator+PaymentModule.h"
#import "UMMobClick/MobClick.h"
#import "RestConstants.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+HomeModule.h"
#import "MJRefresh.h"
#import "TDFPayTypeImageModel.h"
#import "TDFEditButtonView.h"
#import "TDFTimePlanService.h"
#import "GlobalRender.h"
#import "DateUtils.h"
#import "OpenTimePlanRender.h"
#import "OpenTimePlan.h"
#import "NSString+TDF_Empty.h"
#import "TDFMemberPayInfoController.h"

static NSInteger kHeaderHeight = 112;

@interface TDFBusinessFlowViewController () <TDFBusinessFlowHeaderViewDelegate>

@property (nonatomic, strong) TDFPickerItem *spellItem;

@property (nonatomic, strong) TDFEditButtonView *spellView;

@property (nonatomic, strong) DHTTableViewSection *payInfoSection;

@property (nonatomic, strong) TDFBusinessFlowHeaderView *headerView;

@property (nonatomic, strong) NSString *bDateString;

@property (nonatomic, strong) NSString *eDateString;

@property (nonatomic, strong) NSString *kindPayIds; // 选中的服务端要的值

@property (nonatomic, strong) NSString *payType; // 选中的支付类型

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray<TDFPayTypeImageModel *> *payTypeImageList;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation TDFBusinessFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configDefaultManager];
    
    @weakify(self);
    self.tbvBase.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchPayDetailDataWithStartTime:self.bDateString endTime:self.eDateString isAll:[self.spellItem.textValue isEqualToString:kBusinessSpellAllDay] kindPayIds:self.kindPayIds type:self.payType];
    }];
    
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFBusinessPayDetailCell" withItem:@"TDFBusinessPayDetailItem"];
    
    self.page = 1;
    self.bDateString = @"";
    self.eDateString = @"";
//    [self generateFooterButtonWithTypes:TDFFooterButtonTypePrintBill];
    
    if ([self.dateString isNotEmpty]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
        
        NSDate *date = [dateFormatter dateFromString:self.dateString];
        
        dateFormatter.dateFormat = NSLocalizedString(@"MM月dd日营业流水", nil);
        self.title = [dateFormatter stringFromDate:date];
    }
    
    [self configureSpellHeaderView];

    
    self.payInfoSection = [DHTTableViewSection section];
    self.payInfoSection.headerView = [self generateSectionHeader];
    self.payInfoSection.headerHeight = 35;

    [self.manager addSection:self.payInfoSection];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchPayTypeImageUrlWithCompleteBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                self.payTypeImageList = [NSArray yy_modelArrayWithClass:[TDFPayTypeImageModel class] json:dict[@"data"]];
                [self fetchBusinessData];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)configureSpellHeaderView
{
    self.spellItem = [[TDFPickerItem alloc] init];
    self.spellItem.title = NSLocalizedString(@"营业班次", nil);
    self.spellItem.detail = NSLocalizedString(@"注：本店的营业结束时间为{营业结束时间}", nil);
    self.spellItem.alpha = 0.7;
    @weakify(self);
    self.spellItem.filterBlock = ^ (NSString *textValue, id requestValue) {
        @strongify(self);
        self.spellItem.preValue = textValue;
        
        NSString *spellString = requestValue;
        NSArray *spellComponents = [spellString componentsSeparatedByString:@"-"];
        NSString *bTimeString = spellComponents.firstObject;
        NSString *eTimeString = spellComponents.lastObject;
        
        self.bDateString = [NSString stringWithFormat:@"%@%@00", self.dateString, bTimeString];
        self.eDateString = [NSString stringWithFormat:@"%@%@59", self.dateString, eTimeString];
        if (![textValue isEqualToString:kBusinessSpellAllDay]) {
            self.eDateString = [self realEndTimeWithBegTime:self.bDateString endTime:self.eDateString];
         }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSDate *bDate = [dateFormatter dateFromString:self.bDateString];
        
        NSDate *eDate = [dateFormatter dateFromString:self.eDateString];
        
        // 如果开始时间大于结束时间，那么结束时间 加一天
        if ([bDate compare:eDate] == NSOrderedDescending) {
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:eDate];
            
            self.eDateString = [dateFormatter stringFromDate:nextDate];
        }
        
        [self.spellView configureViewWithModel:self.spellItem];
        [self fetchPayInfoDataWithStartDate:self.bDateString endTime:self.eDateString isAll:[textValue isEqualToString:kBusinessSpellAllDay]];
        
        [self.manager reloadData];
        
        return YES;
    };

    self.spellView = [[TDFEditButtonView alloc] initWithFrame:CGRectZero];
    [self.spellView configureViewWithModel:self.spellItem];
    
    CGFloat spellHeaderHeight = [TDFEditButtonView getHeightWithModel:self.spellItem];
    self.spellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, spellHeaderHeight);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = kHeaderHeight + spellHeaderHeight;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:self.spellView];
    frame = self.headerView.frame;
    frame.origin = CGPointMake(0, spellHeaderHeight);
    self.headerView.frame = frame;
    [headerView addSubview:self.headerView];
    
    [self.tbvBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tbvBase.tableHeaderView = headerView;
}


- (UIView *)generateSectionHeader {

    UIView *tableHeaderAlphaView = [[UIView alloc] initWithFrame:CGRectZero];
    tableHeaderAlphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    tableHeaderAlphaView.frame = CGRectMake(0, 0, 300, 24);
    
    CGFloat labelHeight = 12;
    UILabel *lblOpenTime = [self getTableHeaderLabel];
    lblOpenTime.text = NSLocalizedString(@"开单时间", nil);
    [tableHeaderAlphaView addSubview:lblOpenTime];
    [lblOpenTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeaderAlphaView);
        make.height.equalTo(@(labelHeight));
        make.leading.equalTo(tableHeaderAlphaView).with.offset(10);
        make.width.equalTo(@(46));
    }];
    
    UILabel *lblNumber = [self getTableHeaderLabel];
    lblNumber.font = [UIFont systemFontOfSize:12.];
    lblNumber.text = NSLocalizedString(@"桌号或单号", nil);
    [tableHeaderAlphaView addSubview:lblNumber];
    [lblNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeaderAlphaView);
        make.height.equalTo(@(labelHeight));
        make.leading.equalTo(lblOpenTime.mas_trailing).with.offset(10);
        make.width.equalTo(@(100));
    }];
    
    //        UILabel *lblMember = [self getTableHeaderLabel];
    //        lblMember.text = NSLocalizedString(@"会员", nil);
    //        [self addSubview:lblMember];
    //        [lblMember mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.centerY.equalTo(tableHeaderAlphaView);
    //            make.height.equalTo(@(labelHeight));
    //            make.leading.equalTo(lblNumber.mas_trailing).with.offset(10);
    //            make.width.equalTo(@(24));
    //        }];
    
    UILabel *lblAcount = [self getTableHeaderLabel];
    lblAcount.font = [UIFont systemFontOfSize:12.];
    lblAcount.text = NSLocalizedString(@"付款方式/实收金额", nil);
    lblAcount.textAlignment = NSTextAlignmentRight;
    [tableHeaderAlphaView addSubview:lblAcount];
    [lblAcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeaderAlphaView);
        make.height.equalTo(@(labelHeight));
        make.trailing.equalTo(tableHeaderAlphaView).with.offset(-10);
        make.width.equalTo(@(130));
    }];
    
    return tableHeaderAlphaView;
}

- (UILabel *)getTableHeaderLabel
{
    UILabel *tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tableHeaderLabel.font = [UIFont systemFontOfSize:11];
    tableHeaderLabel.textColor = RGBA(51, 51, 51, 1);
    
    return tableHeaderLabel;
}

- (void)fetchBusinessData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchBusinessSpellWithCompleteBlock:^(TDFResponseModel *response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                NSArray<TDFBusinessSpellModel *> *dataList = [NSArray yy_modelArrayWithClass:[TDFBusinessSpellModel class] json:dict[@"data"]];
                NSArray<TDFBusinessSpellModel *> *spellList = [self generateSpellListWithFetchedDataList:dataList];
                
                TDFShowPickerStrategy *strategy = [[TDFShowPickerStrategy alloc] init];
                strategy.pickerItemList = [NSMutableArray arrayWithArray:spellList];
                strategy.selectedItem = spellList.firstObject;
                strategy.pickerName = NSLocalizedString(@"营业班次", nil);
                
                self.spellItem.strategy = strategy;
                self.spellItem.textValue = [strategy.selectedItem obtainItemId];
                self.spellItem.preValue = [strategy.selectedItem obtainItemId];
                
                [TDFTimePlanService fetchOpenTimeWithCompleteBlock:^(TDFResponseModel * response) {
                    if ([response isSuccess]) {
                        if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = response.responseObject;
                            
                            OpenTimePlan *plan = [OpenTimePlan yy_modelWithJSON:dict[@"data"]];

                            NSString* itemName = [GlobalRender obtainItem:[OpenTimePlanRender listEndTypes] itemId:[NSString stringWithFormat:@"%d",plan.endType]];
                            itemName = [NSString stringWithFormat:@"%@%@",itemName,[DateUtils formatTimeWithSecond:plan.endTime]];

                            self.spellItem.detail = [NSString stringWithFormat:NSLocalizedString(@"注：本店的营业结束时间为%@。", nil), itemName];
                            
                            [self.spellView configureViewWithModel:self.spellItem];
                            [self.manager reloadData];
                            
                            [self fetchPayInfoDataWithStartDate:@"" endTime:@"" isAll:YES];
                        }
                    } else {
                        [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
                    }
                }];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
        
    }];
}

- (void)fetchPayInfoDataWithStartDate:(NSString *)startTime endTime:(NSString *)endTime isAll:(BOOL)isAll
{
    self.page = 1;
    [self.payInfoSection removeAllItems];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fecthV2PayInfoWithDate:self.dateString startTime:startTime endTime:endTime isAll:isAll completeBlock:^(TDFResponseModel *response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                
                NSArray<TDFPayInfoModel *> *payInfoList = [NSArray yy_modelArrayWithClass:[TDFPayInfoModel class] json:dict[@"data"]];
                [self addImageUrlToList:payInfoList];
                NSArray<TDFPayInfoModel *> *fullPayInfoList = [self generateFullPayInfoListWithFetchedPayInfoList:payInfoList];
                
                [self.headerView configureViewWithPayInfoList:fullPayInfoList];
                // 默认选中全部
                self.kindPayIds = [[NSArray array] yy_modelToJSONString];
                self.payType = @"0";
                [self fetchPayDetailDataWithStartTime:startTime endTime:endTime isAll:isAll kindPayIds:self.kindPayIds type:self.payType];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
        
    }];
}

- (void)fetchPayDetailDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime isAll:(BOOL)isAll kindPayIds:(NSString *)kindPayIds type:(NSString *)type
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    NSString *kindPayIds = [kindPayId isEqualToString:@""] ? [@[] yy_modelToJSONString] : [@[kindPayId] yy_modelToJSONString];
    [TDFBusinessService fecthV2PayDetailWithDate:self.dateString
                                     startTime:startTime
                                       endTime:endTime
                                         isAll:isAll
                                     kindPayId:kindPayIds
                                          type:type
                                       pageNum:self.page
                                 completeBlock:^(TDFResponseModel *response) {
        [self.tbvBase.mj_footer endRefreshing];
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                
                NSArray<TDFBusinessPayDetailItem *> *detailInfoList = [NSArray yy_modelArrayWithClass:[TDFBusinessPayDetailItem class] json:dict[@"data"]];

                if (detailInfoList.count == 0) {
                    [self.tbvBase.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self addImageUrlToDetailList:detailInfoList];
                [self addSelectedBlockToDetailList:detailInfoList];
                
                [self.payInfoSection addItems:detailInfoList];
                
                if (self.payInfoSection.items.count == 0) {
                    self.tbvBase.tableFooterView = self.emptyView;
                    self.tbvBase.scrollEnabled = NO;
                } else {
                    self.tbvBase.tableFooterView = nil;
                    self.tbvBase.scrollEnabled = YES;
                }
                
                [self.manager reloadData];
            }
            
            self.page++;
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }

    }];
}

//- (void)rightNavigationButtonAction:(id)sender
//{
//    NSString *isSuper =[[Platform Instance] getkey:USER_IS_SUPER];
//    if ([isSuper isEqualToString:@"1"]){
//        
//        [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentEditViewControllerWithCallBack:^{
//        }] animated:YES];
//        
//    } else {
//        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您没有[收款账户]的权限", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
//    }
//    [self umengEvent:@"click_bank_account" attributes:nil number:@(1)];
//}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}

- (void)footerPrintBillButtonAction:(UIButton *)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[dateFormatter dateFromString:self.dateString] options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|kCFCalendarUnitYear|kCFCalendarUnitDay fromDate:date];
    
    NSString *printDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)[components year], (long)[components month], (long)[components day]];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_PrintBillViewControllerWithDateStr:printDate];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- Private Methods --

- (NSArray<TDFBusinessSpellModel *> *)generateSpellListWithFetchedDataList:(NSArray<TDFBusinessSpellModel *> *)fetchedDataList
{
    TDFBusinessSpellModel *allSpell = [[TDFBusinessSpellModel alloc] init];
    allSpell.isAll = YES;
    
    NSMutableArray<TDFBusinessSpellModel *> *spellList = [NSMutableArray<TDFBusinessSpellModel *> arrayWithObject:allSpell];
    [spellList addObjectsFromArray:fetchedDataList];
    
    return spellList;
}

- (NSArray<TDFPayInfoModel *> *)generateFullPayInfoListWithFetchedPayInfoList:(NSArray<TDFPayInfoModel *> *)fetchedPayInfoList
{
    TDFPayInfoModel *allPayInfoModel = [[TDFPayInfoModel alloc] init];
    allPayInfoModel.selected = YES;
    allPayInfoModel.isAll = YES;
    allPayInfoModel.kindPayName = NSLocalizedString(@"全部收款", nil);
   
    double allAccount = 0;
    for (TDFPayInfoModel *model in fetchedPayInfoList) {
        allAccount += model.money;
    }
    
    allPayInfoModel.money = allAccount;
    
    NSMutableArray<TDFPayInfoModel *> *fullPayInfoList = [NSMutableArray<TDFPayInfoModel *> arrayWithObject:allPayInfoModel];
    [fullPayInfoList addObjectsFromArray:fetchedPayInfoList];
    
    return fullPayInfoList;
}

- (void)addImageUrlToList:(NSArray<TDFPayInfoModel *> *)fetchedPayInfoList
{
    for (TDFPayInfoModel *model in fetchedPayInfoList) {
        for (TDFPayTypeImageModel *imageModel in self.payTypeImageList) {
            if ([model.kindPayId isEqualToString:imageModel.type]) {
                model.imageUrl = imageModel.imageUrl;
            }
        }
    }
}

- (void)addImageUrlToDetailList:(NSArray<TDFBusinessPayDetailItem *> *)fetchedPayDetailList
{
    for (TDFBusinessPayDetailItem *model in fetchedPayDetailList) {
        NSMutableArray *payTypeImageList = [NSMutableArray array];
        
        for (NSNumber *payType in model.payTypeList) {
            for (TDFPayTypeImageModel *imageModel in self.payTypeImageList) {
                if ([[payType stringValue] isEqualToString:imageModel.type]) {
                    [payTypeImageList addObject:imageModel.imageUrl];
                }
            }
        }
        
        model.payTypeImageList = payTypeImageList;
    }
}

- (void)addSelectedBlockToDetailList:(NSArray<TDFBusinessPayDetailItem *> *)fetchedPayDetailList
{
    for (TDFBusinessPayDetailItem *model in fetchedPayDetailList) {
        @weakify(model);
        @weakify(self);
        model.selectedBlock = ^ () {
            @strongify(model);
            @strongify(self);
            TDFMemberPayInfoController *vc = [[TDFMemberPayInfoController alloc] init];
            vc.orderId = model.orderId;
            vc.totalPayId = model.totalPayId;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}


-(NSString *)realEndTimeWithBegTime:(NSString *)begTime endTime:(NSString *)endTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *begDate = [dateFormatter dateFromString:begTime];
    
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    
    NSComparisonResult result = [begDate compare:endDate];
    
    if (result == NSOrderedDescending) {
        
        endDate = [endDate dateByAddingTimeInterval:24*60*60];

    }

    NSString *realEndTime = [dateFormatter stringFromDate:endDate];
    
    return realEndTime;
}

#pragma mark -- TDFBusinessFlowHeaderViewDelegate --


- (void)businessFlowHeaderView:(TDFBusinessFlowHeaderView *)headerView didSelectedModel:(TDFPayInfoModel *)model
{
    self.page = 1;
    [self.payInfoSection removeAllItems];
    self.kindPayIds = [model.kindPayIds yy_modelToJSONString];
    self.payType = [model.kindPayId isEqualToString:@""] ? @"0" : model.kindPayId;
//    if (![model.kindPayId isEqualToString:@""]) { // 表明是其它支付方式  ,去掉筛选条件，由服务端判断
//        if (model.kindPayIds.count == 0) {
//            [self.payInfoSection removeAllItems];
//            self.tbvBase.tableFooterView = self.emptyView;
//            self.tbvBase.scrollEnabled = NO;
//            [self.manager reloadData];
//            return ;
//        }
//    }
    [self fetchPayDetailDataWithStartTime:self.bDateString endTime:self.eDateString isAll:[self.spellItem.textValue isEqualToString:kBusinessSpellAllDay] kindPayIds:self.kindPayIds type:self.payType];
}


#pragma mark -- Gettes && Setters --

- (TDFBusinessFlowHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[TDFBusinessFlowHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight)];
        _headerView.delegate = self;
    }
    
    return _headerView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 407)];
        
        UILabel *lblEmpty = [[UILabel alloc] initWithFrame:CGRectZero];
        lblEmpty.font = [UIFont systemFontOfSize:18];
        lblEmpty.textColor = [UIColor whiteColor];
        lblEmpty.textAlignment = NSTextAlignmentCenter;
        lblEmpty.text = NSLocalizedString(@"无营业数据", nil);
        
        [_emptyView addSubview:lblEmpty];
        [lblEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_emptyView).with.offset(80);
            make.leading.equalTo(_emptyView);
            make.trailing.equalTo(_emptyView);
            make.height.equalTo(@(20));
        }];
    }
    
    return _emptyView;
}

@end
