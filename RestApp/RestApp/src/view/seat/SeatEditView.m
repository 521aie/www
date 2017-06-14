//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Seat.h"
#import "Area.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "Platform.h"
#import "INameItem.h"
#import "HelpDialog.h"
#import "SeatItemQr.h"
#import "SeatRender.h"
#import "NameItemVO.h"
#import "RemoteEvent.h"

#import "RemoteResult.h"
#import "SeatEditView.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "GlobalRender.h"
#import "AreaListView.h"
#import "RestConstants.h"
#import "MBProgressHUD.h"
#import "NavigateTitle.h"
#import "FooterListView.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "SingleCheckView.h"
#import "SeatModuleEvent.h"
#import "NSString+Estimate.h"
#import "TDFSeatService.h"
#import "UIViewController+HUD.h"
#import "TDFOptionPickerController.h"
#import "TDFMediator+SeatModule.h"

@implementation SeatEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.changed=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData:self.seat areas:self.areaList action:self.action];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"桌位", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SeatEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SeatEditView_Change object:nil];
}

- (void)initMainView
{
    [self.lsArea initLabel:NSLocalizedString(@"区域", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtName initLabel:NSLocalizedString(@"桌位名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCode initLabel:NSLocalizedString(@"桌位编码", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsKind initLabel:NSLocalizedString(@"桌位类型", nil) withHit:nil delegate:self];
    [self.txtAdviseNum initLabel:NSLocalizedString(@"建议人数", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    
    [self.imgQr initLabel:NSLocalizedString(@"本桌二维码", nil) withHit:NSLocalizedString(@"提示:店家可下载并打印此二维码,贴在对应的餐桌上或餐牌上。顾客使用“火小二”应用中的“扫一扫”功能扫描此二维码后,可以用手机开单,加菜,结账,呼叫服务员.", nil)];
    
    [self.footView initDelegate:self btnArrs:[[NSArray alloc] init]];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsArea.tag = 1;
    self.lsKind.tag = 2;
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

#pragma remote
- (void)loadData:(Seat *)seatTemp areas:(NSMutableArray *)areas action:(NSInteger)action
{
    [self clearDo];
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加桌位", nil);
    } else {
        
        self.title = self.seat.name;
        [self fillModel];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
    [self.txtCode initData:nil];
    [self.txtAdviseNum initData:@"4"];
    [self.lsKind initData:NSLocalizedString(@"散座", nil) withVal:[NSString stringWithFormat:@"%d", SEAT_KIND_COMMON]];
    [self.imgQr visibal:NO];
    
    NSString *lastAreaId = [[Platform Instance] getkey:DEFAULT_AREA];
    if ([NSString isBlank:lastAreaId]) {
        if (self.areaList==nil || self.areaList.count==0) {
            [self.lsArea initData:nil withVal:nil];
        } else {
            Area *areaTemp=[self.areaList firstObject];
            [self.lsArea initData:areaTemp.name withVal:areaTemp._id];
        }
    } else {
        [self.lsArea initData:[GlobalRender obtainObjName:self.areaList itemId:lastAreaId] withVal:lastAreaId];
    }
    [self.titleBox editTitle:NO act:self.action];
}

- (void)fillModel
{
    [self.imgQr visibal:YES];
    [self.imgQr loadSeat:self.seat];
    [self.txtName initData:self.seat.name];
    [self.txtCode initData:self.seat.code];
    
    [self.txtAdviseNum initData:[NSString stringWithFormat:@"%d", self.seat.adviseNum]];
    [self.lsKind initData:[SeatRender formatSeatKind:self.seat.seatKind] withVal:[NSString stringWithFormat:@"%d",self.seat.seatKind]];
    [self.lsArea initData:[SeatRender formatArea:self.seat.areaId areas:self.areaList] withVal:self.seat.areaId];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
        return;
    }
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void)delFinish:(NSError *) error
{
    [self.progressHud hide:YES];
    
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)remoteFinsh:(NSError *)error
{
    [self.progressHud hide:YES];
    
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
    }
    
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadAreaFinshError:(NSError *)error obj:(id)obj
{
    [self.progressHud hide:YES];
    if (error) {
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    
    self.areaList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    //    [OptionPickerBox initData:self.areaList itemId:[self.lsArea getStrVal]];
    //    [OptionPickerBox showManager:self.lsArea.lblName.text managerName:NSLocalizedString(@"区域管理", nil) client:self event:self.lsArea.tag];
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.lsArea.lblName.text
                                                                                  options:self.areaList
                                                                            currentItemId:[self.lsArea getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:wself.areaList[index] event:wself.lsArea.tag];
    };
    
    pvc.shouldShowManagerButton = YES;
    pvc.manageTitle = NSLocalizedString(@"区域管理", nil);
    pvc.managerBlock = ^void(){
        
        [wself managerOption:wself.lsArea.tag];
    };
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj == self.lsArea) {   //选择区域.
        [self showProgressHudWithText:NSLocalizedString(@"正在加载桌位", nil)];
        
        //        [service listArea:@"false" target:self Callback:@selector(loadAreaFinsh:)]
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] areasWithSaleOutFlag:@"false" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [wself loadAreaFinshError:nil obj:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself loadAreaFinshError:error obj:nil];
        }];
    } else if (obj == self.lsKind) {   //选择桌位类型.
        //        [OptionPickerBox initData:[SeatRender listKind] itemId:[obj getStrVal]];
        //        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[SeatRender listKind]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[SeatRender listKind][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    if (event==SEAT_SELECT_KIND) {
        NameItemVO *kind = (NameItemVO *)item;
        [self.lsKind changeData:kind.itemName withVal:kind.itemId];
    } else {
        Area *area = (Area *)item;
        [self.lsArea changeData:area.name withVal:area._id];
    }
    return YES;
}

- (void)managerOption:(NSInteger)eventType
{

    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_AreaListViewWithCallBack:^{
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.lsArea getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择区域!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsKind getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择桌位类型!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"桌位名称不能为空!", nil)];
        return NO;
    }
    
    NSString *seatName = [self.txtName getStrVal];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if ([seatName dataUsingEncoding:encode].length>12) {
        [AlertBox show:NSLocalizedString(@"桌位名称不能超过12个字符!", nil)];
        return NO;
    }
    
    if ([NSString isNotNumAndLetter:[self.txtCode getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"桌位编码不能为空,且只能是数字和英文字母!", nil)];
        return NO;
    }
    
    if (![NSString isNumNotZero:[self.txtAdviseNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"建议人数不能为空,且只能是大于0的数字!", nil)];
        return NO;
    }
    
    if ([[self.txtAdviseNum getStrVal] length]>4) {
        [AlertBox show:NSLocalizedString(@"建议人数只能小于10000!", nil)];
        return NO;
    }
    return YES;
}

