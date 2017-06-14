//
//  TDFShopSelectionTableViewCell.m
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopSelectionTableViewCell.h"
#import "TDFLabelFactory.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface TDFShopSelectionTableViewCell ()

@property (strong, nonatomic, readwrite) UIImageView *selectionImageView;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UILabel *subTitleLabel;
@property (strong, nonatomic, readwrite) UIButton *statusButton;
@property (strong, nonatomic) TDFShopSelectionItem *item;

@end

@implementation TDFShopSelectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configViews];
        [self updateViews];
    }
    return self;
}

- (void)configViews {

    @weakify(self);
    [self addSubview:self.selectionImageView];
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).with.offset(10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.selectionImageView.mas_right).with.offset(10);
        make.top.equalTo(self).with.offset(14);
    }];
    
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.statusButton];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:gesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {

    switch (gesture.state) {
        case UIGestureRecognizerStateEnded:
            
            if (self.item.state == TDFShopSelectionStateNormal && self.item.canSelected) {
                
                self.item.requestValue = @(YES);
                !self.item.selectionChangedBlock ?: self.item.selectionChangedBlock(YES);
                self.item.state = self.state = TDFShopSelectionStateSelected;
            } else if(self.item.state == TDFShopSelectionStateSelected && self.item.canSelected) {
                
                self.item.requestValue = @(NO);
                !self.item.selectionChangedBlock ?: self.item.selectionChangedBlock(NO);
                self.item.state = self.state = TDFShopSelectionStateNormal;
            }
            break;
        default:
            break;
    }
}

- (void)statusButtonTapped {

    !self.item.promptBlock ?: self.item.promptBlock();
}

- (void)updateViews {

    switch (self.item.style) {
        case TDFShopSelectionStyleNormal:
            self.titleLabel.textColor = [UIColor colorWithHeX:0x333333];
            self.subTitleLabel.textColor = [UIColor colorWithHeX:0x666666];
            [self.statusButton setTitleColor:[UIColor colorWithHeX:0xCC0000] forState:UIControlStateNormal];
            self.selectionImageView.alpha = 1;
            break;
        case TDFShopSelectionStyleDisable:
            self.titleLabel.textColor = [UIColor colorWithHeX:0x999999];
            self.selectionImageView.image = [UIImage imageNamed:@"icon_select_empty"];
            self.subTitleLabel.textColor = [UIColor colorWithHeX:0x999999];
            [self.statusButton setTitleColor:[UIColor colorWithHeX:0x999999] forState:UIControlStateNormal];
            self.selectionImageView.alpha = 0.5;
            break;
    }
    
    switch (self.item.state) {
        case TDFShopSelectionStateNormal:
            self.selectionImageView.image = [UIImage imageNamed:@"icon_select_empty"];
            break;
        case TDFShopSelectionStateSelected:
            self.selectionImageView.image = [UIImage imageNamed:@"icon_select_filled"];
            break;
    }
}

- (UIButton *)statusButton {

    if (!_statusButton) {
        
        _statusButton = [[UIButton alloc] init];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _statusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_statusButton addTarget:self action:@selector(statusButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusButton;
}

- (UILabel *)subTitleLabel {

    if (!_subTitleLabel) {
        
        _subTitleLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeComment];
    }
    
    return _subTitleLabel;
}


- (UILabel *)titleLabel {

    if (!_titleLabel) {
     
        _titleLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
    }
    
    return _titleLabel;
}


- (UIImageView *)selectionImageView {

    if (!_selectionImageView) {
        
        _selectionImageView = [[UIImageView alloc] init];
    }
    
    return _selectionImageView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.state = TDFShopSelectionStateNormal;
}

- (void)setState:(TDFShopSelectionState)state {

    if (state != _state) {
        
        _state = state;
        [self updateViews];
    }
}

- (void)cellDidLoad {

    
}


+ (CGFloat)heightForCellWithItem:(DHTTableViewItem *)item {

    return ((TDFShopSelectionItem *)item).shouldShow ? 64 : 0;
}

- (void)configCellWithItem:(TDFShopSelectionItem *)item {

    self.item = item;
    self.titleLabel.text = item.title;
    self.subTitleLabel.text = item.subTitle;
    [self.statusButton setTitle:item.prompt forState:UIControlStateNormal];
    self.state = item.state;
    self.hidden = !item.shouldShow;
    [self updateViews];
}


@end
