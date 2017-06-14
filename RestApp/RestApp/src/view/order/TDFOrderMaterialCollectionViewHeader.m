//
//  TDFOrderMaterialCollectionViewHeader.m
//  RestApp
//
//  Created by QiYa on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderMaterialCollectionViewHeader.h"

@interface TDFOrderMaterialCollectionViewHeader()

@property (nonatomic, strong)UIView *line;

@end

@implementation TDFOrderMaterialCollectionViewHeader
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.line];
        
        [self configureLayoutUI];
    }
    
    return self;
    
}

- (void)configureLayoutUI {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self.line.mas_top);
        make.leading.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self).offset(-10);
    }];
    
}

+ (CGFloat)headerHeight {
    
    return 50.0f;
    
}

#pragma mark - Setter & Getter

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *lbl = [UILabel new];
            lbl.font = [UIFont systemFontOfSize:12];
            lbl.textColor = [UIColor grayColor];
            lbl;
        });
    }
    
    return _titleLabel;
    
}

- (UIView *)line {
    
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _line;
    
}

@end
