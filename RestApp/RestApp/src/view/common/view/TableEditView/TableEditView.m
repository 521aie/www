//
//  TableEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "UIView+Sizes.h"
#import "TableEditView.h"
#import "MBProgressHUD.h"
#import "NavigateTitle.h"
#import "DataSingleton.h"
#import "ObjectUtil.h"
#import "NavigateTitle2.h"
#import "NameValueCell44.h"

@implementation TableEditView

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
    [self initGrid];
    [self initHead];
    [self createData];
}
- (void)createData
{
    if ([ObjectUtil  isNotEmpty: self.dic]) {
        id  data  = self.dic [@"data"];
        NSString *actionStr  =  self.dic [@"action"];
        id delegate  = self.dic [@"delegate"];
        NSString *event  = self.dic [@"event"];
        NSString *title  = self.dic [@"title"];
        id error = self.dic [@"error"] ;
        [self  initDelegate:delegate event:event action:actionStr.intValue title:title];
        [self reload:data error:error];
    }

    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];

}

#pragma mark TitleBox deal
-(void) initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}


-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
            [self.delegate closeListEvent:self.event];
            return;
        } else if(self.action==ACTION_CONSTANTS_SORT){
            [self.delegate closeListEvent:self.event];
        }
      } else {
        if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
            [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要全部删除吗？", nil)];
            return;
        }
        NSMutableArray* ids=[self getIds];
        if ([ids count]==0) {
             [self.delegate closeListEvent:self.event];
        }
        [self.delegate sortEvent:self.event ids:ids];
    }
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
        [self.delegate closeListEvent:self.event];
        [self.navigationController popViewControllerAnimated: YES];
        return;
    } else if(self.action==ACTION_CONSTANTS_SORT){
        [self.delegate closeListEvent:self.event];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    if (self.action==ACTION_CONSTANTS_DEL) {  //删除完成
        [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要全部删除吗？", nil)];
        return;
    }
    NSMutableArray* ids=[self getIds];
    if ([ids count]==0) {
        [self.delegate closeListEvent:self.event];
    }
    [self.delegate sortEvent:self.event ids:ids];
    [self.navigationController popViewControllerAnimated:YES];
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
        NSMutableArray* ids=[self getIds];
        if ([ids count]==0) {
            [self finishAction];
        }
        [self.delegate batchDelEvent:self.event ids:ids];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) finishAction
{
    [self.mainGrid reloadData];
}

#pragma  interface event
- (void)initDelegate:(id<ISampleListEvent>)delegateTemp event:(NSString*)eventTemp action:(int)actionFlag title:(NSString*)titleName
{
    self.delegate=delegateTemp;
    self.event=eventTemp;
    self.action=actionFlag;
    self.titleBox.lblTitle.text=titleName;
    self.title = titleName;
    self.datas=nil;
    [self.mainGrid reloadData];
    [self.mainGrid setEditing:NO animated:NO];
}

- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error
{
    self.datas=_dataTemps;
    if (self.action==ACTION_CONSTANTS_DEL) {
        [self showDelEvent];
    } else {
        [self showSortEvent];
    }
}

#pragma mark table deal
-(void)initGrid
{
    self.mainGrid.opaque=NO;
    UIView *view=[[UIView alloc] init];
    [view setHeight:60];
    view.backgroundColor=[UIColor clearColor];
    self.mainGrid.separatorColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.mainGrid setTableFooterView:view];
}
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 1 :self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell44 * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCell44Identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell44" owner:self options:nil].lastObject;
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
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    return NSLocalizedString(@" 删除 ", nil);
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
    NSMutableArray* ids=[NSMutableArray array];
    [ids addObject:item.obtainItemId];
    
    [self.delegate delEvent:self.event ids:ids];
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

- (void) showDelEvent
{
    self.action=ACTION_CONSTANTS_DEL;
    [self.titleBox btnVisibal:YES direct:DIRECT_RIGHT];
    [self.titleBox.btnUser setTitle:NSLocalizedString(@"全部删除", nil) forState:UIControlStateNormal];
    [self.titleBox navVisibal:NO direct:DIRECT_RIGHT];
    [self beginEditGrid];
}

- (void) showSortEvent
{
    self.action=ACTION_CONSTANTS_SORT;
    [self.titleBox.btnUser setTitle:@"" forState:UIControlStateNormal];
    [self.titleBox btnVisibal:YES direct:DIRECT_RIGHT];
    [self.titleBox loadImg:Head_ICON_OK direct:DIRECT_RIGHT];
    [self.titleBox.btnBack setTitle:@"" forState:UIControlStateNormal];
    [self beginEditGrid];
}

-(void)beginEditGrid
{
    [self.mainGrid setEditing:YES animated:YES];
    self.backDatas=[self.datas mutableCopy];
    [self.mainGrid reloadData];
}

@end
