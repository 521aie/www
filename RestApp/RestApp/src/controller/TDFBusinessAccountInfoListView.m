//
//  TDFBusinessAccountInfoListView.m
//  RestApp
//
//  Created by happyo on 2017/1/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessAccountInfoListView.h"

@implementation TDFBusinessAccountInfoModel


@end

@implementation TDFBusinessAccountInfoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-1);
            make.height.equalTo(@(13));
        }];
        
        [self addSubview:self.lblAccount];
        [self.lblAccount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblTitle.mas_bottom).with.offset(6);
            make.leading.equalTo(self.lblTitle);
            make.trailing.equalTo(self.lblTitle);
            make.height.equalTo(@(15));
        }];
        
        [self addSubview:self.lblDescription];
        [self.lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblAccount.mas_bottom);
            make.leading.equalTo(self.lblTitle);
            make.trailing.equalTo(self.lblTitle);
            make.height.equalTo(@(9));
        }];
        
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self);
            make.width.equalTo(@(1));
            make.height.equalTo(@(34));
        }];
    }
    
    return self;
}

#pragma mark -- Setters && Getters --

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTitle.font = [UIFont systemFontOfSize:11];
        _lblTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return _lblTitle;
}

- (UILabel *)lblAccount
{
    if (!_lblAccount) {
        _lblAccount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblAccount.font = [UIFont systemFontOfSize:13];
        _lblAccount.textColor = [UIColor whiteColor];
    }
    
    return _lblAccount;
}

- (UILabel *)lblDescription
{
    if (!_lblDescription) {
        _lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDescription.font = [UIFont systemFontOfSize:9];
        _lblDescription.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return _lblDescription;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}

@end

@implementation TDFBusinessAccountInfoListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)configureViewWithModelList:(NSArray<TDFBusinessAccountInfoModel *> *)modelList
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat viewWidth = self.bounds.size.width;
    
    CGFloat cellWidth = viewWidth / 3;
    
    CGFloat cellHeight = 50;
    
    NSInteger count = modelList.count;
    
    NSInteger lineNum = (count % 3 == 0) ? count /3 : count / 3 + 1;
 
    self.heightForView = lineNum * cellHeight;
    
    if (self.heightForView != 0) {
        self.heightForView += 10;
    }
    
    for (int i = 0; i < modelList.count; i++) {
        TDFBusinessAccountInfoModel *model = modelList[i];
        
        int line = i / 3;
        
        int column = i % 3;
        
        CGFloat x = 0;
        
        CGFloat y = 0;
        
        if (i % 3 == 0) {
            x = 0;
        } else {
            x = column * cellWidth + 1;
        }
        
        if (i / 3 == 0) {
            y = 0;
        } else {
            y = line * cellHeight + 1;
        }
        
        TDFBusinessAccountInfoDetailView *detailView = [[TDFBusinessAccountInfoDetailView alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        
        detailView.lblTitle.text = model.title;
        detailView.lblAccount.text = model.account;
        detailView.lblDescription.text = model.isShowDescription ? NSLocalizedString(@"(不计入收益)", nil) : @"";
        detailView.spliteView.hidden = (i % 3 == 2);
        
        if (i == modelList.count - 1) { // 如果是最后一个，则隐藏分割线
            detailView.spliteView.hidden = YES;
        }
        
        [self addSubview:detailView];
    }
}


@end
