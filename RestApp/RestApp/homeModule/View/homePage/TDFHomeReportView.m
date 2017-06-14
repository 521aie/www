//
//  TDFHomeReportView.m
//  Pods
//
//  Created by happyo on 2017/3/8.
//
//

#import "TDFHomeReportView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "TDFHomeReportDayView.h"
#import "YYModel.h"
#import "TDFHomeReportMonthView.h"
#import "TDFHomeReportMemberView.h"
#import "UIImageView+WebCache.h"
#import "NSString+TDF_Empty.h"
#import "TDFNumberUtil.h"

@implementation TDFHomeReportModel


@end

@interface TDFHomeReportView () <TDFHomeReportHistogramDelegate>

@property (nonatomic, strong) TDFHomeReportModel *model;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *numberUnitLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *helpButton;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *countUnitLabel;

@property (nonatomic, strong) UIButton *extensionButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) TDFHomeReportDayView *dayView;

@property (nonatomic, strong) TDFHomeReportMonthView *monthView;

@property (nonatomic, strong) TDFHomeReportMemberView *memberView;

@end
@implementation TDFHomeReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 展开前的视图
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
//            make.bottom.equalTo(self);
            make.height.equalTo(@100);
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(10);
            make.top.equalTo(self.alphaView).with.offset(30);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView).with.offset(2);
            make.width.equalTo(@(17));
            make.bottom.equalTo(self.iconImageView);
            make.height.equalTo(@(24));
        }];
        
        [self addSubview:self.numberUnitLabel];
        [self.numberUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.numberLabel.mas_trailing);
            make.width.equalTo(@(10));
            make.bottom.equalTo(self.iconImageView);
            make.height.equalTo(@(24));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(50);
            make.top.equalTo(self.alphaView).with.offset(10);
            make.height.equalTo(@13);
        }];
        
        [self addSubview:self.helpButton];
        [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).with.offset(2);
            make.centerY.equalTo(self.titleLabel);
            make.height.equalTo(@18);
            make.width.equalTo(@18);
        }];
        
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(10);
            make.centerY.equalTo(self.iconImageView);
            make.height.equalTo(@30);
        }];
        
        [self addSubview:self.countUnitLabel];
        [self.countUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.countLabel.mas_trailing);
            make.bottom.equalTo(self.countLabel).with.offset(-4);
            make.height.equalTo(@15);
        }];
        
        [self addSubview:self.extensionButton];
        [self.extensionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.alphaView);
            make.leading.equalTo(self.alphaView);
            make.top.equalTo(self.alphaView).with.offset(20);
            make.height.equalTo(@77);
        }];
        
        [self addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.extensionButton);
        }];
        
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeReportModel *)model
{
    self.model = model;
    
    self.titleLabel.text = model.title;
    
    self.numberLabel.text = model.number;
    self.numberUnitLabel.text = model.numberUnit;
    
    
    self.countLabel.text = model.count;
    self.countUnitLabel.text = model.countUnit;
    
    self.helpButton.hidden = ![model.helpUrl isNotEmpty];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImage] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"]];
        
    [self updateStatusButtonWithIsFold:model.isFold];
    
    if ([model.reportStyle isEqualToString:@"reportDay"]) {
        if (![self.dayView isDescendantOfView:self]) {
            [self addSubview:self.dayView];
            [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(86);
                make.leading.equalTo(self).with.offset(10);
                make.trailing.equalTo(self).with.offset(-10);
                make.height.equalTo(@100);
            }];
        }
        
        NSArray<TDFHomeReportHistogramModel *> *histogramModelList = [NSArray<TDFHomeReportHistogramModel *> yy_modelArrayWithClass:[TDFHomeReportHistogramModel class] json:model.reportModel];
        
        [self.dayView configureViewWithModelList:histogramModelList forwardString:model.forwardDescription forwardUrl:model.forwardUrl];
        [self.dayView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.dayView heightForView]));
        }];
    }
    
    if ([model.reportStyle isEqualToString:@"reportMonth"]) {
        if (![self.monthView isDescendantOfView:self]) {
            [self addSubview:self.monthView];
            [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(86);
                make.leading.equalTo(self).with.offset(10);
                make.trailing.equalTo(self).with.offset(-10);
                make.height.equalTo(@100);
            }];
        }
        
        NSArray<TDFHomeReportHistogramModel *> *histogramModelList = [NSArray<TDFHomeReportHistogramModel *> yy_modelArrayWithClass:[TDFHomeReportHistogramModel class] json:model.reportModel];
        
        [self.monthView configureViewWithModelList:histogramModelList forwardString:model.forwardDescription forwardUrl:model.forwardUrl];
        [self.monthView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.monthView heightForView]));
        }];
    }

    if ([model.reportStyle isEqualToString:@"reportMember"]) {
        if (![self.memberView isDescendantOfView:self]) {
            [self addSubview:self.memberView];
            [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(86);
                make.leading.equalTo(self).with.offset(10);
                make.trailing.equalTo(self).with.offset(-10);
                make.height.equalTo(@100);
            }];
        }
        
        TDFHomeReportMemberModel *memberModel = [TDFHomeReportMemberModel yy_modelWithJSON:model.reportModel];
        self.memberView.forwardUrl = model.forwardUrl;
        self.memberView.forwardString = model.forwardDescription;

        [self.memberView configureViewWithModel:memberModel];
        [self.memberView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.memberView heightForView]));
        }];
    }
    
    [self.alphaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self heightForView] - 10));
    }];
    [self layoutIfNeeded];
}

