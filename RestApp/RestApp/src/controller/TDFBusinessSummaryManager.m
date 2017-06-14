//
//  TDFBusinessSummaryManager.m
//  RestApp
//
//  Created by happyo on 2016/11/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessSummaryManager.h"
#import "TDFBusinessDetailPanelView.h"
#import "TDFBusinessService.h"
#import "TDFResponseModel.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFBusinessInfoView.h"
#import "TDFBusinessInfoModel.h"
#import "YYModel.h"
#import "DateUtils.h"
#import "TDFMemberLevelService.h"
#import "TDFCustomerLevelModel.h"
#import "TDFMemberLevelCollectionViewCell.h"

@interface TDFBusinessSummaryManager () <TDFBusinessInfoViewDelegate>

@property (nonatomic, strong, readwrite) UIView *view;

@property (nonatomic, strong) NSArray<TDFBusinessInfoModel *> *dayModelList;

@property (nonatomic, strong) TDFBusinessInfoView *businessDayView;

@property (nonatomic, strong) TDFBusinessInfoView *businessMonthView;

@property (nonatomic, strong) TDFMemberLevelCollectionViewCell *memberLevelView;

@end
@implementation TDFBusinessSummaryManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        //
        [self.view addSubview:self.businessDayView];
        [self.businessDayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(5);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.height.equalTo(@(1));
        }];

        [self.view addSubview:self.businessMonthView];
        [self.businessMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.businessDayView.mas_bottom).with.offset(5);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.height.equalTo(@(1));
        }];
        
        [self.view addSubview:self.memberLevelView];
        [self.memberLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.businessMonthView.mas_bottom).with.offset(10);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.height.equalTo(@([TDFMemberLevelCollectionViewCell heightForCell]));
        }];
        
        @weakify(self);
        self.businessDayView.extensionBlock = ^ () {
            @strongify(self);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyyMM";
            
            [self fetchDayBusinessDataWithDate:[dateFormatter stringFromDate:[NSDate date]]];
        };
        
        self.businessDayView.forwardBlock = ^ (NSString *dayString) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(managerForwardDidClicked:withDayString:)]) {
                [self.delegate managerForwardDidClicked:self withDayString:dayString];
            }
        };
        
        self.businessMonthView.extensionBlock = ^ () {
            @strongify(self);
            [self fetchMonthBusinessData];
        };
    }
    
    return self;
}

- (void)fetchBusinessData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMM";

    [self fetchSummaryDataWithDate:[dateFormatter stringFromDate:[NSDate date]]];
}

- (void)fetchSummaryDataWithDate:(NSString *)date
{
    self.view.hidden = YES;
    [self.viewController showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchV2HomeBusinessSummaryWithMonthDate:date completeBlock:^(TDFResponseModel *response) {
        self.viewController.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                NSDictionary *dataDict = dict[@"data"];
                
                NSNumber *monthProfit = dataDict[@"monthProfit"]; // 当月收益
                NSNumber *todayProfit = dataDict[@"todayProfit"]; // 当日收益

                NSString *month = dataDict[@"month"]; // 月
                NSString *day = dataDict[@"day"]; // 日,个位数没有0
                
                [self.businessDayView configureViewWithAccount:[todayProfit doubleValue] dateStyle:TDFBusinessDateStyleDay dateString:day];
                [self.businessMonthView configureViewWithAccount:[monthProfit doubleValue] dateStyle:TDFBusinessDateStyleMonth dateString:month];
                [self performSelectorOnMainThread:@selector(updateInfoViewHeight) withObject:nil waitUntilDone:YES];
                
                [self fetchMemberLevelDistribution];
                self.view.hidden = NO;
            }
        } else {
            [self.viewController showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
            [self performSelectorOnMainThread:@selector(updateInfoViewHeight) withObject:nil waitUntilDone:YES];
        }
        
    }];
}

