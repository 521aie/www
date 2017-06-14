//
//  SeatListView.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SeatListView.h"
#import "ServiceFactory.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "SeatListPanel.h"
#import "FooterListView.h"
#import "SingleCheckView.h"
#import "TableEditView.h"
#import "AreaListView.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "RemoteResult.h"
#import "SeatEditView.h"
#import "MBProgressHUD.h"
#import "RestConstants.h"
#import "MailInputBox.h"
#import "UIView+Sizes.h"
#import "PropertyList.h"
#import "RemoteEvent.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "SeatModule.h"
#import "HelpDialog.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "Platform.h"
#import "Area.h"
#import "TDFTableEditViewController.h"
#import "AppDelegate.h"
#import "TDFTableQuickBindViewController.h"
#import "TDFSeatService.h"
#import "UIViewController+HUD.h"
#import <YYModel/YYModel.h>
#import "TDFOptionPickerController.h"
#import "TDFMediator+SettingModule.h"
#import "TDFMediator+SeatModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SeatListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self.view addSubview:self.seatListPanel];
    [self.view addSubview:self.btnBg];
    self.title = NSLocalizedString(@"桌位", nil);
    self.needHideOldNavigationBar = YES;
    [self initNotification];
    [self initMainView];
    [self loadSeat];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadSeat)
                                                 name:@"TDFSeatChanged"
                                               object:nil];

}

- (SeatListPanel *)seatListPanel {
    if(!_seatListPanel) {
        _seatListPanel = [[SeatListPanel alloc] init];
        [_seatListPanel awakeFromNib];
        _seatListPanel.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return _seatListPanel;
}

- (UIButton *)btnBg {
    if(!_btnBg) {
        _btnBg = [[UIButton alloc] init];
        _btnBg.hidden = YES;
        _btnBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_btnBg addTarget:self action:@selector(btnBgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBg;
}

#pragma navigateBar
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    self.titleBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"桌位", nil) backImg:Head_ICON_BACK moreImg:nil];
}

#pragma 通知相关.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:SeatModule_Data_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:SeatModule_Area_Change object:nil];
}

- (void)initMainView
{
    selectAreaPanel = [[SelectAreaPanel alloc]initWithNibName:@"SelectAreaPanel" bundle:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:selectAreaPanel.view];
    CGRect selectAreaPanelFrame = selectAreaPanel.view.frame;
    selectAreaPanelFrame.origin.x = SCREEN_WIDTH;
    selectAreaPanelFrame.size.height = SCREEN_HEIGHT;
    selectAreaPanel.view.frame = selectAreaPanelFrame;
    
    self.managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.managerButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0);
    self.managerButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.managerButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.managerButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.managerButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.managerButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.managerButton setTitle:NSLocalizedString(@"区域", nil) forState:UIControlStateNormal];
    [self.managerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.managerButton addTarget:self action:@selector(selectPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerButton];
    
    [self.seatListPanel initDelegate:self headChange:SeatModule_Area_Change detailChange:SeatModule_Data_Change];
    [self.seatListPanel setBackgroundColor:[UIColor clearColor]];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd|TDFFooterButtonTypeHelp|TDFFooterButtonTypeBatch|TDFFooterButtonTypeSort];
}

- (void)selectPanel:(UIButton *)button
{
    self.isOpen = !self.isOpen;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    
    if (isOpen == YES) {
        [self showSelectArea];
        [self animationMoveIn:self.managerButton backround:self.btnBg];
    }else
    {
        [self.btnBg removeFromSuperview];
        [XHAnimalUtil animationMoveOut:selectAreaPanel.view backround:self.btnBg];
        [self animationMoveOut:self.managerButton backround:self.btnBg];
    }
}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - selectAreaPanel.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.5;
    [UIView commitAnimations];
    
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:selectAreaPanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
    [super leftNavigationButtonAction:sender];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self showSelectArea];
}

#pragma 数据加载.
- (void)loadSeat
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    //    [service listSeat:nil key:nil Target:self Callback:@selector(loadSeatFinish:)];
    
    __typeof(self) wself = self;
    [[[TDFSeatService alloc] init] areasAndSeatsWithSucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        __strong __typeof(wself) sself = wself;
        [wself.progressHud hide:YES];
        
        if (!sself) return;
        
        NSArray *areaArr = [data valueForKey:@"data"];
        
        sself.headList = [NSMutableArray array];
        sself.seatList = [NSMutableArray array];
        sself.detailMap = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in areaArr) {
            
            Area *area = [Area yy_modelWithDictionary:dict];
            [sself.headList addObject: area];
            NSArray *seats = [NSArray yy_modelArrayWithClass:[Seat class] json:dict[@"seats"]];
            [sself.seatList addObjectsFromArray:seats];
            sself.detailMap[area._id] = seats;
        }
        
        [sself pushNotification];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself.progressHud hide:YES];
        [wself showErrorMessage:[error localizedDescription]];
    }];
}

