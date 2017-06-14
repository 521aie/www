//
//  TDFBusinessInfoView.m
//  RestApp
//
//  Created by happyo on 2016/11/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessInfoView.h"
#import "TDFBusinessDetailPanelView.h"
#import "FormatUtil.h"
#import "UIImage+Resize.h"
#import "TDFBusinessBarChartView.h"
#import "TDFBusinessAccountInfoListView.h"
#import "UIColor+Hex.h"

@interface TDFBusinessInfoView () <TDFBusinessBarChartViewDelegate>

@property (nonatomic, strong) UILabel *lblDate;

@property (nonatomic, strong) UILabel *lblDateUnit;

@property (nonatomic, strong) UIImageView *igvDate;

@property (nonatomic, strong) UILabel *lblHeaderTitle;

@property (nonatomic, strong) UILabel *lblAcount;

@property (nonatomic, strong) UIButton *btnForward;

@property (nonatomic, strong) UIButton *btnExtension;

@property (nonatomic, strong) UIButton *btnClose;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, strong) TDFBusinessAccountInfoListView *infoListView;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) TDFBusinessInfoModel *model;

@property (nonatomic, strong) NSString *dayDate;

@property (nonatomic, strong) NSString *monthDate;

@property (nonatomic, strong) TDFBusinessBarChartView *businessChartView;

//
@property (nonatomic, strong) NSArray *dataTitleList;

@property (nonatomic, strong) NSArray *dataList;

//

@property (nonatomic, assign) double account;

@property (nonatomic, assign) TDFBusinessDateStyle dateStyle;

@property (nonatomic, strong) NSString *dateString;

