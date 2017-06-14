//
//  TDFMemberHistogramView.m
//  Pods
//
//  Created by happyo on 2017/4/10.
//
//

#import "TDFMemberHistogramView.h"
#import "TDFHistogramView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "TDFMemberInfoDayModel.h"
#import "TDFMemberInfoMonthModel.h"
#import "TDFDateUtil.h"
#import "TDFNumberUtil.h"

@interface TDFMemberHistogramView () <TDFHistogramViewDelegate>

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *memberCountLabel;

@property (nonatomic, strong) UIButton *switchButton;

@property (nonatomic, strong) TDFHistogramView *histogramView;

@property (nonatomic, strong) UIView *memberNumberView;

@property (nonatomic, strong) UIView *memberNewIcon;

@property (nonatomic, strong) UILabel *memberNewLabel;

@property (nonatomic, strong) UIView *memberOldIcon;

@property (nonatomic, strong) UILabel *memberOldLabel;

@property (nonatomic, strong) NSArray<TDFMemberInfoDayModel *> *dayList;

@property (nonatomic, strong) NSArray<TDFMemberInfoMonthModel *> *monthList;

/**
是 日报表类型，否则 是月报表
 */
@property (nonatomic, assign) BOOL isDayStyle;

@end
@implementation TDFMemberHistogramView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@200);
            make.height.equalTo(@15);
            make.top.equalTo(@30);
        }];
        
        [self addSubview:self.memberCountLabel];
        [self.memberCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLabel.mas_bottom).with.offset(5);
            make.width.equalTo(@300);
            make.height.equalTo(@13);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.switchButton];
        [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.height.equalTo(@32);
            make.width.equalTo(@64);
        }];
        
        UIImageView *igvRedArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvRedArrow.image = [UIImage imageNamed:@"homePage_red_arrow_icon"];
        [self addSubview:igvRedArrow];
        [igvRedArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self.memberCountLabel.mas_bottom).with.offset(5);
            make.width.equalTo(@(14));
            make.height.equalTo(@(11));
        }];
        
        [self addSubview:self.histogramView];
        [self.histogramView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(91);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-5);
            make.height.equalTo(@70);
        }];
        
        [self addSubview:self.memberNumberView];
        [self.memberNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@12);
            make.top.equalTo(self.histogramView.mas_bottom).with.offset(10);
            make.width.equalTo(@100);
        }];
        
        [self.memberNumberView addSubview:self.memberNewIcon];
        [self.memberNewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.memberNumberView);
            make.centerY.equalTo(self.memberNumberView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
        
        [self.memberNumberView addSubview:self.memberNewLabel];
        [self.memberNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.memberNewIcon.mas_trailing).with.offset(10);
            make.centerY.equalTo(self.memberNumberView);
            make.width.equalTo(@70);
            make.height.equalTo(@12);
        }];

        [self.memberNumberView addSubview:self.memberOldIcon];
        [self.memberOldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.memberNewLabel.mas_trailing).with.offset(20);
            make.centerY.equalTo(self.memberNumberView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
        
        [self.memberNumberView addSubview:self.memberOldLabel];
        [self.memberOldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.memberOldIcon.mas_trailing).with.offset(10);
            make.centerY.equalTo(self.memberNumberView);
            make.width.equalTo(@70);
            make.height.equalTo(@12);
        }];
        
        
    }
    
    return self;
}

- (void)configureViewWithDayList:(NSArray<TDFMemberInfoDayModel *> *)dayList
{
    self.dayList = dayList;
    self.isDayStyle = YES;
    self.switchButton.selected = YES;
    
    [self.histogramView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(-7);
    }];
    [self layoutIfNeeded];
    
    self.histogramView.modelList = [self generateHistogramModelListWithDayList:dayList];
}

- (void)configureViewWithMonthList:(NSArray<TDFMemberInfoMonthModel *> *)monthList
{
    self.monthList = monthList;
    self.isDayStyle = NO;
    self.switchButton.selected = NO;
    
    [self.histogramView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(-2);
    }];
    [self layoutIfNeeded];
    
    self.histogramView.modelList = [self generateHistogramModelListWithMonthList:monthList];
}

- (CGFloat)heightForView
{
    return 200;
}

#pragma mark -- Private Methods --

