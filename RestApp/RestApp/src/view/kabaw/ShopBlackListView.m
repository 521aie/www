//
//  ShopBlackListView.m
//  RestApp
//
//  Created by 刘红琳 on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopBlackListView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "HelpDialog.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "ObjectUtil.h"
#import "DataSingleton.h"
#import "ShopBlackListCell.h"
#import "TDFKabawService.h"

@implementation ShopBlackListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"黑名单", nil);
    [self loadDatas];
    [self initNotification];
    [self initDelegate:self event:@"shopblacklist" title:@"" foots:nil];
   
}
#pragma 消息处理部分.
- (void) initNotification
{

}
- (void)initMainView
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.mainGrid.frame.size.height-60)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.mainGrid addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 50, 120, 120)];
    imageView.image=[UIImage imageNamed:@"img_nobill"];
    [bgView addSubview:imageView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 20)];
    lbl.text = @"没有添加黑名单";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:14];
    lbl.textColor=[UIColor whiteColor];
    lbl.numberOfLines=1;
    
    [bgView addSubview:lbl];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 180, SCREEN_WIDTH - 40, 120)];
    
    label.text=NSLocalizedString(@"您可以在收银机上将恶意骚扰的微信点餐顾客加入黑名单。被加入黑名单的顾客，将不能使用微信在本店扫码点菜，请谨慎添加。", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [bgView addSubview:label];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event == 1) {
        
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

-(void)loadDatas
{

  [self showProgressHudWithText:NSLocalizedString(@"正在查询", nil)];
    [[TDFKabawService new]  searchBlackList:@"1" PageSize:@"8" sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self remoteLoadData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) loadFinish:(RemoteResult*)result
{
    [self.progressHud setHidden:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(id ) data
{
    [bgView removeFromSuperview];
   
    NSMutableDictionary *dic=[data objectForKey:@"data"];
    NSMutableArray *arr=[dic objectForKey:@"blackLists"];
    if ([ObjectUtil isNotEmpty:arr]) {
        [self.mainGrid reloadData];
         arr1=[[NSMutableArray alloc]initWithArray:arr];
        
    }else{
        [self initMainView];
      }
    
    [self reload:self.datas error:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr1 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShopBlackListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ShopBlackListCell" owner:self options:nil].lastObject;
         }
        cell.backgroundColor=[[UIColor alloc]initWithWhite:1 alpha:0.7];
        if ([ObjectUtil isNotEmpty:arr1]) {
            NSMutableDictionary *dic = arr1[indexPath.row];
            NSNumber *creatTime=[dic objectForKey:@"createTime"];
            NSString *mobile=[dic objectForKey:@"mobile"];
            if ([ObjectUtil isEmpty: [dic objectForKey:@"name"]]) {
                [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"李四", nil) forKey:@"name"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }else{
                NSString *name=[dic objectForKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            cell.name.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
            cell.mobile.text=mobile;
            NSTimeInterval time=[creatTime doubleValue]/1000.0;
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:NSLocalizedString(@"yyyy.MM.dd HH:mm", nil)];
             NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
             cell.addDate.text=currentDateStr;
       }
        [cell.delBtn addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.delBtn.tag=indexPath.row;
        row=indexPath.row;
        return cell;
}

-(void)btnDelClick:(UIButton *)sender
{
    if ([ObjectUtil isNotEmpty:arr1]) {
            NSMutableDictionary *dic = arr1[sender.tag];
            NSString *userId=[dic objectForKey:@"id"];
            [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"id"];
        }
    [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"您确认要恢复此黑名单顾客的权利吗？", nil)];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

       [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        [[TDFKabawService new] updataBlackListWithID:[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]  sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud setHidden:YES];
            [arr1 removeObjectAtIndex:row];
            [self loadDatas];
           [AlertBox show:NSLocalizedString(@"删除成功", nil)];

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox  show:error.localizedDescription];
        }];

     }
}

-(void) deleteDataFinish:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];

    if (result.isRedo) {
          return;
    }
    if (!result.isSuccess) {
        [self.progressHud setHidden:YES];
        [AlertBox show:result.errorStr];
        return;
    }
}

-(void) showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"shopblacklist"];
}

@end
