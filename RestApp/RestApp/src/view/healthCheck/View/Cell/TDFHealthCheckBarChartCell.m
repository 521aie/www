//
//  TDFHealthCheckBarChartCell.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/20.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "TDFHealthTitleView.h"
#import <Masonry/Masonry.h>
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckBarChartCell.h"
#import "YYModel/YYModel.h"
#import "ObjectUtil.h"
#import "UIColor+Hex.h"
@interface TDFHealthCheckBarChartCell()<UIScrollViewDelegate>
@property (nonatomic, strong) TDFHealthTitleView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger page;
@end
@implementation TDFHealthCheckBarChartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.frame = [[UIScreen mainScreen] bounds];
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
            make.top.equalTo(self.titleView.mas_bottom).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_offset(@110);
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
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview ];
    }
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (NSString *str in data.details) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
        [datas addObject:dict];
    }
    self.page = datas.count;
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
    [self scrollViewWillLoadDatas:self.scrollView datas:datas  item:@"TDFHealthCheckBarChartView"];
}

-(void)scrollViewWillLoadDatas:(UIScrollView *)scrollView datas:(NSArray *)datas  item:(NSString *)clsString {
    CGFloat scrollViewWidth = self.bounds.size.width-30;
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scrollViewWidth);
    }];
    [scrollView layoutIfNeeded];
    
    CGFloat width = datas.count * scrollViewWidth;
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
    for (int i = 0 ; i < datas.count; i++) {
        Class cls = NSClassFromString(clsString);
        UIView *item = [cls new];
        item.backgroundColor = [UIColor clearColor];
        [container addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(scrollViewWidth);
            make.top.equalTo(container);
            make.bottom.equalTo(scrollView.mas_bottom);
            if (lastView) {
                make.centerX.equalTo(lastView.mas_centerX).offset(scrollViewWidth);
            }else{
                make.centerX.equalTo(scrollView.mas_centerX);
            }
        }];
        [item layoutIfNeeded];
        if ([item respondsToSelector:@selector(loadDatas:)]) {
            [item performSelector:@selector(loadDatas:) withObject:datas[i]];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        UILabel *label= ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor colorWithHexString:@"#666666"];
            [container addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(item.mas_bottom).offset(5);
                make.right.and.left.equalTo(item);
            }];
            view.numberOfLines = 0;
            view.backgroundColor = [UIColor redColor];
            view.font = [UIFont systemFontOfSize:9];
            view.textAlignment = NSTextAlignmentCenter;
            view.text = datas[i][@"title"];
            view;
        });
#pragma clang diagnostic pop
        lastView = item;
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
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
    NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName([TDFHealthCheckBarChartCell class])];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TDFHealthCheckBarChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }) ;
    [(TDFHealthCheckBarChartCell *)cell cellLoadData:data];
    return [(TDFHealthCheckBarChartCell *)cell calculateHeightForCell];
    
}
- (CGFloat)calculateHeightForCell {
    [self layoutIfNeeded];
    CGFloat height = self.scrollView.frame.origin.y + self.scrollView.frame.size.height+5;
    
    if (self.page >1) {
        height = self.pageControl.frame.origin.y + self.pageControl.frame.size.height+5;
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
