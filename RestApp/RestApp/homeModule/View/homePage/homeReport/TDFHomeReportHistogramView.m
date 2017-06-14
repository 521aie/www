//
//  TDFHomeReportHistogramView.m
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import "TDFHomeReportHistogramView.h"
#import "TDFHistogramView.h"
#import "TDFCollectionView.h"
#import "Masonry.h"
#import "TDFHomeReportListCell.h"
#import "YYModel.h"
#import "TDFCommonInfoListView.h"
#import "UIColor+Hex.h"
#import "NSString+TDF_Empty.h"

@implementation TDFHomeReportHistogramModel

- (double)dAccount
{
    NSString *noDotString = [self.account stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return [noDotString doubleValue];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"commonCells" : [TDFHomeReportListCellModel class]};
}

@end

@interface TDFHomeReportHistogramView () <TDFHistogramViewDelegate>

@property (nonatomic, strong) TDFCommonInfoListView *infoListView;

@property (nonatomic, strong) UIButton *forwardButton;

@property (nonatomic, strong) UILabel *forwardLabel;

@property (nonatomic, strong) NSString *forwardUrl;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, copy) NSArray<TDFHomeReportHistogramModel *> *modelList;

@property (nonatomic, strong) TDFHomeReportHistogramModel *currentModel;

@end
@implementation TDFHomeReportHistogramView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        if ([self conformsToProtocol:@protocol(TDFHomeReportHistogramProtocol)]) {
            self.child = (id<TDFHomeReportHistogramProtocol>)self;
        }
        
        self.clipsToBounds = YES;
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(15));
        }];
        
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(14));
        }];
        
        UIImageView *igvRedArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvRedArrow.image = [UIImage imageNamed:@"business_bar_chart_red_arrow"];
        [self addSubview:igvRedArrow];
        [igvRedArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(-5);
            make.top.equalTo(self.subTitleLabel.mas_bottom).with.offset(5);
            make.width.equalTo(@(14));
            make.height.equalTo(@(11));
        }];
        
        [self addSubview:self.histogramView];
//        [self.histogramView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(70);
//            make.leading.equalTo(self).with.offset(10);
//            make.trailing.equalTo(self).with.offset(-5);
//            make.height.equalTo(@70);
//        }];

        [self addSubview:self.infoListView];
        [self.infoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.histogramView.mas_bottom).with.offset(10);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@0);
        }];

        [self addSubview:self.forwardButton];
        [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self);
            make.top.equalTo(self.infoListView);
            make.bottom.equalTo(self.infoListView).with.offset(33);
            make.leading.equalTo(self);
        }];
        
        [self.forwardButton addSubview:self.forwardLabel];
        [self.forwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.forwardButton).with.offset(-15);
            make.trailing.equalTo(self.forwardButton).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(150));
        }];
        
        UIImageView *igvArrowRight = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowRight.image = [UIImage imageNamed:@"business_info_arrow_right_blue"];
        [self.forwardButton addSubview:igvArrowRight];
        [igvArrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.forwardButton).with.offset(-15);
            make.trailing.equalTo(self.forwardButton).with.offset(-10);
            make.height.equalTo(@(13));
            make.width.equalTo(@(8));
        }];
    }
    
    return self;
}

#pragma mark -- Public Methods --

- (void)configureViewWithModelList:(NSArray<TDFHomeReportHistogramModel *> *)modelList forwardString:(NSString *)forwardString forwardUrl:(NSString *)forwardUrl
{
    self.modelList = modelList;
    self.forwardUrl = forwardUrl;
    
    if ([forwardString isNotEmpty]) {
        self.forwardLabel.text = forwardString;
        self.forwardButton.hidden = NO;
    } else {
        self.forwardButton.hidden = YES;
    }
    
    if ([self.child respondsToSelector:@selector(updateHistogramMasonry)]) {
        [self.child updateHistogramMasonry];
    }
    
    self.histogramView.modelList = [self generateHistogramModelListWithModelList:modelList];
}

- (CGFloat)heightForView
{
    return 140 + self.infoListView.heightForView + 10 + (self.forwardButton.hidden ? 0 : 33);
}

