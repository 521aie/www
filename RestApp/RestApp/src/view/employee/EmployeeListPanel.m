//
//  EmployeeListPanel.m
//  RestApp
//
//  Created by zxh on 14-9-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeListPanel.h"
#import "EmployeeItemCell.h"
#import "GlobalRender.h"
#import "ObjectUtil.h"
#import "Role.h"

@implementation EmployeeListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(employeeChange:) name:EmployeeModule_Data_Change object:nil];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)employeeChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.detailMap=[dic objectForKey:@"detail_map"];
    self.backDetailMap=[self.detailMap mutableCopy];
    [self.mainGrid reloadData];
    
}

- (void)scrocll:(Role*)role
{
    if ([ObjectUtil isNotEmpty:self.headList] && [ObjectUtil isNotNull:role]) {
        int index = [GlobalRender getPos:self.headList itemId:role._id];
        CGFloat offset = index*DH_HEAD_HEIGHT;
        for (NSUInteger i=0;i<index;++i) {
            Role *nodeTemp = [self.headList objectAtIndex:i];
            if ([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap objectForKey:[nodeTemp obtainItemId]];
                if ([ObjectUtil isNotEmpty:menus]) {
                    offset += DH_IMAGE_CELL_ITEM_HEIGHT*menus.count;
                }
            }
        }
        [self.mainGrid setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeItemCell *detailItem = (EmployeeItemCell *)[tableView dequeueReusableCellWithIdentifier:EmployeeItemCellIndentifier];
    if (detailItem==nil) {
        detailItem = [[EmployeeItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmployeeItemCellIndentifier];
    }
     detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.headList.count > indexPath.section) {
        id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
        Role* role=(Role*)head;
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
            if ([ObjectUtil isNotEmpty:details]) {
                Employee* item=(Employee*)[details objectAtIndex: indexPath.row];
                [detailItem loadItem:item role:role delegate:self.delegate];
                return detailItem;
            }
        }
    }
    return detailItem;
}


@end
