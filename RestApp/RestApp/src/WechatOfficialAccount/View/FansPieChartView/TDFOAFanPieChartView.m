//
//  TDFOAFanPieChartView.m
//  TDFDNSPod
//
//  Created by Octree on 17/3/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFOAFanPieChartView.h"
#import "TDFPieChartView.h"
#import "TDFExpanableLabel.h"
#import <Masonry/Masonry.h>
#import "TDFOAFanCommentItemView.h"

@interface TDFOAFanPieChartView ()<TDFPieChartViewDelegate>

@property (strong, nonatomic) UIView *labelContainerView;           //   饼图 Item 对应的 Label 的 Container
@property (strong, nonatomic) UIView *commentContainerView;   // item-h: 21 margin : 5@property (strong, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) NSArray *presenters;
@property (strong, nonatomic) TDFPieChartView *chartView;           //   饼图

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) TDFExpanableLabel *highlightLabel;
@property (strong, nonatomic, readwrite) UIButton *fansButton;
@property (strong, nonatomic) NSArray *pieItemCache;

@property (strong, nonatomic) NSMutableArray *pieLabels;

@end

@implementation TDFOAFanPieChartView


#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)title presenters:(NSArray <id<TDFOAFanPieChartItemPresentable>>*)presenters {

    if (self = [super init]) {
        
        self.titleLabel.text = title;
        [self configViews];
        [self reloadWithPresenters:presenters];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    
    return self;
}

#pragma mark - Public Method

- (void)reloadWithPresenters:(NSArray <id<TDFOAFanPieChartItemPresentable>>*)presenters {
    
    self.presenters = presenters;
    self.pieItemCache = [self pieItems];
    
    self.chartView.items = self.pieItemCache;
    [self reloadPieView];
    [self reloadCommentView];
    [self reloadPieLabelView];
}

- (CGFloat)expectedHeight {

    return 280 + 21 * self.presenters.count;// - 44;//  FUCK: -0
}

#pragma mark - Private Method

#pragma mark Reload

- (void)reloadPieView {

    [self.chartView stroke:YES];
}


- (void)reloadCommentView {

    [self.commentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    MASViewAttribute *attr = self.commentContainerView.mas_top;
    CGFloat offset = 5;
    for (id<TDFOAFanPieChartItemPresentable> presenter in self.presenters) {
        
        TDFOAFanCommentItemView *view = [self generateCommentItemWithPresenter:presenter];
        [self.commentContainerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentContainerView);
            make.right.equalTo(self.commentContainerView);
            make.top.equalTo(attr).with.offset(offset);
            make.height.equalTo(@21);
        }];
        attr = view.mas_bottom;
        offset = 0;
    }
}

- (void)reloadPieLabelView {

    [self.labelContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = self.presenters.count;
    
    for (NSInteger index = 0; index < count; index++) {
    
        double start = 0, end = 0;
        UILabel *label = [self reuseLabelWithIndex:index];
        [self getPieScopeWithIndex:index startPersentage:&start endPersentage:&end];
        double angle = (start + end) * M_PI;            //   扇形中心的角度
        double yoffset = -70 * cos(angle);
        double xoffset = 70 * sin(angle);
        if (angle > M_PI) {
            xoffset -= label.frame.size.width / 2;
        } else {
            xoffset += label.frame.size.width / 2;
        }
        //  越靠近 x 轴，y 的偏移越大。
        CGFloat offset = 80 / (fabs(xoffset) - 50);
        if (angle > M_PI * 1.5 && angle < M_PI / 2) {
            yoffset -= MIN(5, offset);
        } else {
            yoffset += MIN(5, offset);
        }
//        CGRect frame = label.frame;
//        label.frame = frame;
        [self.labelContainerView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.labelContainerView).with.offset(xoffset);
            make.centerY.equalTo(self.labelContainerView).with.offset(yoffset);
        }];
        id<TDFOAFanPieChartItemPresentable> presenter = self.presenters[index];
        label.hidden = presenter.ratio < 0.00001;
    }
}

- (UILabel *)reuseLabelWithIndex:(NSInteger)index {

    id<TDFOAFanPieChartItemPresentable> presenter = self.presenters[index];
    UILabel *label = nil;
    
    if (index < self.pieLabels.count) {
        
        label = self.pieLabels[index];
    } else {
    
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:13];
        [self.pieLabels addObject:label];
    }
    
    label.text = presenter.pieDescription;
    label.textColor = presenter.pieColor;
    [label sizeToFit];
    return label;
}

- (TDFOAFanCommentItemView *)generateCommentItemWithPresenter:(id<TDFOAFanPieChartItemPresentable>)presenter {

    TDFOAFanCommentItemView *itemView = [[TDFOAFanCommentItemView alloc] init];
    
    itemView.colorView.backgroundColor = presenter.pieColor;
    itemView.titleLabel.text = presenter.commentTitle;
    itemView.detailLabel.text = presenter.commentDescription;
    itemView.ratioLabel.text = presenter.commentRatioDescription;
    
    return itemView;
}

#pragma mark ConfigView

- (void)getPieScopeWithIndex:(NSInteger)index startPersentage:(double *)start endPersentage:(double *)end {

    TDFPieChartItem *item = nil;
    for (NSInteger i = 0; i < index; i++) {
        
        item = self.pieItemCache[i];
        *start += item.ratio;
    }
    
    item = self.pieItemCache[index];
    *end = *start + item.ratio;
}