@end
@implementation TDFBusinessInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.bottom.equalTo(self);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
        }];
        
        [self addSubview:self.igvDate];
        [self.igvDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(10);
            make.top.equalTo(self.alphaView).with.offset(30);
            make.height.equalTo(@(30));
            make.width.equalTo(@(30));
        }];
        
        [self addSubview:self.lblDate];
        [self.lblDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.igvDate).with.offset(2);
            make.width.equalTo(@(17));
            make.bottom.equalTo(self.igvDate);
            make.height.equalTo(@(24));
        }];
        
        [self addSubview:self.lblDateUnit];
        [self.lblDateUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.lblDate.mas_trailing);
            make.width.equalTo(@(10));
            make.bottom.equalTo(self.igvDate);
            make.height.equalTo(@(24));
        }];
        
        [self addSubview:self.lblHeaderTitle];
        [self.lblHeaderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alphaView).with.offset(10);
            make.leading.equalTo(self.alphaView).with.offset(50);
            make.height.equalTo(@(13));
            make.trailing.equalTo(self.alphaView).with.offset(-100);
        }];
        
        [self addSubview:self.lblAcount];
        [self.lblAcount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.igvDate);
            make.leading.equalTo(self.alphaView).with.offset(50);
            make.height.equalTo(@(36));
            make.trailing.equalTo(self).with.offset(-70);
        }];
        
        [self addSubview:self.btnExtension];
        [self.btnExtension mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.alphaView);
            make.leading.equalTo(self.alphaView);
            make.top.equalTo(self.alphaView);
            make.height.equalTo(@77);
        }];
        
        UIImageView *igvArrowDown = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowDown.image = [UIImage imageNamed:@"business_info_arrow_down"];
        
        [self.btnExtension addSubview:igvArrowDown];
        [igvArrowDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnExtension);
            make.trailing.equalTo(self.btnExtension).with.offset(-10);
            make.height.equalTo(@(8));
            make.width.equalTo(@(13));
        }];
        
        UILabel *lblExtension = [[UILabel alloc] initWithFrame:CGRectZero];
        lblExtension.font = [UIFont systemFontOfSize:13];
        lblExtension.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lblExtension.textAlignment = NSTextAlignmentRight;
        lblExtension.text = NSLocalizedString(@"展开", nil);
        
        [self.btnExtension addSubview:lblExtension];
        [lblExtension mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnExtension);
            make.trailing.equalTo(self.btnExtension).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(60));
        }];
        
        [self addSubview:self.btnClose];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.btnExtension);
        }];
        
        UIImageView *igvArrowUp = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowUp.image = [UIImage imageNamed:@"business_info_arrow_up"];
        
        [self.btnClose addSubview:igvArrowUp];
        [igvArrowUp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnClose);
            make.trailing.equalTo(self.btnClose).with.offset(-10);
            make.height.equalTo(@(8));
            make.width.equalTo(@(13));
        }];
        
        UILabel *lblClose = [[UILabel alloc] initWithFrame:CGRectZero];
        lblClose.font = [UIFont systemFontOfSize:13];
        lblClose.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lblClose.textAlignment = NSTextAlignmentRight;
        lblClose.text = @"收起";
        
        [self.btnClose addSubview:lblClose];
        [lblClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnClose);
            make.trailing.equalTo(self.btnClose).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(60));
        }];

        
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblAcount.mas_bottom).with.offset(10);
            make.leading.equalTo(self.alphaView).with.offset(10);
            make.trailing.equalTo(self.alphaView).with.offset(-10);
            make.height.equalTo(@(0.5));
        }];
        
        [self addSubview:self.businessChartView];
        [self.businessChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.spliteView.mas_bottom);
            make.leading.equalTo(self.alphaView);
            make.trailing.equalTo(self.alphaView);
            make.height.equalTo(@([TDFBusinessBarChartView heightForChartView]));
        }];
        
        [self addSubview:self.infoListView];
        [self.infoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.businessChartView.mas_bottom).with.offset(10);
            make.leading.equalTo(self.alphaView);
            make.trailing.equalTo(self.alphaView);
            make.height.equalTo(@(100));
        }];
        
        [self addSubview:self.btnForward];
        [self.btnForward mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.alphaView);
            make.top.equalTo(self.infoListView);
            make.bottom.equalTo(self.infoListView).with.offset(33);
            make.leading.equalTo(self.alphaView);
        }];
        
        UILabel *lblForward = [[UILabel alloc] initWithFrame:CGRectZero];
        lblForward.font = [UIFont systemFontOfSize:13];
        lblForward.textColor = [UIColor colorWithHeX:0x0088CC];
        lblForward.textAlignment = NSTextAlignmentRight;
        lblForward.text = @"查看营业流水";
        
        [self.btnForward addSubview:lblForward];
        [lblForward mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.btnForward).with.offset(-15);
            make.trailing.equalTo(self.btnForward).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(150));
        }];
        
        UIImageView *igvArrowRight = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowRight.image = [UIImage imageNamed:@"business_info_arrow_right_blue"];
        [self.btnForward addSubview:igvArrowRight];
        [igvArrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.btnForward).with.offset(-15);
            make.trailing.equalTo(self.btnForward).with.offset(-10);
            make.height.equalTo(@(13));
            make.width.equalTo(@(8));
        }];

    }
    
    return self;
}

#pragma mark -- Public Methods --

- (void)configureViewWithAccount:(double)account dateStyle:(TDFBusinessDateStyle)dateStyle dateString:(NSString *)dateString
{
    self.account = account;
    self.dateStyle = dateStyle;
    self.dateString = dateString;
    
    NSString *firstString = dateStyle == TDFBusinessDateStyleDay ? @"今" : @"本";
    self.lblHeaderTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@收益(元)", nil), firstString, [self getDateStyleString:dateStyle]];
    
    self.lblAcount.text = [FormatUtil formatDoubleWithSeperator:account];
    
    self.lblDate.text = dateString;
    
    self.lblDateUnit.text = [self getDateStyleString:dateStyle];
    
    self.igvDate.image = [self getDateImageWithDateStyle:dateStyle];

    self.btnExtension.hidden = NO;
    self.btnClose.hidden = YES;
    
    self.btnForward.hidden = YES;
    
    // 隐藏分割线
    self.spliteView.hidden = YES;
    
    // 隐藏柱状图
    self.businessChartView.hidden = YES;
    
    // 隐藏列表
    [self.infoListView configureViewWithModelList:nil];
    [self.infoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.infoListView.heightForView));
    }];
    [self layoutIfNeeded];
}

