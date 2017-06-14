//
//  CardBox.m
//  RestApp
//
//  Created by zxh on 14-11-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FormatUtil.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
#import "CardBoxView.h"
#import "UIView+Sizes.h"
#import "CardSampleVO.h"
#import "InfoDetailCell.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"

@implementation CardBoxView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CardBoxView" owner:self options:nil];
    [self addSubview:self.view];
    [self initGrid];
}

- (void)loadData:(NSString*)title card:(CardSampleVO*)card
{
    if ([ObjectUtil isNull:card]) {
        [self.view setHeight:0];
        [self setHeight:0];
        return;
    }
    
    self.datas=[NSMutableArray array];
    self.lblTitle.text=[NSString isBlank:title]?@"":title;
    int count=4;
    
    NameItemVO* vo=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"机构:", nil) andId:card.member];
    [self.datas addObject:vo];
    
    NSString* ratioStr=[FormatUtil formatDouble2:card.ratio];
    ratioStr=[NSString stringWithFormat:NSLocalizedString(@"折扣%@%%", nil),ratioStr];
    ratioStr=card.ratio==0?NSLocalizedString(@"无折扣", nil):ratioStr;
    vo=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"优惠:", nil) andId:ratioStr];
    [self.datas addObject:vo];
    
    NSString* degreeStr=[FormatUtil formatDouble2:card.degree];
    degreeStr=card.degree==0?@"--":[NSString stringWithFormat:NSLocalizedString(@"%@分", nil),degreeStr];
    vo=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"积分:", nil) andId:degreeStr];
    [self.datas addObject:vo];
    
    NSString* balanceFee=[FormatUtil formatDouble2:card.balance];
    NSString* balanceStr=[NSString stringWithFormat:NSLocalizedString(@"%@元", nil),balanceFee];
    vo=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"余额:", nil) andId:balanceStr];
    [self.datas addObject:vo];
    
    self.lblName.text=card.customerName;
    self.lblKind.text=card.kindCardName;
    self.lblCode.text=[NSString stringWithFormat:@"No.%@",card.cardNo];
    
    if ([NSString isNotBlank:card.path]) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:card.path]] placeholderImage:[UIImage imageNamed:@"img_nopic_member.png"]];
    } else {
        [self.img setImage:[UIImage imageNamed:@"img_nopic_member.png"]];
    }
    
    [self.grid setHeight:count*36];
    [self.grid reloadData];
    float height=(self.grid.top+self.grid.height);
    [self.view setHeight:(height+1)];
    [self setHeight:(height+2)];
}

#pragma mark table deal
-(void)initGrid
{
    self.grid.opaque=NO;
    self.grid.backgroundColor=[UIColor clearColor];
    self.grid.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        InfoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoDetailCellIndentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InfoDetailCell" owner:self options:nil].lastObject;
        }
        NameItemVO* item=(NameItemVO*)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text=item.itemName;
        cell.lblVal.text=item.itemId;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
