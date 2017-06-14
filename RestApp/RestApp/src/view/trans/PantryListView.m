//
//  PantryListView.m
//  传菜方案
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+TransModule.h"
#import "PantryListView.h"
#import "DataSingleton.h"
#import "INameValueItem.h"
#import "GridColHead.h"
#import "RemoteResult.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "UIView+Sizes.h"
#import "NameValueCell44.h"
#import "PantryEditView.h"
#import "NoPrintMenuListView.h"
#import "Gift.h"
#import "GridFooter.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "TDFTransService.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFPantryManageModel.h"
#import "ColorHelper.h"
#import "TDFMediator+UserAuth.h"
@interface PantryListView()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) TDFPantryManageModel *model;
@end

@implementation PantryListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [self initDelegate:self event:@"pantry" title:NSLocalizedString(@"传菜方案", nil) foots:nil];
    self.footView.hidden = YES;
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"传菜方案", nil);
    [self loadDatas];
     [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_PRODUCE_PLAN"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

-(void) initHead{
    [super initHead];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
}

#pragma 数据加载
-(void)loadDatas{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([Platform Instance].isChain) {
        param[@"plate_entity_id"] = self.plateEntityId;
    }
    @weakify(self);
    [[TDFTransService new] pantryListWithParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         @strongify(self);
         [self.progressHud hideAnimated:YES];
        self.model = [TDFPantryManageModel yy_modelWithJSON:data[@"data"]];
        if (self.model.addible) {
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];
        }else{
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
        }
        self.datas  = self.model.pantryList;
        self.mainGrid.tableHeaderView = self.model.addible?[[UIView alloc] init]:self.headView;
        [self.mainGrid reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
       [AlertBox show:error.localizedDescription];
    }];
}

#pragma 实现协议 ISampleListEvent

- (void)footerAddButtonAction:(UIButton *)sender {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_pantryEditViewControllerWithData:nil plateEntityId:self.plateEntityId chainDataManageable:YES action:ACTION_CONSTANTS_ADD andIsContinue:NO callBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"transplan"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj{
    Pantry* editObj=(Pantry*)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_pantryEditViewControllerWithData:editObj plateEntityId:self.plateEntityId chainDataManageable:self.model.chainDataManageable action:ACTION_CONSTANTS_EDIT andIsContinue:NO callBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell44 * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCell44Identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell44" owner:self options:nil].lastObject;
        }
        Pantry *item = [self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= item.name;
        cell.lblVal.text = item.printerIp?item.printerIp:@"";
        cell.isChain.hidden = !item.isChain;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        self.mainGrid.editing=NO;
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas!=nil) {
        [self showEditNVItemEvent:@"Pantry" withObj:[self.datas objectAtIndex: indexPath.row]];
    }
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"传菜方案名称", nil) col2:NSLocalizedString(@"IP地址", nil)];
    [headItem initColLeft:20 col2:90];
     headItem.view.layer.cornerRadius = 11;
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark SET---GET
-(UIView *) headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 31)];
        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _headView.tag = 100;
        [self.view addSubview:_headView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 31)];
        label.text = @"注：本店的传菜方案由总部管理，暂无法添加，如需添加，请联系总部。";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [ColorHelper getRedColor];
        label.numberOfLines = 0;
        [_headView addSubview:label];
        return _headView;
    }
    return _headView;
}
@end
