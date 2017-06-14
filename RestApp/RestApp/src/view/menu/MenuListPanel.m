//
//  MenuListPanel.m
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuListPanel.h"
#import "INameValueItem.h"
#import "SampleMenuVO.h"
#import "GlobalRender.h"
#import "ObjectUtil.h"
#import "TreeNode.h"
#import "Menu.h"
#import "FormatUtil.h"
#import "UIView+Sizes.h"

@implementation MenuListPanel

#pragma 通知相关.
- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString *)headChangeEventP detailChange:(NSString *)detailChangeEventP
{
    [super initDelegate:delegate headChange:headChangeEventP detailChange:detailChangeEventP ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuChange:) name:MenuModule_Menu_Change object:nil];
}

- (void)menuChange:(NSNotification *) notification
{
    NSMutableDictionary *dic = notification.object;
    self.detailMap = [dic objectForKey:@"detail_map"];
    self.backDetailMap = [self.detailMap mutableCopy];
    [self.mainGrid reloadData];
}

- (void)scrocll:(TreeNode*)node
{
    if ([ObjectUtil isNotNull:self.headList] && [ObjectUtil isNotNull:node]) {
        NSInteger index = [GlobalRender getPos:self.headList itemId:node.itemId];
        CGFloat offset = index*DH_HEAD_HEIGHT;
        for (NSUInteger i=0;i<index;++i) {
            TreeNode *nodeTemp = [self.headList objectAtIndex:i];
            if([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap objectForKey:nodeTemp.itemId];
                if ([ObjectUtil isNotEmpty:menus]) {
                    for (SampleMenuVO *menu in menus) {
                        if ([menu isTopMenu]) {
                            offset += DH_BIG_IMAGE_CELL_ITEM_HEIGHT;
                        } else {
                            offset += DH_IMAGE_CELL_ITEM_HEIGHT;
                        }
                    }
                }
            }
        }
        [self.mainGrid setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO *menu = (SampleMenuVO *)[details objectAtIndex:indexPath.row];
            if ([menu isTopMenu] && indexPath.section == 0) {
                return DH_BIG_IMAGE_CELL_ITEM_HEIGHT;
            } else {
                return DH_IMAGE_CELL_ITEM_HEIGHT;
            }
        }
    }
    return 0.0;
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];    
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO *menu = (SampleMenuVO *)[details objectAtIndex:indexPath.row];
            if ([menu isTopMenu] && indexPath.section == 0) {
                MenuItemTopCell *detailItem = (MenuItemTopCell *)[tableView dequeueReusableCellWithIdentifier:MenuItemTopCellIdentifier];
                if (detailItem == nil) {
                    detailItem = [MenuItemTopCell getInstance];
                }
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return [self renderMenuItemTopCell:detailItem menu:menu];
            } else {
                MenuItemCell *detailItem = (MenuItemCell *)[tableView dequeueReusableCellWithIdentifier:MenuItemCellIndentifier];
                if (detailItem == nil) {
                    detailItem = [MenuItemCell getInstance];
                }
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return [self renderMenuItemCell:detailItem menu:menu];
            }
        }
    }
    return nil;
}