- (void)fetchDayBusinessDataWithDate:(NSString *)date
{
    [self.viewController showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchV2DayBusinessDetailWithCompleteBlock:^(TDFResponseModel *response) {
        self.viewController.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                
                self.dayModelList = [NSArray yy_modelArrayWithClass:[TDFBusinessInfoModel class] json:dict[@"data"]];
                [self.businessDayView configureViewWithDayList:self.dayModelList monthDate:date];
                [self performSelectorOnMainThread:@selector(updateInfoViewHeight) withObject:nil waitUntilDone:YES];
            }
        } else {
            [self.viewController showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)fetchMonthBusinessData
{
    [self.viewController showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchRecentMonthsBusinessDetailWithCompleteBlock:^(TDFResponseModel *response) {
        self.viewController.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                
                NSArray<TDFBusinessInfoModel *> *monthList = [NSArray yy_modelArrayWithClass:[TDFBusinessInfoModel class] json:dict[@"data"]];
                
                [self.businessMonthView configureViewWithMonthList:monthList];
                
                [self performSelectorOnMainThread:@selector(updateInfoViewHeight) withObject:nil waitUntilDone:YES];
            }
        } else {
            [self.viewController showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)fetchMemberLevelDistribution
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    NSString *yesterDay =[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    @weakify(self);
    [self.viewController showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[[TDFMemberLevelService alloc] init] memberLevelDistributionV2WithParam:@{@"date":yesterDay} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        self.viewController.progressHud.hidden = YES;
        
        NSDictionary *dataDict = data[@"data"];
        
        NSNumber *isHasPermission = dataDict[@"isHasPermission"];
        
        if ([isHasPermission boolValue]) {
            // 有权限显示
            self.memberLevelView.hidden = NO;
            NSArray<TDFCustomerLevelModel *> *levelList = [NSArray<TDFCustomerLevelModel *> yy_modelArrayWithClass:[TDFCustomerLevelModel class] json:dataDict[@"customerLevelVos"]];
            
            self.memberLevelView.levelList = levelList;
            TDFCustomerLevelModel *model = levelList[0];
            
            NSDate *currentDate = [DateUtils DateWithString:model.date type:TDFFormatTimeTypeYearMonthDayString];
            
            NSString *dateStr = [DateUtils formatTimeWithDate:currentDate type:TDFFormatTimeTypeChinese];
            self.memberLevelView.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"会员等级分布 (%@)", nil),dateStr.length > 0 ? dateStr:@""];
        } else {
            self.memberLevelView.hidden = YES;
        }
        
        if ([self.delegate respondsToSelector:@selector(manager:viewHeightChanged:)]) {
            [self.delegate manager:self viewHeightChanged:[self heightForView]];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.viewController showMessageWithTitle:error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
    }];
}

- (void)updateInfoViewHeight
{
    CGFloat dayHeight = [self.businessDayView heightForInfoView];
    [self.businessDayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(5);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(dayHeight));
    }];
    
    CGFloat monthHeight = [self.businessMonthView heightForInfoView];
    [self.businessMonthView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.businessDayView.mas_bottom).with.offset(5);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(monthHeight));
    }];
    
    if ([self.delegate respondsToSelector:@selector(manager:viewHeightChanged:)]) {
        [self.delegate manager:self viewHeightChanged:[self heightForView]];
    }
}

- (CGFloat)heightForView
{
    if (self.view.isHidden) {
        return 0;
    } else {
        return [self.businessDayView heightForInfoView] + [self.businessMonthView heightForInfoView] + (self.memberLevelView.isHidden ? 0 : [TDFMemberLevelCollectionViewCell heightForCell]) + 20;
    }
}

#pragma mark -- TDFBusinessInfoViewDelegate --

- (void)businessInfoView:(TDFBusinessInfoView *)view monthDidChanged:(NSString *)newMonth
{
    if (view == self.businessDayView) {
        [self fetchDayBusinessDataWithDate:newMonth];
    }
}

- (void)businessInfoViewHeightChanged:(TDFBusinessInfoView *)view
{
    [self performSelectorOnMainThread:@selector(updateInfoViewHeight) withObject:nil waitUntilDone:YES];
}

#pragma mark -- Getters && Setters --

- (UIView *)view
{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _view;
}

- (TDFBusinessInfoView *)businessDayView
{
    if (!_businessDayView) {
        _businessDayView = [[TDFBusinessInfoView alloc] init];
        _businessDayView.delegate = self;
    }
    
    return _businessDayView;
}

- (TDFBusinessInfoView *)businessMonthView
{
    if (!_businessMonthView) {
        _businessMonthView = [[TDFBusinessInfoView alloc] init];
        _businessMonthView.delegate = self;
    }
    
    return _businessMonthView;
}

- (TDFMemberLevelCollectionViewCell *)memberLevelView
{
    if (!_memberLevelView) {
        _memberLevelView = [[TDFMemberLevelCollectionViewCell alloc] initWithFrame:CGRectZero];
        _memberLevelView.backgroundColor = [UIColor clearColor];
        _memberLevelView.rightLabel.hidden = YES;
        _memberLevelView.icon.hidden = YES;
    }
    
    return _memberLevelView;
}

@end
