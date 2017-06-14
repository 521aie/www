//
//  TDFBusinessDetailPanelView.m
//  RestApp
//
//  Created by 黄河 on 16/9/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessDetailPanelView.h"
#import "BusinessSummaryVO.h"
@implementation TDFDataHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self layoutView];
        [self drawLine];
    }
    return self;
}


- (void)layoutView{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
    }];
    
}

- (void)drawLine{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(10,self.frame.size.height-1)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - 20,self.frame.size.height - 1)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
    });
}

#pragma mark --init
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

@end

@implementation TDFDataTitleInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.dateButton setBackgroundImage:[UIImage imageNamed:@"icon_day.png"] forState:UIControlStateNormal];
        self.dateButton.titleLabel.font = [UIFont systemFontOfSize:10];
        self.dateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.dateButton setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
        [self addSubview:self.dateButton];
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.alpha = 0.7;
        self.titleLabel.text = NSLocalizedString(@"昨日收益", nil);
        [self addSubview:self.titleLabel];
        
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.font = [UIFont systemFontOfSize:48];
        [self addSubview:self.detailLabel];
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView{
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@38);
        make.height.equalTo(@38);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(8);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.lessThanOrEqualTo(self.mas_width);
    }];
}


#pragma mark --init
- (UIButton *)dateButton
{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _dateButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

@end

@implementation TDFDataInfoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.titleLabel];
        self.dataLabel.font = [UIFont systemFontOfSize:14];
        self.dataLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.dataLabel];
        
        [self addSubview:self.lblDescription];
        [self layoutView];
    }
    return self;
}

- (void)layoutView{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(self.mas_width);
    }];
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.lessThanOrEqualTo(self.mas_width);
    }];
    
    [self.lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataLabel.mas_bottom);
        make.leading.equalTo(self.dataLabel);
        make.trailing.equalTo(self.dataLabel);
        make.height.equalTo(@(9));
    }];
}

#pragma mark --init

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)dataLabel
{
    if (!_dataLabel) {
        _dataLabel = [UILabel new];
    }
    return _dataLabel;
}

- (UILabel *)lblDescription
{
    if (!_lblDescription) {
        _lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDescription.font = [UIFont systemFontOfSize:9];
        _lblDescription.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return _lblDescription;
}

@end

#define DataInfoDetailWidth (SCREEN_WIDTH - 20)/3.0
#define DataInfoDetailHeight 35

@interface TDFDataInfoView ()
@property (nonatomic, strong)NSMutableArray *viewArray;
@end

@implementation TDFDataInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self updateData];
}

- (void)updateData{
    for (TDFDataInfoDetailView *detailView in self.viewArray) {
        detailView.dataLabel.text = _dataArray[[self.viewArray indexOfObject:detailView]];
    }
}

- (void)setDescriptionArray:(NSArray *)descriptionArray
{
    _descriptionArray = descriptionArray;
    for (TDFDataInfoDetailView *detailView in self.viewArray) {
        NSNumber *isShowDesc = _descriptionArray[[self.viewArray indexOfObject:detailView]];
        detailView.lblDescription.text = [isShowDesc boolValue] ? NSLocalizedString(@"(不计入收益)", nil) : @"";
    }
}


- (void)setDataTitleArray:(NSArray *)dataTitleArray
{
    _dataTitleArray = dataTitleArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.viewArray removeAllObjects];
    [self layoutView];
}

- (CGFloat)heightForView
{
    NSInteger count = self.dataTitleArray.count;
    NSInteger lineNum = (count % 3 == 0) ? count /3 : count / 3 + 1;
    return lineNum * (DataInfoDetailHeight + 20);
}

- (void)layoutView{
    for (int i = 0; i < _dataTitleArray.count; i ++) {
        int x = i % 3;
        int y = i / 3;
        CGFloat width = self.cellWidthd == 0 ? DataInfoDetailWidth : self.cellWidthd;
        TDFDataInfoDetailView *detailView = [[TDFDataInfoDetailView alloc] initWithFrame:CGRectMake((width + 1) * x,(DataInfoDetailHeight + 20) * y , width , DataInfoDetailHeight)];
        detailView.titleLabel.text = [_dataTitleArray objectAtIndex:i];
        [self addSubview:detailView];
        [self.viewArray addObject:detailView];
        if (x != 2) {
            [self drawLineWithFrame:detailView.frame];
        }
    }
}

- (void)drawLineWithFrame:(CGRect)frame{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(frame.origin. x + frame.size.width, frame.origin.y)];
        [path addLineToPoint:CGPointMake(frame.origin. x + frame.size.width,frame.origin.y + frame.size.height)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
    });
}

- (NSMutableArray *)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

@end



@implementation TDFBusinessDetailPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleInfoView.userInteractionEnabled = NO;
        self.infoView.userInteractionEnabled = NO;
        [self addSubview:self.headerView];
        [self addSubview:self.titleInfoView];
        [self addSubview:self.infoView];
        [self addTarget:self action:@selector(touchUpClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark --init
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[TDFDataHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
        _headerView.userInteractionEnabled = NO;
    }
    return _headerView;
}

- (UIView *)titleInfoView
{
    if (!_titleInfoView) {
        _titleInfoView = [[TDFDataTitleInfoView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 85)];
    }
    return _titleInfoView;
}

- (UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[TDFDataInfoView alloc] initWithFrame:CGRectMake(5, 130, self.frame.size.width - 10, 90)];
    }
    return _infoView;
}

#pragma mark --setter
- (void)setDataTitleArray:(NSArray *)dataTitleArray
{
    _dataTitleArray = dataTitleArray;
    self.infoView.dataTitleArray = dataTitleArray;
}


- (void)initDataWithDateYesterDay:(NSString *)yesterDay
                    andYesterDate:(NSString *)yesterDate
                    andTotalAmout:(NSString *)totalAmout
                         withData:(id)data{
    NSString *yesterDayStr = [yesterDay stringByAppendingString:NSLocalizedString(@"日", nil)];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:yesterDayStr];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, yesterDay.length)];
    [self.titleInfoView.dateButton setAttributedTitle:aAttributedString forState:UIControlStateNormal];
    self.titleInfoView.titleLabel.text = yesterDate;
    self.infoView.dataArray = data;
    self.titleInfoView.detailLabel.text = totalAmout;
}
#pragma mark --点击事件
- (void)touchUpClick:(UIControl *)control
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchUpClick)]) {
        [self.delegate touchUpClick];
    }
}
@end

