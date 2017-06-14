//
//  BaseNameValueListView.m
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseNameValueListView.h"
#import "NavigateTitle2.h"
#import "ISampleListEvent.h"
#import "DataSingleton.h"
#import "NameValueCell.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "FooterListView.h"
#import "ViewFactory.h"

@implementation BaseNameValueListView

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
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initGrid];
    [self initHead];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.mainGrid.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT-64;
    self.mainGrid.frame = frame;
}

#pragma mark TitleBox deal
-(void) initHead
{    
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
            [self finishEditGrid];
            return;
        } else if (self.action==ACTION_CONSTANTS_SORT){
            self.datas=[self.backDatas mutableCopy];
            [self finishEditGrid];
        } else {
            [self.delegate closeListEvent:self.event];
        }
        
    } else {
        if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
            
            [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要全部删除吗？", nil)];
            return;
        }
        [UIHelper showHUD:NSLocalizedString(@"正在提交", nil) andView:self.view andHUD:hud];
        NSMutableArray* ids=[self getIds];
        if ([ids count]==0) {
            [self hideHud];
            [self finishEditGrid];
        }
        [self.delegate sortEvent:self.event ids:ids];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
        [self finishEditGrid];
        return;
    } else if (self.action==ACTION_CONSTANTS_SORT){
        self.datas=[self.backDatas mutableCopy];
        [self finishEditGrid];
    } else {
        [self.delegate closeListEvent:self.event];
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
        
        [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要全部删除吗？", nil)];
        return;
    }
    [UIHelper showHUD:NSLocalizedString(@"正在提交", nil) andView:self.view andHUD:hud];
    NSMutableArray* ids=[self getIds];
    if ([ids count]==0) {
        [self hideHud];
        [self finishEditGrid];
    }
    [self.delegate sortEvent:self.event ids:ids];

}


-(NSMutableArray*) getIds
{
    NSMutableArray* ids=[NSMutableArray array];
    if (self.datas && [self.datas count]>0) {    //排序的处理.
        for (id<INameValueItem> item in self.datas) {
            [ids addObject:item.obtainItemId];
        }
    }
    return ids;
}
//全部删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [UIHelper showHUD:NSLocalizedString(@"正在提交", nil) andView:self.view andHUD:hud];
        NSMutableArray* ids=[self getIds];
        if ([ids count]==0) {
            [self hideHud];
            [self finishEditGrid];
        }
        [self.delegate batchDelEvent:self.event ids:ids];
    }
}

-(void) finishSort
{
    [self hideHud];
    [self finishEditGrid];
}

-(void) finishEditGrid
{
    [self.mainGrid setEditing:NO animated:NO];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
    [self.titleBox btnVisibal:YES direct:DIRECT_LEFT];
    self.titleBox.imgBack.hidden=NO;
    [self.titleBox.btnBack setTitle:nil forState:UIControlStateNormal];
    self.footView.hidden=NO;
    [self.titleBox loadImg:Head_ICON_BACK direct:DIRECT_LEFT];
    [self.mainGrid reloadData];
    self.action=ACTION_CONSTANTS_VIEW;
}

#pragma  interface event
- (void)initDelegate:(id<ISampleListEvent>) _delegateTemp event:(NSString*) _eventTemp title:(NSString*) titleName foots:(NSArray*) arr
{
    self.delegate=_delegateTemp;
    self.event=_eventTemp;
    self.titleBox.lblTitle.text=titleName;
    
    self.datas=nil;
    [self.mainGrid reloadData];
    
    
    [self.footView initDelegate:self btnArrs:arr];
    [self.mainGrid setEditing:NO animated:NO];
    self.footView.hidden=NO;
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
}

- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error
{
    self.datas=_dataTemps;
    [self.mainGrid reloadData];
    [hud hide:YES];
}

-(void) hideHud
{
    [hud hide:YES];
}

#pragma mark table deal
-(void)initGrid
{
    self.mainGrid.opaque=NO;
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    [self.mainGrid setTableFooterView:view];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:76];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 1 :self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count) {
        [self.mainGrid reloadData];
    } else {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: row];
        [self.delegate showEditNVItemEvent:self.event withObj:item];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
    NSMutableArray* ids=[NSMutableArray array];
    [ids addObject:item.obtainItemId];
    [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
    [self.delegate delEvent:self.event ids:ids];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    return NSLocalizedString(@" 删除 ", nil);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.action==ACTION_CONSTANTS_DEL) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.action==ACTION_CONSTANTS_DEL) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id object=[self.datas objectAtIndex:sourceIndexPath.row];
    [self.datas removeObjectAtIndex:sourceIndexPath.row];
    [self.datas insertObject:object atIndex:destinationIndexPath.row];
}

-(void)beginEditGrid
{
    [self.mainGrid setEditing:YES animated:YES];
    [self.titleBox btnVisibal:YES direct:DIRECT_RIGHT];
    self.footView.hidden=YES;
    self.backDatas=[self.datas mutableCopy];
    [self.mainGrid reloadData];
}
@end

