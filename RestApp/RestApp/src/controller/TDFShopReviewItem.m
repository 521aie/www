//
//  TDFShopReviewView.m
//  RestApp
//
//  Created by xueyu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopReviewItem.h"
#import <Masonry/Masonry.h>
@interface TDFShopReviewItem()
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *bottomImageView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *button;
@property (copy, nonatomic) ForawardBlock block;
@property (strong, nonatomic) NSDictionary *dict;
@end

@implementation TDFShopReviewItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary forawardBlock:(ForawardBlock)callback
{
    self = [super init];
    if (self) {
        _dict = dictionary;
        _block = callback;
        [self configViews];
    }
    return self;
}
#pragma mark Config Views

-(void)configViews{
    switch ([self.dict[@"style"] integerValue]) {
        case TDFShopReviewItemStyleDefaule:
            [self configViewsDefault];
            break;
        case TDFShopReviewItemStyleImage:
            [self configViewsImage];
            break;
        case TDFShopReviewItemStyleNotification:
            [self configNotificationStyle];
            break;
        default:
            break;
    }
}



// style -- default
- (void)configViewsDefault {
    [self addSubview:self.topImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.contentImageView];
    [self addSubview:self.bottomImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.button];
    [self configConstrainsDefault];
    self.contentImageView.image = [UIImage imageNamed:self.dict[@"image"]];
    self.titleLabel.text = self.dict[@"title"];
    self.tipLabel.text = self.dict[@"content"];
    [self.button setTitle:self.dict[@"buttonTitle"] forState:UIControlStateNormal];
}

- (void)configConstrainsDefault {
    CGFloat topMargin = SCREEN_WIDTH*0.10;
    if (SCREEN_WIDTH <375) {
        topMargin = topMargin*0.66;
    }
    __typeof(self) __weak wself = self;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.mas_top);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(topMargin);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.topImageView.mas_bottom);
        make.centerX.equalTo(wself.mas_centerX).offset(0);
        make.height.equalTo(@(SCREEN_WIDTH *0.48));
        make.width.equalTo(@(SCREEN_WIDTH *0.48));

    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.bottom.equalTo(wself.mas_bottom);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.contentImageView.mas_top);
        make.bottom.equalTo(wself.bottomImageView.mas_top);
        make.right.equalTo(wself.mas_right);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.contentImageView.mas_bottom).with.offset(topMargin);
        make.right.equalTo(wself.mas_right);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(35);
        make.top.equalTo(wself.titleLabel.mas_bottom).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-30);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.mas_centerX);
        make.centerY.equalTo(wself.bottomImageView.mas_top).offset(-5);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(34);
    }];
    
}

// style -- image
-(void)configViewsImage{
  
    [self addSubview:self.topImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.bottomImageView];
    [self addSubview:self.contentImageView];
    [self addSubview:self.button];
    __typeof(self) __weak wself = self;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.mas_top);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.bottom.equalTo(wself.mas_bottom);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself).insets(UIEdgeInsetsMake(16, 20, 33, 20));
    }];

    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.contentImageView.mas_top);
        make.bottom.equalTo(wself.bottomImageView.mas_top);
        make.right.equalTo(wself.mas_right);
    }];

    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.mas_centerX);
        make.centerY.equalTo(wself.bottomImageView.mas_top).offset(-5);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
   self.contentImageView.image = [UIImage imageNamed:self.dict[@"image"]];
    self.contentImageView.contentMode = UIViewContentModeScaleToFill;
   [self.button setTitle:self.dict[@"buttonTitle"] forState:UIControlStateNormal];

}

// style -- Notification
- (void)configNotificationStyle {
    [self addSubview:self.topImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.bottomImageView];
    [self addSubview:self.contentImageView];
    __typeof(self) __weak wself = self;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.mas_top);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself).offset(20);
        make.right.equalTo(wself).offset(-20);
        make.top.equalTo(wself).offset(32);
        make.height.equalTo(self.contentImageView.mas_width);
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.bottom.equalTo(wself.mas_bottom);
        make.right.equalTo(wself.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left);
        make.top.equalTo(wself.topImageView.mas_bottom);
        make.bottom.equalTo(wself.bottomImageView.mas_top);
        make.right.equalTo(wself.mas_right);
    }];

    self.contentImageView.image = [UIImage imageNamed:self.dict[@"image"]];
    
    UIView *footerView = [[UIView alloc] init];
    [self addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImageView.mas_left);
        make.right.equalTo(self.contentImageView.mas_right);
        make.top.equalTo(self.contentImageView.mas_bottom);
        make.bottom.equalTo(wself.bottomImageView.mas_top);
    }];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    leftButton.layer.borderColor = [UIColor grayColor].CGColor;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.cornerRadius = 17;
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"不再提醒" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.centerY.equalTo(footerView);
        make.height.equalTo(@34);
    }];

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    rightButton.layer.borderColor = [UIColor redColor].CGColor;
    rightButton.layer.borderWidth = 1;
    rightButton.layer.cornerRadius = 17;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [footerView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftButton.mas_right).offset(20);
        make.width.equalTo(leftButton.mas_width);
        make.centerY.equalTo(footerView);
        make.right.equalTo(footerView).offset(-20);
        make.height.equalTo(@34);
    }];

}


#pragma mark - Accessor
- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_status_img_top"]];
        
    }
    
    return _topImageView;
}

- (UIImageView *)centerImageView {
    
    if (!_centerImageView) {
        
        _centerImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"shop_review_img_center"]];
    }
    
    return _centerImageView;
}

-(UIImageView *)contentImageView{
    
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        
        _bottomImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"shop_review_img_bottom"]];
    }
    
    return _bottomImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize: 15.];
        _titleLabel.textColor = [UIColor colorWithWhite:51.0 / 255 alpha:1.0];
    }
    
    return _titleLabel;
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize: 13];
        _tipLabel.textColor = [UIColor colorWithWhite:136.0 / 255 alpha:1.0];
        _tipLabel.numberOfLines = 0;
    }
    
    return _tipLabel;
}

- (UIButton *)button {
    
    if (!_button) {
        
        _button = [UIButton buttonWithType: UIButtonTypeSystem];
        CALayer *layer = _button.layer;
        layer.cornerRadius = 17;
        layer.masksToBounds = YES;
        
        UIColor *color = [UIColor colorWithRed:219.0 / 255
                                         green:84.0 / 255
                                          blue:72.0 / 255
                                         alpha:1.0];
        layer.borderColor = color.CGColor;
        layer.borderWidth = 1;
        _button.backgroundColor = [UIColor whiteColor];
        [_button setTitleColor:color forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}
-(void)buttonTapped:(UIButton *)button{
    if (self.block) {
        self.block(self.dict);
    }
    
}

- (void)leftButtonClick:(UIButton *)button {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    dic[@"click"] = @(NO);
    if (self.block) {
        self.block(dic);
    }
}

- (void)rightButtonClick:(UIButton *)button {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    dic[@"click"] = @(YES);
    if (self.block) {
        self.block(dic);
    }
}
@end



