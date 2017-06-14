//
//  TDFShopReviewScrollView.m
//  RestApp
//
//  Created by xueyu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopReviewScrollView.h"
#import <Masonry/Masonry.h>
#import "TDFShopReviewItem.h"
@interface TDFShopReviewScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end
@implementation TDFShopReviewScrollView

-(void)updateView{
   
    self.scrollView = ({
        UIScrollView *view = [UIScrollView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0,30, 0));
        }];
        view.delegate = self;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view.pagingEnabled = YES;
        view;
    });
    
     self.pageControl = ({
        UIPageControl *view = [UIPageControl new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).offset(-20);
            make.left.equalTo(self.scrollView.mas_left);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.mas_equalTo(@50);
        }];
         view.currentPage = 0;
         view.currentPageIndicatorTintColor = [UIColor redColor];
         view.pageIndicatorTintColor=  [UIColor darkGrayColor];
         view;
     });

 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.pageControl.currentPage =  (scrollView.contentOffset.x+0.5*scrollView.frame.size.width)/ scrollView.frame.size.width;
    
}

#pragma mark data
-(void)loadDatas:(NSArray *)data forawardBlock:(ForawardBlock)block
{
    [self updateView];
     self.pageControl.numberOfPages = data.count;
    UIView *container = [UIView new];
    [self.scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    self.pageControl.hidden = data.count < 2 ?YES:NO;
    
    UIView *lastView = nil;
    for (int i = 0; i < data.count; i++) {
        TDFShopReviewItem *item = [[TDFShopReviewItem alloc]initWithDictionary:data[i]  forawardBlock:block];
        [container addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.scrollView);
            make.top.equalTo(container);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(container.mas_left);
            }
        }];
        lastView = item;
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}



@end
