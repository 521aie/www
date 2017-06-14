//
//  TDFHealthCheckVideoCell.m
//  ClassProperties
//
//  Created by guopin on 2016/12/15.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "TDFHealthCheckVideoCell.h"
#import "TDFHealthCheckItemBodyModel.h"
@interface TDFHealthCheckVideoCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *title;
@end
@implementation TDFHealthCheckVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

-(void)configViews{
    self.imgView = ({
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_offset(CGSizeMake(25, 25));
        }];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [UIImage imageNamed:@"ico_video_play"];
        view;
    });
    self.title = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imgView);
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.right.equalTo(self.contentView);
        }];
        view.numberOfLines = 0;
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = [UIColor colorWithHexString:@"#0076FF"];
        view;
    });
}

-(void)cellLoadData:(TDFHealthCheckVideoModel *)data{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_video_play"]];
    if (data.type == 1) {
      self.title.text =  [NSString stringWithFormat:NSLocalizedString(@"视频教程：%@", nil),data.videoName];
    } else if(data.type == 2){
        self.title.text =  data.videoName;
    }
}
@end
