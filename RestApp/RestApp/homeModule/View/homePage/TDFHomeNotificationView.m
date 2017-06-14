//
//  TDFHomeNotificationView.m
//  Pods
//
//  Created by happyo on 2017/3/9.
//
//

#import "TDFHomeNotificationView.h"
#import "Masonry.h"

@implementation TDFHomeNotificationModel


@end

@interface TDFHomeNotificationView ()

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *forwardLabel;

@property (nonatomic, strong) UIImageView *countImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end
@implementation TDFHomeNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
            make.bottom.equalTo(self);
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(10);
            make.height.equalTo(@20);
            make.width.equalTo(@20);
            make.centerY.equalTo(self.alphaView);
        }];
        
        [self addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.alphaView).with.offset(-10);
            make.centerY.equalTo(self.alphaView);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
        [self addSubview:self.forwardLabel];
        [self.forwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.alphaView).with.offset(-25);
            make.centerY.equalTo(self.alphaView);
            make.height.equalTo(@13);
            make.width.equalTo(@28);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(10);
            make.height.equalTo(@13);
            make.centerY.equalTo(self.alphaView);
            make.trailing.equalTo(self.forwardLabel.mas_leading).with.offset(-10);
        }];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeNotificationModel *)model
{
    self.titleLabel.text = model.title;
    
    self.forwardLabel.text = model.forwardDescription;
}

#pragma mark -- Getters && Setters --

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _alphaView.layer.cornerRadius = 5;
    }
    
    return _alphaView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"homePage_notification_icon"];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UILabel *)forwardLabel
{
    if (!_forwardLabel) {
        _forwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _forwardLabel.font = [UIFont systemFontOfSize:13];
        _forwardLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _forwardLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _forwardLabel;
}

- (UIImageView *)countImageView
{
    if (!_countImageView) {
        _countImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _countImageView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.image = [UIImage imageNamed:@"homePage_arrow_right"];
    }
    
    return _arrowImageView;
}

@end
