//
//  InfoDetailView.m
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "InfoDetailView.h"
#import "UIView+Sizes.h"
#import "InfoDetailCell.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"

@implementation InfoDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"InfoDetailView" owner:self options:nil];
    [self addSubview:self.view];
    [self initGrid];
}

- (void)loadData:(NSString*)title titleValue:(NSString*)val datas:(NSMutableArray*)datas
{
    self.lblTitle.text=[NSString isBlank:title]?@"":title;
    self.lblTitleVal.text=[NSString isBlank:val]?@"":val;
    NSInteger count=0;
    if (datas!=nil && datas.count>0) {
        count=datas.count;
    }
    self.datas=datas;
    [self.grid setHeight:count*36];
    float height=(self.grid.top+self.grid.height);
    [self.line setTop:height];
    [self.view setHeight:(height+1)];
    [self setHeight:(height+1)];
    [self.grid reloadData];
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
