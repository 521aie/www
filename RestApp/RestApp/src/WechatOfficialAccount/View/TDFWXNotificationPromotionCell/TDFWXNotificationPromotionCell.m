//
//  TDFWXNotificationPromotionCell.m
//  RestApp
//
//  Created by Xihe on 17/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXNotificationPromotionCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#define CELL_WIDTH SCREEN_WIDTH
#define CELL_MARGIN 10
#define CELL_HEIGHT 140
#define LABEL_MARGIN_X 2*CELL_MARGIN
#define LABEL_MAX_WIDTH (CELL_WIDTH - (LABEL_MARGIN_X*2))

#define CONTENT_WIDTH (CELL_WIDTH - 2*CELL_MARGIN)
#define CONTENT_HEIGHT 130
@implementation TDFWXNotificationPromotionCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
        [self configViews];
    }
    return self;
}

#pragma mark - Accessor

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_MARGIN, CELL_MARGIN, CONTENT_WIDTH,CONTENT_HEIGHT)];
        _bgView.image = [UIImage imageNamed:@"wxoa_wechat_promotion_ticket"];

    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_X, CELL_MARGIN, LABEL_MAX_WIDTH *2/3-20,CONTENT_HEIGHT/4 )];
        _titleLabel.text = NSLocalizedString(@"公众号: 绿隐红", nil);
        _titleLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MAX_WIDTH*2/3 + LABEL_MARGIN_X, CELL_MARGIN, LABEL_MAX_WIDTH/3+20, CONTENT_HEIGHT/4)];
        _dateLabel.text = NSLocalizedString(@"2017-01-12 12:55", nil);
        _dateLabel.textColor = [UIColor colorWithHeX:0x666666];
        _dateLabel.font = [UIFont systemFontOfSize:11];
    }
    return _dateLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_X, CONTENT_HEIGHT/4+CELL_MARGIN, LABEL_MAX_WIDTH, CONTENT_HEIGHT/2)];
        _detailLabel.text = NSLocalizedString(@"恭喜您成为本店的VIP客户，点击可领取VIP会员卡1张与满100减10优惠券1张",nil);
        _detailLabel.numberOfLines = 0;
        _detailLabel.font =[UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor colorWithHeX:0x666666];
    }
    return _detailLabel;
}

- (UILabel *)receiverLabel {
    if (!_receiverLabel) {
        _receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_X, CONTENT_HEIGHT*3/4+CELL_MARGIN, LABEL_MAX_WIDTH, CONTENT_HEIGHT/4)];
        _receiverLabel.textColor = [UIColor colorWithHeX:0x029A1E];
        _receiverLabel.font = [UIFont systemFontOfSize:11];
        _receiverLabel.text = NSLocalizedString(@"发送对象：＃本月生日会员＃共50人", nil);
    }
    return _receiverLabel;
}

#pragma mark - Config View

- (void) configViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:1];
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.receiverLabel];
}
@end
