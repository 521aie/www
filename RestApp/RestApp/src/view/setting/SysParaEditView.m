//
//  SysParaEditView.m
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SysParaEditView.h"
#import "NavigateTitle.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "ItemBase.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "KindConfigConstants.h"
#import "ConfigConstants.h"
#import "RemoteEvent.h"
#import "TDFOptionPickerController.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "XHAnimalUtil.h"
#import "GlobalRender.h"
#import "ConfigRender.h"
#import "StrItemVO.h"
#import "TDFSettingService.h"
#import "MBProgressHUD.h"
#import "NSString+Estimate.h"
#import "SettingModuleEvent.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "ConfigVO.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SysParaEditView

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
    [self.view addSubview:self.scrollView];
    self.changed=NO;
    [self initNavigate];
    [self initMainView];
    [self initNotifaction];
    [self loadData];
}

#pragma mark - UI
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}
- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor clearColor];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.baseTitle];
        [_container addSubview:self.lsLanguage];
        [_container addSubview:self.rdoIsMultiOrder];
        [_container addSubview:self.rdoIsSeatLabel];
        [_container addSubview:self.rdoIsLimitTime];
        [_container addSubview:self.lsLimitTimeEnd];
        [_container addSubview:self.lsLimitTimeWarn];
        [_container addSubview:self.rdoIsConfirmRight];
        [_container addSubview:self.dishParaTitle];
        [_container addSubview:self.rdoMergeSendInstance];
        [_container addSubview:self.rdoMergeInstance];
        [_container addSubview:self.feeParaTitle];
        [_container addSubview:self.rdoServiceFee];
        [_container addSubview:self.rdoLowFee];
        [_container addSubview:self.rdoAdjustFee];
        
    }
    return _container;
}

- (ItemTitle *)baseTitle {
    if(!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] init];
        [_baseTitle awakeFromNib];
        _baseTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _baseTitle.backgroundColor = [UIColor clearColor];
    }
    return _baseTitle;
}

- (EditItemList *)lsLanguage {
    if(!_lsLanguage) {
        _lsLanguage = [[EditItemList alloc] init];
        _lsLanguage.frame = CGRectMake(0, 44, SCREEN_WIDTH, 48);
        _lsLanguage.backgroundColor = [UIColor clearColor];
    }
    return _lsLanguage;
}

- (EditItemRadio *)rdoIsMultiOrder {
    if(!_rdoIsMultiOrder) {
        _rdoIsMultiOrder = [[EditItemRadio alloc] init];
        _rdoIsMultiOrder.frame = CGRectMake(0, 92, SCREEN_WIDTH, 48);
        _rdoIsMultiOrder.backgroundColor = [UIColor clearColor];
    }
    return _rdoIsMultiOrder;
}

- (EditItemRadio *)rdoIsSeatLabel {
    if(!_rdoIsSeatLabel) {
        _rdoIsSeatLabel = [[EditItemRadio alloc] init];
        _rdoIsSeatLabel.frame = CGRectMake(0, 140, SCREEN_WIDTH, 48);
        _rdoIsSeatLabel.backgroundColor = [UIColor clearColor];
    }
    return _rdoIsSeatLabel;
}

- (EditItemRadio *)rdoIsLimitTime {
    if(!_rdoIsLimitTime) {
        _rdoIsLimitTime = [[EditItemRadio alloc] init];
        _rdoIsLimitTime.frame = CGRectMake(0, 188, SCREEN_WIDTH, 48);
        _rdoIsLimitTime.backgroundColor = [UIColor clearColor];
    }
    return _rdoIsLimitTime;
}

- (EditItemList *)lsLimitTimeEnd {
    if(!_lsLimitTimeEnd) {
        _lsLimitTimeEnd = [[EditItemList alloc] init];
        _lsLimitTimeEnd.frame = CGRectMake(0, 236, SCREEN_WIDTH, 48);
        _lsLimitTimeEnd.backgroundColor = [UIColor clearColor];
    }
    return _lsLimitTimeEnd;
}

