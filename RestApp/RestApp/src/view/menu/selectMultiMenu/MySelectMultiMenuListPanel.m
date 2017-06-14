//
//  MySelectMultiMenuListPanel.m
//  RestApp
//
//  Created by 刘红琳 on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MySelectMultiMenuListPanel.h"
#import "SelectMultiMenuItem1.h"
#import "INameValueItem.h"
#import "DataSingleton.h"
#import "ColorHelper.h"
#import "ObjectUtil.h"
#import "TreeNode.h"
#import "KindMenu.h"
#import "Menu.h"

@implementation MySelectMultiMenuListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP];
}

- (void)refreshDataView
{
    [self.mainGrid reloadData];
}

- (void)initDataWithDetailMap:(NSMutableDictionary *)detailMap withRatio:(NSString *)ratio
{
    self.detailMap = detailMap;
    self.ratio = ratio;
}
#pragma table 处理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:item]) {
        if ([ObjectUtil isNotEmpty:self.detailMap]) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            SampleMenuVO* item=(SampleMenuVO*)[details objectAtIndex:indexPath.row];
            item.orClick = !item.orClick;
            [self.mainGrid reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       SelectMultiMenuItem1 *detailItem = (SelectMultiMenuItem1 *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem1" owner:self options:nil].lastObject;
    }
    
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        if ([ObjectUtil isNotEmpty:self.detailMap]) {
            NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
            SampleMenuVO* item=(SampleMenuVO*)[details objectAtIndex:indexPath.row];
            [detailItem loadItem:item];
            if (item.orClick == YES) {
                detailItem.imgCheck.hidden=NO;
                detailItem.imgUnCheck.hidden=YES;
            }else{
                detailItem.imgCheck.hidden=YES;
                detailItem.imgUnCheck.hidden=NO;
            }
            detailItem.lblDiscount.text=[NSString stringWithFormat:@"%@%%",[item obtainItemRatioValue]];
            [detailItem.lblDiscount setTextColor:([self.ratio doubleValue]==[item obtainItemRatioValue].doubleValue)?[ColorHelper getBlueColor]:[ColorHelper getRedColor]];
             return detailItem;
        }
    }
    return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];;
}

@end

