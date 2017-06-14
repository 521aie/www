//
//  customVIew.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "customView.h"

static const CGFloat kBtnCornerRadius = 5.0;
static const CGFloat kBtnBorderWidth = 1.0;
static const CGFloat kBtnHeight = 23;
static const CGFloat kBtnMarginY = 6.5;


@implementation customView

#pragma mark - Access

- (UIButton *)detaiBusBtn {
    if (!_detaiBusBtn) {
        _detaiBusBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, kBtnMarginY, SCREEN_WIDTH*2/3, kBtnHeight)];
        _detaiBusBtn.layer.cornerRadius = kBtnCornerRadius;
        _detaiBusBtn.layer.borderWidth = kBtnBorderWidth;
        _detaiBusBtn.layer.borderColor = [[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
        _detaiBusBtn.layer.masksToBounds = YES;
        [_detaiBusBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detaiBusBtn;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, kBtnMarginY, SCREEN_WIDTH*2/3, kBtnHeight)];
        _lblTitle.font = [UIFont systemFontOfSize:12];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.textColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1];
    }
    return _lblTitle;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Config View

- (id)initWithFrame:(CGRect)frame
{
    if ( self =[super initWithFrame:frame]) {
        [self configView];
    }
    return self ;
}

- (void)configView {
    [self addSubview:self.detaiBusBtn];
    [self addSubview:self.lblTitle];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo (@22);
        make.height.equalTo(@22);
        make.centerY.equalTo(_lblTitle.mas_centerY).offset(0);
        make.left.equalTo(_lblTitle.mas_right).offset(-22);
    }];
}

- (void)iniithit:(NSString *)hit img:(NSString *)img 
{
    self.lblTitle.text =[NSString stringWithFormat:@"%@",hit];
    self.imageView.image =[UIImage imageNamed:img];
}

#pragma mark - Method

- (void)selectBtn:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(btnSelectView:)])
        [self.delegate btnSelectView:self];

}
@end