#pragma 右侧职级列表，定位使用.
- (void)showSelectArea
{
    [self.view addSubview:self.btnBg];
    [selectAreaPanel initDelegate:self event:11];
    [selectAreaPanel loadData:self.headList];
    [XHAnimalUtil animationMoveIn:selectAreaPanel.view backround:self.btnBg];
}

- (void)btnBgClick:(id)sender
{
    self.isOpen = NO;
}

#pragma 实现 FooterListEvent 协议
#pragma 添加桌位.

- (void)footerBatchButtonAction:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"将全部自动生成的桌位码发送到邮箱", nil), NSLocalizedString(@"批量绑定二维火提供已打印好的二维码", nil), nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (self.seatList!=nil && self.seatList.count>0) {
            [MailInputBox show:1 delegate:self title:NSLocalizedString(@"输入EMAIL地址", nil) val:[PropertyList readValue:SELF_MAIL_ADDR] isPresentMode:YES];
        } else {
            [AlertBox show:NSLocalizedString(@"请至少添加一个桌位!", nil)];
        }
    } else if (buttonIndex == 1) {
        
        TDFTableQuickBindViewController *bvc = [[TDFTableQuickBindViewController alloc] initWithSeatMap:self.detailMap areas:self.headList];
        [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:bvc animated:YES];
    }
}

- (void)finishInput:(NSInteger)event content:(NSString*)content
{
    NSMutableArray* codeList=[NSMutableArray array];
    for (Seat* seat in self.seatList) {
        [codeList addObject:seat.code];
    }
    [PropertyList updateValue:content forKey:SELF_MAIL_ADDR];
    [self showProgressHudWithText:NSLocalizedString(@"正在发送", nil)];
    NSMutableArray* mails=[NSMutableArray array];
    [mails addObject:content];
    //    [service mailSendQrCode:codeList mailAddress:mails Target:self Callback:@selector(mailSendFinish:)];
    
    __weak __typeof(self) wself = self;
    [[[TDFSeatService alloc] init] sendQRCodes:[codeList yy_modelToJSONString] toEmails:[mails yy_modelToJSONString] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself mailSendFinish:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself mailSendFinish:error];
    }];
}

- (void)singleCheck:(NSInteger)event item:(id<INameItem>) item
{
    Area *area = (Area *)item;
    [self.seatListPanel scrocll:area];
    self.isOpen = NO;
}

- (void)closeSingleView:(NSInteger)event
{
    [XHAnimalUtil animationMoveOut:selectAreaPanel.view backround:self.btnBg];
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_AreaListViewWithCallBack:^{
        @strongify(self);
        [self loadSeat];
        [self showSelectArea];
        [UIView animateWithDuration:0.25 animations:^{
            self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x + SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
            
            selectAreaPanel.view.frame = CGRectMake(SCREEN_WIDTH - selectAreaPanel.view.frame.size.width, selectAreaPanel.view.frame.origin.y, selectAreaPanel.view.bounds.size.width, selectAreaPanel.view.bounds.size.height);
            self.managerButton.frame = CGRectMake(self.managerButton.frame.origin.x + SCREEN_WIDTH, self.managerButton.frame.origin.y, self.managerButton.bounds.size.width, self.managerButton.bounds.size.height);
        }];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x - SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
        
        selectAreaPanel.view.frame = CGRectMake(selectAreaPanel.view.frame.origin.x - SCREEN_WIDTH-selectAreaPanel.view.frame.size.width, selectAreaPanel.view.frame.origin.y, selectAreaPanel.view.bounds.size.width, selectAreaPanel.view.bounds.size.height);
        self.managerButton.frame = CGRectMake(self.managerButton.frame.origin.x - SCREEN_WIDTH, self.managerButton.frame.origin.y, self.managerButton.bounds.size.width, self.managerButton.bounds.size.height);
    }];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SeatEditViewWithData:nil headList:self.headList action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadSeat];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"seatlist"];
}

- (void)footerSortButtonAction:(UIButton *)sender {
    self.action = ACTION_CONSTANTS_SORT;
    [self showSingleCheckView];
}

//- (void)showDelEvent
//{
//    self.action = ACTION_CONSTANTS_DEL;
//    [self showSingleCheckView];
//}

- (void)selectSeat:(Seat*) seat
{
    TDFTableEditViewController *vc = [[TDFTableEditViewController alloc] initWithSeat:seat scrollToQRCode:NO];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectObj:(id<IImageDataItem>) item
{
    
    TDFTableEditViewController *vc = [[TDFTableEditViewController alloc] initWithSeat:(Seat *)item scrollToQRCode:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma 实现 ISampleListEvent 协议
- (void)closeListEvent:(NSString*)event
{

}

- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    __weak __typeof(self) wself = self;
    [[[TDFSeatService alloc] init] removeSeatsWithIds:ids sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself delSeatFinish:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself delSeatFinish:error];
    }];
}

