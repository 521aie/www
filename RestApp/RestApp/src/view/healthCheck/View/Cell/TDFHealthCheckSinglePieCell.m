//
//  TDFHealthCheckSinglePieCell.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/19.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckSinglePieCell.h"
#import "TDFChartFanDiagram.h"
#import "TDFHealthTitleView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "ObjectUtil.h"
@interface TDFHealthCheckSinglePieCell()<UIScrollViewDelegate>
@property (nonatomic, strong) TDFHealthTitleView *titleView;
@property (nonatomic, strong) TDFChartFanDiagram *pieView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CGFloat height;
//@property (nonatomic, strong) UILabel *itemTitle;
//@property (nonatomic, strong) UIView *listView;

@end
@implementation TDFHealthCheckSinglePieCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configView];
    }
    return self;
}
-(void)configView{
    
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
            make.top.equalTo(self.titleView.mas_bottom).offset(19);
            make.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_offset(@85);
        }];
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        view.clipsToBounds = YES;
        view.pagingEnabled = YES;
        view;
    });
    [self.contentView addSubview:self.pageControl];
    [self.pageControl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(@37);
    }];
}

-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    [self.titleView initTitle:data.title detail:data.desc];
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview ];
    }
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (NSString *str in data.details) {
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
        [datas addObject:dict];
    }
   
//    NSArray *datas = [NSJSONSerialization JSONObjectWithData:[data.details dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
 
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
            make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        }];
        self.pageControl.hidden = NO;
        self.scrollView.scrollEnabled = YES;
    }
    [self scrollViewWillLoadDatas:self.scrollView datas:datas maxNumber:1 item:@"TDFChartFanDiagram"];
    
}

-(void)scrollViewWillLoadDatas:(UIScrollView *)scrollView datas:(NSArray *)datas  maxNumber:(NSInteger)maxNum item:(NSString *)clsString {
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
        UIView *item = [self healthCheckPieView:datas[i]];
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
        lastView = item;
    }
    if (self.height > 85) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(@(self.height));
        }];
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}
/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data{
    static UITableViewCell *cell = nil;
    NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName([TDFHealthCheckSinglePieCell class])];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TDFHealthCheckSinglePieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }) ;
    [(TDFHealthCheckSinglePieCell *)cell cellLoadData:data];
    return [(TDFHealthCheckSinglePieCell *)cell calculateHeightForCell];
}
- (CGFloat)calculateHeightForCell {
    [self layoutIfNeeded];
    CGFloat height= self.pageControl.frame.origin.y + self.pageControl.frame.size.height;
    return height+10;
}


#pragma mark creat item

-(UIView *)annotationlistView:(NSArray *)datas{
    UIView *listView = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *lastView = nil;
    for (NSInteger i = 0; i < datas.count; i++) {
        UIView *item = [self annotationItem:datas[i]];
        [listView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(listView);
            make.size.mas_equalTo(CGSizeMake(6, 9));
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(6);
            }else{
                make.top.equalTo(listView.mas_top);
            }
        }];
        lastView = item;
    }
    return listView;
}
-(UIView *)healthCheckPieView:(id)dict
{
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectZero];
    NSArray *charts = dict[@"charts"];
    if ([ObjectUtil isEmpty:dict] || [ObjectUtil isEmpty:charts]) {
        return pageView;
    }
    NSInteger count = [charts count];
    UIView *listView  = ({
        UIView *view = [self annotationlistView:charts];
        [pageView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pageView.mas_left).offset(19);
            make.top.equalTo(pageView.mas_top).offset(8);
            make.height.mas_equalTo(@(count*9+(count-1)*6));
            make.width.mas_equalTo(@80);
        }];
        view;
    });
    self.height = count*9+(count-1)*6;
    NSArray *valus = [charts valueForKeyPath:@"value"];
    NSArray *colors = [charts valueForKeyPath:@"color"];
    NSDictionary *pieDict = @{@"colors":colors,@"valus":valus};
    TDFChartFanDiagram *pieView = ({
        TDFChartFanDiagram *view = [TDFChartFanDiagram new];
        [pageView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView.mas_top).offset(4);
            make.size.mas_equalTo(CGSizeMake(54, 54));
            make.centerX.equalTo(pageView.mas_centerX);
        }];
        view.colorArray = colors;
        view.dataArray = valus;
        view;
    });
    UILabel *titleView  = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor colorWithHexString:@"#666666"];
        [pageView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pieView.mas_bottom).offset(5);
            make.centerX.equalTo(pieView.mas_centerX);
            make.width.mas_offset(@112);
        }];
        view.text = dict[@"subscript"];
        view.font = [UIFont systemFontOfSize:9];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    return pageView;
}


-(UIView *)annotationItem:(id)dict
{
    UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *icon = [[UIView alloc]init];
    [item addSubview:icon];
    icon.backgroundColor =  [UIColor colorWithHexString:dict[@"color"]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6,8));
        make.left.and.top.equalTo(item);
    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = dict[@"subscript"];
    title.textColor = [UIColor colorWithHexString:@"#666666"];
    title.font = [UIFont systemFontOfSize:9];
    [item addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(item);
        make.left.equalTo(icon.mas_right).offset(4);
        make.width.mas_equalTo(@80);
    }];
    return item;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor=  [UIColor darkGrayColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidden = YES;
    }
    return _pageControl;
}

@end
