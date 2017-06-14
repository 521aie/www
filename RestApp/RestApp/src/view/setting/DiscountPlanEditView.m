//
//  DiscountPlanEditView.m
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNode.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "FormatUtil.h"
#import "TreeBuilder.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "EditItemList.h"
#import "EditMultiList.h"
#import "EditItemRadio.h"
#import "EditItemView.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "TDFOptionPickerController.h"
#import "UIView+Sizes.h"
#import "DiscountPlan.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "GlobalRender.h"
#import "MBProgressHUD.h"
#import "SettingModule.h"
#import "TreeNodeUtils.h"
#import "DiscountDetail.h"
#import "ServiceFactory.h"
#import "MultiCheckView.h"
#import "RatioPickerBox.h"
#import "FooterListView.h"
#import "SettingService.h"
#import "NSString+Estimate.h"
#import "UserDiscountPlanVO.h"
#import "DiscountPlanRender.h"
#import "SettingModuleEvent.h"
#import "DiscountPlanListView.h"
#import "DiscountPlanEditView.h"
#import "DiscountDetailEditView.h"
#import "DateUtils.h"
#import "YYModel.h"
#import "TDFSettingService.h"
#import "TDFLoginService.h"
#import "UIViewController+Picker.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFMediator+SettingModule.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
@interface DiscountPlanEditView()
@property (nonatomic, strong) EditItemRadio *rdoIsMonth;
@property (nonatomic, strong) EditItemList *lsDays;
@property (nonatomic, assign) BOOL isCashierVersion;
@end
@implementation DiscountPlanEditView
#pragma mark life cycle
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
    self.needHideOldNavigationBar = YES;
    [self configViews];
    [self initNotifaction];
    [self initNavigate];
    [self initMainView];
    self.menuRatioList = [[NSMutableArray alloc] init];
    self.kindRatioList = [[NSMutableArray alloc] init];
    self.item1s = [[NSMutableArray alloc] init];
    self.week = [[NSMutableArray alloc] init];
    [self.footView initDelegate:self btnArrs:nil];
//    [self loadData:self.discountPlan action:self.action];
    [self loadCashierVersion];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)configViews {
    [self.container insertSubview:self.rdoIsMonth aboveSubview:self.mlsWeek];
    [self.container insertSubview:self.lsDays aboveSubview:self.rdoIsMonth
     ];
}

