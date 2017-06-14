//
//  ShopTemplateListView.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopTemplateListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "INameValueItem.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "ShopTemplateEditView.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "NameValueCell.h"
#import "DataSingleton.h"
#import "RemoteEvent.h"
#import "GridColHead.h"
#import "HelpDialog.h"
#import "UIView+Sizes.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFSettingService.h"
#import "TDFMediator+SettingModule.h"
#import "TDFShopTemplateModel.h"
#import "DHHeadItem.h"
#import "TDFShopTemplateService.h"
#import "YYModel.h"
#import "TDFShopTemplateCell.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+UserAuth.h"

@interface ShopTemplateListView ()

@property (nonatomic, strong) NSMutableArray<TDFShopTemplateModel *> *secondArr;
@end

@implementation ShopTemplateListView

static NSString *reuseId = @"ShopTemplateListView";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mainGrid registerClass:[TDFShopTemplateCell class] forCellReuseIdentifier:reuseId];
    self.needHideOldNavigationBar = YES;
    [self.footView removeFromSuperview];
    if ([[Platform Instance] isChain]) {
        self.title = @"收银单据";
    }else{
        self.title = NSLocalizedString(@"收银单据", nil);
    }
    [self initDelegate:self event:@"shopTemplate" title:NSLocalizedString(@"收银单据", nil) foots:nil];
    [self initHud];
    [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_BILL_TEMPLATE"];
}

- (void) initHud
{
    hud   = [[MBProgressHUD alloc]  initWithView:self.view];
}
#pragma 数据加载
- (void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view  andHUD:hud ];
    [[TDFSettingService new] listShopTemplateSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [hud  hide:YES];
        NSMutableDictionary *dic = data[@"data"];
        NSArray *list = [dic objectForKey:@"shopTemplateVoList"];
        self.datas = [JsonHelper transList:list objName:@"ShopTemplate"];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[TDFShopTemplateModel class] json:dic[@"functionVoList"]];
        [self configWithSecondArr:arr];
        [self.mainGrid reloadData];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)configWithSecondArr:(NSArray *)arr {

    
    self.secondArr = [NSMutableArray arrayWithArray:arr];
    
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        if (self.datas.count > 0 && indexPath.row < self.datas.count) {
//            NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
//            if (!cell) {
//                cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
//            }
//            id<INameValueItem> item = (id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
//            cell.lblName.text = [item obtainItemName];
//            cell.lblVal.text = [item obtainItemValue];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
            
            
            id<INameValueItem> item = (id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
            TDFShopTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblName.text = [item obtainItemName];
            cell.lblVal.text = [item obtainItemValue];
            return cell;
        } else {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
        }
    }else {
        
        if (self.secondArr.count > 0 && indexPath.row < self.secondArr.count) {
            
            TDFShopTemplateModel *model = self.secondArr[indexPath.row];
            
            TDFShopTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblName.text = model.name;
            cell.lblVal.text = model.customized?NSLocalizedString(@"自定义", nil):NSLocalizedString(@"默认", nil);
            return cell;
            
        } else {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
//    if (!headItem) {
//        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
//    }
//    
////    [headItem initColHead:NSLocalizedString(@"单据名称", nil) col2:NSLocalizedString(@"使用中的模板", nil)];
//    if (section==0) {
//        
//        [headItem initColHead:NSLocalizedString(@"小票打印模板", nil) col2:nil];
//        
//    }else if (section==1) {
//    
//        [headItem initColHead:NSLocalizedString(@"标签打印模板", nil) col2:nil];
//    }
//    [headItem initColLeft:15 col2:137];
//    return headItem;
    
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [headItem.panel.layer setMasksToBounds:YES];
    headItem.panel.layer.cornerRadius =5;
//    TreeNode* iteam =self.allNodeList[section];
//    NSString *name =[NSString stringWithFormat:@"%@",[iteam itemName]];
//    headItem.lblName.text =@"asd";
    if (section == 0 ) {
        
        headItem.lblName.text =NSLocalizedString(@"小票打印模板", nil);
        
    }else if (section == 1) {
    
        headItem.lblName.text =NSLocalizedString(@"标签打印模板", nil);
        
    }else {
    
        headItem.lblName.text =NSLocalizedString(@"标签打印模板", nil);
    }
    
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.secondArr.count==0?1:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        
        return [super tableView:tableView numberOfRowsInSection:section];
        
    }else {
    
        return self.secondArr.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }else {
        
        TDFShopTemplateModel *model = self.secondArr[indexPath.row];
    
        __weak typeof(self) weakSelf = self;
        
        [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_TDFSmartOrderControllerWithCode:model.code CallBack:^{
            
            [weakSelf loadDatas];
            
        }] animated:YES];
    }
}

#pragma 代理实现。
//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    ShopTemplate *editObj=(ShopTemplate*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_ShopTemplateEditView:editObj action: ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"shoptemplate"];
}

- (NSMutableArray<TDFShopTemplateModel *> *)secondArr {

    if (!_secondArr) {
        
        _secondArr = [NSMutableArray new];
    }
    return _secondArr;
}
@end

