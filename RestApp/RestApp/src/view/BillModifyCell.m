//
//  BillModifyCell.m
//  RestApp
//
//  Created by LSArlen on 2017/6/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "BillModifyCell.h"

@interface BillModifyCell ()

@property (nonatomic, strong)  UIView *backWhitView;

@end

@implementation BillModifyCell

+ (CGFloat)cell_height {
    return 92;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        _backWhitView = [[UIView alloc] init];
        _backWhitView.backgroundColor   = [UIColor whiteColor];
        _backWhitView.alpha             = 0.7;
        [self.contentView addSubview:_backWhitView];
        
        _img_next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_next.png"]];
        [self.contentView addSubview:_img_next];
        
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font      = [UIFont systemFontOfSize:17];
        _lblTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_lblTitle];
        
        _lblDetail = [[UILabel alloc] init];
        _lblDetail.font     = [UIFont systemFontOfSize:12];
        _lblDetail.textColor= [UIColor darkGrayColor];
        [self.contentView addSubview:_lblDetail];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float auto_w = SCREEN_WIDTH / 375;
    
    [_backWhitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    
    [_img_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(- (auto_w * 10));
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(auto_w * 10);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.height.equalTo(@21);
        make.right.equalTo(self.img_next.mas_left).offset(auto_w * 10);
    }];
    
    [_lblDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblTitle.mas_bottom).offset(2);
        make.left.right.equalTo(self.lblTitle);
        make.bottom.equalTo(self.backWhitView);
    }];
}

@end
