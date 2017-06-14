//
//  TDFWechatAuthorizationListViewController.m
//  RestApp
//
//  Created by happyo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatAuthorizationListViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "DHTTableViewManager.h"
#import "TDFOfficialAccountsListItem.h"
#import "TDFWechatMarketingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFOfficialAccountModel.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFOAAuthIntrouceViewController.h"
#import "UIViewController+HUD.h"

@interface TDFWechatAuthorizationListViewController ()

@property (strong, nonatomic) NSArray *accounts;

@end

@implementation TDFWechatAuthorizationListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configDefaultManager];
    self.title = self.navTitle ?: NSLocalizedString(@"店家公众号授权", nil);
    [self.manager registerCell:@"TDFOfficialAccountsListCell" withItem:@"TDFOfficialAccountsListItem"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchData];
}

- (void)fetchData
{
    [self.manager removeAllSections];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService fetchOfficialAccountsAuthorizationListWithCallback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];
        
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSDictionary *dict = responseObj;
            
            NSArray<TDFOfficialAccountModel *> *authorizationList = [NSArray yy_modelArrayWithClass:[TDFOfficialAccountModel class] json:dict[@"data"]];
            
            self.accounts = authorizationList;
            [self configureSectionsWithAuthorizationList:authorizationList];
            
            if (authorizationList.count < 5 && !self.addButtonHidden) {
                
                [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd];
            }
            [self.manager reloadData];
        }
    }];
}

- (void)configureSectionsWithAuthorizationList:(NSArray<TDFOfficialAccountModel *> *)authorizationList
{
    if (!self.headerHidden) {
        self.tbvBase.tableHeaderView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_official_accounts_authrization_icon"] description:NSLocalizedString(@"以下为您已授权的公众号与对应的品牌，一个品牌可以绑定一个公众号，并且与品牌之下的门店绑定。您可以设置品牌公众号的菜单、推送消息等。", nil)];
    }
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    for (TDFOfficialAccountModel *model in authorizationList) {
        TDFOfficialAccountsListItem *item = [[TDFOfficialAccountsListItem alloc] init];
        item.title = model.name;
        item.imageUrlStr = model.avatarUrl;
        item.detail = [NSString stringWithFormat:NSLocalizedString(@"共计绑定%li家门店", nil), (long)model.storeNum];
        @weakify(self);
        item.selectedBlock = ^ () {
            @strongify(self);
            if (self.selectedBlock) {
                self.selectedBlock(model);
            }
        };
        
        [section addItem:item];
    }
    [self.manager removeAllSections];
    [self.manager addSection:section];
}


- (void)footerAddButtonAction:(UIButton *)sender
{
    
    TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