- (Seat *)transMode
{
    Seat *seatUpdate = [Seat new];
    seatUpdate.areaId = [self.lsArea getStrVal];
    seatUpdate.name = [self.txtName getStrVal];
    seatUpdate.code = [self.txtCode getStrVal];
    seatUpdate.seatKind = [[self.lsKind getStrVal] intValue];
    seatUpdate.adviseNum = [[self.txtAdviseNum getStrVal] intValue];
    return seatUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    
    Seat *seatTemp = [self transMode];
    [[Platform Instance] saveKeyWithVal:DEFAULT_AREA withVal:seatTemp.areaId];
    NSString* tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        //        [service saveSeat:seatTemp Target:self Callback:@selector(remoteFinsh:)];
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] saveSeatWithParam:[seatTemp yy_modelToJSONObject] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself remoteFinsh:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself remoteFinsh:error];
        }];
    } else {
        seatTemp._id = self.seat._id;
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] updateSeatWithParam:[seatTemp yy_modelToJSONObject] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself remoteFinsh:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself remoteFinsh:error];
        }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.seat.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.seat.name]];
        //        [service removeSeat:self.seat._id Target:self Callback:@selector(delFinish:)];
        
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] removeSeatsWithIds:@[ self.seat._id ] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself delFinish:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself delFinish:error];
        }];
    }
}

- (void)showHelpEvent
{
    [HelpDialog show:@"seat"];
}

@end
