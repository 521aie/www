//
//  SampleMenuView.m
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleMenuView.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "ISampleMenuHandle.h"
#import "DataSingleton.h"
#import "SampleMenuCell.h"
#import "UIHelper.h"
#import "ViewFactory.h"
#import "HelpDialog.h"

@implementation SampleMenuView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGrid];
    [self initHead];
    //表格数据加载.
    [self reload];
}

#pragma mark TitleBox deal
-(void) initHead
{
    [self.titleBox initDelegate:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.footerListView initDelegate:self btnArrs:nil];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [self.delegate backView];
    }
}

-(void)initGrid{
    //表格初始.
//    [self.mainGrid setBackgroundView:nil];
    self.mainGrid.opaque=NO;
    //如果想删除cell之间的分割线，设置
   self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    [self.mainGrid setTableFooterView:view];
//    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.mainGrid.separatorColor = [UIColor lightGrayColor];
}

- (void)initDelegate:(id<ISampleMenuHandle>) _delegateTemp event:(NSString*) _eventTemp title:(NSString*) titleName
{
    self.delegate=_delegateTemp;
    self.event=_eventTemp;
    self.titleBox.lblTitle.text=titleName;
    
    self.datas=nil;
    [self.mainGrid reloadData];
}

- (void)reload:(NSMutableArray*)dataTemps
{
    self.datas=dataTemps;
    [self.mainGrid reloadData];
}

- (void)reload
{
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
      
        SampleMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:SampleMenuCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SampleMenuCell" owner:self options:nil].lastObject;
        }
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
       
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:@"" andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count) {
        [self reload];
    } else {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: row];
        [self.delegate showItemEvent:self.event withObj:item];
    }
}

-(void) showHelpEvent
{

    [HelpDialog show:@"moneyrule"];
}

@end
