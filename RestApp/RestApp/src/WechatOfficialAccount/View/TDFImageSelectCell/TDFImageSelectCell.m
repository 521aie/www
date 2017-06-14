//
//  TDFImageSelectCell.m
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFImageSelectCell.h"
#import "TDFImageSelectItem.h"
#import "TDFImageSelectView.h"

@interface TDFImageSelectCell ()

@property (strong, nonatomic) TDFImageSelectItem *item;
@property (strong, nonatomic) TDFImageSelectView *selectView;
@property (strong, nonatomic) UIView *dividerView;

@end

@implementation TDFImageSelectCell

#pragma mark - DHTTableViewCellDelegate

- (void)cellDidLoad {
    
    [self addSubview:self.selectView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    
    [self addSubview:self.dividerView];
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-9);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}


- (void)configCellWithItem:(DHTTableViewItem *)item {

    self.item = (TDFImageSelectItem *)item;
    if (self.item.editStyle == TDFEditStyleEditable) {
     
        self.selectView.deleteBlock = self.item.deleteBlock;
        self.selectView.selectBlock = self.item.selectBlock;
    }
    

    self.selectView.alwaysHideDeleteButton = self.item.editStyle == TDFEditStyleUnEditable;
    self.selectView.imageURL = [NSURL URLWithString:self.item.requestValue];
    self.selectView.title = self.item.title;
    self.selectView.prompt = self.item.prompt;
    self.selectView.errorMessage = self.item.errorMessage;
    
    self.dividerView.hidden = self.item.separatorHidden;
    self.hidden = !self.item.shouldShow;
}

+ (CGFloat)heightForCellWithItem:(DHTTableViewItem *)item {
    
    return ((TDFImageSelectItem *)item).shouldShow ? 243 : 0;
}


- (TDFImageSelectView *)selectView {

    if (!_selectView) {
        
        _selectView = [[TDFImageSelectView alloc] init];
    }
    
    return _selectView;
}

- (UIView *)dividerView {

    if (!_dividerView) {
        
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    
    return _dividerView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.selectView.imageURL = nil;
    self.selectView.deleteBlock = nil;
    self.selectView.selectBlock = nil;
}

@end
