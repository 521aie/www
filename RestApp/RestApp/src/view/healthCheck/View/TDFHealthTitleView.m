//
//  TDFHealthTitleView.m
//  ClassProperties
//
//  Created by guopin on 2016/12/12.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import "TDFHealthTitleView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
@interface TDFHealthTitleView()
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@end
@implementation TDFHealthTitleView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configViews];
    }
    return self;
}

-(void)configViews{
    UIView *point= ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(4, 4));
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(4);
        }];
        view.backgroundColor = [UIColor blackColor];
        view;
    });

    self.title = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(@12);
            make.top.equalTo(self.mas_top);
            make.left.equalTo(point.mas_right).offset(5);
        }];
        view.font = [UIFont boldSystemFontOfSize:11];
        view;
    });
    self.detail =({
        UILabel *view = [UILabel  new];
        view.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.top.equalTo(self.title.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-25);
        }];
        view.numberOfLines = 0;
        view.textAlignment = NSTextAlignmentLeft;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    [self.title setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.title setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisHorizontal];
    [self.detail setContentHuggingPriority:UILayoutPriorityRequired
                                   forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.detail setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                 forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)initTitle:(NSString *)title detail:(NSString *)detail{
    self.title.text = title;
    self.detail.text = detail;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detail.mas_bottom);
    }];
}

@end
