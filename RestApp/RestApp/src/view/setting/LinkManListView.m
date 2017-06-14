//
//  LinkManListView.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "LinkManListView.h"
#import "SettingModule.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "LinkManEditView.h"
#import "LinkMan.h"
#import "UIHelper.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "GridColHead.h"
#import "LinkCell.h"
#import "XHAnimalUtil.h"

@implementation LinkManListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=parentTemp;
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add",@"del", nil];
    [self initDelegate:self event:@"linkman" title:NSLocalizedString(@"营业短信接收人", nil) foots:arr];
}

#pragma 数据加载
-(void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];
    [service listLinkManTarget:self Callback:@selector(loadFinish:)];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [parent showView:SECOND_MENU_VIEW];
    }
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    [parent showView:SECOND_MENU_VIEW];
}

-(void) showAddEvent:(NSString*)event
{
    [parent showView:LINKMAN_EDIT_VIEW];
    [parent.linkManEditView loadData:nil action:ACTION_CONSTANTS_ADD];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
}

-(void) showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"linkman"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    [parent showView:LINKMAN_EDIT_VIEW];
    LinkMan* editObj=(LinkMan*)obj;
    [parent.linkManEditView loadData:editObj action:ACTION_CONSTANTS_EDIT];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
}

#pragma 消息处理部分.
-(void) initNotification
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinish:) name:REMOTE_LINKMAN_LIST object:nil];
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

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"linkMans"];
    self.datas=[JsonHelper transList:list objName:@"LinkMan"];
    [self.mainGrid reloadData];
}

#pragma table body
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LinkCell * cell = [tableView dequeueReusableCellWithIdentifier:LinkCellIndentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LinkCell" owner:self options:nil].lastObject;
    }
    
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        LinkMan* item=(LinkMan*)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        cell.lblVal.text=[item obtainItemValue];
        cell.lblTip.text=[NSString stringWithFormat:NSLocalizedString(@"每日%d:00,接收%@%@营业汇总短信", nil),item.receiveTime,(item.dateKind==0?NSLocalizedString(@"昨日", nil):NSLocalizedString(@"当日", nil)),(item.smsKind==0)?NSLocalizedString(@"详细", nil):NSLocalizedString(@"简要", nil)];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"姓名", nil) col2:NSLocalizedString(@"手机号", nil)];
    [headItem initColLeft:15 col2:137];
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
