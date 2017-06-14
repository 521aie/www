//
//  TDFPublishGoodsTableViewCell.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "PublishGoodsTableViewCell.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "Masonry.h"
@implementation PublishGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

//布局cell
- (void) initMainViewWithData:(id)data
{
   self.vo  = (ChainPublishHistoryVo *)data;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    self.bgView.backgroundColor  = [UIColor whiteColor];
    self.bgView.alpha =0.7;
    [self.publishStatus  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo (self.mas_left).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(20, 20));
    }];

    
    [self.publishLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.publishStatus.mas_top).with.offset(4);
        make.left.equalTo (self.publishStatus.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 13));
    }];
    self.publishLbl.textColor = [UIColor grayColor];
    self.publishLbl.text = @"";
    self.publishLbl.font = [UIFont systemFontOfSize:15];
    
    [self.publishTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.publishStatus.mas_bottom).with.offset(10);
        make.left.equalTo (self.publishStatus.mas_left);
        make.size.mas_equalTo(CGSizeMake(300, 13));
    }];
    self.publishTimeLbl.textColor = [UIColor grayColor];
    self.publishTimeLbl.text = @" ";
    self.publishTimeLbl.font = [UIFont systemFontOfSize:15];
    
    [self.brandLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.publishTimeLbl.mas_bottom).with.offset(10);
        make.left.equalTo (self.publishStatus.mas_left);
        make.size.mas_equalTo(CGSizeMake(250, 13));
    }];
    self.brandLbl.textColor = [UIColor grayColor];
    self.brandLbl.text = @"";
    self.brandLbl.font = [UIFont systemFontOfSize:15];
    
    [self.summaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height  = 0 ;
        if (self.vo.publishStatus) {
            height = 5;
        }
        make.top.equalTo (self.brandLbl.mas_bottom).with.offset(height);
        make.left.equalTo (self.publishStatus.mas_left);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
    self.summaryLbl.textColor = [UIColor grayColor];
    self.summaryLbl.text = @"";
    self.summaryLbl.font = [UIFont systemFontOfSize:15];
    self.summaryLbl.numberOfLines =0;
    [self.nextClickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.mas_right).with.offset(0);
        make.bottom.equalTo (self.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(90, 13));
    }];
    [self.nextClickButton setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    [self.nextClickButton setTitle:NSLocalizedString(@"查看详情 》", nil) forState:UIControlStateNormal ];
    self.nextClickButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.nextClickButton.backgroundColor = [UIColor clearColor];
    [self.nextClickButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self initWithData: self.vo];
}

- (void)initDelegate:(id <NavigationToJump>)delegate
{
    self.delegate  = delegate;
}

- (void)initWithData:(ChainPublishHistoryVo *)data
{
    ChainPublishHistoryVo *vo  = data;
    if ( !vo.publishStatus) {
        self.publishStatus.image = [UIImage imageNamed:@"Group 22.png"];
        self.summaryLbl.text  = [NSString stringWithFormat:NSLocalizedString(@"总部已成功发布%d个商品到%d家门店", nil),vo.menuCount,vo.shopCount];
    }
    else
    {
        self.publishStatus.image = [UIImage imageNamed:@"Group 2.png"];
        self.summaryLbl.text  = [NSString stringWithFormat:NSLocalizedString(@"总部发布%d个商品到%d家门店,有部分门店发布失败", nil),vo.menuCount,vo.shopCount];
    }
    self.publishTimeLbl.text = [NSString stringWithFormat:NSLocalizedString(@"发布时间: %@%@", nil),vo.publishDate,vo.timeInterval];
    self.publishLbl.text  = vo.publishStatusDesc;
    if ([NSString isNotBlank:vo.plateName]) {
      self.brandLbl.text = [NSString stringWithFormat:NSLocalizedString(@"品牌：%@", nil),vo.plateName];
    }
    else
    {
    self.brandLbl.text = [NSString stringWithFormat:NSLocalizedString(@"品牌：%@", nil),@""];
    }
    
    
}



- (UIImageView *) publishStatus
{
    if (!_publishStatus) {
        _publishStatus = [[UIImageView  alloc] init];
        [self addSubview:_publishStatus];
    }
    return _publishStatus;
}

- (UILabel *) publishLbl
{
    if (!_publishLbl) {
        _publishLbl = [[UILabel  alloc] init];
        [self addSubview:_publishLbl];
    }
    return _publishLbl;
}

- (UILabel *) publishTimeLbl
{
    if (!_publishTimeLbl) {
        _publishTimeLbl  = [[UILabel  alloc] init];
        [self addSubview: _publishTimeLbl];
    }
    return _publishTimeLbl;
}

- (UILabel *) brandLbl
{
    if (!_brandLbl) {
        _brandLbl  = [[UILabel  alloc] init];
        [self addSubview:_brandLbl];
    }
    return _brandLbl;
}

- (UILabel *)summaryLbl
{
    if (!_summaryLbl) {
        _summaryLbl  = [[UILabel  alloc] init];
        [self addSubview:_summaryLbl];
    }
    return _summaryLbl;
}

- (UIButton *)nextClickButton
{
    if (!_nextClickButton) {
        _nextClickButton = [[UIButton alloc] init];
        [self addSubview:_nextClickButton];
    }
    return _nextClickButton;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView   = [[UIView  alloc] init];
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (void)btnClick:(UIButton *)button
{
    if (self.delegate) {
        [self.delegate   navitionToPushBeforeJump:@"" data:self.vo];
    }
}

@end