- (void)configViews {

    [self addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@180);
    }];
    
    [self.chartView addSubview:self.labelContainerView];
    [self.labelContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chartView);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.top.equalTo(self.chartView.mas_bottom);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.fansButton];
    [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-15);
        make.height.equalTo(@30);  //  FUCK:30
        make.width.equalTo(@180);
    }];
    
    //self.fansButton.hidden = YES;//  FUCK:
    
    UIView *sepLine2 = [[UIView alloc] init];
    sepLine2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self addSubview:sepLine2];
    [sepLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.fansButton.mas_top).with.offset(-10);     //  FUCK:-10
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.commentContainerView];
    [self.commentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(sepLine.mas_bottom);
        make.bottom.equalTo(sepLine2.mas_top);
    }];
}

#pragma mark UpdateView

- (void)updateHighlightedLabelWithIndex:(NSInteger)index {

    CGFloat halfWidth = self.labelContainerView.frame.size.width / 2;
    CGFloat halfHeight = self.labelContainerView.frame.size.height / 2;
    UILabel *label = self.pieLabels[index];
    CGPoint origin = label.frame.origin;
    
    id<TDFOAFanPieChartItemPresentable> presenter = self.presenters[index];
    self.highlightLabel.text = presenter.highlightDescription;
    
    [self.highlightLabel removeFromSuperview];
    [self.labelContainerView addSubview:self.highlightLabel];
    
    [self.highlightLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        if (origin.x >= halfWidth) {
        
            make.right.equalTo(self.labelContainerView.mas_right).with.offset(-10);
        } else {
            make.left.equalTo(self.labelContainerView.mas_left).with.offset(10);
        }
        
        if (origin.y < halfHeight) {
            
            make.top.equalTo(label.mas_bottom).with.offset(5);
        } else {
        
            make.bottom.equalTo(label.mas_top).with.offset(-5);
        }
        
        make.width.equalTo(@130);
    }];
    if ([self.delegate respondsToSelector:@selector(fanPieChartView:didSelectItemAtIndex:)]) {
        [self.delegate fanPieChartView:self didSelectItemAtIndex:index];
    }
}

#pragma mark - Pie

- (NSArray *)pieItems {

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.presenters.count];
    
    for (id<TDFOAFanPieChartItemPresentable> presenter in self.presenters) {
        
        [array addObject:[TDFPieChartItem itemWithRatio:presenter.ratio color:presenter.pieColor text:nil]];
    }
    
    /**
     *  最小 5%
     */
    for (TDFPieChartItem *item in array) {
        
        if (item.ratio < 0.05 && item.ratio > 0.00001) {
            
            TDFPieChartItem *max = [self maxRatioItemInPieItems:array];
            max.ratio -= 0.05 - item.ratio;
            item.ratio = 0.05;
        }
    }
    
    return [array copy];
}


- (TDFPieChartItem *)maxRatioItemInPieItems:(NSArray *)items {

    TDFPieChartItem *maxRatioItem = [items firstObject];
    for (TDFPieChartItem *item in items) {
        if (item.ratio > maxRatioItem.ratio) {
            maxRatioItem = item;
        }
    }
    
    return maxRatioItem;
}


#pragma mark - TDFPieChartViewDelegate

- (void)pieChartView:(TDFPieChartView *)chartView didSelectedItemAtIndex:(NSUInteger)index {
 
    [self updateHighlightedLabelWithIndex:index];
}

- (void)pieChartViewDidTouchOutSide:(TDFPieChartView *)chartView {

    [self.highlightLabel removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(fanPieChartViewDidDeSelectItem:)]) {
        [self.delegate fanPieChartViewDidDeSelectItem:self];
    }
}

#pragma mark - Accessor

- (UIView *)labelContainerView {
    
    if (!_labelContainerView) {
        
        _labelContainerView =  [[UIView alloc] init];
        _labelContainerView.backgroundColor = [UIColor clearColor];
    }
    return _labelContainerView;
}

- (UIView *)commentContainerView {
    
    if (!_commentContainerView) {
        
        _commentContainerView =  [[UIView alloc] init];
        _commentContainerView.backgroundColor = [UIColor clearColor];
    }
    return _commentContainerView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:11];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}

- (TDFPieChartView *)chartView {
    
    if (!_chartView) {
        
        _chartView = [[TDFPieChartView alloc] init];
        _chartView.radius = 60;
        _chartView.delegate = self;
    }
    return _chartView;
}

- (TDFExpanableLabel *)highlightLabel {
    
    if (!_highlightLabel) {
        
        _highlightLabel = [[TDFExpanableLabel alloc] init];
        _highlightLabel.font = [UIFont systemFontOfSize:11];
        _highlightLabel.textColor = [UIColor whiteColor];
        _highlightLabel.horizontalExpan = 20;
        _highlightLabel.verticalExpan = 20;
        _highlightLabel.numberOfLines = 0;
        _highlightLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _highlightLabel.layer.masksToBounds = YES;
        _highlightLabel.layer.cornerRadius = 5;
        _highlightLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _highlightLabel.userInteractionEnabled = NO;
    }
    return _highlightLabel;
}

- (UIButton *)fansButton {

    if (!_fansButton) {
        
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansButton.backgroundColor = [UIColor colorWithRed:7.0 / 255 green:173.0 / 244 blue:31.0 / 255 alpha:1.0];
        [_fansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fansButton setTitle:@"转化粉丝" forState:UIControlStateNormal];
        _fansButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _fansButton.layer.masksToBounds = YES;
        _fansButton.layer.cornerRadius = 5;
    }
    
    return _fansButton;
}

- (void)setTitle:(NSString *)title {

    self.titleLabel.text = title;
}


- (NSMutableArray *)pieLabels {

    if (!_pieLabels) {
        
        _pieLabels = [[NSMutableArray alloc] init];
    }
    
    return _pieLabels;
}


@end
