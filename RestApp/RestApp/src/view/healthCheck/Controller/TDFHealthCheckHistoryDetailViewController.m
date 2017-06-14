//
//  TDFHealthCheckHistoryDetailViewController.m
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryDetailViewController.h"
#import "TDFHealthCheckHistoryDetailAPI.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFHealthCheckNavigationView.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFHealthCheckHistoryDetailItem.h"
#import "TDFFoodSelectHeaderView.h"
#import "UIColor+Hex.h"

@interface TDFHealthCheckHistoryDetailViewController ()

@property (nonatomic, strong) TDFAlertAPIHUDPresenter *hudPresenter;

@property (nonatomic, strong) TDFHealthCheckHistoryDetailAPI *detailApi;

@property (nonatomic, strong) TDFHealthCheckNavigationView *navigateView;

@property (nonatomic, strong) UIView *headerView;

@end
@implementation TDFHealthCheckHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configDefaultManager];
    
    [self.manager registerCell:@"TDFHealthCheckHistoryDetailCell" withItem:@"TDFHealthCheckHistoryDetailItem"];
    
    [self configureView];
    
    [self fetchData];
}

- (void)configureView
{
    [self.view addSubview:self.navigateView];
    [self.navigateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom);
        make.height.equalTo(@34);
    }];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = self.dateString;
    
    [self.headerView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).with.offset(10);
        make.centerY.equalTo(self.headerView);
        make.height.equalTo(@13);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    scoreLabel.font = [UIFont systemFontOfSize:13];
    scoreLabel.textColor = [UIColor whiteColor];
    NSAttributedString *attributeScore = [[NSAttributedString alloc] initWithString:[self.score stringByAppendingString:@"分"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHeX:0xCC0000]}];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"得分："];
    [attributeString appendAttributedString:attributeScore];
    scoreLabel.attributedText = attributeString;
    
    [self.headerView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headerView).with.offset(-10);
        make.height.equalTo(@13);
        make.centerY.equalTo(self.headerView);
    }];
    
    UIView *spliteView = [[UIView alloc] initWithFrame:CGRectZero];
    spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    [self.headerView addSubview:spliteView];
    [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).with.offset(10);
        make.trailing.equalTo(self.headerView).with.offset(-10);
        make.bottom.equalTo(self.headerView);
        make.height.equalTo(@1);
    }];
    
    [self.tbvBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)fetchData
{
    self.detailApi.resultId = self.resultId;
    
    @weakify(self);
    [self.detailApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        NSArray *dataList = response[@"data"];
        
        for (NSDictionary *dict in dataList) {
            NSNumber *levelCodeNum = dict[@"levelCode"];
            NSString *levelName = dict[@"levelName"];
            NSString *extraStr = dict[@"extraStr"];
            
            NSInteger levelCode = [levelCodeNum integerValue];

            DHTTableViewSection *section = [DHTTableViewSection section];
            
            TDFFoodSelectHeaderView *headerView = [[TDFFoodSelectHeaderView alloc] initWithTitle:[levelName stringByAppendingString:extraStr]];
            section.headerView = headerView;
            section.headerHeight = [TDFFoodSelectHeaderView heightForView];
            
            if (levelCode == 0) {
                [headerView updateTitleColor:[UIColor colorWithHeX:0x07AD1F]];
            } else if (levelCode == 1) {
                [headerView updateTitleColor:[UIColor colorWithHeX:0xFF8800]];
            } else if (levelCode == 2) {
                [headerView updateTitleColor:[UIColor colorWithHeX:0xCC0000]];
            }
            
            NSArray *itemList = dict[@"healthItems"];
            for (NSDictionary *itemDict in itemList) {
                TDFHealthCheckHistoryDetailItem *item = [[TDFHealthCheckHistoryDetailItem alloc] init];
                item.iconUrl = itemDict[@"iconUrl"];
                item.title = itemDict[@"itemName"];
                item.levelType = levelCode;
                item.levelDesc = itemDict[@"status"];
                item.value = itemDict[@"itemValue"];
                
                [section addItem:item];
            }
            
            [self.manager addSection:section];
        }
        
        [self.manager reloadData];
    }];
    
    [self.detailApi start];
}

#pragma mark -- Getters && Setters --

- (TDFAlertAPIHUDPresenter *)hudPresenter
{
    if (!_hudPresenter) {
        _hudPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _hudPresenter;
}

- (TDFHealthCheckHistoryDetailAPI *)detailApi
{
    if (!_detailApi) {
        _detailApi = [[TDFHealthCheckHistoryDetailAPI alloc] init];
        _detailApi.presenter = self.hudPresenter;
    }
    
    return _detailApi;
}

- (TDFHealthCheckNavigationView *)navigateView
{
    if (!_navigateView) {
        _navigateView = [[TDFHealthCheckNavigationView alloc] initWithFrame:CGRectZero];
        [_navigateView updateTitle:@"报告详情"];
        @weakify(self);
        _navigateView.backBlock = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    
    return _navigateView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _headerView;
}

@end