#pragma mark -- Private Methods --

- (NSArray<TDFHistogramModel *> *)generateHistogramModelListWithModelList:(NSArray<TDFHomeReportHistogramModel *> *)modelList
{
    NSMutableArray<TDFHistogramModel *> *histogramModelList = [NSMutableArray array];
    
    double maxAccount = [self generateMaxAccountWithInfoModelList:modelList];
    
    for (int i = 0; i < modelList.count; i++) {
        TDFHomeReportHistogramModel *infoModel = modelList[i];
        
        if ([self.child conformsToProtocol:@protocol(TDFHomeReportHistogramProtocol)]) {
            TDFHistogramModel *model = [self.child transformReportModelToHistogramModel:infoModel maxAccount:maxAccount];
            
            [histogramModelList addObject:model];
        }
    }
    
    return histogramModelList;
}

- (double)generateMaxAccountWithInfoModelList:(NSArray<TDFHomeReportHistogramModel *> *)infoModelList
{
    double maxAccount = 0;
    
    for (TDFHomeReportHistogramModel *infoModel in infoModelList) {
        if (infoModel.dAccount > maxAccount) {
            maxAccount = infoModel.dAccount;
        }
    }
    
    return maxAccount;
}

#pragma mark -- Actions --

- (void)forwardButtonClicked
{
    if (!self.currentModel) {
        return ;
    }
    
    if ([self.delegate respondsToSelector:@selector(homeReportHistogramView:didClickForwardButton:)]) {
        // 自己拼接date参数，以后会修改
        NSString *urlWithParamDate = [self.forwardUrl stringByAppendingString:[NSString stringWithFormat:@"?date=%@", self.currentModel.date]];
        
        [self.delegate homeReportHistogramView:self didClickForwardButton:urlWithParamDate];
    }
}

#pragma mark -- TDFHistogramViewDelegate --

- (void)histogramView:(TDFHistogramView *)view didScrollToModel:(TDFHistogramModel *)model index:(NSInteger)index
{
    NSInteger dayIndex = index;
    if (dayIndex >= self.modelList.count) {
        return ;
    }
    self.currentModel = self.modelList[dayIndex];
    
    if ([self.child respondsToSelector:@selector(configureTitleWithModel:)]) {
        [self.child configureTitleWithModel:self.currentModel];
    }
    
    [self.infoListView configureViewWithModelList:self.currentModel.commonCells];
    [self.infoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.infoListView.heightForView));
    }];
    [self layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(homeReportHistogramView:didScrollToModel:)]) {
        [self.delegate homeReportHistogramView:self didScrollToModel:self.currentModel];
    }
}

- (CGFloat)histogramItemViewWidth:(TDFHistogramView *)view
{
    if ([self.child respondsToSelector:@selector(histogramItemWidth)]) {
        return [self.child histogramItemWidth];
    } else {
        return 10;
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _subTitleLabel;
}

- (TDFHistogramView *)histogramView
{
    if (!_histogramView) {
        _histogramView = [[TDFHistogramView alloc] initWithFrame:CGRectMake(10, 70, self.bounds.size.width - 11, 70)];
        _histogramView.delegate = self;
    }
    
    return _histogramView;
}


- (TDFCommonInfoListView *)infoListView
{
    if (!_infoListView) {
        _infoListView = [[TDFCommonInfoListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    
    return _infoListView;
}

- (NSArray<TDFHomeReportHistogramModel *> *)modelList
{
    if (!_modelList) {
        _modelList = [NSArray<TDFHomeReportHistogramModel *> array];
    }
    
    return _modelList;
}

- (UIButton *)forwardButton
{
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton addTarget:self action:@selector(forwardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _forwardButton;
}

- (UILabel *)forwardLabel
{
    if (!_forwardLabel) {
        _forwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _forwardLabel.font = [UIFont systemFontOfSize:13];
        _forwardLabel.textColor = [UIColor colorWithHeX:0x0088CC];
        _forwardLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _forwardLabel;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}

@end
