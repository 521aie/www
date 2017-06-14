//
//  MultiDetailView.m
//  RestApp
//
//  Created by zxh on 14-7-31.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiDetailView.h"
#import "NavigateTitle2.h"
#import "NameValueCell.h"
#import "ObjectUtil.h"
#import "MultiMasterManagerView.h"

@implementation MultiDetailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDelegate:self event:@"" title:@"" foots:nil];
    self.footView.hidden = YES;
    [self createData];
}

-(void) onNavigateEvent:(NSInteger)event{
    
    if (event==DIRECT_LEFT) {
        [self hideMoveOut];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty: self.dic]) {
        id data = self.dic [@"data"];
        NSString *titleName = self.dic [@"titleName"];
        [self loadDatas:data titleName:titleName mainView:nil];
    }
}

#pragma 数据加载
-(void)loadDatas:(NSMutableArray*)datasTemp titleName:(NSString*)titleName mainView:(MultiMasterManagerView*)mainView
{
    self.datas=datasTemp;
//    self.multiMasterManagerView=mainView;
    self.titleBox.lblTitle.text=titleName;
    self.title = titleName;
    [self.mainGrid reloadData];
//    [self showMoveIn];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        [cell.img setHidden:YES];
        cell.lblVal.text=[item obtainItemValue];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
}

- (void)showMoveIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 0.5;
    self.view.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideMoveOut
{
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterMoveOutPanel:finished:context:)];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(70, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 1.0;
    self.view.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)afterMoveOutPanel:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
//    [self.multiMasterManagerView.mainGrid setHidden:NO];
//    [self.multiMasterManagerView.footView setHidden:NO];
}



@end
