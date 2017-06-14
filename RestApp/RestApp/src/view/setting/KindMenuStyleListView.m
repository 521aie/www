//
//  KindMenuStyleListView.m
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "GridColHead.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "INameValueItem.h"
#import "RemoteEvent.h"
#import "JsonHelper.h"
#import "XHAnimalUtil.h"
#import "NameValueCell.h"
#import "DataSingleton.h"
#import "EventConstants.h"
#import "KindMenuStyleVO.h"
#import "TDFSettingService.h"
#import "NSString+Estimate.h"
#import "KindMenuStyleListView.h"
#import "TDFOptionPickerController.h"

@implementation KindMenuStyleListView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"电子菜谱排版", nil);
    self.needHideOldNavigationBar = YES;
    [self initNotification];
    [self initDelegate:self event:@"kindMenuStyle" title:NSLocalizedString(@"电子菜谱排版", nil) foots:nil];
    [self loadDatas];
}

#pragma 代理实现。
- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    id<INameItem> vo=(id<INameItem>)item;
    self.val.pdaStyleId=[vo obtainItemId];
    self.val.styleId=[vo obtainItemId];
    [self save];
    return YES;
}

-(void)save
{
    self.val.usage=USAGE_PDA;
    
     // [service updateKindMenuStyle:self.val Target:self Callback:@selector(remoteFinsh:)];
    [[TDFSettingService new] updateKindMenuStyle:self.val sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         [self loadDatas];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
    
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    self.val=(KindMenuStyleVO*)obj;
    if (self.options==nil || self.options.count==0) {
        [AlertBox show:NSLocalizedString(@"未查询到相关的排版方式，请重试或联系迪火科技.", nil)];
        return;
    }
    NSString* styleId=self.val.pdaStyleId;
    if ([NSString isBlank:self.val.pdaStyleId] ) {
        for (id<INameValueItem> item in self.options) {
            if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"文字，36个商品", nil)]) {
                styleId=[item obtainItemId];
                break;
            }
        }
    }
    
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"排版方式", nil)
                                                                                  options:self.options
                                                                            currentItemId:styleId];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:self.options[index] event:1];
    };
    
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

#pragma 数据加载
-(void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];
    [[TDFSettingService new] listKindMenuStyleSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary* map= data [@"data"];
        NSArray *list = [map objectForKey:@"kindMenuStyleVos"];
        self.datas=[JsonHelper transList:list objName:@"KindMenuStyleVO"];
        
        NSArray *optionList = [map objectForKey:@"kindMenuStyleOptionsPdaLess"];
        self.options=[JsonHelper transList:optionList objName:@"KindMenuStyleOption"];
        
        [self.mainGrid reloadData];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

-(void) showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"kindmenustyle"];
}

#pragma 消息处理部分.
-(void) initNotification
{
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinish:) name:REMOTE_KINDMENUSTYLE_LIST object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_KINDMENUSTYLE_SAVE object:nil];
}

-(void) loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"kindMenuStyleVos"];
    self.datas=[JsonHelper transList:list objName:@"KindMenuStyleVO"];
    
    NSArray *optionList = [map objectForKey:@"kindMenuStyleOptionsPdaLess"];
    self.options=[JsonHelper transList:optionList objName:@"KindMenuStyleOption"];
    
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
        }
        UIImage *tempPic=[UIImage imageNamed:@"ico_next_down.png"];
        cell.img.image=tempPic;
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        NSString* val=[item obtainItemValue];
        cell.lblVal.text=[NSString isBlank:val]?NSLocalizedString(@"文字,36个商品", nil):val;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"商品分类", nil) col2:NSLocalizedString(@"排版方式", nil)];
    [headItem initColLeft:15 col2:137];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
