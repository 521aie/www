//
//  TDFNormalMenuCell.m
//  TDFFakeOfficialAccount
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFNormalMenuCell.h"
#import <Masonry/Masonry.h>
#import "TDFLabelFactory.h"

//   Label Padding 10 5 10 5
//   Arrow width 14 height 7

@interface TDFNormalMenuCell ()

@property (strong, nonatomic) UILabel *label;


@end

@implementation TDFNormalMenuCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    return self;
}

- (void)configViews {

    [self addSubview:self.label];
    
    __weak __typeof(self) wself = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.left.equalTo(sself.mas_left).with.offset(5);
        make.right.equalTo(sself.mas_right).with.offset(-5);
        make.centerY.equalTo(sself.mas_centerY);
    }];
}

- (CGSize)sizeThatFits:(CGSize)size withPresenter:(TDFOfficialAccountMenuPresenter *)presenter {

    size.width -= 10;
    self.label.text = presenter.title;
    CGSize newSize = [self.label sizeThatFits:size];
    CGFloat multiLines = newSize.height > 20;
    newSize.width += 10;
    newSize.height += presenter.showArrow ? 27 : 20;
    
    if (multiLines) {
        newSize.height -= 10;
    }
    
    return newSize;
}

- (void)updateWithPresenter:(TDFOfficialAccountMenuPresenter *)presenter {
    [super updateWithPresenter:presenter];
    
    __weak __typeof(self) wself = self;
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.centerY.equalTo(sself.mas_centerY).with.offset(presenter.showArrow ? -3.5 : 0);
    }];
    
    self.label.text = presenter.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.text = @"";
}

- (UILabel *)label {
    
    if (!_label) {
        
        _label = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.numberOfLines = 0;
    }
    
    return _label;
}


@end
