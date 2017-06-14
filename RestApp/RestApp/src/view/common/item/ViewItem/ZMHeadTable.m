//
//  ZMTable.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZMHeadTable.h"
#import "INameValueItem.h"
#import "ZmTableHead.h"
#import "ZmTableCell.h"
#import "UIView+Sizes.h"
#import "ObjectUtil.h"
#import "UIHelper.h"

@implementation ZMHeadTable

-(void) loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount
{
    self.headList=headList;
    self.detailMap=detailMap;
    self.detailCount=detailCount;
    NSInteger height=(headList==nil || headList.count==0)?0:(detailCount*44);
    [self.mainGrid setHeight:height];
    [self.view setHeight:height+44];
    [self.footView setTop:height];
    
    [self setHeight:height+44];
    [self.mainGrid reloadData];
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZmTableCell *detailItem = (ZmTableCell *)[tableView dequeueReusableCellWithIdentifier:ZmTableCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"ZmTableCell" owner:self options:nil].lastObject;
    }

    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item=[temps objectAtIndex: indexPath.row];
            [detailItem initDelegate:self obj:item event:self.event itemMode:self.itemMode];
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<INameValueItem> head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        return ([ObjectUtil isNotEmpty:temps]?temps.count:0);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<INameValueItem> head = [self.headList objectAtIndex:section];
    ZmTableHead *headItem = (ZmTableHead *)[tableView dequeueReusableCellWithIdentifier:ZmTableHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"ZmTableHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem loadData:self.kindName obj:head delegate:self event:self.event];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.headList]?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

@end
