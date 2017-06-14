//
//  SelectImageItem.m
//  CardApp
//
//  Created by 邵建青 on 14-2-27.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "SelectImageItem.h"
#import "BackgroundView.h"
#import "Masonry.h"

@implementation SelectImageItem

- (instancetype)init {
    if(self = [super init]) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:SELECT_IMAGE_ITEM_RADIUS];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.selectBg];
        [self.selectBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.selectImg];
        [self.selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.and.height.mas_equalTo(32);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIView *)selectBg {
    if(!_selectBg) {
        _selectBg = [[UIView alloc] init];
        _selectBg.backgroundColor = [UIColor blackColor];
        _selectBg.alpha = 0.3;
        _selectBg.hidden = YES;
    }
    return _selectBg;
}

- (UIImageView *)selectImg {
    if(!_selectImg) {
        _selectImg = [[UIImageView alloc] init];
        _selectImg.image = [UIImage imageNamed:@"ico_ok"];
        _selectImg.hidden = YES;
    }
    return _selectImg;
}
- (void)initWithBackgroundData:(BackgroundData *)backgroundDataP parent:(BackgroundView *)backgroundViewP
{
    backgroundData = backgroundDataP;
    backgroundView = backgroundViewP;
    [self.imageView setImage:[UIImage imageNamed:backgroundData.smallImgName]];
}

- (IBAction)imageBtnClick:(id)sender
{
    [backgroundView selectBackground:self];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if(isSelected) {
        self.selectImg.hidden = NO;
        self.selectBg.hidden = NO;
        self.layer.borderWidth = 1;
    } else {
        self.selectImg.hidden = YES;
        self.selectBg.hidden = YES;
        self.layer.borderWidth = 0;
    }
}

- (BackgroundData *)getBackgroundData
{
    return backgroundData;
}

@end
