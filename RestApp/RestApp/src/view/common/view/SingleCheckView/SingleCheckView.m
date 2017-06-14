//
//  SingleCheckView.m
//  RestApp
//
//  Created by zxh on 14-4-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SingleCheckView.h"

#import "INameItem.h"
#import "SingleCheckCell.h"
#import "XHAnimalUtil.h"
#import "DataSingleton.h"
#import "NSString+Estimate.h"

@implementation SingleCheckView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGrid];
    [self initHead];
}

#pragma mark TitleBox deal
-(void) initHead
{
    [self.titleBox initDelegate:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
}

-(void) onNavigateEvent:(NSInteger)event
{
    [XHAnimalUtil animationMoveDown:self.view];
}

#pragma  interface event
- (void)initDelegate:(int) _eventTemp delegate:(id<SingleCheckHandle>) _delegateTemp title:(NSString*) titleName
{
    self.delegate=_delegateTemp;
    self.event=_eventTemp;
    self.titleBox.lblTitle.text=titleName;
    self.datas=nil;
    [self.mainGrid reloadData];
}

- (void)reload:(NSMutableArray*) _dataTemps selValue:(NSString*) val
{
    self.datas=_dataTemps;
    self.val=val;
    [self.mainGrid reloadData];
}

#pragma mark table deal

-(void)initGrid
{
    self.mainGrid.opaque=NO;
    //如果想删除cell之间的分割线，设置
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        SingleCheckCell * cell = [tableView dequeueReusableCellWithIdentifier:SingleCheckCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SingleCheckCell" owner:self options:nil].lastObject;
        }
        id<INameItem> item=(id<INameItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        BOOL result=!([NSString isNotBlank:self.val] && [self.val isEqualToString:[item obtainItemId]]);
        cell.imgCheck.hidden= result;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count) {
        [self.mainGrid reloadData];
    } else {
        id<INameItem> item=(id<INameItem>)[self.datas objectAtIndex: row];
        [XHAnimalUtil animationMoveDown:self.view];
        [self.delegate singleCheck:self.event item:item];
    }
}

@end
