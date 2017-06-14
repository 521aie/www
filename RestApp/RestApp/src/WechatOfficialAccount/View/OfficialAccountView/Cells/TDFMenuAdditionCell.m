//
//  TDFMenuAdditionCell.m
//  TDFFakeOfficialAccount
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFMenuAdditionCell.h"
#import <Masonry/Masonry.h>

@interface TDFMenuAdditionCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TDFMenuAdditionCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    
    return self;
}

- (void)configViews {

    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"wxoa_menu_add"];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    
    return _imageView;
}

@end
