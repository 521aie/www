//
//  MenuAreaPrinterListView.m
//  点菜单分区域打印
//
//  Created by xueyu on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "GridColHead.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "NameValueCell.h"
#import "TDFTransService.h"
#import "MenuAreaPrinterEditView.h"
#import "MenuAreaPrinterListView.h"
#import "TDFMediator+TransModule.h"
#import "TDFRootViewController+FooterButton.h"
@interface MenuAreaPrinterListView ()

@end

@implementation MenuAreaPrinterListView
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].transService;
        self.datas = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainGrid];
    [self loadDatas];
}
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"点菜单分区域打印", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"点菜单分区域打印", nil);
    
}
- (void)initMainGrid
{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.opaque = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *menuSalesRankCell= [UINib nibWithNibName:NSStringFromClass([NameValueCell class]) bundle:nil];
    [self.tableView registerNib:menuSalesRankCell forCellReuseIdentifier:NameValueCellIdentifier];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];

}
- (void)footerAddButtonAction:(UIButton *)sender {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_menuAreaPrinterEditViewControllerWithData:nil andAction:ACTION_CONSTANTS_ADD isContinue:NO callBack:^{
        [self loadDatas];
    }];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
   [HelpDialog show:@"areatransplan"];
}

-(void)loadDatas{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFTransService new] getAreaPrinterListSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
       
        NSArray *list = [data objectForKey:@"data"];
        [self.datas removeAllObjects];
        self.datas = [JsonHelper transList:list objName:@"AreaPantry"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) loadFinish:(RemoteResult*)result{
    
    [self.progressHud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSArray *list = [map objectForKey:@"data"];
    [self.datas removeAllObjects];
     self.datas = [JsonHelper transList:list objName:@"AreaPantry"];
    [self.tableView reloadData];
  }


#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ObjectUtil isNotEmpty:self.datas]?self.datas.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
    cell.lblName.text= [item obtainItemName];
    cell.lblVal.text=[item obtainItemValue];
    cell.lblVal.hidden=tableView.editing;
    cell.img.hidden=tableView.editing;
    [cell initSubViewsWithLeft:13 right:SCREEN_WIDTH-170];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.tableView dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"桌位区域", nil) col2:NSLocalizedString(@"打印机IP地址", nil)];
    [headItem initColLeft:20 col2:125];
    return headItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaPantry *areaPantry = self.datas[indexPath.row];
    
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_menuAreaPrinterEditViewControllerWithData:areaPantry andAction:ACTION_CONSTANTS_EDIT isContinue:NO callBack:^{
        [self loadDatas];
    }];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:viewController animated:YES];
    
    
}
@end
