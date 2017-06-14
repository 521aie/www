//
//  TDFSunOfKitchenCell.m
//  RestApp
//
//  Created by suckerl on 2017/6/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSunOfKitchenCell.h"
#import "UIColor+Hex.h"

@interface TDFSunOfKitchenCell()
@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) UILabel *zoneLabel;
@property (nonatomic,strong) UILabel *seeVideoLabel;
@property (nonatomic,strong) UIImageView *arrowImage;
@end

@implementation TDFSunOfKitchenCell


- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self constructLayOut];
    }
    return self;
}





- (void)setupSubviews {
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
//    [self.contentView setBackgroundColor:[UIColor whiteColor]];
//    [self.contentView setAlpha:0.7];
//    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.zoneLabel];
    [self.contentView addSubview:self.seeVideoLabel];
    [self.contentView addSubview:self.arrowImage];
}

- (void)constructLayOut {
    [_zoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@15);
    }];
    
    [_seeVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-28);
        make.top.equalTo(_zoneLabel.mas_top);
        make.width.equalTo(@180);
        make.height.equalTo(_zoneLabel.mas_height);
    }];
    
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_seeVideoLabel.mas_right).offset(5);
        make.top.equalTo(_zoneLabel.mas_top);
        make.width.equalTo(@13);
        make.height.equalTo(@13);
    }];
}

#pragma mark - lazy
-(UILabel *)zoneLabel {
    if (_zoneLabel == nil) {
        _zoneLabel = [[UILabel alloc] init];
        _zoneLabel.font = [UIFont systemFontOfSize:15];
        _zoneLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _zoneLabel.text = @"加工区";
    }
    return _zoneLabel;
}

- (UILabel *)seeVideoLabel {
    if (_seeVideoLabel == nil) {
        _seeVideoLabel = [[UILabel alloc] init];
        _seeVideoLabel.text = @"查看监控";
        _seeVideoLabel.textAlignment = NSTextAlignmentRight;
        _seeVideoLabel.font = [UIFont systemFontOfSize:15];
        _seeVideoLabel.textColor = [UIColor colorWithHexString:@"#0088CC"];
    }
    return _seeVideoLabel;
}

- (UIImageView *)arrowImage {
    if (_arrowImage == nil) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_arrow_right_gray"]];
        _arrowImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArrow)];
//        [_arrowImage addGestureRecognizer:tap];
    }
    return _arrowImage;
}

- (void)setZoneName:(NSString *)zoneName {
    _zoneName = zoneName;
    self.zoneLabel.text = zoneName;
}
@end
