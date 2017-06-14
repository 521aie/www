//
//  SuitMenuDetailTable.m
//  RestApp
//
//  Created by zxh on 14-8-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "ObjectUtil.h"
#import "FormatUtil.h"
#import "ZmTableCell.h"
#import "UIView+Sizes.h"
#import "GridFooter44.h"
#import "SuitMenuChange.h"
#import "INameValueItem.h"
#import "SuitMenuDetail.h"
#import "SuitMenuDetailHead.h"
#import "SuitMenuDetailTable.h"
#import "SpecDetail.h"

@implementation SuitMenuDetailTable

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SuitMenuDetailTable" owner:self options:nil];
    [self addSubview:self.view];
    [self initGrid];
}

-(void)initGrid
{
    self.mainGrid.opaque=NO;
    self.mainGrid.scrollEnabled=NO;
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void) initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event addName:(NSString*)addName itemMode:(NSInteger)mode
{
    self.delegate=delegate;
    self.event=event;
    self.itemMode=mode;
    self.addName=addName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.view.frame;
    frame.size.width = SCREEN_WIDTH;
    self.view.frame = frame;
}

-(void) loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount
{
    self.headList=headList;
    self.detailMap=detailMap;
    NSInteger headCount=headList==nil?0:headList.count;
    self.detailCount=headCount*2+detailCount;
    NSInteger height=(headList==nil || headList.count==0)?0:(self.detailCount*44);
    
    [self.view setHeight:height];
    [self.mainGrid setHeight:height];
    [self setHeight:height];
    [self.mainGrid reloadData];
}

- (void)reloadData
{
    [self.mainGrid reloadData];
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<INameValueItem> head = [self.headList objectAtIndex:section];
    SuitMenuDetailHead *headItem = (SuitMenuDetailHead *)[tableView dequeueReusableCellWithIdentifier:SuitMenuDetailHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"SuitMenuDetailHead" owner:self options:nil].lastObject;
    }
    headItem.panel.backgroundColor=[UIColor whiteColor];
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self.delegate obj:head event:self.event];
    SuitMenuDetail* detail=(SuitMenuDetail*)head;
    if (detail.isRequired==1) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if (temps==nil || temps.count==0) {
            headItem.lblValue.text=NSLocalizedString(@"必须全部选择:0", nil);
        } else {
            double totalNum=0;
            for (SuitMenuChange* menu in temps) {
                totalNum=totalNum+menu.num;
            }
            headItem.lblValue.text=[NSString stringWithFormat:NSLocalizedString(@"必须全部选择:%@", nil),[FormatUtil formatDouble4:totalNum ]];
        }
    }
    
    [headItem initOperateWithAdd:NO edit:YES];
    if (self.isChain) {
        headItem.imgEdit.hidden = YES;
        headItem.imgAdd.hidden = YES;
        headItem.btnEdit.userInteractionEnabled = NO;
        headItem.btnAdd.userInteractionEnabled = NO;
        headItem.lblValue.textColor = [UIColor grayColor];
    }
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            GridFooter44 *footerItem = (GridFooter44 *)[tableView dequeueReusableCellWithIdentifier:GridFooterCell44Indentifier];
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter44" owner:self options:nil].lastObject;
            }
            footerItem.bgView.backgroundColor=[UIColor clearColor];
            footerItem.lblName.text=self.addName;
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return footerItem;
        } else {
            ZmTableCell *detailItem = (ZmTableCell *)[tableView dequeueReusableCellWithIdentifier:ZmTableCellIndentifier];
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"ZmTableCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotNull:temps]) {
                SuitMenuChange *item=[temps objectAtIndex: indexPath.row];
//                item.isRequired = 1;
                if (![item.menuName containsString:NSLocalizedString(@"）", nil)]) {
                    for (SpecDetail *metric in self.metricList) {
                        if ([metric._id isEqualToString:item.specDetailId]) {
                            item.menuName = [NSString stringWithFormat:NSLocalizedString(@"%@（%@）", nil), item.menuName, metric.name];
                        }
                    }
                }
                
                [detailItem initDelegate:self obj:item event:self.event itemMode:self.itemMode];
                if (self.isChain) {
                    detailItem.btnAct.userInteractionEnabled = NO;
                    detailItem.lblVal.textColor = [UIColor grayColor];
                    detailItem.imgAct.hidden = YES;
                    
                    [detailItem.lblVal mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(detailItem.lblName.mas_centerY);
                        make.right.equalTo(detailItem.btnAct.mas_right).with.offset(-10);
                        make.height.mas_equalTo(43);
                        make.left.equalTo(detailItem.lblName.mas_right).with.offset(0);
                    }];
                }else{
                    detailItem.btnAct.userInteractionEnabled = YES;
                    detailItem.lblVal.textColor = [ColorHelper getBlueColor];
                    detailItem.imgAct.hidden = NO;
                    [detailItem.lblVal mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(detailItem.lblName.mas_centerY);
                        make.right.equalTo(detailItem.btnAct.mas_left).with.offset(-8);
                        make.height.mas_equalTo(43);
                        make.left.equalTo(detailItem.lblName.mas_right).with.offset(0);
                    }];
                }
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
        if ([ObjectUtil isNotNull:temps]) {
            if (self.isChain) {
                return temps.count;
            }
            return temps.count+1;
        } else {
            if (self.isChain) {
                return 0;
            }
            return 1;
        }
    }
    return 0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
             [self.delegate showAddEvent:self.event obj:head];
        }
    }
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
