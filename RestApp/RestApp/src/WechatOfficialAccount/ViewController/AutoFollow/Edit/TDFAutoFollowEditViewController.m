//
//  TDFAutoFollowEditViewController.m
//  RestApp
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAutoFollowEditViewController.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "BackgroundHelper.h"
#import "TDFImageSelectView.h"
#import <Masonry/Masonry.h>
#import "UIViewController+HUD.h"
#import "TDFForm.h"
#import "Platform.h"
#import "DicSysItem.h"
#import "TDFAutoFollowModel.h"
#import "TDFOptionPickerController.h"
#import "UIColor+Hex.h"
#import "TDFWechatMarketingService.h"
#import <YYModel/YYModel.h>
#import "TDFEditViewHelper.h"
#import "TDFEditViewHelper.h"
#import "TDFAuditStatusViewController.h"
#import "NSDate+TDFMilliInterval.h"
#import "TDFWXPayTraderModel.h"
#import "TDFMarketingStore.h"
#import "DicSysItem+Extension.h"

@interface TDFAutoFollowEditViewController ()

/**
 *  类型
 */
@property (strong, nonatomic) TDFShowPickerStrategy *typeStrategy;
@property (strong, nonatomic) TDFPickerItem *typeItem;
/**
 *  微信公众号
 */
@property (strong, nonatomic) TDFShowPickerStrategy *accountStrategy;
@property (strong, nonatomic) TDFPickerItem *accountItem;
/**
 *  其他公众号
 */
@property (strong, nonatomic) TDFTextfieldItem *accountFieldItem;
/**
 *  已经绑定的微信公众号
 */
@property (copy, nonatomic) NSArray *accounts;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) DHTTableViewManager *manager;

@end

@implementation TDFAutoFollowEditViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"支付后关注公众号", nil);
    [self configViews];
    [self fetchAuthedAccounts];
}


#pragma mark - Methods

- (void)configViews {
    
    [self updateNavigationBar];
    [self configBackground];
    [self configContentViews];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
}

- (void)configContentViews {
    
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark Update Views

- (void)updateNavigationBar {
    
    if (![self contentChanged]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
        [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        return;
    }
    
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationClose];
    [button addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationSave];
    [button addTarget:self action:@selector(commitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (BOOL)contentChanged {
    
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (TDFOfficialAccountModel *)officialAccountWithId:(NSString *)oaId {

    for (TDFOfficialAccountModel *model in self.accounts) {
        
        if ([model._id isEqualToString:oaId]) {
            
            return model;
        }
    }
    return nil;
}

#pragma mark Network

- (void)fetchAuthedAccounts {
    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFWechatMarketingService alloc] init] fetchAuthedOfficialAccountsWithCallback:^(id responseObj, NSError *error) {
       @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        self.accounts = [NSArray yy_modelArrayWithClass:[TDFOfficialAccountModel class] json:[responseObj objectForKey:@"data"]];
        
        self.accountStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.accounts];
        if (self.model.officialAccount.name.length == 0 || self.model.type == TDFOfficialAccountAuthTypeCustom) {
            TDFOfficialAccountModel *model = self.accounts.firstObject;
            self.accountItem.textValue = model.name;
            self.accountItem.requestValue = model._id;
        }
        
        for (TDFOfficialAccountModel *model in self.accounts) {
            
            if ([model._id isEqualToString:self.model._id]) {
                
                self.accountStrategy.selectedItem = model;
                break;
            }
        }
        
        [self.manager reloadData];
    }];
}


#pragma mark Action

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)commitButtonTapped {

    NSString *msg = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.manager.sections withIgnoredCharator:@" "];
    if (msg) {
        [self showErrorMessage:msg];
        return;
    }
    
    TDFAutoFollowModel *model = [[TDFAutoFollowModel alloc] init];
    model.type = [self.typeItem.requestValue integerValue];
    if (model.type == TDFOfficialAccountAuthTypeAuthed) {
    
        model.officialAccount = [self officialAccountWithId:self.accountItem.requestValue];
    } else {
    
        TDFOfficialAccountModel *account = [[TDFOfficialAccountModel alloc] init];
        account._id = @"";
        account.name = self.accountFieldItem.textValue;
        model.officialAccount = account;
    }

    @weakify(self);
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFWechatMarketingService service] saveAutoFollowInfoWithTraderId:self.traderId jsonString:[model yy_modelToJSONString] callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
        
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        [self showAuditVCWithModel:model];
    }];
}