- (void)configureViewWithDayList:(NSArray<TDFBusinessInfoModel *> *)dayList monthDate:(NSString *)monthDate
{
    self.monthDate = monthDate;
    
    self.btnExtension.hidden = YES;
    self.btnClose.hidden = NO;
    
    self.btnForward.hidden = NO;
    
    // 显示分割线
    self.spliteView.hidden = NO;
    
    // 显示柱状图
    self.businessChartView.hidden = NO;
//    [self.businessChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.spliteView.mas_bottom);
//        make.leading.equalTo(self.alphaView);
//        make.trailing.equalTo(self.alphaView);
//        make.height.equalTo(@([TDFBusinessBarChartView heightForChartView]));
//    }];
    
    [self.businessChartView configureViewWithDayList:dayList monthDate:monthDate];

}

//- (void)configureViewWithMonthModel:(TDFBusinessInfoModel *)monthModel
//{
//    self.btnExtension.hidden = YES;
//    self.btnClose.hidden = NO;
//    
//    self.btnForward.hidden = YES;
//    
//    // 显示分割线
//    self.spliteView.hidden = NO;
//    
//    // 隐藏柱状图
//    self.businessChartView.hidden = YES;
//    [self.businessChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.spliteView.mas_bottom);
//        make.leading.equalTo(self.alphaView);
//        make.trailing.equalTo(self.alphaView);
//        make.height.equalTo(@(0));
//    }];
//    
//    // 显示列表
//    [self configureDataInfoListWithModel:monthModel];
//}

- (void)configureViewWithMonthList:(NSArray<TDFBusinessInfoModel *> *)monthList
{
    self.btnExtension.hidden = YES;
    self.btnClose.hidden = NO;
    
    self.btnForward.hidden = YES;
    
    // 显示分割线
    self.spliteView.hidden = NO;
    
    // 显示柱状图
    self.businessChartView.hidden = NO;
//    [self.businessChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.spliteView.mas_bottom);
//        make.leading.equalTo(self.alphaView);
//        make.trailing.equalTo(self.alphaView);
//        make.height.equalTo(@([TDFBusinessBarChartView heightForChartView]));
//    }];

    [self.businessChartView configureViewWithMonthList:monthList];
}

- (void)configureDataInfoListWithModel:(TDFBusinessInfoModel *)model
{

    NSMutableArray *dataTitleList = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"应收(元)", nil), NSLocalizedString(@"折扣(元)", nil), NSLocalizedString(@"损益(元)", nil), NSLocalizedString(@"账单数(单)", nil), NSLocalizedString(@"总客人(人)", nil), NSLocalizedString(@"人均(元)", nil), NSLocalizedString(@"会员充值金额(元)", nil), NSLocalizedString(@"会员充值次数(次)", nil)]];
    
    NSString *sourceAmount = [FormatUtil formatDoubleWithSeperator:model.sourceAmount];
    NSString *discountAmount = [FormatUtil formatDoubleWithSeperator:model.discountAmount];
    NSString *profitLoseAmount = [FormatUtil formatDoubleWithSeperator:model.profitLossAmount];
    NSString *orderCount = [FormatUtil formatInt:model.orderCount];
    NSString *mealsCount = [FormatUtil formatInt:model.mealsCount];
    NSString *actualAmountAvg = [FormatUtil formatDoubleWithSeperator:model.actualAmountAvg];
    NSString *memberChargeAmount = [FormatUtil formatDoubleWithSeperator:model.memberChargeAmount];
    NSString *memberChargeTimes = [FormatUtil formatInt:model.memberChargeTimes];

    NSMutableArray *dataList = [NSMutableArray arrayWithArray:@[sourceAmount, discountAmount, profitLoseAmount, orderCount, mealsCount, actualAmountAvg, memberChargeAmount, memberChargeTimes]];
    
    NSMutableArray<TDFBusinessAccountInfoModel *> *infoList = [NSMutableArray<TDFBusinessAccountInfoModel *> array];
    
    for (TDFPayInfoModel *payInfoModel in model.pays) {
        [dataTitleList addObject:payInfoModel.kindPayName];
        [dataList addObject:[NSString stringWithFormat:@"%0.2f", payInfoModel.money]];
    }
    
    for (int i = 0; i < dataTitleList.count; i++) {
        TDFBusinessAccountInfoModel *model = [[TDFBusinessAccountInfoModel alloc] init];
        model.title = dataTitleList[i];
        model.account = dataList[i];
        model.isShowDescription = [model.title isEqualToString:NSLocalizedString(@"会员充值金额(元)", nil)];
        
        [infoList addObject:model];
    }

    [self.infoListView configureViewWithModelList:infoList];
    [self.infoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.infoListView.heightForView));
    }];
    [self layoutIfNeeded];
}

