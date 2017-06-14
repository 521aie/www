//
//  TDFBusinessFlowHeaderView.m
//  RestApp
//
//  Created by happyo on 2016/11/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessFlowHeaderView.h"
#import "SwipeView.h"
#import "TDFPayInfoModel.h"
#import "UIImageView+WebCache.h"


@interface TDFPayInfoView ()

@property (nonatomic, strong) UIImageView *igvIcon;

@property (nonatomic, strong) UILabel *lblTitle;

@property (nonatomic, strong) UILabel *lblAcount;

@property (nonatomic, strong) UIButton *btnSmall;

@property (nonatomic, strong) UIButton *btnBig;

@property (nonatomic, strong) UILabel *lblBigTitle;

@property (nonatomic, strong) UILabel *lblBigAccount;

@end
@implementation TDFPayInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.btnSmall];
        [self.btnSmall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.centerX.equalTo(self);
            make.width.equalTo(@(70));
            make.height.equalTo(@(60));
        }];
                
        [self.btnSmall addSubview:self.igvIcon];
        [self.igvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnSmall).with.offset(6);
            make.centerX.equalTo(self.btnSmall);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        [self.btnSmall addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.igvIcon.mas_bottom).with.offset(3);
            make.leading.equalTo(self.btnSmall);
            make.trailing.equalTo(self.btnSmall);
            make.height.equalTo(@(11));
        }];
        
        [self.btnSmall addSubview:self.lblAcount];
        [self.lblAcount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblTitle.mas_bottom).with.offset(3);
            make.leading.equalTo(self.btnSmall);
            make.trailing.equalTo(self.btnSmall);
            make.height.equalTo(@(11));
        }];
        
        [self addSubview:self.btnBig];
        [self.btnBig mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.centerX.equalTo(self);
            make.width.equalTo(@(70));
            make.height.equalTo(@(70));
        }];
        
        [self.btnBig addSubview:self.lblBigTitle];
        [self.lblBigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(11));
            make.leading.equalTo(self.btnBig);
            make.trailing.equalTo(self.btnBig);
            make.centerY.equalTo(self.btnBig).with.offset(-6);
        }];
        
        [self.btnBig addSubview:self.lblBigAccount];
        [self.lblBigAccount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(11));
            make.leading.equalTo(self.btnBig);
            make.trailing.equalTo(self.btnBig);
            make.centerY.equalTo(self.btnBig).with.offset(6);
        }];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFPayInfoModel *)model
{
    [self.igvIcon sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    
    if (model.isAll) {
        self.btnBig.hidden = NO;
        self.btnSmall.hidden = YES;
        self.lblBigTitle.text = model.kindPayName;
        self.lblBigAccount.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f元", nil), model.money];
        self.btnBig.selected = model.isSelected;
    } else {
        self.btnBig.hidden = YES;
        self.btnSmall.hidden = NO;
        self.lblTitle.text = model.kindPayName;
        self.lblAcount.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f元", nil), model.money];
        self.btnSmall.selected = model.isSelected;
    }
}

#pragma mark -- Getters && Setters --

- (UIImageView *)igvIcon
{
    if (!_igvIcon) {
        _igvIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _igvIcon;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTitle.font = [UIFont systemFontOfSize:12];
        _lblTitle.textColor = RGBA(102, 102, 102, 1);
        _lblTitle.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblTitle;
}

- (UILabel *)lblAcount
{
    if (!_lblAcount) {
        _lblAcount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblAcount.font = [UIFont systemFontOfSize:12];
        _lblAcount.textColor = RGBA(102, 102, 102, 1);
        _lblAcount.textAlignment = NSTextAlignmentCenter;

    }
    
    return _lblAcount;
}

- (UIButton *)btnSmall
{
    if (!_btnSmall) {
        _btnSmall = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSmall.userInteractionEnabled = NO;
        [_btnSmall setBackgroundImage:[UIImage imageNamed:@"business_pay_small_unselected"] forState:UIControlStateNormal];
        [_btnSmall setBackgroundImage:[UIImage imageNamed:@"business_pay_small_selected"] forState:UIControlStateSelected];
    }
    
    return _btnSmall;
}

- (UIButton *)btnBig
{
    if (!_btnBig) {
        _btnBig = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBig.userInteractionEnabled = NO;
        [_btnBig setBackgroundImage:[UIImage imageNamed:@"business_pay_big_unselected"] forState:UIControlStateNormal];
        [_btnBig setBackgroundImage:[UIImage imageNamed:@"business_pay_big_selected"] forState:UIControlStateSelected];
    }
    
    return _btnBig;
}

- (UILabel *)lblBigTitle
{
    if (!_lblBigTitle) {
        _lblBigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblBigTitle.font = [UIFont systemFontOfSize:12];
        _lblBigTitle.textColor = RGBA(102, 102, 102, 1);
        _lblBigTitle.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblBigTitle;
}

- (UILabel *)lblBigAccount
{
    if (!_lblBigAccount) {
        _lblBigAccount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblBigAccount.font = [UIFont systemFontOfSize:12];
        _lblBigAccount.textColor = RGBA(102, 102, 102, 1);
        _lblBigAccount.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _lblBigAccount;
}

@end

@interface TDFBusinessFlowHeaderView () <SwipeViewDelegate, SwipeViewDataSource>

@property (nonatomic, strong) SwipeView *paySwipeView;

@property (nonatomic, strong) NSArray<TDFPayInfoModel *> *payInfoList;

@end
@implementation TDFBusinessFlowHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        UIView *payAlphaView = [[UIView alloc] initWithFrame:CGRectZero];
        payAlphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self addSubview:payAlphaView];
        [payAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(111));
        }];
        
        [self addSubview:self.paySwipeView];
        [self.paySwipeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).with.offset(11);
            make.trailing.equalTo(self);
            make.height.equalTo(@(85));
        }];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        lblDescription.font = [UIFont systemFontOfSize:11];
        lblDescription.textColor = RGBA(102, 102, 102, 1);
        lblDescription.text = NSLocalizedString(@"注：现金收款包括现金、银行卡等店家自己设置的付款方式。", nil);
        
        [self addSubview:lblDescription];
        [lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paySwipeView.mas_bottom).with.offset(5);
            make.leading.equalTo(self).with.offset(15);
            make.trailing.equalTo(self);
            make.height.equalTo(@(9));
        }];
    }
    
    return self;
}