- (void)updateStatusButtonWithIsFold:(BOOL)isFold
{
    self.extensionButton.hidden = !isFold;
    self.closeButton.hidden = isFold;
    
    if ([self.model.reportStyle isEqualToString:@"reportDay"]) {
        self.dayView.hidden = isFold;
    }
    
    if ([self.model.reportStyle isEqualToString:@"reportMonth"]) {
        self.monthView.hidden = isFold;
    }
    
    if ([self.model.reportStyle isEqualToString:@"reportMember"]) {
        self.memberView.hidden = isFold;
    }
    
    [self.alphaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self heightForView] - 10));
    }];
    [self layoutIfNeeded];
}

- (CGFloat)heightForView
{
    CGFloat reportHeight = 0;
    
    if (!self.model.isFold) {
        if ([self.model.reportStyle isEqualToString:@"reportDay"]) {
            reportHeight = [self.dayView heightForView];
        }
        
        if ([self.model.reportStyle isEqualToString:@"reportMonth"]) {
            reportHeight = [self.monthView heightForView];
        }
        
        if ([self.model.reportStyle isEqualToString:@"reportMember"]) {
            reportHeight = [self.memberView heightForView];
        }
    }
    
    return 87 + reportHeight;
}

#pragma mark -- TDFHomeReportHistogramDelegate --

- (void)homeReportHistogramView:(TDFHomeReportHistogramView *)histogramView didScrollToModel:(TDFHomeReportHistogramModel *)model
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *chainAppendTitle = [[Platform Instance] isChainOrBranch] ? @"所有门店" : @"";
    
    if ([self.model.reportStyle isEqualToString:@"reportDay"]) {
        dateFormatter.dateFormat = @"yyyyMMdd";
        NSDate *date = [dateFormatter dateFromString:model.date];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
        
        NSString *currentDayString = [dateFormatter stringFromDate:[NSDate date]];
        
        self.titleLabel.text = [currentDayString isEqualToString:model.date] ? [NSString stringWithFormat:@"今日%@收益", chainAppendTitle] : [NSString stringWithFormat:@"当日%@收益", chainAppendTitle];
        
        self.numberLabel.text = [NSString stringWithFormat:@"%2i", (int)components.day];
        
        [self.dayView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.dayView heightForView]));
        }];
    }
    
    if ([self.model.reportStyle isEqualToString:@"reportMonth"]) {
        dateFormatter.dateFormat = @"yyyyMM";
        NSDate *date = [dateFormatter dateFromString:model.date];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
        
        NSString *currentMonthString = [dateFormatter stringFromDate:[NSDate date]];
        
        self.titleLabel.text = [currentMonthString isEqualToString:model.date] ? [NSString stringWithFormat:@"本月%@收益", chainAppendTitle] : [NSString stringWithFormat:@"当月%@收益", chainAppendTitle];
        
        self.numberLabel.text = [NSString stringWithFormat:@"%2i", (int)components.month];
        
        [self.monthView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.monthView heightForView]));
        }];
    }
    
    [self.alphaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self heightForView] - 10));
    }];
    [self layoutIfNeeded];
    
    self.countLabel.text = [TDFNumberUtil seperatorDotStringWithDouble:model.dAccount];
    self.countUnitLabel.text = [TDFNumberUtil unitWithNum:model.dAccount baseUnit:@"元"];
    
    if (self.viewHeightChanged) {
        self.viewHeightChanged([self heightForView]);
    }
    
}

- (void)homeReportHistogramView:(TDFHomeReportHistogramView *)histogramView didClickForwardButton:(NSString *)forwardUrl
{
    // 自己拼接type参数，以后会修改
    NSString *type = @"";
    if (histogramView == self.dayView) {
        type = @"day";
    } else {
        type = @"month";
    }
    
    NSString *urlWithParamType = [forwardUrl stringByAppendingString:[NSString stringWithFormat:@"&type=%@", type]];
    
    if (self.forwardWithUrlBlock) {
        self.forwardWithUrlBlock(urlWithParamType);
    }
}