- (void)hiddenForwardView:(BOOL)hidden
{
    self.btnForward.hidden = hidden;
}

- (UIImage *)getDateImageWithDateStyle:(TDFBusinessDateStyle)dateStyle
{
    UIImage *image;
    if (dateStyle == TDFBusinessDateStyleDay) {
        image = [UIImage imageNamed:@"business_icon_back_day"];
    } else {
        image = [UIImage imageNamed:@"business_icon_back_month"];
    }
    
    return image;
}

- (void)configureHeaderTitleWithDate:(NSString *)date dateStyle:(TDFBusinessDateStyle)dateStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateStyle == TDFBusinessDateStyleDay ? @"yyyyMMdd" : @"yyyyMM";
    NSDate *todayDate = [NSDate date];
    
    NSString *firstString = dateStyle == TDFBusinessDateStyleDay ? @"今" : @"本";
    NSString *prefix = [date isEqualToString:[dateFormatter stringFromDate:todayDate]] ? firstString : @"当";
    self.lblHeaderTitle.text = [NSString stringWithFormat:@"%@%@收益(元)", prefix, [self getDateStyleString:dateStyle]];
}

- (NSString *)getDateStyleString:(TDFBusinessDateStyle)dateStyle
{
    NSString *dateStyleString;
    if (dateStyle == TDFBusinessDateStyleDay) {
        dateStyleString = NSLocalizedString(@"日", nil);
    } else {
        dateStyleString = NSLocalizedString(@"月", nil);
    }
    
    return dateStyleString;
}

- (NSAttributedString *)getAttributedDateWithDateNum:(NSString *)dateNum dateStyle:(TDFBusinessDateStyle)dateStyle
{
    if (!dateNum) {
        return nil;
    }
    
    NSString *dateStyleString = [self getDateStyleString:dateStyle];

    NSString *dateString = [dateNum stringByAppendingString:dateStyleString];
    NSMutableAttributedString *attributedDateString = [[NSMutableAttributedString alloc] initWithString:dateString];
    [attributedDateString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, dateNum.length)];

    return attributedDateString;
}

- (CGFloat)heightForInfoView
{
    CGFloat height = self.infoListView.isHidden ? 0 : self.infoListView.heightForView + 77 + (self.businessChartView.isHidden ? 0 : [TDFBusinessBarChartView heightForChartView]);
    
    height += self.btnForward.isHidden ? 0 : 40;
    
    return height;
}

- (void)btnForwardClicked
{
    if (self.forwardBlock) {
        self.forwardBlock(self.dayDate);
    }
}

- (void)btnExtensionClicked
{
    if (self.extensionBlock) {
        self.extensionBlock();
    }
}

- (void)btnCloseClicked
{
//    [self configureViewWithAccount:self.account dateStyle:self.dateStyle dateString:self.dateString];
    self.btnExtension.hidden = NO;
    self.btnClose.hidden = YES;
    
    self.btnForward.hidden = YES;
    
    // 隐藏分割线
    self.spliteView.hidden = YES;
    
    // 隐藏柱状图
    self.businessChartView.hidden = YES;
    
    // 隐藏列表
    //    self.dateInfoView.dataTitleArray = nil;
    //    self.dateInfoView.dataArray = nil;
    [self.infoListView configureViewWithModelList:nil];
    [self.infoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.infoListView.heightForView));
    }];
    [self layoutIfNeeded];

    if (self.delegate) {
        [self.delegate businessInfoViewHeightChanged:self];
    }
}

