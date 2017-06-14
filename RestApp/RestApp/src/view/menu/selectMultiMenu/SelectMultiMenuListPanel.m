//
//  SelectMenuListPanel.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMultiMenuListPanel.h"
#import "SelectMultiMenuItem.h"
#import "INameValueItem.h"
#import "SampleMenuVO.h"
#import "ObjectUtil.h"
#import "TreeNode.h"
#import "KindMenu.h"
#import "Menu.h"

@implementation SelectMultiMenuListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP];
}

- (void)initSelectData:(NSArray *)selectList
{
    selectDataSet = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:selectList]) {
        for (id<IMenuDataItem> menuData in selectList) {
            [selectDataSet addObject:[menuData obtainMenuId]];
        }
    }
}

- (NSMutableArray *)getSelectDatas
{
    return selectDataSet;
}

- (void)refreshDataView
{
    [self.mainGrid reloadData];
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectMultiMenuItem *detailItem = (SelectMultiMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem" owner:self options:nil].lastObject;
    }
    
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO* item=(SampleMenuVO*)[details objectAtIndex: indexPath.row];
            [detailItem loadItem:item];
            if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"0"]) {
                if (item.chain == 1) {
                    detailItem.isChainLbl.hidden = NO;;
                }
            }
            detailItem.imgCheck.hidden=![selectDataSet containsObject:item._id];;
            detailItem.imgUnCheck.hidden=[selectDataSet containsObject:item._id];

            return detailItem;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:item]) {
        NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO *item=[details objectAtIndex:indexPath.row];
            if (item) {
                if ([selectDataSet containsObject:item._id]) {
                    [selectDataSet removeObject:item._id];
                } else {
                    [selectDataSet addObject:item._id];
                }
                [self.mainGrid reloadData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)selectAll
{
    for (NSMutableArray *details in [self.detailMap allValues]) {
        if ([ObjectUtil isNotEmpty:details]) {
            for (SampleMenuVO *menu in details) {
                if ([ObjectUtil isNotNull:menu]) {
                    if ([selectDataSet containsObject:menu._id]==NO) {
                        [selectDataSet addObject:menu._id];
                    }
                }
            }
        }
    }
    [self.mainGrid reloadData];
}

-(void)deSelectAll
{
    [selectDataSet removeAllObjects];
    [self.mainGrid reloadData];
}

@end