- (NSArray<TDFHistogramModel *> *)generateHistogramModelListWithDayList:(NSArray<TDFMemberInfoDayModel *> *)dayList
{
    NSMutableArray<TDFHistogramModel *> *histogramModelList = [NSMutableArray array];
    
    double maxCount = [self generateMaxCountWithDayList:dayList];
    
    for (int i = 0; i < dayList.count; i++) {
        TDFMemberInfoDayModel *day = dayList[i];
        
        TDFHistogramModel *model = [[TDFHistogramModel alloc] init];
        model.title = [TDFDateUtil weekNameWithDayString:day.date];
        model.count = day.customerOldNumDay;
        model.topCount = day.customerNumDay;
        
        NSInteger customerCountDay = day.customerOldNumDay + day.customerNumDay;
        model.heightRatio = customerCountDay == 0 ? 0 : customerCountDay / maxCount;
        model.histogramStyle = TDFHistogramStyleTwo;
        
        if ([model.title isEqualToString:@"日"]) { // 如果过是周日，则显示特殊的颜色
            model.specialDotColor = [UIColor whiteColor];
        }
        
        [histogramModelList addObject:model];
    }
    
    return histogramModelList;
}


- (double)generateMaxCountWithDayList:(NSArray<TDFMemberInfoDayModel *> *)dayList
{
    double maxAccount = 0;
    
    for (TDFMemberInfoDayModel *day in dayList) {
        NSInteger customerCountDay = day.customerOldNumDay + day.customerNumDay;
        if (customerCountDay > maxAccount) {
//            maxAccount = day.customerNum;
            maxAccount = customerCountDay;
        }
    }
    
    return maxAccount;
}

- (NSArray<TDFHistogramModel *> *)generateHistogramModelListWithMonthList:(NSArray<TDFMemberInfoMonthModel *> *)monthList
{
    NSMutableArray<TDFHistogramModel *> *histogramModelList = [NSMutableArray array];
    
    double maxAccount = [self generateMaxAccountWithMonthList:monthList];
    
    for (int i = 0; i < monthList.count; i++) {
        TDFMemberInfoMonthModel *month = monthList[i];
        
        TDFHistogramModel *model = [[TDFHistogramModel alloc] init];
        model.title = [TDFDateUtil monthNameWithMonthString:month.month];
        model.count = month.customerOldNumMonth;
        model.topCount = month.customerNumMonth;
        
        NSInteger customerCountMonth = month.customerOldNumMonth + month.customerNumMonth;
        model.heightRatio = customerCountMonth == 0 ? 0 : customerCountMonth / maxAccount;
        
        model.histogramStyle = TDFHistogramStyleTwo;

        [histogramModelList addObject:model];
    }
    
    return histogramModelList;
}


- (double)generateMaxAccountWithMonthList:(NSArray<TDFMemberInfoMonthModel *> *)monthList
{
    double maxAccount = 0;
    
    for (TDFMemberInfoMonthModel *month in monthList) {
        NSInteger customerCountMonth = month.customerOldNumMonth + month.customerNumMonth;

        if (customerCountMonth > maxAccount) {
            maxAccount = customerCountMonth;
        }
    }
    
    return maxAccount;
}

- (void)configureDateLabelAndCountLabelWithDayString:(NSString *)dayString count:(int)count
{
    NSDateComponents *components = [TDFDateUtil dateComponentsWithDayString:dayString];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%i年%02i月", (int)components.year, (int)components.month];
    
    self.memberCountLabel.text = [NSString stringWithFormat:@"%02i月%02i日 %@ 总会员数：%@%@", (int)components.month, (int)components.day, [TDFDateUtil fullWeekNameWithDayString:dayString], [TDFNumberUtil seperatorDotStringWithInt:count], [TDFNumberUtil unitWithNum:count baseUnit:@"人"]];
}

- (void)configureDateLabelAndCountLabelWithMonthString:(NSString *)monthString count:(int)count
{
    NSDateComponents *components = [TDFDateUtil dateComponentsWithMonthString:monthString];

    self.dateLabel.text = [NSString stringWithFormat:@"%i年", (int)components.year];
    
    self.memberCountLabel.text = [NSString stringWithFormat:@"%02i月 总会员数：%@%@", (int)components.month, [TDFNumberUtil seperatorDotStringWithInt:count], [TDFNumberUtil unitWithNum:count baseUnit:@"人"]];
}

- (void)configureMemberNewLabelWithCount:(int)count
{
    self.memberNewLabel.text = [NSString stringWithFormat:@"新会员%@%@", [TDFNumberUtil seperatorDotStringWithInt:count], [TDFNumberUtil unitWithNum:count baseUnit:@"人"]];
}

- (void)configureMemberOldLabelWithCount:(int)count
{
    self.memberOldLabel.text = [NSString stringWithFormat:@"老会员%@%@", [TDFNumberUtil seperatorDotStringWithInt:count], [TDFNumberUtil unitWithNum:count baseUnit:@"人"]];
}

#pragma mark -- TDFHistogramViewDelegate --

