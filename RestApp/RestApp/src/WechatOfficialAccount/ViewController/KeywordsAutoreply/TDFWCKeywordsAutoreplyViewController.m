//
//  TDFWCKeywordsAutoreplyViewController.m
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFAPIKit/TDFAPIKit.h>
#import <TDFPagingDataLoader/TDFPagingDataLoader.h>
#import <TDFBatchOperation/TDFBatchOperation.h>
#import <TDFAPIHUDPresenter/TDFAPIHUDPresenter.h>
#import <TDFCategories/TDFCategories.h>

#import "DHTTableViewManager+Register.h"

#import "HelpDialog.h"
#import "TDFWXOfficialAccountActionPath.h"
#import "TDFWXKeywordsRuleModel.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFWXKeywordsAutoreplyItem.h"

#import "TDFWCKeywordsAutoreplyViewController.h"
#import "TDFWXKeywordsRuleSettingViewController.h"

#import "TDFOfficialAccountModel.h"

@interface TDFWCKeywordsAutoreplyViewController () <TDFPagingDataLoaderReformer, TDFPagingDataLoaderInterceptor>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TDFGeneralPageAPI *getReplyListAPI;
@property (strong, nonatomic) TDFTableViewPagingDataLoader *loader;
@property (assign, nonatomic) BOOL authorised;
@property (strong, nonatomic) NSString *wxAppId;
@property (strong, nonatomic) UILabel *nomessageLabel;
@end

@implementation TDFWCKeywordsAutoreplyViewController
#pragma mark - life cycle

- (instancetype)initWithAuthorised:(BOOL)authorised wxAppId:(NSString *)wxAppId {
    if (self = [super init]) {
        self.authorised = authorised;
        self.wxAppId = wxAppId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置关键词自动回复";
    
    [self configureSubviews];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    
    if (self.authorised) {
        [self.loader start];
    }
    
    self.nomessageLabel.hidden = self.authorised;
}

#pragma mark - override
- (void)footerAddButtonAction:(UIButton *)sender {
    [super footerAddButtonAction:sender];
    
    if (!self.authorised) {
        [self showAlert:@"当前公众号未授权，无法设置关键词回复" confirm:nil];
        return;
    }
    
    TDFWXKeywordsRuleSettingViewController *viewController = [[TDFWXKeywordsRuleSettingViewController alloc] initWithModifiedHandler:^{
        [self.loader start];
    } wxAppId:self.wxAppId];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"KeywordsAutoreply"];
}


#pragma mark - TDFPagingDataLoaderInterceptor
- (void)afterHeaderRefreshWithReformedItems:(NSArray *)items {
    self.nomessageLabel.hidden = items.count;
}

#pragma mark - TDFPagingDataLoaderReformer
- (NSArray *)reformDataWithNewItems:(NSArray *)items {
    return [items tdf_map:^id(TDFWXKeywordsRuleModel *value) {
        TDFWXKeywordsAutoreplyItem *item = [[TDFWXKeywordsAutoreplyItem alloc] initWithRule:value];
        
        @weakify(self)
        item.selectedBlock = ^{
            @strongify(self)
            TDFWXKeywordsRuleSettingViewController *viewController = [[TDFWXKeywordsRuleSettingViewController alloc] initWithRule:value modifiedHandler:^{
                [self.loader start];
            } wxAppId:self.wxAppId];
            [self.navigationController pushViewController:viewController animated:YES];
        };
        
        return item;
    }];
}

#pragma mark - configure
- (void)configureSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configureHeaderView];
    
    [self.tableView addSubview:self.nomessageLabel];
    [self.nomessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView).offset(30);
        make.width.equalTo(self.tableView).offset(-60);
        make.top.equalTo(@260);
        make.height.equalTo(@60);
    }];
}

- (void)configureHeaderView {
    TDFIntroductionHeaderView *headerView;
    headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wx_set_keywords_replay"]
                                                   description:@"关键词回复可设置多个规则，不会占用公众号的发送额度。此功能所有的公众号都可以用。关键词回复可以发券/卡/文字消息。此功能可以用来与顾客互动，帮助店家更好的与顾客交流。"
                                                     badgeIcon:[UIImage imageNamed:self.authorised ? @"wxoa_wechat_notification_authorization" : @"wxoa_wechat_notification_unauthorization"]];
    [headerView changeBackAlpha:0.7];
    
    UIView *containerView = [[UIView alloc] initWithFrame:headerView.frame];
    [containerView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.bottom.equalTo(containerView).offset(-5);
    }];
    
    self.tableView.tableHeaderView = containerView;
}

#pragma mark - getter
- (UILabel *)nomessageLabel {
    if (!_nomessageLabel){
        _nomessageLabel = [[UILabel alloc] init];
        _nomessageLabel.text = self.authorised ? @"您还没有任何关键词回复设置" : @"当前公众号未授权，无法设置关键词回复";
        _nomessageLabel.font = [UIFont systemFontOfSize:17];
        _nomessageLabel.numberOfLines = 0;
        _nomessageLabel.textAlignment = NSTextAlignmentCenter;
        _nomessageLabel.textColor = [UIColor whiteColor];
    }
    return _nomessageLabel;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }
    
    return _tableView;
}

- (TDFTableViewPagingDataLoader *)loader {
    if (!_loader) {
        _loader = [[TDFTableViewPagingDataLoader alloc] initWithTableView:self.tableView];
        _loader.fetcher = self.getReplyListAPI;
        _loader.reformer = self;
        _loader.interceptor = self;
        [_loader.manager registerItems:@[S(TDFWXKeywordsAutoreplyItem)]];
    }
    
    return _loader;
}

- (TDFGeneralPageAPI *)getReplyListAPI {
    if (!_getReplyListAPI) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXQueryKeywordsRuleList];
        requestModel.apiVersion = kTDFAPWXQueryKeywordsRuleListVersion;
        _getReplyListAPI= [[TDFGeneralPageAPI alloc] init];
        _getReplyListAPI.requestModel = requestModel;
        _getReplyListAPI.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
        _getReplyListAPI.apiResponseReformBlock = ^id(__kindof TDFBaseAPI *api, id response) {
            return [NSArray yy_modelArrayWithClass:[TDFWXKeywordsRuleModel class] json:response[@"data"]];
        };
        _getReplyListAPI.currentPageSizeBlock = ^NSInteger(id response) {
            return [response[@"data"] count];
        };
        @weakify(self)
        _getReplyListAPI.apiRequestWillBeSentBlock = ^(TDFGeneralPageAPI *api) {
            @strongify(self)
            api.params[kTDFAPWXDeleteKeywordsRuleWXAppIdKey] = self.wxAppId;
        };
    }
    
    return _getReplyListAPI;
}

@end
