//
//  TDFHealthCheckScanView.m
//  RestApp
//
//  Created by 黄河 on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckScanView.h"
#import "TDFLayoutGroupListView.h"
#import "TDFHealthCheckConfigViewModel.h"
#import "TDFLayoutGroupListWithImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+TDFRequest.h"
#import "UIColor+Hex.h"
#import "NSString+TDFRegix.h"
#import "UIView+TDFUIKit.h"
#import "Masonry.h"

@implementation TDFHealthCheckScanHeaderImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@21);
            make.height.equalTo(@21);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end


@interface TDFHealthCheckScanView ()
{
    NSTimer* _timer;
    CGFloat _startAngel;
    CGFloat _incrementAngel;
}
@property (nonatomic, strong)TDFLayoutGroupListView *groupListView;

@property (nonatomic, strong)TDFLayoutGroupListWithImageView *groupListImageView;

@property (nonatomic, strong)UILabel *remarkLabel;

@property (nonatomic, strong)UIImageView *backgroundImageView;

@property (nonatomic, strong)UIImageView *scanImageView;


@end

@implementation TDFHealthCheckScanView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    _incrementAngel = (2 * M_PI)/20;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.7];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"ico_leida"];
    self.scanImageView.image = [UIImage imageNamed:@"ico_leidascan"];
    [self addSubview:self.scanImageView];
    [self addSubview:self.backgroundImageView];
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.groupListView];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.checkLabel];
    [self addSubview:self.groupListImageView];
    
    self.groupListImageView.detailLabel.text = NSLocalizedString(@"查看详情", nil);
    self.groupListImageView.detailImageView.image = [UIImage imageNamed:@"ico_next_down.png"];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@(self.backgroundImageView.image.size.width));
        make.height.equalTo(@(self.backgroundImageView.image.size.height));
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView.mas_centerX);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.height.lessThanOrEqualTo(self);
    }];
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView.mas_centerX);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.width.equalTo(self.backgroundImageView.mas_width);
        make.height.equalTo(self.backgroundImageView.mas_height);
    }];
    
    [self.groupListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(15);
        make.centerY.equalTo(self);
        make.height.lessThanOrEqualTo(self);
    }];
    
    [self.groupListImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_right).offset(-99);
        make.height.lessThanOrEqualTo(self);
    }];
    self.isShowDetail = NO;
    
    
    self.checkLabel.font = [UIFont systemFontOfSize:13];
    self.checkLabel.textColor = [UIColor colorWithHexString:@"#0076FF"];
    self.checkLabel.text = NSLocalizedString(@"正在检测...", nil);
    self.checkLabel.hidden = YES;
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.headerImageView.layer.cornerRadius = self.headerImageView.tdf_width/2.0;
}

- (void)startAnimation {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAngel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateAngel {
    self.scanImageView.transform = CGAffineTransformMakeRotation(_startAngel + _incrementAngel);
    _startAngel += _incrementAngel;
}

- (void)cancelAnimation {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark -- setter && getter

- (UILabel *)checkLabel {
    if (!_checkLabel) {
        _checkLabel = [UILabel new];
    }
    return _checkLabel;
}

- (TDFHealthCheckScanHeaderImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [TDFHealthCheckScanHeaderImageView new];
    }
    return _headerImageView;
}

- (void)setIsShowDetail:(BOOL)isShowDetail {
    _isShowDetail = isShowDetail;
    self.groupListImageView.isShowDetail = isShowDetail;
}

- (TDFLayoutGroupListView *)groupListView {
    if (!_groupListView) {
        _groupListView = [TDFLayoutGroupListView listViewWithSpacing:3];
    }
    return _groupListView;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [UILabel new];
    }
    return _remarkLabel;
}

- (TDFLayoutGroupListWithImageView *)groupListImageView {
    if (!_groupListImageView) {
        _groupListImageView = [TDFLayoutGroupListWithImageView listViewWithSpacing:8];
    }
    return _groupListImageView;
}

- (UIImageView *)scanImageView {
    if (!_scanImageView) {
        _scanImageView = [UIImageView new];
    }
    return _scanImageView;
}

- (UIImageView *) backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
    }
    return _backgroundImageView;
}

- (void)setIsHeaderCheck:(BOOL)isHeaderCheck {
    _isHeaderCheck = isHeaderCheck;
    if (isHeaderCheck) {
        self.groupListImageView.hidden = YES;
        self.checkLabel.hidden = NO;
        self.headerImageView.hidden = YES;
    }else {
        self.headerImageView.hidden = NO;
        self.groupListImageView.hidden = NO;
        self.checkLabel.hidden = YES;
    }
}

- (void)setShowScanAnimation:(BOOL)showScanAnimation {
    _showScanAnimation = showScanAnimation;
    if (_showScanAnimation) {
        self.backgroundImageView.hidden = NO;
        self.scanImageView.hidden = NO;
    }else {
        self.backgroundImageView.hidden = YES;
        self.scanImageView.hidden = YES;
        _startAngel = 0;
        self.scanImageView.transform = CGAffineTransformMakeRotation(_startAngel);
    }
}

- (void)setHeaderModel:(TDFHealthCheckItemHeaderModel *)headerModel {
    _headerModel = headerModel;
    
    if (headerModel.subTitle) {
        NSAttributedString *attrbuterString = [NSString string:headerModel.subTitle.originalStr with:headerModel.subTitle.replaceStrs colors:headerModel.subTitle.colors regixString:@"\\{0?\\}"];
        if (self.isHeaderCheck) {
            self.groupListView.isShowDetail = NO;
        }else if (headerModel.subTitle.replaceStrs.count > 0 || headerModel.subTitle.originalStr.length > 0) {
            self.groupListView.isShowDetail = YES;
            self.groupListView.detailLabel.attributedText = attrbuterString;
        }
    }else{
        self.groupListView.isShowDetail = NO;
    }
    self.groupListView.titleLabel.font = [UIFont systemFontOfSize:15];
    self.groupListView.titleLabel.text = headerModel.itemName;
    self.groupListImageView.infoImageView.image = [TDFHealthCheckConfigViewModel statusImage:headerModel.levelCode];
    self.groupListImageView.infoLabel.textColor = [TDFHealthCheckConfigViewModel statusColor:headerModel.levelCode];
    self.groupListImageView.infoLabel.text = headerModel.status;
    self.headerImageView.backgroundColor = [TDFHealthCheckConfigViewModel statusColor:headerModel.levelCode];
    [self.headerImageView.imageView sd_setImageWithURL:[NSURL URLWithString:headerModel.iconUrl] placeholderImage:nil options:SDWebImageRefreshCached];
}



@end
@interface TDFHealthCheckScanViewCell ()
@property (nonatomic, strong) TDFHealthCheckScanView *scanView;
@end

@implementation TDFHealthCheckScanViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    [self addSubview:self.scanView];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    UIView *line = [UIView new];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

#pragma mark -- setter && getter
- (TDFHealthCheckScanView *)scanView {
    if (!_scanView) {
        _scanView = [TDFHealthCheckScanView new];
        _scanView.showScanAnimation = NO;
    }
    return _scanView;
}

- (void)setHeaderModel:(TDFHealthCheckItemHeaderModel *)headerModel {
    _headerModel = headerModel;
    self.scanView.showScanAnimation = NO;
    self.scanView.headerModel = headerModel;
}

- (void)setIsShowDetail:(BOOL)isShowDetail {
    _isShowDetail = isShowDetail;
    self.scanView.isShowDetail = isShowDetail;
}

@end
