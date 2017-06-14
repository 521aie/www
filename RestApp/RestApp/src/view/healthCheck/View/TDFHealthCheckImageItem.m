//
//  TDFHealthCheckImageItem.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/19.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "TDFHealthCheckImageItem.h"
#import "TDFHealthCheckConfigViewModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"
@interface  TDFHealthCheckImageItem()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *markImg;
@property (nonatomic, strong) UILabel *title;
@end
@implementation TDFHealthCheckImageItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configViews];
    }
    return self;
}

-(void)configViews{
    self.title = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.and.left.equalTo(self);
        }];
        view.numberOfLines = 0;
        view.font = [UIFont systemFontOfSize:9];
        view.textColor = [UIColor colorWithHexString:@"#666666"];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });

    self.imgView = ({
        UIImageView *view = [UIImageView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view;
    });
    
    self.markImg = ({
        UIImageView *view = [UIImageView  new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imgView);
            make.size.equalTo(self.imgView);
        }];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view;
    });

}

-(void)loadDatas:(id)data{
    self.title.text = data[@"iconName"];
    self.markImg.image = [TDFHealthCheckConfigViewModel accountStatusImage:[data[@"status"] integerValue]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:data[@"iconUrl"]] placeholderImage:nil];
}
@end
