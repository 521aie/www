//
//  TDFHomeGroupTwoImageHeaderCell.m
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import "TDFHomeGroupTwoImageHeaderCell.h"
#import "TDFHomeGroupTwoImageHeaderItem.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface TDFHomeGroupTwoImageHeaderCell ()

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *descriptionLabel;

@end
@implementation TDFHomeGroupTwoImageHeaderCell


- (void)cellDidLoad
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftImageView.mas_trailing).with.offset(5);
        make.size.equalTo(self.leftImageView);
        make.top.equalTo(self.leftImageView);
    }];
    
    [self addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.rightImageView.mas_trailing).with.offset(10);
        make.top.equalTo(self).with.offset(10);
        make.trailing.equalTo(self).with.offset(-10);
    }];
}

- (void)configCellWithItem:(TDFHomeGroupTwoImageHeaderItem *)item
{
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:item.leftIconUrl] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"]];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:item.rightIconUrl] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"]];
    
    self.descriptionLabel.text = item.desciption;
}

+ (CGFloat)heightForCellWithItem:(TDFHomeGroupTwoImageHeaderItem *)item
{
    CGFloat height = 0;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    UILabel *lblHeight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 20 - 95, 0)];
    lblHeight.font = [UIFont systemFontOfSize:11];
    lblHeight.numberOfLines = 0;
    lblHeight.text = item.desciption;
    
    [lblHeight sizeToFit];
    height += lblHeight.frame.size.height + 40;
    
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

#pragma mark -- Getters && Setters --

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _rightImageView;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.font = [UIFont systemFontOfSize:11];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.numberOfLines = 0;
        
    }
    
    return _descriptionLabel;
}

@end
