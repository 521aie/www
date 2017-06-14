//
//  TDFFunctionPopView.m
//  RestApp
//
//  Created by 黄河 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "TDFFunctionPopView.h"
#import "TDFFunctionKindVo.h"
#import "TDFFunctionVo.h"
#import "TDFForwardGroup.h"
@interface TDFFunctionPopView ()
@property (nonatomic, strong)TDFFunctionKindVo* kindVo;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)UIView *shadowView;
@property (nonatomic, strong)UIView *showView;
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, strong)UILabel *showLocationLabel;
@property (nonatomic, strong)UILabel *suggestLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@end
@implementation TDFFunctionPopView

#pragma mark --init
- (UIView *)showView
{
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
    }
    return _headerImageView;
}

- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [UIView new];
    }
    return _shadowView;
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton new];
    }
    return _selectButton;
}
- (UILabel *)showLocationLabel
{
    if (!_showLocationLabel) {
        _showLocationLabel = [UILabel new];
    }
    return _showLocationLabel;
}
- (UILabel *)suggestLabel
{
    if (!_suggestLabel) {
        _suggestLabel = [UILabel new];
    }
    return _suggestLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self layoutView];
    }
    return self;
}

#pragma mark --initView
- (void)initView {
    self.showView.layer.cornerRadius = 4;
    self.showView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.showView];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.showView addSubview:self.titleLabel];
    
    self.showLocationLabel.font = [UIFont systemFontOfSize:13];
    self.showLocationLabel.textColor = RGBA(111, 113, 121, 1);
    [self.showView addSubview:self.showLocationLabel];
    
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headerImageView.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor;
    self.headerImageView.layer.cornerRadius = 25;
    [self.headerImageView clipsToBounds];
    [self.showView addSubview:self.headerImageView];
    
    self.shadowView.layer.cornerRadius = 25;
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.headerImageView addSubview:self.shadowView];
    
    
    self.suggestLabel.textColor = RGBA(111, 113, 121, 1);
    self.suggestLabel.font = [UIFont systemFontOfSize:10];
    [self.showView addSubview:self.suggestLabel];
    
    [self.selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:self.selectButton];
    
    self.detailLabel.font = [UIFont systemFontOfSize:13];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textColor = RGBA(111, 113, 121, 1);
    [self.showView addSubview:self.detailLabel];
}


#pragma mark --layout
- (void)layoutView {
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pw_fw.png"]];
    [self.shadowView addSubview:shadowImageView];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor grayColor];
    UIImageView *selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_check.png"]];
    selectImageView.tag = 111;
    [self.selectButton addSubview:selectImageView];
    [self.showView addSubview:line];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"ico_functionCloseImage"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeSelfFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.showView.mas_right);
        make.centerY.equalTo(self.showView.mas_top);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(44);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showView.mas_top).offset(15);
        make.left.equalTo(self.showView.mas_left).offset(20);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerImageView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top);
        make.left.equalTo(self.headerImageView.mas_right).offset(8);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.left.equalTo(self.headerImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.selectButton.mas_centerX);
        make.centerY.equalTo(self.selectButton.mas_centerY);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    [self.suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.left.equalTo(self.selectButton.mas_right);
    }];
    [self.showLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.suggestLabel.mas_top);
        make.left.equalTo(self.selectButton.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(8);
        make.left.equalTo(self.showView.mas_left).offset(8);
        make.right.equalTo(self.showView.mas_right).offset(-8);
        make.height.equalTo(@1);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(8);
        make.left.equalTo(self.showView.mas_left).offset(8);
        make.right.equalTo(self.showView.mas_right).offset(-8);
        make.bottom.equalTo(self.showView.mas_bottom).offset(-8);
    }];
}

#pragma mark --loadData

- (void)loadDataWithFunctionKindVo:(TDFFunctionKindVo *)kindVo
                      andIndexPath:(NSIndexPath *)indexPath {
    self.kindVo = kindVo;
    self.indexPath = indexPath;
    if (kindVo.functionVoList.count > indexPath.row ) {
        TDFFunctionVo * functionVO = [kindVo.functionVoList objectAtIndex:indexPath.row];
        self.titleLabel.text = functionVO.actionName;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:functionVO.iconImageUrl.fUrl] placeholderImage:[UIImage imageNamed:@"ico_functionplaceImage.png"] options:SDWebImageRefreshCached];
        self.suggestLabel.text = [NSString stringWithFormat:@"(%@)",functionVO.isSuggestShow?NSLocalizedString(@"建议设置为显示", nil):NSLocalizedString(@"建议设置完成后隐藏", nil)];
        self.detailLabel.text = functionVO.detail;
        [self setShowLocationLabel];
    }
}

- (void)loadDataWithKindVo:(TDFForwardGroup *)kindVo
              andIndexPath:(NSIndexPath *)indexPath {

//    self.kindVo = kindVo;
    self.indexPath = indexPath;
    if (kindVo.forwardCells.count > indexPath.row ) {
        TDFForwardCells * functionVO = [kindVo.forwardCells objectAtIndex:indexPath.row];
        self.titleLabel.text = functionVO.title;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:functionVO.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_functionplaceImage.png"] options:SDWebImageRefreshCached];
        self.suggestLabel.text = [NSString stringWithFormat:@"(%@)",functionVO.isSuggestShow?NSLocalizedString(@"建议设置为显示", nil):NSLocalizedString(@"建议设置完成后隐藏", nil)];
        self.detailLabel.text = functionVO.detail;
        [self setShowLocationLabel];
    }
}



#pragma mark --显示或隐藏
- (void)setShowLocationLabel {
    if (self.kindVo.functionVoList.count > self.indexPath.row ) {
        TDFFunctionVo * functionVO = [self.kindVo.functionVoList objectAtIndex:self.indexPath.row];
        UIImageView *imageView = [self.selectButton viewWithTag:111];
        imageView.image = [UIImage imageNamed:functionVO.isHide ?@"ico_uncheck.png":@"ico_check.png"];
        
        self.shadowView.hidden = !functionVO.isLock;
        self.showLocationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"此功能在%@%@", nil),self.kindVo.kindType?NSLocalizedString(@"首页", nil):NSLocalizedString(@"左侧栏", nil),functionVO.isHide?NSLocalizedString(@"隐藏", nil):NSLocalizedString(@"显示", nil)];
    }
}

#pragma mark --buttonclick
- (void)selectButtonClick:(UIButton *)click
{
    TDFFunctionVo * functionVO = [self.kindVo.functionVoList objectAtIndex:self.indexPath.row];
    functionVO.isHide = !functionVO.isHide ;
    [self setShowLocationLabel];
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)removeSelfFromSuperView {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    if (!CGRectContainsPoint(self.showView.frame, point)) {
        [self removeFromSuperview];
    }
    
}
@end