- (void)histogramView:(TDFHistogramView *)view didScrollToModel:(TDFHistogramModel *)model index:(NSInteger)index
{
    if (self.isDayStyle) {
        NSInteger dayIndex = index;
        if (dayIndex >= self.dayList.count) {
            return ;
        }
        
        TDFMemberInfoDayModel *currentDayModel = self.dayList[dayIndex];
        
        [self configureDateLabelAndCountLabelWithDayString:currentDayModel.date count:(currentDayModel.customerNumDay + currentDayModel.customerOldNumDay)];
        
        [self configureMemberNewLabelWithCount:currentDayModel.customerNumDay];
        
        [self configureMemberOldLabelWithCount:currentDayModel.customerOldNumDay];
        
        [self updateMemberNumberConstants];
        
        if ([self.delegate respondsToSelector:@selector(memberHistogramView:didScrollToDayModel:atIndex:)]) {
            [self.delegate memberHistogramView:self didScrollToDayModel:currentDayModel atIndex:index];
        }
    } else {
        NSInteger monthIndex = index;
        if (monthIndex >= self.monthList.count) {
            return ;
        }
        
        TDFMemberInfoMonthModel *currentMonthModel = self.monthList[monthIndex];
        
        [self configureDateLabelAndCountLabelWithMonthString:currentMonthModel.month count:(currentMonthModel.customerNumMonth + currentMonthModel.customerOldNumMonth)];
        
        [self configureMemberNewLabelWithCount:currentMonthModel.customerNumMonth];
        
        [self configureMemberOldLabelWithCount:currentMonthModel.customerOldNumMonth];
        
        [self updateMemberNumberConstants];
        
        if ([self.delegate respondsToSelector:@selector(memberHistogramView:didScrollToMonthModel:atIndex:)]) {
            [self.delegate memberHistogramView:self didScrollToMonthModel:currentMonthModel atIndex:index];
        }
    }
}

- (void)updateMemberNumberConstants
{
    [self.memberNewLabel sizeToFit];
    
    [self.memberOldLabel sizeToFit];
    
    [self.memberNewLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.memberNewLabel.bounds.size.width));
    }];
    
    [self.memberOldLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.memberOldLabel.bounds.size.width));
    }];
    
    [self.memberNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.memberNewLabel.bounds.size.width + self.memberOldLabel.bounds.size.width + 60));
    }];
    
    [self layoutIfNeeded];
}

- (CGFloat)histogramItemViewWidth:(TDFHistogramView *)view
{
    if (self.isDayStyle) {
        return 20;
    } else {
        return 30;
    }
}

#pragma mark -- Actions --

- (void)switchButtonClicked:(UIButton *)button
{
    self.isDayStyle = !self.isDayStyle;
    
    button.selected = self.isDayStyle;
    
    if ([self.delegate respondsToSelector:@selector(memberHistogramView:switchStyle:)]) {
        [self.delegate memberHistogramView:self switchStyle:self.isDayStyle];
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}

- (UILabel *)memberCountLabel
{
    if (!_memberCountLabel) {
        _memberCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _memberCountLabel.font = [UIFont systemFontOfSize:13];
        _memberCountLabel.textColor = [UIColor whiteColor];
        _memberCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _memberCountLabel;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_switchButton setBackgroundImage:[UIImage imageNamed:@"member_home_month_selected_icon"] forState:UIControlStateNormal];
        [_switchButton setBackgroundImage:[UIImage imageNamed:@"member_home_day_selected_icon"] forState:UIControlStateSelected];
        [_switchButton addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _switchButton.selected = YES;
    }
    
    return _switchButton;
}

- (TDFHistogramView *)histogramView
{
    if (!_histogramView) {
        _histogramView = [[TDFHistogramView alloc] initWithFrame:CGRectZero];
        _histogramView.delegate = self;
    }
    
    return _histogramView;
}

- (UIView *)memberNewIcon
{
    if (!_memberNewIcon) {
        _memberNewIcon = [[UIView alloc] initWithFrame:CGRectZero];
        _memberNewIcon.backgroundColor = [UIColor colorWithHeX:0xCC0000];
    }
    
    return _memberNewIcon;
}

- (UILabel *)memberNewLabel
{
    if (!_memberNewLabel) {
        _memberNewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _memberNewLabel.font = [UIFont systemFontOfSize:12];
        _memberNewLabel.textColor = [UIColor whiteColor];
    }
    
    return _memberNewLabel;
}

- (UIView *)memberNumberView
{
    if (!_memberNumberView) {
        _memberNumberView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _memberNumberView;
}

- (UIView *)memberOldIcon
{
    if (!_memberOldIcon) {
        _memberOldIcon = [[UIView alloc] initWithFrame:CGRectZero];
        _memberOldIcon.backgroundColor = [UIColor whiteColor];
    }
    
    return _memberOldIcon;
}

- (UILabel *)memberOldLabel
{
    if (!_memberOldLabel) {
        _memberOldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _memberOldLabel.font = [UIFont systemFontOfSize:12];
        _memberOldLabel.textColor = [UIColor whiteColor];
    }
    
    return _memberOldLabel;
}

@end
