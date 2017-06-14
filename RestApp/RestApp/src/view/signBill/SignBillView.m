//
//  SeatListView.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridHead.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "RemoteEvent.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "SignBillView.h"
#import "ServiceFactory.h"
#import "SignBillItemCell.h"
#import "SignBillPayTotalVO.h"
#import "TDFSignBillService.h"
#import "SignBillPayNoPayOptionOrKindPayTotalVO.h"
#import "TDFMediator+SignBillModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillView

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
    [self initNavigate];
    [self initMainGrid];
    [self initNotification];
    [self loadSignBillList];
}

#pragma navigateBar
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self.titleBox initWithName:NSLocalizedString(@"挂账处理", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_NONE];
    self.title = NSLocalizedString(@"挂账处理", nil);
    [self configRightNavigationBar:nil rightButtonName:NSLocalizedString(@"已还款", nil)];
}

- (void)initMainGrid
{
    self.mainGrid.opaque = NO;
    
    [self.mainGrid setTableFooterView:[ViewFactory generateFooter:60]];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma 通知相关.
- (void)initNotification
{

}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
    } else if (event==DIRECT_RIGHT) {
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillRecordViewControllerWithCallBack:^{
        [self loadSignBillList];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)loadSignBillList
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSignBillService new] listSignBillListSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary *map= data [@"data"];
//        NSDictionary *signBillPayTotalDic = [map objectForKey:@"signBillKindPays"];
        SignBillPayTotalVO *signBillPayTotalVO = [SignBillPayTotalVO convertToSignBillPayTotalVO:map];
        if (signBillPayTotalVO!=nil) {
            self.lbLlbillCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)signBillPayTotalVO.count];
            self.lbLlbillFee.text = [NSString stringWithFormat:@"%0.2f", signBillPayTotalVO.fee];
            self.dataList = signBillPayTotalVO.noPaylist;
            self.detailMap = [[NSMutableDictionary alloc]init];
            if ([ObjectUtil isNotEmpty:self.dataList]) {
                for (SignBillPayNoPayOptionOrKindPayTotalVO* signBillPayNoPayOptionOrKindPayTotal in self.dataList) {
                    [self.detailMap setObject:signBillPayNoPayOptionOrKindPayTotal.signBillPayNoPayOptionTotalVOList forKey:signBillPayNoPayOptionOrKindPayTotal.kindPayId];
                }
            }
            [self.mainGrid reloadData];
        }
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseResult:result.content];
}

- (void)parseResult:(NSString*)result
{
    NSDictionary *map=[JsonHelper transMap:result];
    NSDictionary *signBillPayTotalDic = [map objectForKey:@"signBillPayTotalVO"];
    SignBillPayTotalVO *signBillPayTotalVO = [SignBillPayTotalVO convertToSignBillPayTotalVO:signBillPayTotalDic];
    if (signBillPayTotalVO!=nil) {
        self.lbLlbillCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)signBillPayTotalVO.count];
        self.lbLlbillFee.text = [NSString stringWithFormat:@"%0.2f", signBillPayTotalVO.fee];
        self.dataList = signBillPayTotalVO.noPaylist;
        self.detailMap = [[NSMutableDictionary alloc]init];
        if ([ObjectUtil isNotEmpty:self.dataList]) {
            for (SignBillPayNoPayOptionOrKindPayTotalVO* signBillPayNoPayOptionOrKindPayTotal in self.dataList) {
                [self.detailMap setObject:signBillPayNoPayOptionOrKindPayTotal.signBillPayNoPayOptionTotalVOList forKey:signBillPayNoPayOptionOrKindPayTotal.kindPayId];
            }
        }
        [self.mainGrid reloadData];
    }
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignBillPayNoPayOptionOrKindPayTotalVO *head = [self.dataList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *list = [self.detailMap objectForKey:head.kindPayId];
        SignBillItemCell *detailItem = [tableView dequeueReusableCellWithIdentifier:SignBillItemCellIndentifier];
        if (detailItem==nil) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"SignBillItemCell" owner:self options:nil].lastObject;
        }
        if ([ObjectUtil isNotEmpty:list]) {
            SignBillPayNoPayOptionTotalVO *data = [list objectAtIndex:indexPath.row];
            [detailItem initWithData:data];
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignBillPayNoPayOptionOrKindPayTotalVO *head = [self.dataList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *list = [self.detailMap objectForKey:head.kindPayId];
        if ([ObjectUtil isNotEmpty:list]) {
            SignBillPayNoPayOptionTotalVO *data = [list objectAtIndex:indexPath.row];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillDetailViewControllerWithData:data andCallBack:^{
                
            }];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SignBillPayNoPayOptionOrKindPayTotalVO *head = [self.dataList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.kindPayId];
        if ([ObjectUtil isNotEmpty:temps]) {
            return temps.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SignBillPayNoPayOptionOrKindPayTotalVO *head = [self.dataList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"reason"];
    [headItem initOperateWithAdd:YES edit:NO];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.dataList]?self.dataList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signBill"];
}


@end
