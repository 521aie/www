//
//  TDFHealthCheckHistoryViewController.m
//  RestApp
//
//  Created by happyo on 2017/5/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFHealthCheckHistoryItem.h"
#import "TDFHealthCheckHistoryPageAPI.h"
#import <TDFPagingDataLoader/TDFPagingDataLoader.h>
#import "TDFHealthCheckNavigationView.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFHealthCheckHistoryDetailViewController.h"

@interface TDFHealthCheckHistoryViewController () <TDFPagingDataLoaderReformer>

@property (nonatomic, strong) TDFAlertAPIHUDPresenter *hudPresenter;

@property (nonatomic, strong) TDFHealthCheckNavigationView *navigateView;

@property (nonatomic, strong) TDFHealthCheckHistoryPageAPI *historyPageApi;

@property (nonatomic, strong) TDFTableViewPagingDataLoader *pageLoader;

@end
@implementation TDFHealthCheckHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configDefaultManager];
    [self.manager registerCell:@"TDFHealthCheckHistoryCell" withItem:@"TDFHealthCheckHistoryItem"];
    
    [self.view addSubview:self.navigateView];
    [self.navigateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.tbvBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).with.offset(10);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self fetchData];
}

- (void)fetchData
{
    [self.pageLoader start];
}

#pragma mark -- TDFPagingDataLoaderReformer --

- (NSArray *)reformDataWithNewItems:(NSArray *)items
{
    NSMutableArray *reformedItems = [NSMutableArray array];
    for (NSDictionary *item in items) {
        TDFHealthCheckHistoryItem *tItem = [TDFHealthCheckHistoryItem item];
        NSString *title = [NSString stringWithFormat:@"%@\n%@ %@", item[@"date"], item[@"dayOfWeek"], item[@"time"]];
        tItem.title = title;
        NSNumber *differType = item[@"diffFlag"];
        tItem.differType = [differType integerValue];
        tItem.score = [NSString stringWithFormat:@"%@", item[@"score"]];
        tItem.differScore = [NSString stringWithFormat:@"%@", item[@"diffScore"]];
        
        NSString *resultId = item[@"resultId"];

        @weakify(self);
        tItem.selectedBlock = ^{
            @strongify(self);
            TDFHealthCheckHistoryDetailViewController *vc = [[TDFHealthCheckHistoryDetailViewController alloc] init];
            vc.resultId = resultId;
            vc.dateString = [NSString stringWithFormat:@"%@%@ %@", item[@"date"], item[@"dayOfWeek"], item[@"time"]];
            vc.score = [NSString stringWithFormat:@"%@", item[@"score"]];
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        [reformedItems addObject:tItem];
    }
    return reformedItems;
}

#pragma mark -- Getters && Setters --

- (TDFAlertAPIHUDPresenter *)hudPresenter
{
    if (!_hudPresenter) {
        _hudPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _hudPresenter;
}

- (TDFHealthCheckNavigationView *)navigateView
{
    if (!_navigateView) {
        _navigateView = [[TDFHealthCheckNavigationView alloc] initWithFrame:CGRectZero];
        [_navigateView updateTitle:@"历史记录"];
        @weakify(self);
        _navigateView.backBlock = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    
    return _navigateView;
}

- (TDFHealthCheckHistoryPageAPI *)historyPageApi
{
    if (!_historyPageApi) {
        _historyPageApi = [[TDFHealthCheckHistoryPageAPI alloc] init];
        _historyPageApi.presenter = self.hudPresenter;
    }
    
    return _historyPageApi;
}

- (TDFTableViewPagingDataLoader *)pageLoader
{
    if (!_pageLoader) {
        _pageLoader = [[TDFTableViewPagingDataLoader alloc] initWithTableViewManager:self.manager];
        _pageLoader.reformer = self;
        _pageLoader.fetcher = self.historyPageApi;
    }
    
    return _pageLoader;
}


@end
