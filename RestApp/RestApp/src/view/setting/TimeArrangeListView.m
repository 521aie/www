//
//  TimeArrangeListView.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimeArrangeListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "TimeArrangeEditView.h"
#import "XHAnimalUtil.h"
#import "GridColHead.h"
#import "HelpDialog.h"
#import "TimeArrangeCell.h"
#import "AlertBox.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "TDFMediator+SettingModule.h"
#import "TDFBusinessService.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TimeArrangeListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
        [self loadDatas];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    self.title= NSLocalizedString(@"营业班次", nil);
    [self initDelegate:self event:@"timeArrange" title:NSLocalizedString(@"营业班次", nil) foots:nil];
    self.footView.hidden = YES;
}

#pragma 数据加载
-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFBusinessService fetchBusinessSpellWithCompleteBlock:^(TDFResponseModel *response) {
        [self.progressHud setHidden:YES];
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                NSArray<TimeArrangeVO *> *dataList = [NSArray yy_modelArrayWithClass:[TimeArrangeVO class] json:dict[@"data"]];
                
                self.datas = [NSMutableArray arrayWithArray:dataList];
                [self.mainGrid reloadData];
            }
        } else {
            [self.progressHud setHidden:YES];
            [AlertBox show:response.error.localizedDescription];
        }
        
    }];


}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)footerAddButtonAction:(UIButton *)sender {
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_TimeArrangeEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^(){
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeTimeArranges:ids Target:self Callback:@selector(delFinish:)];
    [TDFBusinessService removeBusinessSpellWithSpellIds:[ids yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
        [hud hide:YES];
        if ([response isSuccess]) {
            [self loadDatas];
        } else {
            [AlertBox show:response.error.localizedDescription];
        }
    }];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"timearrange"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    TimeArrangeVO* editObj=(TimeArrangeVO*)obj;
    UIViewController *viewController = [[TDFMediator alloc]TDFMediator_TimeArrangeEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^(){
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinish:) name:REMOTE_TIMEARRANGE_LIST object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_TIMEARRANGE_DEL object:nil];
}

-(void) loadFinish:(RemoteResult*) result{
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



-(void) delFinish:(RemoteResult*)result{
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
    NSArray *list = [map objectForKey:@"timeArrangeVOs"];
    self.datas=[JsonHelper transList:list objName:@"TimeArrangeVO"];
    [self.mainGrid reloadData];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeArrangeCell *detailItem = (TimeArrangeCell *)[self.mainGrid dequeueReusableCellWithIdentifier:TimeArrangeCellIndentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"TimeArrangeCell" owner:self options:nil].lastObject;
    }
    
    if (self.datas!=nil) {
        TimeArrange* item=[self.datas objectAtIndex: indexPath.row];
        [detailItem initDelegate:self obj:item];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas==nil || [indexPath row] == self.datas.count) {
        [self showAddEvent:@"timearrang"];
    }
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"班次", nil) col2:NSLocalizedString(@"起止时间", nil)];
    [headItem initColLeft:15 col2:133];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
