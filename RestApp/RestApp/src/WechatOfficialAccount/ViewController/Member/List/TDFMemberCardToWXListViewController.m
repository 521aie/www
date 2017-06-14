//
//  TDFMemberCardToWXListViewController.m
//  RestApp
//
//  Created by 黄河 on 2017/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "MobClick.h"
#import "TDFMemberCardToWXListViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "TDFButtonFactory.h"
#import "TDFLabelFactory.h"
#import "TDFIntroductionHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIViewController+HUD.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFOAAuthIntrouceViewController.h"
#import "TDFWXBadgeItem.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFWXMemberCardEditViewController.h"
#import "TDFMediator+SupplyChain.h"
#import "GlobalRender.h"
#import "STTweetLabel.h"
#import "TDFWechatMarketingService.h"
#import "TDFWXMemberCardModel.h"
#import "TDFSynchronizeCardInfoModel.h"
#import "TDFOAHelpViewController.h"
#import "HelpDialog.h"
#import "MultiCheckView.h"
#import "TDFOfficialAccountModel.h"
@interface TDFMemberCardToWXListViewController ()
@property (nonatomic, strong) STTweetLabel *promptLabel;
@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) DHTTableViewSection *section;
@property (nonatomic, strong) DHTTableViewSection *noDataSection;
@end

@implementation TDFMemberCardToWXListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViews];
    if (self.isAuthorized) {
        [self getCardInfoService];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
- (void)footerAddButtonAction:(UIButton *)button {
    [MobClick event:@"wechat_card_add"];
    
    if (!self.isAuthorized) {
        [AlertBox show:@"需完成公众号授权后，才能使用此功能"];
        return;
    }
    [self showProgressHudWithText:@"正在加载"];
    [[TDFWechatMarketingService service] getCanSynchronizeCardInfoWithOAId:self.officialAccount._id sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        if (data[@"data"]) {
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[TDFSynchronizeCardInfoModel class] json:data[@"data"]];
            if (dataArray.count == 0) {
                [AlertBox show:@"没有可同步的会员卡"];
                return ;
            }
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:1 delegate:self title:@"选择要同步的卡" dataTemps:[NSMutableArray arrayWithArray:dataArray] selectList:[NSMutableArray array] needHideOldNavigationBar:NO];
            if ([viewController isKindOfClass:[MultiCheckView class]]) {
                MultiCheckView *vc = (MultiCheckView *)viewController;
                vc.maxSelectCount = ^{
                    return 50;
                };
                vc.selectNoneAttentionString = ^{
                    return @"您还没有选中任何会员卡！";
                };
                vc.selectMoreAttentionString = ^{
                    return @"单次最多选择50张会员卡同步，本次将同步前50张会员卡，如需增加请再添加会员卡";
                };
            }
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"synchronizeCard"];
}
#pragma mark --delegate
- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items {
    [self showProgressHudWithText:@"正在保存"];
    NSMutableArray *cardArray = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(TDFSynchronizeCardInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cardArray addObject:obj.cardId];
    }];
    NSString *cardIDs = [cardArray componentsJoinedByString:@","];
    [[TDFWechatMarketingService service] synchronizeCardWithOAId:self.officialAccount._id
                                                      andCardIds:cardIDs
                                                          sucess:^(NSURLSessionDataTask *task, id data) {
                                                              [AlertBox show:@"请确认您已在微信公众号后台添加“卡包组件”，添加后几分钟内即可同步"];
                                                              [self.progressHud setHidden:YES];
                                                              [self getCardInfoService];
                                                          }
                                                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                             [self.progressHud setHidden:YES];
                                                             [AlertBox show:error.localizedDescription];
                                                         }];
}

- (void)closeMultiView:(NSInteger)event {
    
}

#pragma mark -- service 
- (void)getCardInfoService {
    [self showProgressHudWithText:@"正在加载"];
    [[TDFWechatMarketingService service] getCardInfoWithOAId:self.officialAccount._id sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        if (data[@"data"]) {
            [self.manager removeSection:self.noDataSection];
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[TDFWXMemberCardModel class] json:data[@"data"]];
            [self configListViewWithDataArray:dataArray];
            if (dataArray.count == 0) {
                [self.manager addSection:self.noDataSection];
            }
            [self.manager reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark Config Views

- (void)configViews {
    [self configNavigationBar];
    [self configManager];
    [self configContentViews];
    [self configFooterButton];
}

- (void)configFooterButton {
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];
}

- (void)configNavigationBar {
    self.title = @"同步会员卡到微信卡包";
}

- (void)configContentViews {
    [self configTableView];
    [self configHeaderViewWithAuthorizedStatus:self.isAuthorized];
    DHTTableViewSection *headerSection = [DHTTableViewSection section];
    headerSection.headerView = self.headerView;
    headerSection.headerHeight = self.headerView.bounds.size.height;
    [self.manager addSection:headerSection];
    
    DHTTableViewSection *infomationSection = [DHTTableViewSection section];
    infomationSection.headerView = self.infoView;
    infomationSection.headerHeight = self.infoView.bounds.size.height;
    [self.manager addSection:infomationSection];
    
    self.noDataSection = [DHTTableViewSection section];
    UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您还没有在此公众号中同步任何会员卡";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [noDataView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(noDataView);
        make.centerX.equalTo(noDataView);
        
    }];
    self.noDataSection.headerView = noDataView;
    self.noDataSection.headerHeight = 60;
    if (!self.isAuthorized) {
        [self.manager addSection:self.noDataSection];
    }
}

