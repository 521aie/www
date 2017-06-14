//
//  ZMKindTable.m
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZMKindTable.h"
#import "INameValueItem.h"
#import "ZmTableHead.h"
#import "ZmTableViewCell.h"
#import "AdditionMenuVo.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "FormatUtil.h"
#import "ObjectUtil.h"
#import "MenuModuleEvent.h"


@implementation ZMKindTable

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZmTableViewCell *detailItem = (ZmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ZmTableViewCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"ZmTableViewCell" owner:self options:nil].lastObject;
    }
    
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item=[temps objectAtIndex: indexPath.row];
            detailItem.lblName.text=[item obtainItemName];
            if ([self.event isEqualToString:KINDMENU_ADDITION_EVENT]) {
                AdditionMenuVo* vo=(AdditionMenuVo*)item;
                detailItem.lblVal.text=[NSString stringWithFormat:NSLocalizedString(@"加价:%@元", nil),[FormatUtil formatDouble5:vo.menuPrice]];
            } else {
                detailItem.lblVal.text=[item obtainItemValue];
            }
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