- (void)showAuditVCWithModel:(TDFAutoFollowModel *)model {

    TDFTraderAuditModel *auditModel = [[TDFTraderAuditModel alloc] init];
    auditModel.title = NSLocalizedString(@"您的申请审核中", nil);
    auditModel.detail = NSLocalizedString(@"您的申请资料已成功提交，微信官方会在5个工作日内审核，请耐心等待。", nil);
    auditModel.applyTime = [[NSDate date] milliInterval];
    auditModel.status = TDFWXPayTraderAuditStatusAuditing;
    
    @weakify(self);
    TDFAuditStatusViewController *vc  = [TDFAuditStatusViewController statusViewWithAsync:TDFAsync.unit(auditModel) title:self.title viewProfileBlock:^{
        @strongify(self);
        TDFAutoFollowEditViewController *editVC = [[TDFAutoFollowEditViewController alloc] init];
        editVC.readOnly = YES;
        editVC.traderId = self.traderId;
        editVC.model = model;
        [self.navigationController pushViewController:editVC animated:YES];
    }];
    vc.popDepth = 3;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Accessor

- (NSArray *)typeItems {

    return @[
             [DicSysItem itemWithId:@"0" name:NSLocalizedString(@"已授权的公众号", nil)],
             [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"其他公众号", nil)]
             ];
}

- (TDFShowPickerStrategy *)typeStrategy {
    
    if (!_typeStrategy) {
        
        _typeStrategy = [[TDFShowPickerStrategy alloc] init];
        _typeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.typeItems];
        _typeStrategy.selectedItem = self.typeItems[ self.model.type ];
        _typeStrategy.pickerName = NSLocalizedString(@"公众号类型", nil);
    }
    return _typeStrategy;
}

- (TDFPickerItem *)typeItem {
    
    if (!_typeItem) {
        
        _typeItem = [TDFPickerItem item];
        DicSysItem *item = self.typeItems[ self.model.type ];
        if ([TDFMarketingStore sharedInstance].marketingModel.wxoaAuthCount == 0) {
            item = [self.typeItems lastObject];
        }
        _typeItem.editStyle = self.readOnly ? TDFEditStyleUnEditable : TDFEditStyleEditable;
        @weakify(self);
        _typeItem.tdf_title(NSLocalizedString(@"公众号类型", nil))
        .tdf_requestKey(@"type")
        .tdf_preValue(item.name)
        .tdf_requestValue(item._id)
        .tdf_isRequired(YES)
        .tdf_textValue(item.name)
        .tdf_strategy([TDFMarketingStore sharedInstance].marketingModel.wxoaAuthCount == 0 || self.readOnly ? nil : self.typeStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if ([requestValue integerValue] == TDFOfficialAccountAuthTypeAuthed) {
                
                self.accountItem.tdf_shouldShow(YES).tdf_isRequired(YES);
                self.accountFieldItem.tdf_shouldShow(NO).tdf_isRequired(NO);
            } else {
                self.accountItem.tdf_shouldShow(NO).tdf_isRequired(NO);
                self.accountFieldItem.tdf_shouldShow(YES).tdf_isRequired(YES);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self.manager reloadData];
                [self updateNavigationBar];
            });
            return YES;
        });
    }
    return _typeItem;
}

