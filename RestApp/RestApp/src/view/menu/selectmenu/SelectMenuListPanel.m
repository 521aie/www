//
//  SelectMenuListPanel.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMenuListPanel.h"
#import "INameValueItem.h"
#import "SelectMenuItem.h"
#import "SampleMenuVO.h"
#import "ObjectUtil.h"

@implementation SelectMenuListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP ];
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectMenuItem *detailItem = (SelectMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMenuItem" owner:self options:nil].lastObject;
    }
    detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO* item=(SampleMenuVO*)[details objectAtIndex: indexPath.row];
            [detailItem loadItem:item];
            return detailItem;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

@end