- (EditItemList *)lsLimitTimeWarn {
    if(!_lsLimitTimeWarn) {
        _lsLimitTimeWarn = [[EditItemList alloc] init];
        _lsLimitTimeWarn.frame = CGRectMake(0, 284, SCREEN_WIDTH, 48);
        _lsLimitTimeWarn.backgroundColor = [UIColor clearColor];
    }
    return _lsLimitTimeWarn;
}

- (EditItemRadio *)rdoIsConfirmRight {
    if(!_rdoIsConfirmRight) {
        _rdoIsConfirmRight = [[EditItemRadio alloc] init];
        _rdoIsConfirmRight.frame = CGRectMake(0, 332, SCREEN_WIDTH, 48);
        _rdoIsConfirmRight.backgroundColor = [UIColor clearColor];
    }
    return _rdoIsConfirmRight;
}

- (ItemTitle *)dishParaTitle {
    if(!_dishParaTitle) {
        _dishParaTitle = [[ItemTitle alloc] init];
        [_dishParaTitle awakeFromNib];
        _dishParaTitle.frame = CGRectMake(0, 372, SCREEN_WIDTH, 44);
        _dishParaTitle.backgroundColor = [UIColor clearColor];
    }
    return _dishParaTitle;
}

- (EditItemRadio *)rdoMergeSendInstance {
    if(!_rdoMergeSendInstance) {
        _rdoMergeSendInstance = [[EditItemRadio alloc] init];
        _rdoMergeSendInstance.frame = CGRectMake(0, 424, SCREEN_WIDTH, 48);
        _rdoMergeSendInstance.backgroundColor = [UIColor clearColor];
    }
    return _rdoMergeSendInstance;
}

- (EditItemRadio *)rdoMergeInstance {
    if(!_rdoMergeInstance) {
        _rdoMergeInstance = [[EditItemRadio alloc] init];
        _rdoMergeInstance.frame = CGRectMake(0, 468, SCREEN_WIDTH, 48);
        _rdoMergeInstance.backgroundColor = [UIColor clearColor];
    }
    return _rdoMergeInstance;
}

- (ItemTitle *)feeParaTitle {
    if(!_feeParaTitle) {
        _feeParaTitle = [[ItemTitle alloc] init];
        [_feeParaTitle awakeFromNib];
        _feeParaTitle.frame = CGRectMake(0, 472, SCREEN_WIDTH, 44);
        _feeParaTitle.backgroundColor = [UIColor clearColor];
    }
    return _feeParaTitle;
}

- (EditItemRadio *)rdoServiceFee {
    if(!_rdoServiceFee) {
        _rdoServiceFee = [[EditItemRadio alloc] init];
        _rdoServiceFee.frame = CGRectMake(0, 516, SCREEN_WIDTH, 48);
        _rdoServiceFee.backgroundColor = [UIColor clearColor];
    }
    return _rdoServiceFee;
}

- (EditItemRadio *)rdoLowFee {
    if(!_rdoLowFee) {
        _rdoLowFee = [[EditItemRadio alloc] init];
        _rdoLowFee.frame = CGRectMake(0, 660, SCREEN_WIDTH, 48);
        _rdoLowFee.backgroundColor = [UIColor clearColor];
    }
    return _rdoLowFee;
}

- (EditItemRadio *)rdoAdjustFee {
    if(!_rdoAdjustFee) {
        _rdoAdjustFee = [[EditItemRadio alloc] init];
        _rdoAdjustFee.frame = CGRectMake(0, 612, SCREEN_WIDTH, 48);
        _rdoAdjustFee.backgroundColor = [UIColor clearColor];
    }
    return _rdoAdjustFee;
}

