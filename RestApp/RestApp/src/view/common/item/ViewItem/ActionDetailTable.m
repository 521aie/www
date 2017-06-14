//
//  ActionDetailTable.m
//  RestApp
//
//  Created by zxh on 14-10-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ActionDetailTable.h"
#import "ActionTableHead.h"
#import "UIView+Sizes.h"
#import "GridFooter44.h"
#import "ZmTableCell.h"
#import "ObjectUtil.h"
#import "UIHelper.h"
#import "ColorHelper.h"

@implementation ActionDetailTable

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ActionDetailTable" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:self.view];
    [self initGrid];
}

- (void)initGrid
{
    self.mainGrid.opaque=NO;
    self.mainGrid.scrollEnabled=NO;
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mainGrid registerNib:[UINib nibWithNibName:@"ZmTableCell" bundle:nil] forCellReuseIdentifier:ZmTableCellIndentifier];
}

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event addName:(NSString*)addName itemMode:(NSInteger)mode
{
    self.delegate=delegate;
    self.event=event;
    self.itemMode=mode;
    self.addName=addName;
}

- (void)loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount
{
    if (headList.count == 0) {
        self.frontLine.hidden = YES;
    }else{
        self.frontLine.hidden = NO;
    }
    self.headList=headList;
    self.detailMap=detailMap;
    [self.btn setTitle:[NSString stringWithFormat:@"  %@",self.addName] forState:UIControlStateNormal];
    [self.btn setTitleColor:[ColorHelper getRedColor] forState:UIControlStateNormal];
    NSInteger headCount=([ObjectUtil isNotEmpty:headList]?headList.count:0);
    self.detailCount=headCount+detailCount;
    NSInteger height=([ObjectUtil isEmpty:headList])?0:(self.detailCount*44);
    
    [self.view setHeight:height];
    [self.mainGrid setHeight:height + 10];
    [self.view setHeight:height+44];
    [self.footView setTop:height];
    [self setHeight:height+44];
    [self.mainGrid reloadData];
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<INameValueItem> head = [self.headList objectAtIndex:section];
    ActionTableHead *headItem = (ActionTableHead *)[tableView dequeueReusableCellWithIdentifier:ActionTableHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"ActionTableHead" owner:self options:nil].lastObject;
    }
    headItem.panel.backgroundColor=[UIColor whiteColor];
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self.delegate obj:head event:self.event];
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if (temps!=nil && indexPath.row<temps.count) {
            ZmTableCell *detailItem = (ZmTableCell *)[tableView dequeueReusableCellWithIdentifier:ZmTableCellIndentifier];
            if ([ObjectUtil isNotEmpty:temps]) {
                id<INameValueItem> item=[temps objectAtIndex: indexPath.row];
                [detailItem initDelegate:self obj:item event:self.event itemMode:self.itemMode];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
       return nil;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    return (self.headList!=nil?self.headList.count:0);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma btnAdd ...
-(IBAction)btnAddClick:(id)sender
{
    [self.delegate showAddEvent:self.event];
}

#pragma del确认包装.
-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=(id<INameValueItem>)obj;
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.currObj obtainItemName]]];
}

-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    [self.delegate showEditNVItemEvent:self.event withObj:obj];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.delegate delObjEvent:self.event obj:self.currObj];
    }
}

@end
