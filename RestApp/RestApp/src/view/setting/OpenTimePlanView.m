//
//  OpenTimePlanView.m
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "OpenTimePlanView.h"
#import "OpenTimePlan.h"
#import "SettingService.h"
#import "MBProgressHUD.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "SettingModuleEvent.h"
#import "RemoteEvent.h"
#import "NavigateTitle2.h"
#import "ItemEndNote.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "OpenTimePlanRender.h"
#import "GlobalRender.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "DateUtils.h"
#import "PairPickerBox.h"
#import "Platform.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFSettingService.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "TDFRootViewController+FooterButton.h"

@implementation OpenTimePlanView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self initData];
    [self loadData];
}

-(void) initData
{
    self.dic=[NSMutableDictionary dictionary];
    self.timesToday=[[NSArray alloc] initWithObjects:@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",nil];
    [self.dic setObject:self.timesToday forKey:NSLocalizedString(@"当日", nil)];
    self.timesTomorrow=[[NSArray alloc] initWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",nil];
    [self.dic setObject:self.timesTomorrow forKey:NSLocalizedString(@"次日早晨", nil)];
    self.keys=[[NSArray alloc] initWithObjects:NSLocalizedString(@"当日", nil),NSLocalizedString(@"次日早晨", nil),nil];
}


#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"营业时间", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"营业时间", nil);
}

- (void)leftNavigationButtonAction:(id)sender{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView
{
    [self.lsEndType initLabel:NSLocalizedString(@"营业结束时间", nil) withHit:nil delegate:self];
    self.lblNote.text = NSLocalizedString(@"提示：如果营业结束时间设为当日22:00，那么这个时间点之前结账的账单会出现在当日的报表中，这个时间点之后结账的账单会出现在第二天的报表中。", nil);
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    //[UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    //修改
    [[TDFSettingService new] loadOpenTimePlanSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary *planDic = [data objectForKey:@"data"];
        self.openTimePlan=[JsonHelper dicTransObj:planDic obj:[OpenTimePlan alloc]];
        [self refreshUI];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma ui-data-bind
-(void) refreshUI
{
    if (self.openTimePlan) {
        NSString* itemName=[GlobalRender obtainItem:[OpenTimePlanRender listEndTypes] itemId:[NSString stringWithFormat:@"%d",self.openTimePlan.endType]];
        itemName=[NSString stringWithFormat:@"%@,%@",itemName,[DateUtils formatTimeWithSecond:self.openTimePlan.endTime]];
        [self.lsEndType initData:itemName withVal:[NSString stringWithFormat:@"%d|%d",self.openTimePlan.endType,self.openTimePlan.endTime]];
    } else {
        [self.lsEndType initData:NSLocalizedString(@"当日 ▪︎ 21:00", nil) withVal:[NSString stringWithFormat:@"%d|%d",TYPE_TODAY,21*60]];
    }
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
}


#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    NSArray *times = [[self.lsEndType getStrVal] componentsSeparatedByString:@"|"];
    int kPos=((NSString*)[times objectAtIndex:0]).intValue;
    int endTime=((NSString*)[times objectAtIndex:1]).intValue;
    int vPos=0;
    if (self.openTimePlan) {
        NSArray* arr=kPos==0?self.timesToday:self.timesTomorrow;
        int pos=0;
        NSString* currTime=[DateUtils formatTimeWithSecond:endTime];
        for (NSString* time in arr) {
           if ([time isEqualToString:currTime]) {
              vPos=pos;
              break;
           }
           pos++;
        }
     }
     [PairPickerBox initData:self.dic keys:self.keys keyPos:kPos valPos:vPos];
     [PairPickerBox show:NSLocalizedString(@"选择营业结束时间", nil) client:self event:0];
}

- (BOOL)pickOption:(NSInteger)keyIndex valIndex:(NSInteger)valIndex event:(NSInteger)eventType
{
    NSString* key=[self.keys objectAtIndex:keyIndex];
    NSArray* arr=keyIndex==0?self.timesToday:self.timesTomorrow;
    NSString* val=[arr objectAtIndex:valIndex];
    NSInteger time=0;
    NSArray *times = [val componentsSeparatedByString:@":"];
    if (times.count==2) {
        NSString *time1 = [times objectAtIndex:0];
        NSString *time2 = [times objectAtIndex:1];
        time = time1.integerValue*60 + time2.integerValue;
    }
    
    [self.lsEndType changeData:[NSString stringWithFormat:@"%@,%@",key,val] withVal:[NSString stringWithFormat:@"%ld|%ld",(long)keyIndex, (long)time]];
    return YES;
}

#pragma ------------------------------------------------------------------
#pragma ui-data-save
-(BOOL) isValid
{
    if ([NSString isBlank:[self.lsEndType getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择营业结束时间!", nil)];
        return NO;
    }
    
    return YES;
}

-(OpenTimePlan*) transMode
{
    OpenTimePlan* planUpdate=[OpenTimePlan new];
    NSArray *times = [[self.lsEndType getStrVal] componentsSeparatedByString:@"|"];
    planUpdate.endType=((NSString*)[times objectAtIndex:0]).intValue;
    planUpdate.endTime=((NSString*)[times objectAtIndex:1]).intValue;
    return planUpdate;
}

-(void) save
{
    if (![self isValid]) {
        return;
    }
    OpenTimePlan* planUpdate=[self transMode];
    if (self.openTimePlan) {
        planUpdate._id=self.openTimePlan._id;
    }

  [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFSettingService new] updateOpenTimePlan:planUpdate sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        [self remoteFinsh:data];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_OpenTimePlanView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_OpenTimePlanView_Change object:nil];

}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

-(void) loadFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    
    NSDictionary *planDic = [map objectForKey:@"openTimePlan"];
    self.openTimePlan=[JsonHelper dicTransObj:planDic obj:[OpenTimePlan alloc]];
    [self refreshUI];
 }

-(void) remoteFinsh:(id)data
{
   
    [UIHelper clearChange:self.container];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    NSDictionary* planDic = [data objectForKey:@"openTimePlan"];
    self.openTimePlan=[JsonHelper dicTransObj:planDic obj:[OpenTimePlan alloc]];
    NSMutableDictionary *actDic=[[Platform Instance] getCountDic];
    [actDic removeObjectForKey:@"openTimeStr"];
    NSString* itemName=[GlobalRender obtainItem:[OpenTimePlanRender listEndTypes] itemId:[NSString stringWithFormat:@"%d",self.openTimePlan.endType]];
    itemName=[NSString stringWithFormat:@"%@,%@",itemName,[DateUtils formatTimeWithSecond:self.openTimePlan.endTime]];
    [actDic setValue:itemName forKey:@"openTimeStr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_COUNTDATA_INIT object:nil] ;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"opentimeplan"];
}

@end
