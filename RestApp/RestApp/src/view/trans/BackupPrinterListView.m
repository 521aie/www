//
//  BackupPrinter.m
//  RestApp
//  备用打印机
//  Created by SHAOJIANQING-MAC on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "DataSingleton.h"
#import "ServiceFactory.h"
#import "TransService.h"
#import "INameValueItem.h"
#import "GridColHead.h"
#import "RemoteResult.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "UIView+Sizes.h"
#import "BackupPrinterCell.h"
#import "PantryEditView.h"
#import "NoPrintMenuListView.h"
#import "Gift.h"
#import "GridFooter.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "BackupPrinterListView.h"
#import "BackupPrinterEditView.h"
#import "BackupPrinter.h"
#import "TDFMediator+TransModule.h"
#import "TDFTransService.h"
#import "TDFRootViewController+FooterButton.h"

@implementation BackupPrinterListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].transService;
        [self loadDatas];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    [self initDelegate:self event:@"backupprinter" title:NSLocalizedString(@"备用打印机", nil) foots:nil];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd|TDFFooterButtonTypeHelp];
    self.title = NSLocalizedString(@"备用打印机", nil);
}

-(void) initHead
{
    [super initHead];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
}

#pragma 数据加载
-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

     [[TDFTransService new] listBackupPrinter:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
          [self.progressHud hide:YES];
         NSArray *list = data [@"data"];
         self.datas=[JsonHelper transList:list objName:@"BackupPrinter"];
         [self.mainGrid reloadData];
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hide: YES];
         [AlertBox show:error.localizedDescription];
     }];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_backupPrinterEditViewControllerWithData:nil andAction:ACTION_CONSTANTS_ADD callBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeBackupPrinters:ids event:REMOTE_BACKUPPRINTER_DELONE];
  

}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
//    [service removeBackupPrinters:ids event:REMOTE_BACKUPPRINTER_DELALL];
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"transaltprinter"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    BackupPrinter* editObj=(BackupPrinter *)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_backupPrinterEditViewControllerWithData:editObj andAction:ACTION_CONSTANTS_EDIT callBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
   
}



#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        BackupPrinterCell * cell = [tableView dequeueReusableCellWithIdentifier:BackupPrinterCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BackupPrinterCell" owner:self options:nil].lastObject;
        }
        BackupPrinter* item=(BackupPrinter *)[self.datas objectAtIndex: indexPath.row];
        cell.lblFormalPrinterIP.text= [item originIp];
        cell.lblReplacePrinterIP.text=[item backupIp];
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
        [self showEditNVItemEvent:@"BackupPrinter" withObj:[self.datas objectAtIndex: indexPath.row]];
    }
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"原打印机IP", nil) col2:NSLocalizedString(@"备用打印机IP", nil)];
    [headItem initColLeft:20 col2:100];
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

@end
