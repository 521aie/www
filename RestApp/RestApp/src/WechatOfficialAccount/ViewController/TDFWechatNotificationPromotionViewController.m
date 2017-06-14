//
//  TDFWechatNotificationPromotionViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatNotificationPromotionViewController.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFWXNotificationPromotionCell.h"
#import "TDFWechatMarketingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "YYModel.h"
#import "ObjectUtil.h"
#import "TDFWXNotificationModel.h"
#import "TDFWXNotificationEditViewController.h"
#import "HelpDialog.h"
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>

#define  HELP_BTN_WIDTH 34
#define  ADD_BTN_WIDTH 56
#define  BTN_MARGIN 10
#define  HELP_BTN_MARGTN_Y 25

const static NSInteger kTDFWXNotificationPullPageSize = 5;

@interface TDFWechatNotificationPromotionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *nomessageLabel;
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *helpBtn;
/**
 *  页码从 1 开始的
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hasNextPage;

@end


@implementation TDFWechatNotificationPromotionViewController

#pragma mark - Accessor

- (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc] init];   
    }
    return _dataArry;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TDFWXNotificationPromotionCell class] forCellReuseIdentifier:@"TDFWXNotificationPromotionCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
    }
    
    return _tableView;
}

- (UILabel *)nomessageLabel {
    if (!_nomessageLabel){
        _nomessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 260, SCREEN_WIDTH-60, 60)];
        
        _nomessageLabel.text = self.isAuthorization?@"您还没有通过二维火发送任何消息给微信粉丝" : @"当前公众号未授权，无法发送消息";
        _nomessageLabel.font = [UIFont systemFontOfSize:17];
        _nomessageLabel.numberOfLines = 0;
        _nomessageLabel.textAlignment = NSTextAlignmentCenter;
        _nomessageLabel.textColor = [UIColor whiteColor];
    }
    return _nomessageLabel;
}

- (UIButton *)helpBtn {
    if (!_helpBtn){
        _helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTN_MARGIN, SCREEN_HEIGHT - HELP_BTN_MARGTN_Y - HELP_BTN_WIDTH-64, HELP_BTN_WIDTH, HELP_BTN_WIDTH)];
        [_helpBtn setImage:[UIImage imageNamed:@"ico_help"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

- (UIButton *)addBtn {
    if (!_addBtn){
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - BTN_MARGIN-ADD_BTN_WIDTH, SCREEN_HEIGHT - BTN_MARGIN - ADD_BTN_WIDTH-64, ADD_BTN_WIDTH, ADD_BTN_WIDTH)];
        [_addBtn setImage:[UIImage imageNamed:@"ico_footer_button_addd"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定向推送卡/券/促销活动", nil);
    [self configViews];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refresh];
    [MobClick beginLogPageView:@"定向推送卡/券/促销活动"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"定向推送卡/券/促销活动"];
}


#pragma mark - Config View

- (void)configViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof (self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNextPage];
    }];
    
    MJRefreshAutoNormalFooter *footerView = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
    [footerView setTitle:@" " forState:MJRefreshStateNoMoreData];
    [footerView setTitle:@" " forState:MJRefreshStateIdle];
//    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
//    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
    [self.view addSubview:self.helpBtn];
    [self.view addSubview:self.addBtn];
    [self configureHeaderViewWithAuthorizedStatus:self.isAuthorization];
}

- (void)configureHeaderViewWithAuthorizedStatus:(BOOL)isAuthorized {
    UIImage *iconImage = [UIImage imageNamed:@"wxoa_noti_icon"];
    NSString *description = NSLocalizedString(@"您可选择对应的公众号粉丝发送您需要的消息，本消息可根据粉丝特点定向发送，选择对应的标签即可。此类消息每位粉丝每月最多可收到4条。", nil);
    TDFIntroductionHeaderView *headerView;
    if (isAuthorized) {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization"]];
    } else {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]];
    }
    [headerView changeBackAlpha:0.7];
    self.tableView.tableHeaderView = headerView;
    [self.tableView addSubview:self.nomessageLabel];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFWXNotificationPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFWXNotificationPromotionCell" forIndexPath:indexPath];
    TDFWXNotificationModel *model = self.dataArry[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"公众号：%@",model.officialAccountName];
    cell.detailLabel.text = model.text;
    NSString *dateStr = [self dateFormatterWithMilliTimeInterval:model.sendDate];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    NSString *number = [self numDeal:model.targetMemberNumber];
    cell.receiverLabel.text = [NSString stringWithFormat:@"发送对象：#%@#共%@人",model.targetName,number];
    return cell;
}


#pragma mark - Method

- (NSString *)dateFormatterWithMilliTimeInterval:(TDFMilliTimeInterval)sendDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr =[formatter stringFromDate:[NSDate dateWithMilliIntervalSince1970:sendDate]];
    return dateStr;
}

- (NSString *)numDeal:(NSInteger) number {
    if (number>10000) {
        return  [NSString stringWithFormat:@"%.2f万",number/10000.0];
    }
    return [NSString stringWithFormat:@"%zd",number];
}



#pragma mark - Network

- (void)refresh {

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchPromotionListWithOAId:self.officialAccount._id page:1 limitation:kTDFWXNotificationPullPageSize callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        
        NSDictionary *data = [responseObj objectForKey:@"data"];
        self.dataArry = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TDFWXNotificationModel class] json:data[@"notifications"]]];
        [self.tableView reloadData];
        self.currentPage = 1;
        self.hasNextPage = [data[@"hasNextPage"] boolValue];
        if (!self.hasNextPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataArry.count ==0){
            self.nomessageLabel.hidden = NO;
            [self.tableView reloadData];
        }else {
            self.nomessageLabel.hidden = YES;
        }
    }];
}

- (void)loadNextPage {
    
    if (!self.hasNextPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSInteger nextPage = self.currentPage + 1;
    [[TDFWechatMarketingService service] fetchPromotionListWithOAId:self.officialAccount._id page:nextPage limitation:kTDFWXNotificationPullPageSize callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        
        self.currentPage = nextPage;
        NSDictionary *data = [responseObj objectForKey:@"data"];
        [self.dataArry addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TDFWXNotificationModel class] json:data[@"notifications"]]];
        [self.tableView reloadData];
        self.hasNextPage = [data[@"hasNextPage"] boolValue];
        if (self.dataArry.count ==0){
            self.nomessageLabel.hidden = NO;
            [self.tableView reloadData];
        }else {
            self.nomessageLabel.hidden = YES;
        }
    }];
}

#pragma mark Action

- (void)helpBtnClick {
    
    [HelpDialog show:@"wxnotification"];
}

- (void)addBtnClick {
    [MobClick event:@"wechat_message_add"];
    if (_isAuthorization) {
        TDFWXNotificationEditViewController *vc = [[TDFWXNotificationEditViewController alloc] init];
        vc.officialAccount = self.officialAccount;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
          [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前公众号未授权，无法发送消息", nil)  cancelTitle:NSLocalizedString(@"我知道了", nil)];
    }
    
}
@end


