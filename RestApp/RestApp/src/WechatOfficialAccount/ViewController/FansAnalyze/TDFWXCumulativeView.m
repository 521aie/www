//
//  TDFWXCumulativeView.m
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import <Masonry/Masonry.h>
#import "TDFWXCumulativeView.h"
#import "TDFWXCumulativeItemView.h"

const CGFloat kTDFWXCumulativeViewDefaultHeight = 77;

// 这里可以根据外部的item动态设置 itemview，不过复用可能性低，直接写死
@interface TDFWXCumulativeView()
@property (strong, nonatomic) TDFWXCumulativeItemView *fansView;
@property (strong, nonatomic) TDFWXCumulativeItemView *potentialView;
@property (strong, nonatomic) TDFWXCumulativeItemView *getCardView;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line2;
@end

@implementation TDFWXCumulativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        [self addSubview:self.potentialView];
        [self addSubview:self.fansView];
        [self addSubview:self.getCardView];
        [self addSubview:self.line1];
        [self addSubview:self.line2];
        
        [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.right.equalTo(self.line1.mas_left);
            make.width.equalTo(self.potentialView);
        }];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        [self.potentialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.line1.mas_right);
            make.right.equalTo(self.line2.mas_left);
            make.width.equalTo(self.getCardView);
        }];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        [self.getCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line2.mas_right);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self);
        }];
        
        [self.fansView addTarget:self linkAction:@selector(getMoreFansOnClick)];
        [self.potentialView addTarget:self linkAction:@selector(getMoreFansOnClick)];
        [self.getCardView addTarget:self linkAction:@selector(getMoreFansOnClick)];
    }
    
    return self;
}

- (void)getMoreFansOnClick {
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"如何增加更多领卡粉丝？"
                                                                 message:@"方法一：自动发卡消息\n\
您可以在【微信公众号营销】——【同步会员卡到微信卡包】中选择同步一张卡，并且同步后点击卡，设置“关注即发此卡”。\n\
方法二：支付即发卡 \n\
您可以在【微信公众号营销】——【同步会员卡到微信卡包】中选择同步一张卡，并且同步后点击卡，设置“支付成功即发此卡”——要求一定使用微信支付，并且是微信 直连商户。"
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
    [self.tdf_viewController presentViewController:avc animated:YES completion:nil];
}

- (void)setFansCount:(NSString *)fansCount {
    _fansCount = fansCount;
    self.fansView.countString = fansCount;
}

- (void)setPotentialCost:(NSString *)potentialCost {
    _potentialCost = potentialCost;
    self.potentialView.countString = potentialCost;
}

- (void)setPeopleCount:(NSString *)peopleCount {
    _peopleCount = peopleCount;
    self.getCardView.countString = peopleCount;
}

- (TDFWXCumulativeItemView *)potentialView {
    if (!_potentialView) {
        _potentialView = [[TDFWXCumulativeItemView alloc] initWithFrame:CGRectZero];
        _potentialView.title = @"近两周累计拉动消费";
        _potentialView.linkString = @"获得更多拉动？";
    }
    
    return _potentialView;
}

- (TDFWXCumulativeItemView *)getCardView {
    if (!_getCardView) {
        _getCardView = [[TDFWXCumulativeItemView alloc] initWithFrame:CGRectZero];
        _getCardView.title = @"累计领卡";
        _getCardView.linkString = @"领卡太少？";
    }
    
    return _getCardView;
}

- (TDFWXCumulativeItemView *)fansView {
    if (!_fansView) {
        _fansView = [[TDFWXCumulativeItemView alloc] initWithFrame:CGRectZero];
        _fansView.title = @"累计新增粉丝";
        _fansView.linkString = @"粉丝数太少？";
    }
    
    return _fansView;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    
    return _line2;
}
@end