- (TDFShowPickerStrategy *)accountStrategy {
    
    if (!_accountStrategy) {
        
        _accountStrategy = [[TDFShowPickerStrategy alloc] init];
        _accountStrategy.pickerName = NSLocalizedString(@"微信号", nil);
        if (self.model.type == TDFOfficialAccountAuthTypeAuthed) {
            _accountStrategy.selectedItem = self.model.officialAccount;
        }
    }
    return _accountStrategy;
}

- (TDFPickerItem *)accountItem {
    
    if (!_accountItem) {
        
        _accountItem = [TDFPickerItem item];
        BOOL flag = self.model.type == TDFOfficialAccountAuthTypeAuthed && [TDFMarketingStore sharedInstance].marketingModel.wxoaAuthCount != 0;
        @weakify(self);
        _accountItem.tdf_title(NSLocalizedString(@"微信号", nil))
        .tdf_requestKey(@"officialAccount")
        .tdf_strategy([self isChain] ? self.accountStrategy : nil)
        .tdf_isRequired(flag)
        .tdf_shouldShow(flag)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateNavigationBar];
            });
            return YES;
        });
        
        _accountItem.editStyle = [self isChain] && !self.readOnly ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        
        if (self.model.type == TDFOfficialAccountAuthTypeAuthed) {
            _accountItem.tdf_preValue(self.model.officialAccount.name)
            .tdf_textValue(self.model.officialAccount.name)
            .tdf_requestValue(self.model.officialAccount._id);
        }
    }
    return _accountItem;
}

- (TDFTextfieldItem *)accountFieldItem {
    
    if (!_accountFieldItem) {
        
        _accountFieldItem = [TDFTextfieldItem item];
        BOOL flag = self.model.type == TDFOfficialAccountAuthTypeAuthed && [TDFMarketingStore sharedInstance].marketingModel.wxoaAuthCount != 0;
        @weakify(self);
        _accountFieldItem.tdf_title(NSLocalizedString(@"微信号", nil))
        .tdf_requestKey(@"officialAccount")
        .tdf_isRequired(!flag)
        .tdf_shouldShow(!flag)
        .tdf_filterBlock(^BOOL(NSString *text) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateNavigationBar];
            });
            return YES;
        });
        
        _accountFieldItem.editStyle = self.readOnly ? TDFEditStyleUnEditable : TDFEditStyleEditable;
        
        if (self.model.type != TDFOfficialAccountAuthTypeAuthed) {
            _accountFieldItem.tdf_preValue(self.model.officialAccount.name)
            .tdf_requestValue(self.model.officialAccount.name)
            .tdf_textValue(self.model.officialAccount.name);
        }
    }
    
    return _accountFieldItem;
}

- (DHTTableViewManager *)manager {
    
    if (!_manager) {
        
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
        [_manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
        DHTTableViewSection *section = [DHTTableViewSection section];
        [section addItem:self.typeItem];
        [section addItem:self.accountItem];
        [section addItem:self.accountFieldItem];
        [_manager addSection:section];
    }
    return _manager;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = self.footerView;
    }
    
    return _tableView;
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        CGFloat width = SCREEN_WIDTH;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UILabel *promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeComment];
        promptLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        promptLabel.numberOfLines = 0;
        promptLabel.frame = CGRectMake(10,15, width - 20, 0);
        promptLabel.text = @"注：请进入微信服务号后台-基本配置-复制您的 appid 到此处,添加的公众号认证主体需与特约商户号经营主体一致，且需为通过微信认证的服务号。";

        [promptLabel sizeToFit];
        [_footerView addSubview:promptLabel];
        
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        [button setTitle:NSLocalizedString(@"提交申请", nil) forState:UIControlStateNormal];
        button.hidden = self.readOnly;
        [button addTarget:self action:@selector(commitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        CGFloat y = promptLabel.frame.origin.y + promptLabel.frame.size.height + 20;
        button.frame = CGRectMake(10, y, width - 20, 40);
        [_footerView addSubview:button];
    }
    return _footerView;    
} 

- (BOOL)isChain {

    return [Platform Instance].isChain;
}

@end
