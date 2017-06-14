//
//  MultiCheckManageView.m
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiCheckManageView.h"
#import "MenuModuleEvent.h"
#import "INameValueItem.h"
#import "MultiCheckCell.h"
#import "ViewFactory.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "INameItem.h"

@implementation MultiCheckManageView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGrid];
    [self initHead];
    [self createData];
}

#pragma mark TitleBox deal
- (void)initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}
     
- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        id delegate  =  self.dic [@"delegate"];
        NSDictionary *constdic  =  self.dic [@"constDic"];
        if ([ObjectUtil isNotEmpty:constdic]) {
            NSString *eventStr  = constdic [@"event"];
            NSString *managerName = constdic [@"managerName"];
            NSString *title  = constdic [@"title"] ;
            [self initDelegate:delegate event:eventStr.intValue title:title managerName:managerName];
           
        }
        id headListMap = self.dic [@"headListTemp"];
        id selectLIst  = self.dic [@"selectList"];
        [self loadData:headListMap selectList:selectLIst];

    
    }
}
     

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_RIGHT) {
        NSMutableArray* newList=[NSMutableArray array];
        if ([ObjectUtil isNotNull:self.selectList] && [ObjectUtil isNotEmpty:self.dataList]) {
            for (id<INameValueItem> item in self.dataList) {
                if ([self.selectList containsObject:[item obtainItemId]]) {
                    [newList addObject:item];
                }
            }
        }
        [self.delegate multiCheck:self.event items:newList];
    } else {
        [self.delegate closeMultiView:self.event];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
    [self.delegate closeMultiView:self.event ];
   
}

- (void)rightNavigationButtonAction:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
    NSMutableArray* newList=[NSMutableArray array];
    if ([ObjectUtil isNotNull:self.selectList] && [ObjectUtil isNotEmpty:self.dataList]) {
        for (id<INameValueItem> item in self.dataList) {
            if ([self.selectList containsObject:[item obtainItemId]]) {
                [newList addObject:item];
            }
        }
    }
    [self.delegate multiCheck:self.event items:newList];
}

#pragma  interface event
- (void)initDelegate:(id<IMultiManagerEvent>)delegate event:(int)event title:(NSString*)titleName managerName:(NSString*)managerName
{
    self.delegate=delegate;
    self.event=event;
    self.titleBox.lblTitle.text=titleName;
    self.title = titleName;
    [self.footView initDelegate:self managerName:managerName];
    self.datas=nil;
    [self.mainGrid reloadData];
}

- (void)loadData:(NSMutableArray *)dataListTemp selectList:(NSMutableArray *) selectList
{
    self.dataList=[dataListTemp mutableCopy];
    self.selectList=selectList;
    [self.mainGrid reloadData];
}

- (void)reLoadData:(NSMutableArray*) dataList
{
    self.dataList=[dataList mutableCopy];
    [self.mainGrid reloadData];
}

#pragma mark checkall notcheckall
-(void) checkAllEvent
{
    if (self.dataList && [self.dataList count]>0) {
        for (id<INameValueItem> item in self.dataList) {
            [self.selectList addObject:[item obtainItemId]];
        }
    }
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    [self.selectList removeAllObjects];
    [self.mainGrid reloadData];
}

-(void) managerEvent
{
    [self.delegate managerEvent:self.event];
}

-(void) showHelpEvent
{
    if (self.event==MENU_SPEC) {
        [HelpDialog show:@"basemenuspec"];
    } else if (self.event==MENU_MAKE) {
        [HelpDialog show:@"basemenucook"];
    }
}

#pragma mark table deal

-(void)initGrid
{
    self.mainGrid.opaque=NO;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    [self.mainGrid setTableFooterView:view];
    //如果想删除cell之间的分割线，设置
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainGrid registerClass:[MultiCheckCell class] forCellReuseIdentifier:MultiCheckCellIdentifier];
}

#pragma mark UITableView
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultiCheckCell * cell = [tableView dequeueReusableCellWithIdentifier:MultiCheckCellIdentifier];

    if (self.dataList.count > 0 && indexPath.row < self.dataList.count) {
        id<INameValueItem> item=[self.dataList objectAtIndex:indexPath.row];
        cell.lblName.text=[item obtainItemName];
        cell.lblVal.textAlignment = NSTextAlignmentRight;
        cell.lblVal.text=[item obtainItemValue];
        cell.imgCheck.hidden=![self.selectList containsObject:[item obtainItemId]];
        cell.imgUnCheck.hidden=[self.selectList containsObject:[item obtainItemId]];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.dataList.count == 0 ? 0 :self.dataList.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item=(id<INameValueItem>)[self.dataList objectAtIndex: indexPath.row];
    if (item) {
        if ([self.selectList containsObject:[item obtainItemId]]) {
            [self.selectList removeObject:[item obtainItemId]];
        } else {
            [self.selectList addObject:[item obtainItemId]];
        }
       [self.mainGrid reloadData];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}
@end
