//
//  TDFHealthCheckBarCell.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/19.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckCycleCell.h"
#import "TDFHealthTitleView.h"
#import <Masonry/Masonry.h>
#import "TDFCycleView.h"
#import "ObjectUtil.h"
#import "UIColor+Hex.h"
@interface TDFHealthCheckCycleCell()<UIScrollViewDelegate>
@property (nonatomic, strong) TDFHealthTitleView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger page;
@end
@implementation TDFHealthCheckCycleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGRect rect = self.frame;
        rect.size.width = [[UIScreen mainScreen] bounds].size.width*0.95;
        self.frame = rect;
        [self configViews];
    }
    return self;
}

-(void)configViews{
    
    self.titleView = ({
        TDFHealthTitleView *view = [TDFHealthTitleView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
        }];
        view;
    });
    self.scrollView = ({
        UIScrollView *view = [UIScrollView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom).offset(20);
            make.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_offset(@0);
        }];
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        view.clipsToBounds = YES;
        view.pagingEnabled = YES;
        view;
    });
    [self.contentView addSubview:self.pageControl];
    [self.pageControl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(-10);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(@37);
    }];
}

#pragma mark layout
-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    [self.titleView initTitle:data.title detail:data.desc];
  
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview ];
    }
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[[data.details lastObject] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
    
    NSArray *charts = dict[@"charts"];
    if ( [ObjectUtil isEmpty:dict]||  [ObjectUtil isEmpty:charts]) {
        return;
    }
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGSizeMake(54,70).height);
    }];
    self.pageControl.hidden = NO;
    NSInteger maxNum = [dict[@"pageCnt"] integerValue];
    NSArray *itemDatas = [self data:charts maxItems:maxNum];
    self.page = itemDatas.count;
    self.pageControl.numberOfPages = self.page;
    if (self.page <= 1) {
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).offset(-37);
        }];
        self.pageControl.hidden = YES;
        self.scrollView.scrollEnabled = NO;
    }else{
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).offset(-10);
        }];
        self.pageControl.hidden = NO;
        self.scrollView.scrollEnabled = YES;
    }
    [self scrollViewWillLoadDatas:self.scrollView datas:itemDatas maxNumber:maxNum item:NSStringFromClass([TDFCycleView class]) itemSize:CGSizeMake(54,70)];
}

-(void)scrollViewWillLoadDatas:(UIScrollView *)scrollView datas:(NSArray *)itemDatas  maxNumber:(NSInteger)maxNum item:(NSString *)clsString itemSize:(CGSize)itemSize{
    CGFloat scrollViewWidth = self.bounds.size.width-30;
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scrollViewWidth);
    }];
    [scrollView layoutIfNeeded];
    NSUInteger page = itemDatas.count;
    CGFloat width = page * scrollViewWidth;
    UIView *container= ({
        UIView *view = [UIView new];
        [scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.height.equalTo(scrollView);
        }];
        view;
    });
    UIView *lastView = nil;
    for (int i = 0 ; i < itemDatas.count; i++) {
        UIView *item = [self item:itemDatas[i] itemCls:clsString];
        item.backgroundColor = [UIColor clearColor];
        [container addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(scrollViewWidth, 70));
            make.top.equalTo(container);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(0);
            }else{
                make.left.equalTo(container.mas_left).offset(0);
            }
        }];
        [item layoutIfNeeded];
        lastView = item;
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(itemSize.height);
        make.width.mas_equalTo(width);
    }];
}

-(NSArray*)data:(NSArray *)datas maxItems:(NSInteger)maxNum{
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i = 0; i < [datas count]; i++) {
        NSMutableArray *items = [NSMutableArray array];
        NSInteger count = 0;
        while (count != maxNum && i < [datas count]) {
            count++;
            [items addObject:datas[i]];
            i++;
        }
        [data addObject:items];
        i--;
    }
    return data;
}

-(UIView *)item:(NSArray *)items itemCls:(NSString *)clsString{
    CGFloat scrollViewWidth = self.bounds.size.width-30;
    CGFloat space = 20;
    CGFloat start = (scrollViewWidth - items.count *54 - (items.count-1)*space)/2;
    UIView *itemContainer = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *lastView = nil;
    for (int i = 0; i < items.count ; i++) {
        Class cls = NSClassFromString(clsString);
        UIView *item = [cls new];
        item.backgroundColor = [UIColor clearColor];
        [itemContainer addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(54, 54));
            make.top.equalTo(itemContainer);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(space);
            }else{
                make.left.equalTo(itemContainer.mas_left).offset(start);
            }
        }];
        [item layoutIfNeeded];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([item respondsToSelector:@selector(loadDatas:)]) {
            [item performSelector:@selector(loadDatas:) withObject:items[i]];
        }
#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        UILabel *label= ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor colorWithHexString:@"#666666"];
            [itemContainer addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(item.mas_bottom).offset(5);
                make.left.equalTo(item.mas_left).offset(-18);
                make.right.equalTo(item.mas_right).offset(18);
            }];
            view.numberOfLines = 0;
            view.font = [UIFont systemFontOfSize:9];
            view.textAlignment = NSTextAlignmentCenter;
            view.text = items[i][@"subscript"];
            view;
        });
#pragma clang diagnostic pop
        lastView = item;
    }
    return itemContainer;
}

#pragma mark scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage =  scrollView.contentOffset.x/self.scrollView.frame.size.width;
}

/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data{
    static UITableViewCell *cell = nil;
  NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName([TDFHealthCheckCycleCell class])];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TDFHealthCheckCycleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }) ;
    [(TDFHealthCheckCycleCell *)cell cellLoadData:data];
    return [(TDFHealthCheckCycleCell *)cell calculateHeightForCell];
    
}
- (CGFloat)calculateHeightForCell {
    [self layoutIfNeeded];
    CGFloat height = self.scrollView.frame.origin.y + self.scrollView.frame.size.height+10;
    
    if (self.page >1) {
        height = self.pageControl.frame.origin.y + self.pageControl.frame.size.height+10;
    }
    return height;
}
#pragma mark getter

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor=  [UIColor darkGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}


@end
