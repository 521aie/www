//
//  SelectRoleView.m
//  RestApp
//
//  Created by zxh on 14-9-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Area.h"
#import "TreeNode.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "SelectAreaCell.h"
#import "UIImage+Resize.h"
#import "SelectAreaPanel.h"

@implementation SelectAreaPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainGrid];
    UIImage *pic = [UIImage imageNamed:@"ico_manage.png"];
    [self.btnSelect setImage:[pic transformWidth:22 height:22] forState:UIControlStateNormal];
    [self borderLine:self.btnSelect];
    
    self.btnSelect.layer.cornerRadius = 3;
}

- (void)borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setCornerRadius:5.0]; //设置矩圆角半径
    UIColor *color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

- (void)initDelegate:(id<SingleCheckHandle>)delegate event:(NSInteger)event
{
    self.delegate = delegate;
    self.event = event;
}

- (void)loadData:(NSMutableArray *)areaList
{
    self.areaList = areaList;
    [self.mainGrid reloadData];
}

- (void)initMainGrid
{
    self.mainGrid.opaque = YES;
    UIView *view = [ViewFactory generateFooter:60];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.areaList.count==0?0:self.areaList.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectAreaCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectAreaCellIndentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectAreaCell" owner:self options:nil].lastObject;
    }
    
    if (self.areaList.count > 0 && indexPath.row < self.areaList.count) {
        Area* item = (Area *)[self.areaList objectAtIndex: indexPath.row];
        cell.lblName.text = [item obtainItemName];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.areaList.count) {
        [self.mainGrid reloadData];
    } else {
        Area *item = (Area *)[self.areaList objectAtIndex: row];
        [self.delegate singleCheck:self.event item:item];
    }
}

- (IBAction)btnRoleManagerClick:(id)sender
{
    [self.delegate closeSingleView:self.event];
}

@end
