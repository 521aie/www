//
//  TDFTransPlateViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController+FooterButton.h"
#import "TDFTransPlateViewController.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFMediator+BrandModule.h"
#import "TDFTransPlateListAPI.h"
#import "NameValueCell44.h"
#import "TDFEmptyView.h"
#import "TDFMediator.h"
#import "ViewFactory.h"
#import "ColorHelper.h"

@interface TDFTransPlateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) TDFAlertAPIHUDPresenter *HUDPresenter;
@property (strong, nonatomic) TDFTransPlateListAPI *plateListApi;
@property (strong, nonatomic) UITableView *brandTab;
@property (strong,nonatomic) TDFEmptyView *emptyView;
@property (strong, nonatomic) NSMutableArray *plateList;

@end

@implementation TDFTransPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"品牌", nil);
    
    [self.view addSubview:self.brandTab];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - NetWork
- (void)loadData {

    @weakify(self);
    NSMutableDictionary*param = [[NSMutableDictionary alloc]init];
    param[@"type"] = [NSString stringWithFormat:@"%ld",(long)self.transType];
    self.plateListApi.params = param;
    [self.plateListApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response){
        @strongify(self);
        self.plateList = (NSMutableArray *)response;
        if(self.plateList.count <= 0) {
            self.emptyView.hidden = NO;
            self.brandTab.hidden = YES;
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd];
        }else {
            self.emptyView.hidden = YES;
            self.brandTab.hidden = NO;
            [self.brandTab reloadData];
        }
    }];
    
    [self.plateListApi start];
}

#pragma mark UITableView Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.plateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell44 * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCell44Identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell44" owner:self options:nil].lastObject;
    }
    TDFOldPlateModel *model  = self.plateList[indexPath.row];
    cell.lblName.text= model.plateName;
    cell.settingValue.text = model.isSetted?@"":@"未设置";
    cell.settingValue.textColor = [ColorHelper getRedColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *switchU = [Platform Instance].allFunctionSwitchDictionary[self.actionCode];
    TDFOldPlateModel *model  = self.plateList[indexPath.row];

    if (switchU[@"mediatorMethod"]) {
        SEL action = NSSelectorFromString(switchU[@"mediatorMethod"]);
        @weakify(self);
        if ([[TDFMediator sharedInstance] respondsToSelector:action]) {
            @strongify(self);
            UIViewController *viewController = [[TDFMediator sharedInstance] performSelector:action withObject:model.plateEntityId];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark FootBtnClick
- (void) footerAddButtonAction:(UIButton *)sender
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_addBrandViewControllerWithAddBrandCallBack:^(BOOL orFresh) {
        @strongify(self);
        [self loadData];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SET-----GET
- (UITableView *)brandTab
{
    if (!_brandTab) {
        _brandTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _brandTab.backgroundColor = [UIColor clearColor];
        _brandTab.delegate = self;
        _brandTab.dataSource = self;
        _brandTab.opaque=NO;
        _brandTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView* view=[ViewFactory generateFooter:76];
        view.backgroundColor=[UIColor clearColor];
        [_brandTab setTableFooterView:view];
    }
    return _brandTab;
}

- (TDFTransPlateListAPI *)plateListApi {
    if (!_plateListApi) {
        _plateListApi = [[TDFTransPlateListAPI alloc] init];
        _plateListApi.presenter = self.HUDPresenter;
    }
    
    return _plateListApi;
}

- (TDFAlertAPIHUDPresenter *)HUDPresenter {
    if (!_HUDPresenter) {
        _HUDPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _HUDPresenter;
}

- (TDFEmptyView *)emptyView {
    if(!_emptyView) {
        _emptyView = [TDFEmptyView emptyViewWithContent:@"您还未添加过任何品牌,\n请先添加一个吧!"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
