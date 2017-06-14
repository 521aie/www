//
//  MultiHeadCheckView.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiHeadCheckManageView.h"
#import "INameValueItem.h"
#import "MultiCheckCell.h"
#import "MultiHeadCell.h"
#import "ViewFactory.h"
#import "ObjectUtil.h"
#import "INameItem.h"

@implementation MultiHeadCheckManageView

#pragma mark TitleBox deal
-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_RIGHT) {
        NSMutableArray* newList=[NSMutableArray array];
        if (self.detailMap && [self.detailMap count]>0) {
            NSEnumerator* keyList=[self.detailMap keyEnumerator];
            NSMutableArray* arr=nil;
            for (NSString* key in keyList) {
                arr = [self.detailMap objectForKey:key];
                for (id<INameValueItem> item in arr) {
                    if ([self.selectList containsObject:[item obtainItemId]]) {
                        [newList addObject:item];
                    }
                }
            }
        }
        [self.delegate multiCheck:self.event items: newList];
    } else {
        [self.delegate closeMultiView:self.event];
    }
}

#pragma  interface event
- (void)loadData:(NSMutableArray*) headListTemp detalMap:(NSMutableDictionary*)detailMap selectList:(NSMutableArray*) selectList
{
    self.headList=[headListTemp mutableCopy];
    self.detailMap=[detailMap mutableCopy];
    self.selectList=selectList;
    [self.mainGrid reloadData];
}

- (void)reLoadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap
{
    [self loadData:headList detalMap:detailMap selectList:self.selectList];
}

#pragma mark checkall notcheckall
-(void) checkAllEvent
{
    if (self.detailMap && [self.detailMap count]>0) {
        NSEnumerator* keyList=[self.detailMap keyEnumerator];
        NSMutableArray* arr=nil;
        for (NSString* key in keyList) {
            arr = [self.detailMap objectForKey:key];
            for (id<INameValueItem> item in arr) {
                [self.selectList addObject:[item obtainItemId]];
            }
        }
    }
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    [self.selectList removeAllObjects];
    [self.mainGrid reloadData];
}

#pragma mark UITableView
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultiCheckCell * cell = [tableView dequeueReusableCellWithIdentifier:MultiCheckCellIdentifier];
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"MultiCheckCell" owner:self options:nil].lastObject;
//    }
    
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item = (id<INameValueItem>)[temps objectAtIndex: indexPath.row];
            cell.lblName.text= [item obtainItemName];
            cell.imgCheck.hidden=![self.selectList containsObject:[item obtainItemId]];
            cell.imgUnCheck.hidden=[self.selectList containsObject:[item obtainItemId]];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item=(id<INameValueItem>)[temps objectAtIndex: indexPath.row];
            if ([ObjectUtil isNotNull:item]) {
                if ([self.selectList containsObject:[item obtainItemId]]) {
                    [self.selectList removeObject:[item obtainItemId]];
                } else {
                    [self.selectList addObject:[item obtainItemId]];
                }
                [self.mainGrid reloadData];
            }
        }
    }
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
    MultiHeadCell *headItem = (MultiHeadCell *)[tableView dequeueReusableCellWithIdentifier:MultiHeadCellIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"MultiHeadCell" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem loadData:head delegate:nil];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.headList]?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

@end
