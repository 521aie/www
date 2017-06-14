//
//  TDFWXKeywordsAutoreplyCell.m
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import "TDFWXKeywordsAutoreplyItem.h"
#import "TDFWXKeywordsAutoreplyCell.h"
#import "TDFImaginaryLineView.h"

static const CGFloat kTDFWXKeywordsAutoreplyCellHeight = 130.0f;

@interface TDFWXKeywordsAutoreplyCell()
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *ruleTitleLabel;
@property (strong, nonatomic) UILabel *ruleContentLabel;
@property (strong, nonatomic) UILabel *keywordsTitleLabel;
@property (strong, nonatomic) UILabel *keywordsContentLabel;
@property (strong, nonatomic) UIImageView *keywordsContentImageView;
@property (strong, nonatomic) UILabel *autoreplyTitleLabel;
@property (strong, nonatomic) UIImageView *autoreplyImageView;
@property (strong, nonatomic) UILabel *autoreplyContentLabel;
@property (strong, nonatomic) TDFImaginaryLineView *seperatorLine1;
@property (strong, nonatomic) TDFImaginaryLineView *seperatorLine2;
@property (strong, nonatomic) TDFWXKeywordsAutoreplyItem *item;
@end

@implementation TDFWXKeywordsAutoreplyCell
- (void)cellDidLoad {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.ruleTitleLabel];
    [self.containerView addSubview:self.ruleContentLabel];
    [self.containerView addSubview:self.keywordsTitleLabel];
    [self.containerView addSubview:self.keywordsContentImageView];
    [self.containerView addSubview:self.keywordsContentLabel];
    [self.containerView addSubview:self.autoreplyTitleLabel];
    [self.containerView addSubview:self.autoreplyContentLabel];
    [self.containerView addSubview:self.autoreplyImageView];
    [self.containerView addSubview:self.seperatorLine2];
    [self.containerView addSubview:self.seperatorLine1];
    [self layoutPageSubviews];
}

- (void)layoutPageSubviews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(@5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    [self.ruleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@15);
    }];
    [self.ruleContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleTitleLabel.mas_right);
        make.top.equalTo(self.ruleTitleLabel);
        make.right.lessThanOrEqualTo(self.containerView).offset(-10);
    }];
    [self.keywordsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleTitleLabel);
        make.centerY.equalTo(self.containerView);
    }];
    [self.keywordsContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keywordsTitleLabel.mas_right);
        make.centerY.equalTo(self.keywordsTitleLabel);
        make.right.lessThanOrEqualTo(self.keywordsContentImageView.mas_left).offset(-10);
    }];
    [self.keywordsContentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@15);
        make.centerY.equalTo(self.containerView);
        make.right.equalTo(self.containerView).offset(-10);
    }];
    [self.autoreplyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleTitleLabel);
        make.bottom.equalTo(self.containerView).offset(-15);
    }];
    [self.autoreplyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@14);
        make.height.equalTo(@10);
        make.left.equalTo(self.autoreplyTitleLabel.mas_right);
        make.centerY.equalTo(self.autoreplyTitleLabel);
    }];
    [self.autoreplyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoreplyImageView.mas_right).offset(5);
        make.centerY.equalTo(self.autoreplyTitleLabel);
        make.right.lessThanOrEqualTo(self.containerView).offset(-10);
    }];
    [self.seperatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.right.equalTo(self.containerView).offset(-5);
        make.top.equalTo(@((kTDFWXKeywordsAutoreplyCellHeight - 10) / 3));
        make.height.equalTo(@1);
    }];
    [self.seperatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.seperatorLine1);
        make.bottom.equalTo(self.containerView).offset(-(kTDFWXKeywordsAutoreplyCellHeight - 10) / 3);
    }];
}

+ (CGFloat)heightForCellWithItem:(TDFWXKeywordsAutoreplyItem *)item {
    return kTDFWXKeywordsAutoreplyCellHeight;
}

