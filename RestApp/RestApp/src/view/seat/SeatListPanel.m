//
//  SeatListPanel.m
//  RestApp
//
//  Created by zxh on 14-10-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SeatListPanel.h"
#import "GlobalRender.h"
#import "SeatItemCell.h"
#import "SeatRender.h"
#import "ObjectUtil.h"

@implementation SeatListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEventP detailChange:(NSString*)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seatChange:) name:SeatModule_Data_Change object:nil];
}

- (void)seatChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.detailMap=[dic objectForKey:@"detail_map"];
    self.backDetailMap=[self.detailMap mutableCopy];
    [self.mainGrid reloadData];
}

- (void)scrocll:(Area *)area
{
    if ([ObjectUtil isNotNull:self.headList] && [ObjectUtil isNotNull:area]) {
        int index = [GlobalRender getPos:self.headList itemId:area._id];
        CGFloat offset = index*DH_HEAD_HEIGHT;
        for (NSUInteger i=0;i<index;++i) {
            Area *nodeTemp = [self.headList objectAtIndex:i];
            if([ObjectUtil isNotNull:nodeTemp]) {
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
    SeatItemCell *seatItem = (SeatItemCell *)[tableView dequeueReusableCellWithIdentifier:SeatItemCellIndentifier];
    if (seatItem==nil) {
        seatItem = [[NSBundle mainBundle] loadNibNamed:@"SeatItemCell" owner:self options:nil].lastObject;
    }
    if (self.headList.count > indexPath.section) {
        id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
            if ([ObjectUtil isNotEmpty:details]) {
                if (details.count > indexPath.row) {
                    Seat* item=(Seat*)[details objectAtIndex:indexPath.row];
                    [seatItem loadItem:item delegate:self.delegate];
                }
                seatItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return seatItem;
            }
        }
    }
    return nil;
}

@end