#pragma navigateBar
-(void) initNavigate
{
   self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
   [self.titleDiv addSubview:self.titleBox.view];
   [self.titleBox initWithName:NSLocalizedString(@"系统参数", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"系统参数", nil);
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

#pragma ui.
-(void) initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lsLanguage initLabel:NSLocalizedString(@"界面语言", nil) withHit:nil delegate:self];
    [self.rdoIsMultiOrder initLabel:NSLocalizedString(@"允许拼桌(一桌多单)", nil) withHit:NSLocalizedString(@"注:如果允许拼桌那么一个桌子可以同时有两张或者两张以上的客单，否则只有一张", nil) delegate:self];
    [self.rdoIsSeatLabel initLabel:NSLocalizedString(@"▪︎ 启用桌位标签", nil) withHit:NSLocalizedString(@"提示:如果打开此项,收银开单时可以指定一个“桌位标签”,如:桌号001开了3张单,指定桌位标签后分别展示为001-A,001-B,001-C", nil)];
    
    [self.rdoIsLimitTime initLabel:NSLocalizedString(@"收银开单时可选择\"限时用餐\"", nil) withHit:NSLocalizedString(@"如果打开此项，收银开单时可以选择\"限时用餐\",当顾客的用餐时间超过指定的提醒时间时，桌位图标上会显示剩余时间提醒。", nil) delegate:self];
    [self.rdoIsConfirmRight initLabel:NSLocalizedString(@"收银查看账单汇总需要权限验证", nil) withHit:NSLocalizedString(@"如果打开此项，二维火收银系统上查看“已结账”账单汇总和“交接班”的“账单汇总”时需员工有权限，否则无法操作", nil) delegate:self];
    
    [self.lsLimitTimeEnd initLabel:NSLocalizedString(@"限时用餐时间(分钟)", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsLimitTimeWarn initLabel:NSLocalizedString(@"限时用餐提醒时间(分钟)", nil) withHit:nil isrequest:YES delegate:self];
    
    self.dishParaTitle.lblName.text=NSLocalizedString(@"点菜参数", nil);
    [self.rdoMergeSendInstance initLabel:NSLocalizedString(@"客单确认后相同商品合并数量", nil) withHit:nil];
    [self.rdoMergeInstance initLabel:NSLocalizedString(@"点单过程中相同商品合并数量", nil) withHit:nil];
    
    self.feeParaTitle.lblName.text=NSLocalizedString(@"附加费打折设置", nil);
    [self.rdoServiceFee initLabel:NSLocalizedString(@"整单打折时服务费默认打折", nil) withHit:nil];
    [self.rdoLowFee initLabel:NSLocalizedString(@"整单打折时最低消费默认打折", nil) withHit:nil];
    [self.rdoAdjustFee initLabel:NSLocalizedString(@"收银时允许调整附加费", nil) withHit:nil];
    
    self.shouyin = [[ItemTitle alloc]init];
    [self.shouyin awakeFromNib];
    self.shouyin.frame = self.shouyin.view.frame;
    self.shouyin.lblName.text=NSLocalizedString(@"沽清权限设置", nil);
    [self.container insertSubview:self.shouyin aboveSubview:self.rdoAdjustFee];

    self.shouyineffect = [[EditItemRadio alloc]init];
    [self.shouyineffect awakeFromNib];
    self.shouyineffect.frame = self.shouyineffect.view.frame;
    [self.shouyineffect initLabel:NSLocalizedString(@"沽清权限对主收银生效", nil) withHit:NSLocalizedString(@"注：打开此项，如果员工没有沽清权限，则在主收银上无法沽清", nil)];
    [self.container insertSubview:self.shouyineffect aboveSubview:self.shouyin];

    [self.container setBackgroundColor:[UIColor clearColor]];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsLanguage.tag = SYSPARA_SELECT_LANGUAGE;
    self.rdoIsMultiOrder.tag = SYSPARA_MULTI_ORDER;
    self.rdoIsLimitTime.tag = SYSPARA_LIMIT_TIME;
    self.lsLimitTimeEnd.tag = SYSPARA_LIMIT_TIME_END;
    self.lsLimitTimeWarn.tag = SYSPARA_LIMIT_TIME_WARN;
    
    
    [self.lsLimitTimeEnd setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    [self.lsLimitTimeWarn setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
-(void) loadData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    //修改
    [[TDFSettingService new] listConfig:SYS_CONFIG sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hideAnimated:YES];
        
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *configVOList=[JsonHelper transList:list objName:@"ConfigVO"];
        [self fillModel:configVOList];
        
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma ui-data-1bind
-(void)fillModel:(NSMutableArray *)configVOList
{
    NSMutableDictionary* map=[ConfigRender transDic:configVOList];
    
    self.languageConfig=[map objectForKey:DEFAULT_LANGUAGE];
    [self.lsLanguage initData:[ConfigRender getOptionName:self.languageConfig] withVal:self.languageConfig.val];
    self.multiOrderConfig=[ConfigRender fillConfig:MULTIORDER withControler:self.rdoIsMultiOrder withMap:map];
    self.isSeatLabelConfig=[ConfigRender fillConfig:IS_SEAT_LABEL withControler:self.rdoIsSeatLabel withMap:map];
    [self.rdoIsSeatLabel visibal:[self.rdoIsMultiOrder getVal]];
    
    
    self.limitTimeConfig=[ConfigRender fillConfig:ISLIMITTIME withControler:self.rdoIsLimitTime withMap:map];
    /**
     *  收银查看账单汇总需要权限验证
     */
    self.isComfirmRight = [ConfigRender fillConfig:IS_ACCOUTSUM_CONFIRM withControler:self.rdoIsConfirmRight withMap:map];
    
     self.limitTimeEndConfig=[map objectForKey:LIMITTIMEEND];
      self.limitTimeWarnConfig=[map objectForKey:LIMITTIMEWARN];
    
    
    [self.lsLimitTimeEnd initData:self.limitTimeEndConfig.val withVal:self.limitTimeEndConfig.val];
    [self.lsLimitTimeWarn initData:self.limitTimeWarnConfig.val withVal:self.limitTimeWarnConfig.val];
    [self.lsLimitTimeEnd visibal:[self.rdoIsLimitTime getVal]];
    [self.lsLimitTimeWarn visibal:[self.rdoIsLimitTime getVal]];
    self.mergeSendInstanceConfig=[ConfigRender fillConfig:MERGE_SENDINSTANCE withControler:self.rdoMergeSendInstance withMap:map];
    self.mergeInstanceConfig=[ConfigRender fillConfig:MERGE_INSTANCE withControler:self.rdoMergeInstance withMap:map];
    self.isServiceFeeDiscountConfig=[ConfigRender fillConfig:IS_SERVICEFEE_DISCOUNT withControler:self.rdoServiceFee withMap:map];
    self.minConsumeModeConfig=[ConfigRender fillConfig:MINCONSUMEMODE withControler:self.rdoLowFee withMap:map];
    self.isSetMinConsumeModeConfig=[ConfigRender fillConfig:IS_SET_MINCONSUMEMODE withControler:self.rdoAdjustFee withMap:map];
    self.isPermissionCashConfig = [ConfigRender fillConfig:IS_PERMISSION_CASH withControler:self.shouyineffect withMap:map];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsLanguage getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择界面语言", nil)];
        return NO;
    }
    return YES;
}

-(NSMutableArray*) transMode
{
    NSMutableArray *idList = [NSMutableArray array];
    if (self.multiOrderConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.multiOrderConfig._id,[self.rdoIsMultiOrder getStrVal]]];
    }
    
    if (self.mergeSendInstanceConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.mergeSendInstanceConfig._id,[self.rdoMergeSendInstance getStrVal]]];
    }
    
    if (self.mergeInstanceConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.mergeInstanceConfig._id,[self.rdoMergeInstance getStrVal]]];
    }
    
    if (self.isServiceFeeDiscountConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isServiceFeeDiscountConfig._id,[self.rdoServiceFee getStrVal]]];
    }
    
    if (self.minConsumeModeConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.minConsumeModeConfig._id,[self.rdoLowFee getStrVal]]];
    }
    
    if (self.isSetMinConsumeModeConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isSetMinConsumeModeConfig._id,[self.rdoAdjustFee getStrVal]]];
    }
    
    if (self.isPermissionCashConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isPermissionCashConfig._id,[self.shouyineffect getStrVal]]];
    }
    
    if (self.languageConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.languageConfig._id,[self.lsLanguage getStrVal]]];
    }
    
    if (self.isSeatLabelConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isSeatLabelConfig._id,[self.rdoIsSeatLabel getStrVal]]];
    }
    
    if (self.limitTimeConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.limitTimeConfig._id,[self.rdoIsLimitTime getStrVal]]];
    }
    
    /**
     *  收银查看账单汇总需要权限验证
     */
    if (self.isComfirmRight){
    
       [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isComfirmRight._id,[self.rdoIsConfirmRight getStrVal]]];
       }
    
    if (self.limitTimeEndConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.limitTimeEndConfig._id,[self.lsLimitTimeEnd getStrVal]]];
    }
    
    if (self.limitTimeWarnConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.limitTimeWarnConfig._id,[self.lsLimitTimeWarn getStrVal]]];
    }
    
    return idList;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    NSMutableArray* ids=[self transMode];
    if ([ids count]==0) {
        [UIHelper ToastNotification:NSLocalizedString(@"没有配置项可以设置", nil) andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFSettingService new] saveConfig:ids sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated: YES];
        [UIHelper clearChange:self.container];
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud   hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj.tag==SYSPARA_SELECT_LANGUAGE) {
        //选择界面语言.
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.languageConfig.options
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.languageConfig.options[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    id<INameItem> vo=(id<INameItem>)item;
    [self.lsLanguage changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    return YES;
}

- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==SYSPARA_LIMIT_TIME_END) {
        [self.lsLimitTimeEnd changeData:val withVal:val];
    } else if (eventType==SYSPARA_LIMIT_TIME_WARN) {
        [self.lsLimitTimeWarn changeData:val withVal:val];
    }
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SysParaEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SysParaEditView_Change object:nil];
 
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
  //  [self.titleBox editTitle:[UIHelper currChange:self.shouyineffect] act:ACTION_CONSTANTS_EDIT];
}

-(void)loadFinsh:(RemoteResult*) result
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
    NSArray *list = [map objectForKey:@"configs"];
    NSMutableArray *configVOList=[JsonHelper transList:list objName:@"ConfigVO"];
    [self fillModel:configVOList];
}

- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag==SYSPARA_MULTI_ORDER) {
        [self.rdoIsSeatLabel visibal:[obj getVal]];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else if (obj.tag==SYSPARA_LIMIT_TIME) {
        [self.lsLimitTimeEnd visibal:[obj getVal]];
        [self.lsLimitTimeWarn visibal:[obj getVal]];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
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
    
    [UIHelper clearChange:self.container];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"sysparas"];
}

#pragma  回收处理.
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.titleBox=nil;
    self.lsLanguage=nil;
    self.rdoIsMultiOrder=nil;
    self.rdoIsSeatLabel=nil;
    self.dishParaTitle=nil;
    self.rdoMergeSendInstance=nil;
    self.rdoMergeInstance=nil;
    self.feeParaTitle=nil;
    self.rdoServiceFee=nil;
    self.rdoLowFee=nil;
    self.rdoLowFee=nil;
    self.container=nil;
    self.scrollView=nil;
    self.shouyineffect = nil;
    service=nil;
}
@end