- (UILabel *)getTableHeaderLabel
{
    UILabel *tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tableHeaderLabel.font = [UIFont systemFontOfSize:12];
    tableHeaderLabel.textColor = RGBA(51, 51, 51, 1);
    
    return tableHeaderLabel;
}

- (void)configureViewWithPayInfoList:(NSArray<TDFPayInfoModel *> *)payInfoList
{
    self.payInfoList = payInfoList;
    [self.paySwipeView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark -- SwipeViewDelegate -

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(78, 85);
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    for (int i = 0; i < self.payInfoList.count; i++) {
        TDFPayInfoModel *model = self.payInfoList[i];
        
        if (i == index) {
            model.selected = YES;
        } else {
            model.selected = NO;
        }
    }
    
    [swipeView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(businessFlowHeaderView:didSelectedModel:)]) {
        [self.delegate businessFlowHeaderView:self didSelectedModel:self.payInfoList[index]];
    }
}

#pragma mark -- SwipeViewDataSource --

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.payInfoList.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    TDFPayInfoView *payInfoView = [[TDFPayInfoView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
    [payInfoView configureViewWithModel:self.payInfoList[index]];
    
    return payInfoView;
}

#pragma mark -- Getters && Setters --

- (SwipeView *)paySwipeView
{
    if (!_paySwipeView) {
        _paySwipeView = [[SwipeView alloc] initWithFrame:self.bounds];
        _paySwipeView.delegate = self;
        _paySwipeView.dataSource = self;
    }
    
    return _paySwipeView;
}

@end