- (MenuItemCell *)renderMenuItemCell:(MenuItemCell *)detailItem menu:(SampleMenuVO *)menu
{
    [detailItem loadItem:menu delegate:self.delegate];
    if (menu.chain == 0) {
        detailItem.lblIschain.hidden = YES;
    }else{
        detailItem.lblIschain.hidden = NO;
    }
    if (menu.memberPrice!=menu.price) {
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@", nil), [FormatUtil formatDouble5:menu.price]];
        detailItem.lblDetail.text=val;
        detailItem.lblDetail.textColor=[UIColor redColor];
        [detailItem.lblDetail sizeToFit];
        [detailItem.lblAccount setLeft:(detailItem.lblDetail.left+detailItem.lblDetail.width+2)];
        detailItem.lblAccount.textColor=[UIColor redColor];
        [detailItem.lblAccount sizeToFit];
        [detailItem.lblAccount setNeedsDisplay];
        detailItem.lblRedLine.frame =CGRectMake(detailItem.lblDetail.frame.origin.x, detailItem.lblDetail.frame.origin.y+9, detailItem.lblDetail.frame.size.width+detailItem.lblAccount.frame.size.width, 1);
        NSString* OriginVal =[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblOriginPrice.text=OriginVal;
        detailItem.lblOriginPrice.textColor =[UIColor colorWithRed:0 green:204/255.0f blue:0 alpha:1];
        [detailItem.lblOriginPrice setLeft:(detailItem.lblAccount.left + detailItem.lblAccount.width+2)];
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:detailItem.lblOriginPrice.text];
        [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,[FormatUtil formatDouble5:menu.memberPrice].length+1)];
        detailItem.lblOriginPrice.attributedText =aAttributedString;
        [detailItem.lblOriginPrice sizeToFit];
        [detailItem.btnMember setHidden:NO];
        [detailItem.btnMember setLeft:(detailItem.lblOriginPrice.left+detailItem.lblOriginPrice.width+2)];
        [detailItem.btnMember setNeedsDisplay];
    } else {
        detailItem.lblDetail.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        detailItem.lblDetail.text = [menu obtainItemValue];
        detailItem.lblAccount.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        [detailItem.btnMember setHidden:YES];
        [detailItem.lblRedLine setHidden:YES];
        [detailItem.lblOriginPrice setHidden:YES];
    }
    return detailItem;
}

- (MenuItemTopCell *)renderMenuItemTopCell:(MenuItemTopCell *)detailItem menu:(SampleMenuVO *)menu
{
    [detailItem loadItem:menu delegate:self.delegate];
    if (menu.chain == 0) {
        detailItem.lblIsChain.hidden = YES;
    }else{
        detailItem.lblIsChain.hidden = NO;
    }
    if (menu.memberPrice!=menu.price ) {
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.price], [menu showUnit]];
        detailItem.lblDetail.text=val;
        detailItem.lblDetail.textColor=[UIColor redColor];
        NSString* originval=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblOriginPrice.text=originval;
        detailItem.lblOriginPrice.textColor=[UIColor colorWithRed:0 green:204/255.0f blue:0 alpha:1];
        [detailItem.lblOriginPrice setLeft:(detailItem.lblDetail.left+detailItem.lblDetail.width+2)];
        CGRect originrect = [detailItem.lblDetail.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        detailItem.lblRedLine.frame=CGRectMake(detailItem.lblDetail.frame.origin.x, detailItem.lblDetail.frame.origin.y+8, originrect.size.width, 1);
        CGRect rectlabel = detailItem.lblOriginPrice.frame;
        rectlabel.origin.x = detailItem.lblDetail.origin.x + originrect.size.width;
        detailItem.lblOriginPrice.frame =rectlabel;
        [detailItem.lblOriginPrice sizeToFit];
        [detailItem.btnMember setLeft:(detailItem.lblOriginPrice.left+detailItem.lblOriginPrice.width+2)];
        CGRect rect = [detailItem.lblOriginPrice.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        CGRect rect1 = detailItem.btnMember.frame;
        rect1.origin.x = detailItem.lblOriginPrice.origin.x + rect.size.width;
        detailItem.btnMember.frame = rect1;
        [detailItem.lblAccount setNeedsDisplay];
        [detailItem.btnMember setHidden:NO];
        [detailItem.btnMember setNeedsDisplay];
    } else {
        detailItem.lblDetail.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblDetail.text=val;
        [detailItem.btnMember setHidden:YES];
        [detailItem.lblOriginPrice setHidden:YES];
        [detailItem.lblRedLine setHidden:YES];
    }
    return detailItem;
}

@end