#pragma mark -- TDFBusinessBarChartViewDelegate -

- (void)chartView:(TDFBusinessBarChartView *)chartView monthDidChanged:(NSString *)newDate
{
    if (self.delegate) {
        [self.delegate businessInfoView:self monthDidChanged:newDate];
    }
}

- (void)chartView:(TDFBusinessBarChartView *)chartView dayDidChanged:(TDFBusinessInfoModel *)newDayModel dayDate:(NSString *)dayDate
{
    self.lblAcount.text = [FormatUtil formatDoubleWithSeperator:newDayModel.actualAmount];
    self.account = newDayModel.actualAmount;
    
    [self configureHeaderTitleWithDate:newDayModel.date dateStyle:self.dateStyle];
    
    self.lblDate.text = dayDate;
    
    [self configureDataInfoListWithModel:newDayModel];
    self.dayDate = newDayModel.date;
    if (self.delegate) {
        [self.delegate businessInfoViewHeightChanged:self];
    }
}

- (void)chartView:(TDFBusinessBarChartView *)chartView monthDidChanged:(TDFBusinessInfoModel *)newMonthModel monthDate:(NSString *)monthDate
{
    self.lblAcount.text = [FormatUtil formatDoubleWithSeperator:newMonthModel.actualAmount];
    self.account = newMonthModel.actualAmount;
    
    [self configureHeaderTitleWithDate:newMonthModel.date dateStyle:self.dateStyle];
    
    self.lblDate.text = monthDate;
    [self configureDataInfoListWithModel:newMonthModel];
    if (self.delegate) {
        [self.delegate businessInfoViewHeightChanged:self];
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)lblDate
{
    if (!_lblDate) {
        _lblDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDate.font = [UIFont systemFontOfSize:13];
        _lblDate.textColor = RGBA(102, 102, 102, 1);
        _lblDate.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblDate;
}

- (UILabel *)lblDateUnit
{
    if (!_lblDateUnit) {
        _lblDateUnit = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDateUnit.font = [UIFont systemFontOfSize:9];
        _lblDateUnit.textColor = RGBA(102, 102, 102, 1);
        _lblDateUnit.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblDateUnit;
}

- (UIImageView *)igvDate
{
    if (!_igvDate) {
        _igvDate = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _igvDate;
}

- (UILabel *)lblHeaderTitle
{
    if (!_lblHeaderTitle) {
        _lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblHeaderTitle.font = [UIFont systemFontOfSize:13];
        _lblHeaderTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return _lblHeaderTitle;
}

- (UILabel *)lblAcount
{
    if (!_lblAcount) {
        _lblAcount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblAcount.font = [UIFont systemFontOfSize:30];
        _lblAcount.adjustsFontSizeToFitWidth = YES;
        _lblAcount.textColor = [UIColor whiteColor];
    }
    
    return _lblAcount;
}

- (UIButton *)btnForward
{
    if (!_btnForward) {
        _btnForward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnForward addTarget:self action:@selector(btnForwardClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnForward;
}

- (UIButton *)btnExtension
{
    if (!_btnExtension) {
        _btnExtension = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnExtension addTarget:self action:@selector(btnExtensionClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnExtension;
}

- (UIButton *)btnClose
{
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnClose;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}

- (TDFBusinessAccountInfoListView *)infoListView
{
    if (!_infoListView) {
        _infoListView = [[TDFBusinessAccountInfoListView alloc] initWithFrame:CGRectZero];
    }
    
    return _infoListView;
}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _alphaView.layer.cornerRadius = 3;
    }
    
    return _alphaView;
}

- (TDFBusinessBarChartView *)businessChartView
{
    if (!_businessChartView) {
        _businessChartView = [[TDFBusinessBarChartView alloc] init];
        _businessChartView.delegate = self;
        _businessChartView.hidden = YES;
    }
    
    return _businessChartView;
}

- (NSArray *)dataTitleList
{
    if (!_dataTitleList) {
        _dataTitleList = [NSArray array];
    }
    
    return _dataTitleList;
}

- (NSArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    
    return _dataList;
}

@end