#pragma mark -- Actions --

- (void)btnCloseClicked
{
    self.model.isFold = YES;
    
    [self updateStatusButtonWithIsFold:YES];
    
    if (self.viewHeightChanged) {
        self.viewHeightChanged([self heightForView]);
    }
}

- (void)btnExtensionClicked
{
    if (self.fetchExtensionData) {
        self.fetchExtensionData(self.model.extensionUrl);
    }
}

- (void)helpButtonClicked
{
    if (self.forwardWithUrlBlock) {
        self.forwardWithUrlBlock(self.model.helpUrl);
    }
}

#pragma mark -- Getters && Setters --

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _alphaView.layer.cornerRadius = 5;
    }
    
    return _alphaView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _iconImageView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.textColor = [UIColor colorWithHeX:0x666666];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _numberLabel;
}

- (UILabel *)numberUnitLabel
{
    if (!_numberUnitLabel) {
        _numberUnitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberUnitLabel.font = [UIFont systemFontOfSize:9];
        _numberUnitLabel.textColor = [UIColor colorWithHeX:0x666666];
        _numberUnitLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _numberUnitLabel;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return _titleLabel;
}

- (UIButton *)helpButton
{
    if (!_helpButton) {
        _helpButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_helpButton setBackgroundImage:[UIImage imageNamed:@"homePage_report_help_icon"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _helpButton;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.font = [UIFont systemFontOfSize:30];
        _countLabel.textColor = [UIColor whiteColor];
    }
    
    return _countLabel;
}

- (UILabel *)countUnitLabel
{
    if (!_countUnitLabel) {
        _countUnitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countUnitLabel.font = [UIFont systemFontOfSize:15];
        _countUnitLabel.textColor = [UIColor whiteColor];
    }
    
    return _countUnitLabel;
}

- (UIButton *)extensionButton
{
    if (!_extensionButton) {
        _extensionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_extensionButton addTarget:self action:@selector(btnExtensionClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *igvArrowDown = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowDown.image = [UIImage imageNamed:@"homePage_arrow_down"];
        
        [_extensionButton addSubview:igvArrowDown];
        [igvArrowDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_extensionButton).with.offset(-20);
            make.trailing.equalTo(_extensionButton).with.offset(-10);
            make.height.equalTo(@(13));
            make.width.equalTo(@(13));
        }];
        
        UILabel *lblExtension = [[UILabel alloc] initWithFrame:CGRectZero];
        lblExtension.font = [UIFont systemFontOfSize:13];
        lblExtension.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lblExtension.textAlignment = NSTextAlignmentRight;
        lblExtension.text = @"展开";
        
        [_extensionButton addSubview:lblExtension];
        [lblExtension mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_extensionButton).with.offset(-20);
            make.trailing.equalTo(_extensionButton).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(60));
        }];

    }
    
    return _extensionButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeButton addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *igvArrowUp = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowUp.image = [UIImage imageNamed:@"homePage_arrow_up"];
        
        [_closeButton addSubview:igvArrowUp];
        [igvArrowUp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_closeButton).with.offset(-20);
            make.trailing.equalTo(_closeButton).with.offset(-10);
            make.height.equalTo(@(13));
            make.width.equalTo(@(13));
        }];
        
        UILabel *lblClose = [[UILabel alloc] initWithFrame:CGRectZero];
        lblClose.font = [UIFont systemFontOfSize:13];
        lblClose.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lblClose.textAlignment = NSTextAlignmentRight;
        lblClose.text = @"收起";
        
        [_closeButton addSubview:lblClose];
        [lblClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_closeButton).with.offset(-20);
            make.trailing.equalTo(_closeButton).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(60));
        }];
    }
    
    return _closeButton;
}

- (TDFHomeReportDayView *)dayView
{
    if (!_dayView) {
        _dayView = [[TDFHomeReportDayView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _dayView.delegate = self;
    }
    
    return _dayView;
}

- (TDFHomeReportMonthView *)monthView
{
    if (!_monthView) {
        _monthView = [[TDFHomeReportMonthView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _monthView.delegate = self;
    }
    
    return _monthView;
}

- (TDFHomeReportMemberView *)memberView
{
    if (!_memberView) {
        _memberView = [[TDFHomeReportMemberView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        @weakify(self);
        _memberView.forwardWithUrlBlock = ^(NSString *forwardUrl) {
            @strongify(self);
            if (self.forwardWithUrlBlock) {
                self.forwardWithUrlBlock(forwardUrl);
            }
        };
    }
    
    return _memberView;
}

@end
