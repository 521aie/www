//
//  TDFMenuPromptView.m
//  RestApp
//
//  Created by Octree on 20/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuPromptView.h"
#import <Masonry/Masonry.h>

@interface TDFMenuPromptView ()

@property (strong, nonatomic, readwrite) UILabel *promptLabel;
@property (strong, nonatomic, readwrite) UIButton *closeButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) void (^closeBlock)();

@end

@implementation TDFMenuPromptView

+ (instancetype)promptViewWithTitle:(NSString *)title closeBlock:(void(^)())block {

    TDFMenuPromptView *view = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 183, 68)];
    view.closeBlock = block;
    view.promptLabel.text = title;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    
    return self;
}


- (void)closeButtonTapped {

    !self.closeBlock ?: self.closeBlock();
}

- (void)configViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 3, 0));
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}


- (UILabel *)promptLabel {

    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _promptLabel;
}


- (UIButton *)closeButton {

    if (!_closeButton) {
    
        _closeButton = [[UIButton alloc] init];
        [_closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}


- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_prompt_background"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imageView;
}

@end
