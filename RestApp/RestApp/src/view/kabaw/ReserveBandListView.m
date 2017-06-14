//
//  ReserveBandListView.m
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+KabawModule.h"
#import "ReserveBandListView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "ReserveBandEditView.h"
#import "ReserveSeat.h"
#import "UIHelper.h"
#import "HelpDialog.h"
#import "DataSingleton.h"
#import "NameValueCell.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ReserveBandListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"reserveband" title:@"" foots:nil];
    self.title = NSLocalizedString(@"不接受预订日期", nil);
    self.datas = self.params[@"data"];
    [self loadBandDatas:self.datas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

#pragma 数据加载
-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [service listReserveBand:REMOTE_RESERVEBAND_LIST];
    [[ServiceFactory Instance].kabawService listReserveBandTarget:self Callback:@selector(loadFinish:)];
}

-(void)loadBandDatas:(NSMutableArray*)datas
{
    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveBandEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeReserveBands:ids event:REMOTE_RESERVEBAND_DEL];
     [[ServiceFactory Instance].kabawService removeReserveBands:ids Target:self Callback:@selector(delFinish:)];
}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    //    [service removeReserveBands:ids event:REMOTE_RESERVEBAND_DELALL];
    [[ServiceFactory Instance].kabawService removeReserveBands:ids Target:self Callback:@selector(delBatchFinish:)];
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    ReserveBand* editObj=(ReserveBand*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveBandEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
  
}

-(void) loadFinish:(RemoteResult*) result{
    
[self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) delBatchFinish:(RemoteResult*) result{
    
  [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    
    [self remoteLoadData:result.content];
    [self finishSort];
}

-(void) delFinish:(RemoteResult*) result{

    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [self.progressHud hide:YES];
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"reserveBands"];
    self.datas=[JsonHelper transList:list objName:@"ReserveBand"];
    [self reload:self.datas error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_RESERVEBAND_REFRESH object:self.datas] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
        }
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        [cell.lblName setWidth:220];
        cell.lblVal.hidden=tableView.editing;
        cell.img.hidden=tableView.editing;
        cell.lblVal.text=[item obtainItemValue];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
        self.mainGrid.editing=NO;
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:@"" andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

@end