#pragma notification 处理.
-(void) initNotifaction{
    
    [UIHelper initNotification:self.container event:Notification_UI_DiscountPlanEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_DiscountPlanEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_Kind_Multi_Select object:nil];
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"打折方案", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}
- (void) leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView{
    
    self.baseTitle.lblName.text = NSLocalizedString(@"基础设置", nil);
    [self.txtName initLabel:NSLocalizedString(@"方案名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsMode initLabel:NSLocalizedString(@"优惠方式", nil) withHit:nil delegate:self];
    [self.lsRadio initLabel:NSLocalizedString(@"▪︎ 折扣率(%)", nil) withHit:nil isrequest:YES delegate:self];
    [self.rdoIsRadio initLabel:NSLocalizedString(@"▪︎ 对设置了不允许打折的商品也打折", nil) withHit:nil delegate:self];
    [self.rdoIsAllKind initLabel:NSLocalizedString(@"所有商品折扣相同", nil) withHit:nil delegate:self];
    [self.mlsKind initLabel:NSLocalizedString(@"▪︎ 为个别分类设置不同的折扣率", nil) delegate:self];
    [self.mlsMenu initLabel:NSLocalizedString(@"▪︎ 为个别商品设置不同的折扣率", nil) delegate:self];
    [self.mlsMenu initDetail:nil];
    [self.rdoIsAllUser initLabel:NSLocalizedString(@"全部员工可使用此折扣", nil) withHit:nil delegate:self];
    [self.mlsUsers initLabel:NSLocalizedString(@"▪︎ 可使用此折扣的员工", nil) delegate:self];
    self.titleValid.lblName.text=NSLocalizedString(@"有效期设置", nil);
    [self.rdoIsDate initLabel:NSLocalizedString(@"在指定日期内有效", nil) withHit:nil delegate:self];
    [self.lsStartDate initLabel:NSLocalizedString(@"▪︎ 开始日期", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"▪︎ 结束日期", nil) withHit:nil delegate:self];
    [self.rdoIsTime initLabel:NSLocalizedString(@"在指定时间有效", nil) withHit:nil delegate:self];
    [self.lsStartTime initLabel:NSLocalizedString(@"▪︎ 开始时间", nil) withHit:nil delegate:self];
    [self.lsEndTime initLabel:NSLocalizedString(@"▪︎ 结束时间", nil) withHit:nil delegate:self];
    [self.rdoIsWeek initLabel:NSLocalizedString(@"在每周特定日期有效", nil) withHit:nil delegate:self];
    [self.mlsWeek initLabel:NSLocalizedString(@"▪︎ 日期", nil) delegate:self];

    
    self.lsMode.tag=DISCOUNTPLAN_MODE;
    self.rdoIsAllKind.tag=DISCOUNTPLAN_IS_ALL_KIND;
    self.mlsKind.tag=DISCOUNTPLAN_KIND_RATIO;
    self.mlsMenu.tag=DISCOUNTPLAN_MENU_RATIO;
    self.rdoIsAllUser.tag=DISCOUNTPLAN_IS_ALL_USER;
    self.mlsUsers.tag=DISCOUNTPLAN_USERS;
    self.lsRadio.tag=DISCOUNTPLAN_RATIO;
    self.rdoIsDate.tag=DISCOUNTPLAN_IS_DATE;
    self.lsStartDate.tag=DISCOUNTPLAN_STARTDATE;
    self.lsEndDate.tag=DISCOUNTPLAN_ENDDATE;
    self.rdoIsTime.tag=DISCOUNTPLAN_IS_TIME;
    self.lsStartTime.tag=DISCOUNTPLAN_STARTTIME;
    self.lsEndTime.tag=DISCOUNTPLAN_ENDTIME;
    self.rdoIsWeek.tag=DISCOUNTPLAN_IS_WEEK;
    self.mlsWeek.tag=DISCOUNTPLAN_WEEKS;
}

#pragma remote

#pragma mark  cashier version
-(void)loadCashierVersion{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    //版本控制
    [[[TDFLoginService alloc] init]cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4Discount" }
                                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                         @strongify(self);
                                                         [self.progressHud hide:YES];
                                                         id obj = [data objectForKey:@"data"];
                                                         self.isCashierVersion = obj !=nil && [obj boolValue];
                                                        [self.rdoIsMonth visibal:self.isCashierVersion ];
                                                        [self.lsDays visibal:[self.rdoIsMonth getVal]];
                                                        [self loadData:self.discountPlan action:self.action];
                                                     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                         [self.progressHud hide:YES];
                                                         [AlertBox show:error.localizedDescription];
                                                     }];
}

-(void) loadData:(DiscountPlan*) objTemp action:(int)action
{
    self.action=action;
    self.discountPlan=objTemp;
    NSString* planId=self.discountPlan==nil?@"":self.discountPlan._id;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加打折方案", nil);
        [self clearDo];
    } else {
        [self cleanDO];
        self.title=self.discountPlan.name;
    }
    NSDate *dateNow = [NSDate date];
    NSString *dateStr = [DateUtils formatTimeWithDate:dateNow type:TDFFormatTimeTypeYearMonthDay];
    [self.lsStartDate initData:dateStr withVal:dateStr];
    [self.lsEndDate initData:dateStr withVal:dateStr];
    

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] editDiscountPlanItemId:planId sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self remoteLoadEdits:data];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 数据层处理
-(void) clearDo
{
    [self initDateComp];
    [self.txtName initData:nil];
    [self.lsMode initData:NSLocalizedString(@"打折", nil) withVal:[NSString stringWithFormat:@"%d",MODE_RADIO]];
    [self.lsRadio initData:@"100" withVal:@"100"];
    [self.rdoIsRadio initData:@"0"];
    [self.rdoIsAllKind initData:@"1"];
    [self.mlsKind initData:nil];
    [self.mlsMenu initData:nil];
    [self.mlsWeek initData:nil];
    [self.rdoIsAllUser initData:@"1"];
    [self.mlsUsers initData:nil];
    [self refreshUI:YES];
    [self.mlsKind visibal:NO];
    [self.mlsMenu visibal:NO];
    [self.mlsUsers visibal:NO];
    [self.mlsWeek visibal:NO];
    [self.lsStartTime initData:nil withVal:nil];
    [self.lsEndTime initData:nil withVal:nil];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)cleanDO
{
    [self.mlsUsers initData:nil];
}
-(void) fillModel
{
    
    [self.txtName initData:self.discountPlan.name];
    NSString* modeId=[NSString stringWithFormat:@"%d",self.discountPlan.isMemberPrice];
    [self.lsMode initData:[GlobalRender obtainItem:[DiscountPlanRender listMode] itemId:modeId] withVal:modeId];
    NSString* ratioStr=[FormatUtil formatInt:self.discountPlan.ratio];
    if (![ratioStr isEqualToString:@"0"]) {
        [self.lsRadio initData:ratioStr withVal:ratioStr];
    }
    [self.rdoIsRadio initData:[NSString stringWithFormat:@"%d",self.discountPlan.isRatioDiscount]];
    [self refreshUI:(self.discountPlan.isMemberPrice==0)];
    BOOL isAllKind=(self.discountDetailList==nil || [self.discountDetailList count]==0);
    
    [self.rdoIsAllKind initData:isAllKind?@"1":@"0"];
    [self.mlsKind initData:self.kindRatioList];
    [self.mlsMenu initData1:self.menuRatioList];
    [self.mlsKind visibal:(![self.rdoIsAllKind getVal] && [self.lsMode getStrVal].intValue==0)];
    [self.mlsMenu visibal:(![self.rdoIsAllKind getVal] && [self.lsMode getStrVal].intValue==0)];
    BOOL isAllUser=(self.discountPlan.isAuthority==0);
    
    [self.rdoIsAllUser initData:isAllUser?@"1":@"0"];
    if (self.discountPlan && self.discountPlan.isAuthority==1) {
        [self.mlsUsers initData:self.userDiscountPlanVOList];
    }
    [self.mlsUsers visibal:!isAllUser];
    [self initDateComp];
    [self fillDetail:self.discountPlan];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
-(void) fillDetail:(DiscountPlan*)discountPlan
{
    
    BOOL showDate=(discountPlan.isDate==1);
    BOOL showTime=(discountPlan.isTime==1);
    BOOL showWeek=([NSString isNotBlank:discountPlan.weekDay]);
    if (showWeek == NO) {
        [self.mlsWeek initData:nil];
    }
    [self isShowDate:showDate];
    [self isShowTime:showTime];
    [self isShowWeek:showWeek];
    
    [self.rdoIsDate initData:showDate?@"1":@"0"];
    
    [self.rdoIsTime initData:showTime?@"1":@"0"];
    [self.rdoIsWeek initData:showWeek?@"1":@"0"];
    
    if (showDate) {
        if (discountPlan.startDate!=nil) {
//            NSString *startDate2=(NSString *)discountPlan.startDate;
            NSString *startDate2  = [NSString stringWithFormat:@"%@",discountPlan.startDate];
//            NSString *startDate1 = [startDate2 substringWithRange:NSMakeRange(0,10)];
            NSString *startDateStr  = [DateUtils formatTimeWithTimestamp:startDate2.integerValue type:TDFFormatTimeTypeYearMonthDay];
            [self.lsStartDate initData:startDateStr withVal:startDateStr];
        } else {
            [self.lsStartDate initData:nil withVal:nil];
        }
        if (discountPlan.endDate!=nil) {
//            NSString* endDate2=(NSString *)discountPlan.endDate;
            NSString *endDate2  = [NSString stringWithFormat:@"%@",discountPlan.endDate];
           // NSString *endDate1 = [endDate2 substringWithRange:NSMakeRange(0,10)];
             NSString *endDateStr  = [DateUtils formatTimeWithTimestamp:endDate2.integerValue type:TDFFormatTimeTypeYearMonthDay];
            [self.lsEndDate initData:endDateStr withVal:endDateStr];
        } else {
            [self.lsEndDate initData:nil withVal:nil];
        }
    }
    if (showTime) {
        NSString* startTime=[DateUtils formatTimeWithSecond:discountPlan.startTime];
        NSString *startTime1=[NSString stringWithFormat:@"%d",discountPlan.startTime];
        [self.lsStartTime initData:startTime withVal:startTime1];
        
        NSString* endTime=[DateUtils formatTimeWithSecond:discountPlan.endTime];
        NSString *endTime1=[NSString stringWithFormat:@"%d",discountPlan.endTime];
        [self.lsEndTime initData:endTime withVal:endTime1];
    }else
    {
        [self isShowTime:NO];
        [self.lsStartTime initData:nil withVal:nil];
        [self.lsEndTime initData:nil withVal:nil];
    }
    if (showWeek == NO) {
        [self.week removeAllObjects];
    }
    if (showWeek) {
        NSString* weekStr=discountPlan.weekDay;
        if ([NSString isBlank:weekStr]) {
            [self.mlsWeek initData:nil];
        } else {
            NSArray* arr=[weekStr componentsSeparatedByString:@","];
            NSMutableArray* list=[NSMutableArray array];
            NameItemVO* itemVO=nil;
            for (NSString* week in arr) {
                itemVO=[GlobalRender getItem:[GlobalRender listWeeks] withId:week];
                [list addObject:itemVO];
            }
            [self.mlsWeek initData:list];
        }
    }
    if (self.isCashierVersion) {
        BOOL isMonth = [NSString isNotBlank:discountPlan.monthDay];
        NSArray *days = [discountPlan.monthDay componentsSeparatedByString:@","];
        [self.rdoIsMonth initShortData:isMonth];
        [self.lsDays initHit:discountPlan.monthDay];
        if (isMonth) {
            [self.lsDays initData:[NSString stringWithFormat:NSLocalizedString(@"%ld项", nil),days.count] withVal:discountPlan.monthDay];
        }else{
            [self.lsDays initData:NSLocalizedString(@"0项", nil) withVal:nil];
        }
        [self.lsDays.lblDetail setRight:self.scrollView.frame.size.width-10];
        [self.lsDays visibal:[self.rdoIsMonth getVal]];

    }
  
}

-(void) initDateComp
{
    [self.rdoIsDate initData:@"0"];
    [self isShowDate:NO];
    
    [self.rdoIsTime initData:@"0"];
    [self isShowTime:NO];
    
    [self.rdoIsWeek initData:@"0"];
    [self isShowWeek:NO];
}

-(void) isShowDate:(BOOL)visibal
{
    [self.lsStartDate visibal:visibal];
    [self.lsEndDate visibal:visibal];
}

-(void) isShowTime:(BOOL)visibal
{
    [self.lsStartTime visibal:visibal];
    [self.lsEndTime visibal:visibal];
}

-(void) isShowWeek:(BOOL)visibal
{
    [self.mlsWeek visibal:visibal];
}

-(void) refreshUI:(BOOL)visibal
{
    [self.rdoIsAllKind visibal:visibal];
    [self.lsRadio visibal:visibal];
    [self.mlsKind visibal:visibal];
    [self.mlsMenu visibal:visibal];
    [self.rdoIsRadio visibal:visibal];
}



#pragma UI处理.
#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        if ([UIHelper currChange:self.container]) {
            [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
            [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        }else{
            [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
            [self configRightNavigationBar:nil rightButtonName:@""];
        }
    }
}

-(void) remoteLoadEdits:(id) data
{
    NSDictionary* map= data [@"data"];
    NSArray *list = [map objectForKey:@"discountDetailVo"];
    
    self.discountDetailList=[JsonHelper transList:list objName:@"DiscountDetail"];
    self.discountDetailList1=[JsonHelper transList:list objName:@"SampleMenuVO"];
    [self.kindRatioList removeAllObjects];
    for (DiscountDetail *discountDetail in self.discountDetailList) {
        if (discountDetail.type == 0) {
            [self.kindRatioList addObject:discountDetail];
        }
    }
    [self.menuRatioList removeAllObjects];
    for (SampleMenuVO *menu in self.discountDetailList1) {
        if (menu.type == 1) {
            [self.menuRatioList addObject:menu];
        }
    }
    list = [map objectForKey:@"userDiscountPlanVos"];
    self.userDiscountPlanVOList=[JsonHelper transList:list objName:@"UserDiscountPlanVO"];
    
    list = [map objectForKey:@"emptyUsers"];
    self.userVOList=[JsonHelper transList:list objName:@"UserVO"];
    
    list = [map objectForKey:@"kindMenuVos"];
    NSMutableArray* kindMenus=[JsonHelper transList:list objName:@"KindMenu"];
    if (kindMenus==nil) {
        kindMenus=[NSMutableArray array];
    }
    self.treeNodeTemps=[TreeBuilder buildTree:kindMenus];
    self.headList=[TreeNodeUtils convertAllNode:self.treeNodeTemps];
    
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self fillModel];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

-(void) pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [dic setObject:self.treeNodeTemps forKey:@"allNode_list"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Data_Multi_Select object:dic] ;
}
-(void) kindChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.headList=[dic objectForKey:@"head_list"];
    self.treeNodeTemps=[dic objectForKey:@"allNode_list"];
}
#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj.tag==DISCOUNTPLAN_MODE) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[DiscountPlanRender listMode]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {

            [wself pickOption:[DiscountPlanRender listMode][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
        
    } else if (obj.tag==DISCOUNTPLAN_RATIO) {
        NSInteger ratio=100;
        if ([NSString isNotBlank:[obj getStrVal]]) {
            ratio=[obj getStrVal].intValue;
        }
        [RatioPickerBox initData:ratio];
        [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==DISCOUNTPLAN_STARTDATE || obj.tag==DISCOUNTPLAN_ENDDATE) {
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj mininumDate:nil maxinumDate:nil completionBlock:^(NSDate *date) {
            NSString *dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
            [obj changeData:dateStr withVal:dateStr];

        }];
    } else if (obj.tag==DISCOUNTPLAN_STARTTIME || obj.tag==DISCOUNTPLAN_ENDTIME) {
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeTime editItem:obj mininumDate:nil maxinumDate:nil completionBlock:^(NSDate *date) {
            
            NSString *timeStr = [DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute];
            NSString *timeStr1 = [NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]];
            [obj changeData:timeStr withVal:timeStr1];
        }];
    }else if (obj.tag == DISCOUNTPLAN_DAYS){
        BOOL isDays = [NSString isNotBlank:[obj getStrVal]];
        __weak typeof (self)wSelf = self;
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_tdfScheduleDateViewControllerWithData:isDays?[[obj getStrVal] componentsSeparatedByString:@","]:nil selectCompletion:^(NSArray *datas) {
            
            datas =[datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if([obj1 integerValue] > [obj2 integerValue]){
                    return NSOrderedDescending;
                }else if ([obj1 integerValue] < [obj2 integerValue]){
                    return NSOrderedAscending;
                }
                else{
                    return NSOrderedSame;}
            }];
            [wSelf.lsDays changeData:[NSString stringWithFormat:NSLocalizedString(@"%ld项", nil),datas.count] withVal:[datas componentsJoinedByString:@","]];
            [wSelf.lsDays initHit:[datas componentsJoinedByString:@","]];
            [wSelf.lsDays.lblDetail setRight:self.scrollView.frame.size.width-10];
            [UIHelper refreshUI:wSelf.container scrollview:wSelf.scrollView];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==DISCOUNTPLAN_MODE) {
        NameItemVO* vo=(NameItemVO*)selectObj;
        [self.lsMode changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        [self refreshUI:[self.lsMode getStrVal].intValue==0];
        [self.mlsKind visibal:(![self.rdoIsAllKind getVal] && [self.lsMode getStrVal].intValue==0)];
        [self.mlsMenu visibal:(![self.rdoIsAllKind getVal] && [self.lsMode getStrVal].intValue==0)];
    } else {
        NSString* result=(NSString*)selectObj;
        [self.lsRadio changeData:result withVal:result];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

//多选List控件变换.
-(void) onMultiItemListClick:(EditMultiList*)obj
{
    if (obj.tag==DISCOUNTPLAN_KIND_RATIO) {
        double ratio=100;
        if ([NSString isNotBlank:[self.lsRadio getStrVal]]) {
            ratio=[self.lsRadio getStrVal].doubleValue;
        }
        [self dealKindData:ratio];
          @weakify(self);
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMeditor_DiscountDetailEditViewControllerWithData:self.allDetailList
                                                                                                                       radio:ratio
                                                                                                    needHideOldNavigationBar:YES CallBack:^(NSMutableArray *items){
                                                                   @strongify(self);                                      [self refreshKind:items];
                                                                                }];
        [self.navigationController pushViewController:viewController animated:YES];

    }else if (obj.tag==DISCOUNTPLAN_MENU_RATIO) {
        NSString * ratio = @"100";
        if ([NSString isNotBlank:[self.lsRadio getStrVal]]) {
            ratio=[self.lsRadio getStrVal];
        }
          @weakify(self);
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMeditor_DiscountMenuDetailEditViewControllerWithData:self.menuRatioList radio:ratio needHideOldNavigationBar:YES CallBack:^(NSMutableArray *items) {
             @strongify(self);
            [self refreshMenu:items];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (obj.tag==DISCOUNTPLAN_USERS) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:obj.tag delegate:self title:NSLocalizedString(@"选择员工", nil) dataTemps:self.userVOList selectList:self.userDiscountPlanVOList needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (obj.tag==DISCOUNTPLAN_WEEKS) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:obj.tag delegate:self title:NSLocalizedString(@"选择特定日期", nil) dataTemps:[GlobalRender listWeeks] selectList:[obj getCurrList] needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 分类折扣率设置完成.
-(void) refreshKind:(NSMutableArray*)arrs
{
    self.kindRatioList=arrs;
    [self.mlsKind changeData:self.kindRatioList];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma 商品折扣率设置完成.
-(void) refreshMenu:(NSMutableArray*)arrs
{
    self.menuRatioList=arrs;
    [self.mlsMenu changeData1:self.menuRatioList];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) dealKindData:(double)ratio
{
    self.allDetailList=[NSMutableArray array];
    DiscountDetail* detail;
    for (TreeNode* node in self.headList) {
        detail=[DiscountDetail new];
        detail.kindMenuId=node.itemId;
        detail.menuKindName=[node obtainOrignName];
        detail.ratio=[self getKindMenuRadio:self.kindRatioList kId:node.itemId defaultVal:ratio];
        [self.allDetailList addObject:detail];
    }
}

-(double)getKindMenuRadio:(NSMutableArray*) discountDetails kId:(NSString*)kindMenuId defaultVal:(double)ratio
{
    if (discountDetails==nil || [discountDetails count]==0) {
        return ratio;
    }
    for (DiscountDetail* detail in discountDetails) {
        if ([detail.kindMenuId isEqualToString:kindMenuId]) {
            return detail.ratio;
        }
    }
    return ratio;
}

//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    if (obj.tag==DISCOUNTPLAN_IS_ALL_KIND) {
        [self.mlsKind visibal:![obj getVal]];
        [self.mlsMenu visibal:![obj getVal]];
    } else if (obj.tag==DISCOUNTPLAN_IS_ALL_USER) {
        [self.mlsUsers visibal:![obj getVal]];
    }
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
    if (obj.tag==DISCOUNTPLAN_IS_DATE) {
        [self isShowDate:result];
        self.date = result;
        
    } else if (obj.tag==DISCOUNTPLAN_IS_TIME) {
        [self isShowTime:result];
    } else if (obj.tag==DISCOUNTPLAN_IS_WEEK) {
        [self isShowWeek:result];
    }else if(obj.tag == DISCOUNTPLAN_IS_MONTH){
        [self.lsDays visibal:[obj getVal]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 多选页结果处理.
- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==DISCOUNTPLAN_STARTTIME) {
        NSString *timeStr = [DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute];
        NSString *timeStr1 = [NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]];
        NSString *timeStr2 = [timeStr substringWithRange:NSMakeRange(0,2)];
        NSString *timeStr3 = [timeStr substringWithRange:NSMakeRange(3,2)];
        if ([timeStr2 isEqualToString:@"00"]) {
            timeStr =[NSString stringWithFormat:@"12:%@",timeStr3];
            
        }
        else if ([timeStr2 isEqualToString:@"12"]) {
            timeStr =[NSString stringWithFormat:@"00:%@",timeStr3];
            
        }
        [self.lsStartTime changeData:timeStr withVal:timeStr1];
    } else {
        NSString *timeStr = [DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute];
        NSString *timeStr1 = [NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]];
        NSString *timeStr2 = [timeStr substringWithRange:NSMakeRange(0,2)];
        NSString *timeStr3 = [timeStr substringWithRange:NSMakeRange(3,2)];
        if ([timeStr2 isEqualToString:@"00"]) {
            timeStr =[NSString stringWithFormat:@"12:%@",timeStr3] ;
            
        }
        else if ([timeStr2 isEqualToString:@"12"]) {
            timeStr =[NSString stringWithFormat:@"00:%@",timeStr3];
            
        }
        [self.lsEndTime changeData:timeStr withVal:timeStr1];
    }
    return YES;
}
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString *dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    if (event==DISCOUNTPLAN_STARTDATE) {
        [self.lsStartDate changeData:dateStr withVal:dateStr];
    } else {
        [self.lsEndDate changeData:dateStr withVal:dateStr];
    }
    return YES;
}

-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
    if (event==DISCOUNTPLAN_WEEKS) {
        [self.mlsWeek changeData:items];
        self.week = items;
    }
    if(event==DISCOUNTPLAN_USERS){
        self.userDiscountPlanVOList=[NSMutableArray array];
        UserDiscountPlanVO* vo=nil;
        if (items && [items count]>0) {
            for (id<INameItem> item in items) {
                vo=[UserDiscountPlanVO new];
                vo.userId=[item obtainItemId];
                vo.userName=[item obtainItemName];
                [self.userDiscountPlanVOList addObject:vo];
            }
        }
        [self.mlsUsers changeData:self.userDiscountPlanVOList];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)closeMultiView:(NSInteger)event
{

}


#pragma save-data
-(BOOL)isValid
{
    
    if ([self.rdoIsMonth getVal]&& [self.rdoIsWeek getVal]) {
        [AlertBox show:NSLocalizedString(@"您设置的有效期存在冲突，请重新设置", nil)];
        return NO;
    }
    
    NSDate *startDate = [DateUtils DateWithString:[self.lsStartDate getStrVal] type:TDFFormatTimeTypeYearMonthDayString];
    NSDate *endDate = [DateUtils DateWithString:[self.lsEndDate getStrVal] type:TDFFormatTimeTypeYearMonthDayString];
    
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    if (endTime < startTime) {
        [AlertBox show:NSLocalizedString(@"开始日期不能晚于结束日期", nil)];
        return NO;
    }
    
    NSInteger period = (endTime - startTime)/(24*3600);
    
    if (period<7.0 && [self.rdoIsDate getVal]==YES) {
        NSMutableArray *weekDayList = [[NSMutableArray alloc]init];
        for (int i=0;i<=period;++i) {
            NSDate *date = [startDate dateByAddingTimeInterval:i*24*3600];
            NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
            NSString *dayString = [NSString stringWithFormat:@"%li", (long)dateComponents.weekday];
            [weekDayList addObject:dayString];
        }
        
        if ([ObjectUtil isNotEmpty:self.week]) {
            BOOL isWeekValid = NO;
            for (NameItemVO *nameItem in self.week) {
                if ([weekDayList containsObject:[nameItem obtainItemId]]) {
                    isWeekValid = YES;
                    break;
                }
            }
            if (isWeekValid==NO) {
                [AlertBox show:NSLocalizedString(@"您设置的有效期存在冲突，请重新设置", nil)];
                return NO;
            }
        }
    }
    
    NSInteger dateIntelval = [endDate timeIntervalSinceDate:startDate]/(3600*24);
    NSMutableArray *days = [NSMutableArray new];
    if (dateIntelval <= 60  && [self.rdoIsDate getVal]&&[self.rdoIsMonth getVal]&&[NSString isNotBlank:[self.lsDays getStrVal]]) {
        for (NSInteger i = 0; i < dateIntelval+1; i++) {
            NSDate *date = [NSDate dateWithTimeInterval:i*3600*24 sinceDate:startDate];
                NSCalendar* calendar=[NSCalendar currentCalendar];
                NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:date];
                [days addObject:[NSString stringWithFormat:@"%ld",comps.day]];
        }
        NSArray *selectDays = [[self.lsDays getStrVal] componentsSeparatedByString:@","];
        if (![[NSSet setWithArray:selectDays] intersectsSet:[NSSet setWithArray:days]]) {
            [AlertBox show:NSLocalizedString(@"您设置的有效期存在冲突，请重新设置", nil)];
            return NO;
        }
    }
    
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"方案名称不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsMode getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"优惠方式不能为空!", nil)];
        return NO;
    }
    if ([self.lsMode getStrVal].intValue==MODE_RADIO) {
        if ([NSString isBlank:[self.lsRadio getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"折扣率(%)不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isPositiveNum:[self.lsRadio getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"折扣率(%)不是数字!", nil)];
            return NO;
        }
        int radio=[self.lsRadio getStrVal].intValue;
        if (radio>100 || radio<0) {
            [AlertBox show:NSLocalizedString(@"折扣率(%)只能输入[0-100]的数字!", nil)];
            return NO;
        }
        
    }
    if (![self.rdoIsAllUser getVal] && (self.userDiscountPlanVOList==nil || [self.userDiscountPlanVOList count]==0)) {
        [AlertBox show:NSLocalizedString(@"请选择可以使用当前打折方案的员工!", nil)];
        return NO;
    }
    return YES;
}




-(DiscountPlan*) transMode{
    DiscountPlan* tempUpdate=[DiscountPlan new];
    if (self.action == ACTION_CONSTANTS_EDIT) {
          tempUpdate.lastVer =  self.discountPlan.lastVer;
    }
    tempUpdate.name=[self.txtName getStrVal];
    if ([self.lsMode getStrVal].intValue==0) {
        tempUpdate.ratio=[self.lsRadio getStrVal].doubleValue;
    }else{
        tempUpdate.ratio=100;
    }
    tempUpdate.monthDay = [self.rdoIsMonth getVal]?[self.lsDays getStrVal]:@"";
    tempUpdate.isAuthority=[self.rdoIsAllUser getVal]?0:1;
    tempUpdate.isMemberPrice=[self.lsMode getStrVal].intValue;
    tempUpdate.isRatioDiscount=[self.rdoIsRadio getStrVal].intValue;
    BOOL isDate=[self.rdoIsDate getVal];
    BOOL isTime=[self.rdoIsTime getVal];
    tempUpdate.isDate=isDate?1:0;
    tempUpdate.isTime=isTime?1:0;
    if (isDate) {
        if ([NSString isNotBlank:[self.lsStartDate getStrVal]]) {
            NSString *startDateStr = [NSString stringWithFormat:@"%@ 00:00:00", [self.lsStartDate getStrVal]];
            tempUpdate.startDate=[DateUtils DateWithString:startDateStr type:TDFFormatTimeTypeAllTimeString];
        }
        if ([NSString isNotBlank:[self.lsEndDate getStrVal]]) {
            NSString *endDateStr=[NSString stringWithFormat:@"%@ 00:00:00", [self.lsEndDate getStrVal]];
            tempUpdate.endDate=[DateUtils DateWithString:endDateStr type:TDFFormatTimeTypeAllTimeString];
        }
    }
    if (isTime) {
        if ([NSString isNotBlank:[self.lsStartTime getStrVal]]) {
            tempUpdate.startTime=[self.lsStartTime getStrVal].intValue;
        }
        if ([NSString isNotBlank:[self.lsEndTime getStrVal]]) {
            tempUpdate.endTime=[self.lsEndTime getStrVal].intValue;
        }
    }
    BOOL isWeek=[self.rdoIsWeek getVal];
    if (!isWeek) {
        tempUpdate.weekDay=@"";
        return tempUpdate;
    }
    NSMutableArray* weeks=[self.mlsWeek getCurrList];
    if (weeks && [weeks count]>0) {
        NSMutableArray *weekIds=[NSMutableArray array];
        for (id<INameItem> item in weeks) {
            [weekIds addObject:[item obtainItemId]];
        }
        tempUpdate.weekDay=[weekIds componentsJoinedByString:@","];
    }else{
        tempUpdate.weekDay=@"";
    }
    return tempUpdate;
    
}

-(NSMutableArray*) getUserIds
{
    NSMutableArray* list=[NSMutableArray array];
    if ([self.rdoIsAllUser getVal] || self.userDiscountPlanVOList==nil || [self.userDiscountPlanVOList count]==0) {
        return list;
    }
    for (UserDiscountPlanVO* vo in self.userDiscountPlanVOList) {
        [list addObject:vo.userId];
    }
    return list;
}

-(NSMutableArray*) getKindRatio
{
    NSMutableArray* list=[NSMutableArray array];
    if ([self.rdoIsAllKind getVal] || self.kindRatioList==nil || [self.kindRatioList count]==0) {
        return list;
    }
    NSString* result=nil;
    for (DiscountDetail* vo in self.kindRatioList) {
        result=[NSString stringWithFormat:@"%@|%@",vo.kindMenuId,[FormatUtil formatInt:vo.ratio]];
        [list addObject:result];
    }
    return list;
}
-(NSMutableArray*) getMenuRatio
{
    NSMutableArray* list=[NSMutableArray array];
    if ([self.rdoIsAllKind getVal] || self.menuRatioList==nil || [self.menuRatioList count]==0) {
        return list;
    }
    NSString* result=nil;
    for (SampleMenuVO* vo in self.menuRatioList) {
        result=[NSString stringWithFormat:@"%@|%@",vo._id,[FormatUtil formatInt:vo.ratio]];
        [list addObject:result];
    }
    return list;
}


-(void)save{
    if (![self isValid]) {
        return;
    }
    DiscountPlan* objTemp=[self transMode];
    NSMutableArray* userIds=[self getUserIds];
    NSMutableArray* kindIds=[self getKindRatio];
    NSMutableArray* menuIds=[self getMenuRatio];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@打折方案", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];

    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [[TDFSettingService new] saveDiscountPlan:objTemp isAllKind:[self.rdoIsAllKind getStrVal] userIds:userIds kindIds:kindIds menuIds:menuIds sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud setHidden:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        objTemp.id = self.discountPlan._id;
        [[TDFSettingService new] updateDiscountPlan:objTemp isAllKind:[self.rdoIsAllKind getStrVal] userIds:userIds kindIds:kindIds menuIds:menuIds sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
           [self.progressHud setHidden:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.discountPlan.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.discountPlan.name]];
        NSArray *idList = [[NSArray alloc] initWithObjects:self.discountPlan._id, nil];
        NSString *idStr  = [idList yy_modelToJSONString];
        [[TDFSettingService new] removeDiscountPlan:idStr sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud setHidden:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}
-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"discountplan"];
}

#pragma mark getter 
-(EditItemRadio *)rdoIsMonth{
    if (!_rdoIsMonth) {
        _rdoIsMonth = [[EditItemRadio alloc]initWithFrame:self.mlsWeek.frame];
        [_rdoIsMonth awakeFromNib];
        [_rdoIsMonth initLabel:NSLocalizedString(@"在每月特定日期有效", nil) withHit:nil delegate:self];
        [_rdoIsMonth initShortData:0];
        _rdoIsMonth.tag = DISCOUNTPLAN_IS_MONTH;
    }
    return _rdoIsMonth;
}

-(EditItemList *)lsDays{
    if (!_lsDays) {
        _lsDays = [[EditItemList alloc]initWithFrame:self.rdoIsMonth.frame];
        [_lsDays awakeFromNib];
        [_lsDays initLabel:NSLocalizedString(@"▪︎ 日期", nil) withHit:nil delegate:self];
        [_lsDays initData:NSLocalizedString(@"0项", nil) withVal:nil];
        [_lsDays.lblDetail setRight:self.scrollView.frame.size.width-10];
        _lsDays.tag = DISCOUNTPLAN_DAYS;
        [_lsDays visibal:NO];
    }
    return _lsDays;
}
@end