- (void)batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    //    [service removeSeats:ids Target:self Callback:@selector(delBatchSeatFinish:)];
    __weak __typeof(self) wself = self;
    [[[TDFSeatService alloc] init] removeSeatsWithIds:ids sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself delBatchSeatFinish:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself delBatchSeatFinish:error];
    }];
}
//
//- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids
//{
//    [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
//    [service removeSeats:ids Target:self Callback:@selector(delSeatFinish:)];
//}

//- (void)batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
//{
//    [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
//    [service removeSeats:ids Target:self Callback:@selector(delBatchSeatFinish:)];
//}
//
- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在提交", nil)];
    //    [service sortSeats:ids Target:self Callback:@selector(sortSeatFinish:)];
    __weak __typeof(self) wself = self;
    [[[TDFSeatService alloc] init] sortSeatsWithIds:ids sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself sortSeatFinish:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself sortSeatFinish:error];
    }];
}

#pragma test event
#pragma edititemlist click event.
- (void)showSingleCheckView
{
    NSString *titleName = [NSString stringWithFormat:NSLocalizedString(@"选择要%@桌位的区域", nil),self.action==ACTION_CONSTANTS_DEL?NSLocalizedString(@"删除", nil):NSLocalizedString(@"排序", nil)];
    //    [OptionPickerBox initData:self.headList itemId:nil];
    //    [OptionPickerBox show:titleName client:self event:self.action];
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:titleName
                                                                                  options:self.headList
                                                                            currentItemId:nil];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:wself.headList[index] event:self.action];
    };

    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    self.currentArea=(Area*)selectObj;
    NSMutableArray *seats = [[self.detailMap objectForKey:self.currentArea._id] mutableCopy];
    if (seats==nil || seats.count==0) {
        NSString* message=[NSString stringWithFormat:NSLocalizedString(@"区域[%@]中没有桌位!", nil),self.currentArea.name];
        [AlertBox show:message];
        return YES;
    }
    if (event==ACTION_CONSTANTS_DEL) {     //删除操作.
        //        [parent showView:TABLE_EDIT_VIEW];
        //        [parent.tableEditView initDelegate:self event:REMOTE_SEAT_LIST action:ACTION_CONSTANTS_DEL title:NSLocalizedString(@"桌位删除", nil)];
        //        [parent.tableEditView reload:seats error:nil];
        //        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
    } else {
        //保存操作.
        if ([ObjectUtil isNotEmpty:seats] && seats.count>=2) {
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:REMOTE_SEAT_LIST action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"桌位排序", nil) dataTemps:seats error:nil needHideOldNavigationBar:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        }
    }
    return YES;
}

- (void)mailSendFinish:(NSError *)result
{
    [self.progressHud hide:YES];
    
    if (result) {
        
        [self showErrorMessage:result.localizedDescription];
        return;
    }
    
    [self showErrorMessage:NSLocalizedString(@"二维码发送成功！", nil)];
}

- (void)sortSeatFinish:(NSError *)error
{
    
    [self.progressHud hide:YES];
    
    if (error) {
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    //    [self parseResult:result.content];
    [self loadSeat];
    [self pushNotification];
}

- (void)delSeatFinish:(NSError *)error
{
    [self.progressHud hide:YES];
    if (error) {
        
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    
    //    [self parseResult:result.content];
    
    //    NSMutableArray *seats = [self.detailMap objectForKey:self.currentArea._id];
    [self loadSeat];
}

- (void)delBatchSeatFinish:(NSError *)error
{
    
    [self.progressHud hide:YES];
    if (error) {
        
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    
    [self loadSeat];
}

- (void)loadSeatFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseResult:result.content];
}

- (void)parseResult:(NSString*)result
{
    NSDictionary *map=[JsonHelper transMap:result];
    NSArray *areaArrs = [map objectForKey:@"areas"];
    self.headList=[JsonHelper transList:areaArrs objName:@"Area"];
    
    NSArray *seatArrs = [map objectForKey:@"seats"];
    self.seatList=[JsonHelper transList:seatArrs objName:@"Seat"];
    self.detailMap=[[NSMutableDictionary alloc] init];
    NSMutableArray* arr=nil;
    
    if (self.seatList!=nil && self.seatList.count>0) {
        for (Seat* seat in self.seatList) {
            arr=[self.detailMap objectForKey:seat.areaId];
            if (!arr) {
                arr=[NSMutableArray array];
            } else {
                [self.detailMap removeObjectForKey:seat.areaId];
            }
            [arr addObject:seat];
            self.detailMap[seat.areaId] = arr;
        }
    }
    [self pushNotification];
}

- (void)pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SeatModule_Data_Change object:dic] ;
}

- (void)dataChange:(NSNotification*) notification
{
}

- (void)areaChange:(NSNotification*) notification
{
    self.headList=notification.object;
}
@end
