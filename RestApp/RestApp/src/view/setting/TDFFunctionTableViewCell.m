//
//  TDFFunctionTableViewCell.m
//  RestApp
//
//  Created by 黄河 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFFunctionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TDFFunctionVo.h"

@interface TDFFunctionTableViewCell ()
@property (nonatomic, strong)UILabel *detailLabel;
@end
@implementation TDFFunctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
        [self initRightButton];
        [self layouView];
    }
    return self;
}

#pragma mark --初始化属性
- (void)initCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.imageView addSubview:self.shadowView];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.detailLabel];
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor;
    self.imageView.layer.cornerRadius = 30;
    self.shadowView.layer.cornerRadius = 30;
    [self.imageView clipsToBounds];
}

#pragma mark --右边选择按钮
- (void)initRightButton {
    self.rightControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 30, 90)];
    [self.rightControl addTarget:self action:@selector(selectControlClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_check.png"]];
    imageView.tag = 10;
    [self.rightControl addSubview:imageView];
    [self.contentView addSubview:self.rightControl];
    [self.rightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo (self.contentView);
        make.bottom.equalTo (self.contentView);
        make.width.equalTo (@50);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightControl.mas_centerX);
        make.centerY.equalTo(self.rightControl.mas_centerY);
        make.width.equalTo (@18);
        make.height.equalTo (@18);
    }];
    
}

#pragma mark --layout
- (void)layouView {
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pw_fw.png"]];
    [self.shadowView addSubview:shadowImageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.equalTo(self.imageView.mas_height);
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([shadowImageView superview]);
        make.centerY.equalTo([shadowImageView superview]);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-4);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.top.equalTo(self.textLabel.mas_bottom).offset(8);
        make.right.equalTo(self.rightControl.mas_left);
    }];
}

#pragma mark --loadData

- (void)initWithData:(TDFFunctionVo *)data {
    self.textLabel.text = data.actionName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.iconImageUrl.fUrl] placeholderImage:[UIImage imageNamed:@"ico_functionplaceImage.png"] options:SDWebImageRefreshCached];
    self.detailLabel.text = data.detail;
    UIImageView *imageView = [self.rightControl viewWithTag:10];
    imageView.image = [UIImage imageNamed:data.isHide ?@"ico_uncheck.png":@"ico_check.png"];
    self.shadowView.hidden = !data.isLock;
}

- (void)selectControlClick:(UIControl *)control {
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter && getter
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

@end