- (void)configCellWithItem:(TDFWXKeywordsAutoreplyItem *)item {
    self.item = item;
    
    self.ruleContentLabel.text = item.displayedRuleName;
    self.keywordsContentLabel.text = item.displayedKeywords;
    self.autoreplyImageView.image = item.displayedReplyTypeImage;
    
    if (item.displayedReplyTypeImage) {
        [self.autoreplyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@14);
        }];
    } else {
        [self.autoreplyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    self.autoreplyContentLabel.text = item.displayedReplyTypeTitle;
}


- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 3;
        _containerView.clipsToBounds = YES;
    }
    
    return _containerView;
}

- (UILabel *)ruleTitleLabel {
    if (!_ruleTitleLabel) {
        _ruleTitleLabel = [[UILabel alloc] init];
        _ruleTitleLabel.text = @"规则名称: ";
        _ruleTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _ruleTitleLabel.textColor = [UIColor tdf_colorWithRGB:0x333333];
    }
    
    return _ruleTitleLabel;
}

- (UILabel *)ruleContentLabel {
    if (!_ruleContentLabel) {
        _ruleContentLabel = [[UILabel alloc] init];
        _ruleContentLabel.font = [UIFont systemFontOfSize:13];
        _ruleContentLabel.textColor = [UIColor tdf_colorWithRGB:0x666666];
    }
    
    return _ruleContentLabel;
}
- (UILabel *)keywordsTitleLabel {
    if (!_keywordsTitleLabel) {
        _keywordsTitleLabel = [[UILabel alloc] init];
        _keywordsTitleLabel.text = @"关键词: ";
        _keywordsTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _keywordsTitleLabel.textColor = [UIColor tdf_colorWithRGB:0x333333];
    }
    
    return _keywordsTitleLabel;
}
- (UILabel *)keywordsContentLabel {
    if (!_keywordsContentLabel) {
        _keywordsContentLabel = [[UILabel alloc] init];
        _keywordsContentLabel.font = [UIFont systemFontOfSize:13];
        _keywordsContentLabel.textColor = [UIColor tdf_colorWithRGB:0x666666];
    }
    
    return _keywordsContentLabel;
}
- (UIImageView *)keywordsContentImageView {
    if (!_keywordsContentImageView) {
        _keywordsContentImageView = [[UIImageView alloc] init];
        _keywordsContentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _keywordsContentImageView.image = [UIImage imageNamed:@"icon_next_alpha"];
    }
    
    return _keywordsContentImageView;
}
- (UILabel *)autoreplyTitleLabel {
    if (!_autoreplyTitleLabel) {
        _autoreplyTitleLabel = [[UILabel alloc] init];
        _autoreplyTitleLabel.text = @"自动回复: ";
        _autoreplyTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _autoreplyTitleLabel.textColor = [UIColor tdf_colorWithRGB:0x333333];
    }
    
    return _autoreplyTitleLabel;
}
- (UILabel *)autoreplyContentLabel {
    if (!_autoreplyContentLabel) {
        _autoreplyContentLabel = [[UILabel alloc] init];
        _autoreplyContentLabel.font = [UIFont systemFontOfSize:13];
        _autoreplyContentLabel.textColor = [UIColor tdf_colorWithRGB:0x666666];
    }
    
    return _autoreplyContentLabel;
}
- (UIImageView *)autoreplyImageView {
    if (!_autoreplyImageView) {
        _autoreplyImageView = [[UIImageView alloc] init];
    }
    
    return _autoreplyImageView;
}
- (TDFImaginaryLineView *)seperatorLine1 {
    if (!_seperatorLine1) {
        _seperatorLine1 = [[TDFImaginaryLineView alloc] init];
        _seperatorLine1.lineWidth = 1;
        _seperatorLine1.lineSpacing = 1;
        _seperatorLine1.lineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    
    return _seperatorLine1;
}

- (TDFImaginaryLineView *)seperatorLine2 {
    if (!_seperatorLine2) {
        _seperatorLine2 = [[TDFImaginaryLineView alloc] init];
        _seperatorLine2.lineWidth = 1;
        _seperatorLine2.lineSpacing = 1;
        _seperatorLine2.lineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    
    return _seperatorLine2;
}

@end
