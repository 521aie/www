//
//  TDFShopCompareCell.m
//  RestApp
//
//  Created by Cloud on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopCompareCell.h"
#import "TDFShopCompareItem.h"

@interface TDFShopCompareCell ()

@property (nonatomic ,strong) UILabel *nameL;

@property (nonatomic ,strong) UILabel *moneyL;

@property (nonatomic ,strong) UIProgressView *progressV;

@property (nonatomic ,strong) UIButton *rightBtn;

@property (nonatomic ,strong) UIView *bottomLine;

@end

@implementation TDFShopCompareCell

#pragma mark - proto

- (void)cellDidLoad {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self configLayout];
}

+ (CGFloat)heightForCellWithItem:(TDFShopCompareItem *)item {

    return 44;
}

- (void)configCellWithItem:(TDFShopCompareItem *)item {

    self.nameL.text = item.shopName;
    self.progressV.progress = item.proportion;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    formatter.minimumFractionDigits = 2;
    
    formatter.maximumFractionDigits = 2;
    
    formatter.minimumIntegerDigits = 1;
    
    formatter.positiveSuffix = @"元";
    
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc]initWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:item.actualAmount]]];
    
    [newText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(newText.length-1, 1)];
    self.moneyL.attributedText = newText;
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2lf元",item.actualAmount]];
//     [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(attrStr.length-1, 1)];
//    self.moneyL.attributedText = attrStr;
}

#pragma mark - normalFuncs 

- (void)configLayout {
    
    self.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.nameL];
    [self.contentView addSubview:self.moneyL];
    [self.contentView addSubview:self.progressV];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.bottomLine];
    
    __weak typeof(self) ws = self;
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(2);
        make.left.offset(10);
        make.bottom.offset(-2);
        make.width.mas_equalTo(50);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
//        make.top.offset(7);
//        make.right.offset(0);
//        make.bottom.offset(-7);
//        make.width.mas_equalTo(30);
        make.width.height.mas_equalTo(22);
        make.right.offset(-10);
        make.centerY.equalTo(ws.contentView.mas_centerY);
    }];
    
    [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(10);
        make.left.equalTo(ws.nameL.mas_right).offset(10);
        make.right.equalTo(ws.rightBtn.mas_left);
        make.height.equalTo(ws.contentView.mas_height).multipliedBy(0.4);
    }];
    
    [self.progressV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(ws.moneyL.mas_bottom).offset(5);
        make.height.mas_equalTo(5);
        make.left.equalTo(ws.moneyL.mas_left);
        make.width.mas_equalTo(ws.moneyL.mas_width);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(ws.contentView.mas_bottom);
        make.left.offset(10);
        make.right.offset(-13);
        make.height.mas_equalTo(0.5);
    }];
    
    
}

#pragma mark - Getter

- (UILabel *)nameL {

    if (!_nameL) {
        
        _nameL = [UILabel new];
        _nameL.numberOfLines = 3;
        _nameL.text = @"店名:";
        _nameL.textColor = [UIColor lightGrayColor];
        _nameL.font = [UIFont systemFontOfSize:11];
    }
    return _nameL;
}

- (UILabel *)moneyL {

    if (!_moneyL) {
        
        _moneyL = [UILabel new];
        _moneyL.textColor = [UIColor whiteColor];
        _moneyL.font = [UIFont boldSystemFontOfSize:15];
        _moneyL.text = @"97,259,158,888.00元";
    }
    return _moneyL;
}

- (UIProgressView *)progressV {

    if (!_progressV) {
        
        _progressV = [UIProgressView new];
//        _progressV.backgroundColor = [UIColor redColor];
        _progressV.backgroundColor = [UIColor clearColor];
        _progressV.progressTintColor = [UIColor redColor];
        _progressV.trackTintColor = [UIColor clearColor];
        _progressV.progress = 0.6;
    }
    return _progressV;
}

- (UIButton *)rightBtn {

    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"ico_next_w.png"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (UIView *)bottomLine {

    if (!_bottomLine) {
        
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor grayColor];
        _bottomLine.alpha = 0.5;
    }
    return _bottomLine;
}


@end
