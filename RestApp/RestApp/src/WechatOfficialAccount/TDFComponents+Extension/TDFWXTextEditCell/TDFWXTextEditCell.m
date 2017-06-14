//
//  TDFWXTextEditCell.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXTextEditCell.h"
#import "DHTTableViewCellProtocol.h"
#import "TDFBaseEditView.h"
#import "TDFWXTextEditItem.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface TDFWXTextEditCell ()<DHTTableViewCellDelegate>

@property (nonatomic, strong) TDFBaseEditView *baseEditView;
@property (nonatomic, strong) TDFWXTextEditItem *item;
@property (nonatomic, strong) UILabel *requiredLabel;

@end

@implementation TDFWXTextEditCell

#pragma mark -- DHTTableViewCellDelegate --

- (void)cellDidLoad {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.baseEditView];
    
    [self.baseEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.requiredLabel];
    [self.requiredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.top.equalTo(self).with.offset(15);
    }];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:gesture];
}

- (void)configCellWithItem:(TDFWXTextEditItem *)item {
    
    self.item = item;
    if (item.shouldShow) {
        self.hidden = NO;
    } else {
        self.hidden = YES;
        return ;
    }
    
    [self.baseEditView configureViewWithModel:item];
    BOOL changed = ([item.requestValue length] != 0 || [item.preValue length] != 0)
                    && ![item.requestValue isEqualToString:item.preValue];
    self.baseEditView.lblTip.hidden = !changed;
    item.isShowTip = changed;
    if ([item.requestValue length] > 0) {

        NSAttributedString *string = [[NSAttributedString alloc] initWithString:item.requestValue
                                                                     attributes:@{
                                                                                  NSFontAttributeName: [UIFont systemFontOfSize:13],
                                                                                  NSForegroundColorAttributeName:[UIColor colorWithHeX:0x0088CC]
                                                                                  }];
        self.baseEditView.lblDetail.attributedText = string;
        self.requiredLabel.text = nil;
    } else {
        
        UIColor *color = [UIColor colorWithHeX:item.isRequired ? 0xCC0000 : 0x999999];
        self.requiredLabel.text = item.isRequired ? @"必填": @"可不填";
        self.requiredLabel.textColor = color;
    }
}

+ (CGFloat)heightForCellWithItem:(TDFWXTextEditItem *)item {
    CGFloat height = 0;
    TDFWXTextEditItem *newItem = [item copy];
    if ([item.requestValue length] > 0) {
        newItem.attributedDetail = [[NSAttributedString alloc] initWithString:item.requestValue
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:13],
                                                                                NSForegroundColorAttributeName:[UIColor colorWithHeX:0x0088CC]
                                                                                }];
    }
    if (item.shouldShow) {
        height = [TDFBaseEditView getHeightWithModel:newItem];
    }
    
    return height;
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)gesture {

    switch (gesture.state) {
        case UIGestureRecognizerStateEnded:
            !self.item.clickBlock ?: self.item.clickBlock();
            break;
            
        default:
            break;
    }
}

#pragma mark -- Setters && Getters --

- (TDFBaseEditView *)baseEditView {
    if (!_baseEditView) {
        _baseEditView = [[TDFBaseEditView alloc] initWithFrame:CGRectZero];
    }
    
    return _baseEditView;
}

- (UILabel *)requiredLabel {

    if (!_requiredLabel) {
        
        _requiredLabel = [[UILabel alloc] init];
        _requiredLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _requiredLabel;
}

@end
