 //
//  TDFXinhuoLoanViewController.m
//  RestApp
//
//  Created by zishu on 16/8/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFXinhuoLoanViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFMediator+LoanModule.h"
#import "DHTTableViewManager.h"
#import "TDFDisplayCommonItem.h"
#import "DHTTableViewSection.h"
#import "TDFSettingService.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "LoanCompanyVO.h"
#import "YYModel.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "MobClick.h"
#define NOLOAN 0 //无贷款
#define APPLY 1  //申请
#define REFUSELOAN  3 //驳回
#define ENDLOAN 5  //结束

@interface TDFXinhuoLoanViewController()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TDFXinhuoLoanViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我要贷款", nil);
    [self configDefaultManager];
    [self registerCells];
    [self getLoanCompanyList];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
    @weakify(self);
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"ico_loan"] description:NSLocalizedString(@"如果您在经营过程中需要资金贷款，可以在此处选择机构进行贷款。 \n此处所列贷款机构均为独立且有资格为小微企业提供贷款服务的机构，在此处进行贷款申请后，对方会进行下一步的线下服务。", nil) detailBlock:^{
        @strongify(self);
        [self showHelpEvent];
    }];
}

- (void)registerCells
{
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
}

- (void)addSections
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    for (LoanCompanyVO * loanCompany in self.dataArray) {
        TDFDisplayCommonItem *callVoiceItem = [[TDFDisplayCommonItem alloc] init];
        callVoiceItem.iconImage = [UIImage imageNamed:@"logo_05 3x"];
        callVoiceItem.title = loanCompany.name;
        callVoiceItem.detail = [NSString stringWithFormat:NSLocalizedString(@"预授信额度：%@", nil),loanCompany.preAmount];
        @weakify(self);
        callVoiceItem.clickedBlock = ^ () {
            @strongify(self);
            [MobClick event:@"click_loan_xinhuo"];//点击"鑫火纯信用餐饮云贷"
            [self forwardCallVoiceVC:loanCompany];
        };
        
        [section addItem:callVoiceItem];
    }
    [self.manager addSection:section];
    [self.manager reloadData];
}

- (void)forwardCallVoiceVC:(LoanCompanyVO *)loanCompany
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    if ([ObjectUtil isNotEmpty:self.dataArray]) {
        if (loanCompany.loanStatus.intValue == NOLOAN || loanCompany.loanStatus.intValue == REFUSELOAN || loanCompany.loanStatus.intValue == ENDLOAN || loanCompany.loanStatus.intValue == APPLY) {
            if ([NSString isBlank:loanCompany.name]) {
                loanCompany.name = NSLocalizedString(@"鑫火纯信用餐饮云贷", nil);
            }
            UIViewController *noteViewController = [mediator TDFMediator_loanNoteViewControllerWithLoanCompanyId:loanCompany.id loanCompanyName:loanCompany.name h5Url:loanCompany.url];
            [self.navigationController pushViewController:noteViewController animated:YES];
        }else{
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *webViewController = [mediator TDFMediator_loanWebViewControllerWithH5Url:loanCompany.url];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

- (NSMutableArray *) dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void) getLoanCompanyList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [self.dataArray removeAllObjects];
     NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    
     @weakify(self);
    [[TDFSettingService new] getLoanCompanyListWithParam:parma sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSArray *dataArray = [data objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            LoanCompanyVO *loanCompany = [LoanCompanyVO yy_modelWithDictionary:dic];
            [self.dataArray addObject:loanCompany];
        }
        [self addSections];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
        [self.manager reloadData];
    }];
}

- (void) footerHelpButtonAction:(UIButton *)sender
{
    [self showHelpEvent];
}

- (void) showHelpEvent
{
    [HelpDialog show:@"loanCompanyListHelp"];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
    [MobClick event:@"click_loan_list_back"];//点击左上角返回
}
@end
