//
//  TDFOptionSelectCell.m
//  TDFTools
//
//  Created by Octree on 16/8/16.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import "TDFOptionSelectCell.h"

@interface TDFOptionSelectCell ()

@end

@implementation TDFOptionSelectCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _selectImageView.image = [UIImage imageNamed:@"ico_uncheck"];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.selectImageView];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imageWidth = self.selectImageView.frame.size.width;
    CGFloat x = 15;
    CGFloat y = (height - imageWidth) / 2;
    
    self.selectImageView.frame = CGRectMake(x, y, imageWidth, imageWidth);
    
    CGFloat labelX = 45;
    CGFloat labelY = (height - 40) / 2;
    CGFloat labelWidth = width - labelX - 15;
    
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelWidth, 40);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectImageView.image = [UIImage imageNamed: selected ? @"ico_check" : @"ico_uncheck"];
}


#pragma mark - Accessor


@end