- (void)configListViewWithDataArray:(NSArray *)dataArray {
    [self.manager removeSection:self.section];
    self.section = [DHTTableViewSection section];
    for (TDFWXMemberCardModel *cardModel in dataArray) {
        TDFWXBadgeItem *item = [[TDFWXBadgeItem alloc] init];
        __weak typeof(item) wItem = item;
        [self configItem:wItem withModel:cardModel];
        wItem.selectedBlock = ^{
//            if ([item.statusBadgeName isEqualToString:@"未同步"]) {
//                [AlertBox show:@"您尚未同步此卡到微信卡包，无法设置。"];
//            }
            TDFWXMemberCardEditViewController *controller = [[TDFWXMemberCardEditViewController alloc] init];
            cardModel.wxId = self.officialAccount._id;
            controller.cardModel = cardModel;
            controller.callBack = ^(TDFWXMemberCardModel *backCardModel) {
                if (cardModel.status == 0 && backCardModel.status != 0) {
                    [AlertBox show:@"请确认您已在微信公众号后台添加“卡包组件”，添加后几分钟内即可同步"];
                }
                [self getCardInfoService];
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.section addItem:wItem];
    }
    if (dataArray.count > 0) {
        self.section.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        self.section.footerHeight = 80;
    }
    [self.manager addSection:self.section];
}

- (void)configItem:(TDFWXBadgeItem *)item
         withModel:(TDFWXMemberCardModel *)cardModel {
    item.title = cardModel.name;
    item.status = cardModel.status;
    NSMutableArray *statusArray = [NSMutableArray array];
    if (cardModel.followStatus) {
        [statusArray addObject:@"关注发卡"];
    }
    if (cardModel.payStatus) {
        [statusArray addObject:@"支付发卡"];
    }
    
    if (cardModel.activeStatus) {
        [statusArray addObject:@"开卡发券"];
    }
    
    item.badgeNames = statusArray;
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)configManager {
    [self.manager registerCell:@"TDFWXBadgeCell" withItem:@"TDFWXBadgeItem"];
}

- (void)configHeaderViewWithAuthorizedStatus:(BOOL)isAuthorized {
    UIImage *iconImage = [UIImage imageNamed:@"wxoa_member_card"];
    NSString *description = NSLocalizedString(@"您可将二维火发行的会员卡，同步到微信公众号中，顾客在关注您的公众号或者在您店里使用微信支付后可收到领卡提醒，领卡后可在微信卡包展示。此功能是使用微信营销功能的基础，如您需要在朋友圈投放广告发券或使用微信卡包功能等均可在同步后实现", nil);
    if (isAuthorized) {
        self.headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization"]];
    } else {
        self.headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage
                                                       description:description
                                                         badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]
                                                       detailTitle:NSLocalizedString(@"立即去授权", nil)
                                                       detailBlock:^{
                                                           [self forwardAuthorizationVC];
                                                       }];
    }
    
    CGFloat infomationHeight = 0;
    infomationHeight = isAuthorized ? 50 : 44;
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, infomationHeight)];
    self.infoView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    if (isAuthorized) {
        [self.infoView addSubview:self.promptLabel];
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.infoView);
            make.left.equalTo(self.infoView).offset(10);
            make.right.equalTo(self.infoView).offset(-10);
        }];
        
    }else {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = RGBA(204, 0, 0, 1);
        lbl.text = NSLocalizedString(@"需完成公众号授权后，才能使用此功能", nil);
        
        [self.infoView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.infoView);
            make.height.equalTo(@20);
            make.leading.equalTo(self.infoView);
            make.trailing.equalTo(self.infoView);
        }];
    }
    
    UIView *spliteView = [[UIView alloc] initWithFrame:CGRectZero];
    spliteView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    
    [self.infoView addSubview:spliteView];
    [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@(0));
        make.height.equalTo(@1);
    }];

    
    
}

- (void)configHeaderViewInfoLabelWithAuthorizedStatus:(BOOL)isAuthorized {
    
}

#pragma mark Network


#pragma mark Action

- (void)forwardAuthorizationVC
{
    TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
    vc.authPopDepthAddition = 2;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark setter && getter
- (DHTTableViewManager *)manager {
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _tableView;
}

- (STTweetLabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
        NSString *text = NSLocalizedString(@"注：卡券同步功能仅限认证服务号可用，请确认您的公众号已认证，并且在公众号后台申请添加卡包组件，卡券即可正常同步。", nil);
        NSString *hotword = NSLocalizedString(@"查看详细教程 〉", nil);
        _promptLabel.hotwordRegex = hotword;
        _promptLabel.numberOfLines = 2;
        [_promptLabel setText:[NSString stringWithFormat:@"%@%@", text, hotword]];
        [_promptLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:0xCC0000],
                                      NSFontAttributeName: [UIFont systemFontOfSize:11]
                                      }];
        [_promptLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:0x0088CC],
                                      NSFontAttributeName: [UIFont systemFontOfSize:11]
                                      }
                            hotWord:STTweetLink];
        _promptLabel.textSelectable = NO;
        @weakify(self);
        [_promptLabel setDetectionBlock:^(STTweetHotWord hotword, NSString *text, NSString *protocol, NSRange range) {
            @strongify(self);
            TDFOAHelpViewController *controller = [[TDFOAHelpViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }
    return _promptLabel;
}


@end
