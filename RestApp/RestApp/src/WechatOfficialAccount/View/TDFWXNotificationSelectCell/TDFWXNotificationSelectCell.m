//
//  TDFWXNotificationSelectCell.m
//  RestApp
//
//  Created by Xihe on 17/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXNotificationSelectCell.h"
#import "UIColor+Hex.h"

#define IMG_WIDTH 18
#define LABEL_MARGIN_X 38
#define IMG_MARGIN_X 10
#define LINE_HEIGHT 1
@implementation TDFWXNotificationSelectCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        [self configViews];
    }
    return self;
}

#pragma mark - Accessor

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height- LINE_HEIGHT, self.frame.size.width, LINE_HEIGHT)];
        _lineView.backgroundColor = [UIColor colorWithHeX:0x333333];
    }
    return _lineView;
}

- (UIImageView *)imgCheck {
    if (!_imgCheck) {
        _imgCheck = [[UIImageView alloc] initWithFrame:CGRectMake(IMG_MARGIN_X, (self.frame.size.height - IMG_WIDTH)/2, IMG_WIDTH, IMG_WIDTH)];
        _imgCheck.image = [UIImage imageNamed:@"ico_check"];
    }
    return _imgCheck;
}

- (UIImageView *)imgUnCheck {
    if (!_imgUnCheck) {
        _imgUnCheck = [[UIImageView alloc] initWithFrame:CGRectMake(IMG_MARGIN_X, (self.frame.size.height - IMG_WIDTH)/2, IMG_WIDTH, IMG_WIDTH)];
        _imgUnCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }
    return _imgUnCheck;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame: CGRectMake(LABEL_MARGIN_X, 0, self.frame.size.width - LABEL_MARGIN_X, self.frame.size.height)];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    return _contentLabel;
}

#pragma mark - Config View

- (void)configViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.contentLabel];
    [self addSubview:self.imgCheck];
    [self addSubview:self.imgUnCheck];
    [self addSubview:self.lineView];
}

@end
