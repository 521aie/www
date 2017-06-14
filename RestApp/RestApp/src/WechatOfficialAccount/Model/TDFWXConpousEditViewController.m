//
//  TDFWXConpousEditViewController.m
//  RestApp
//
//  Created by 黄河 on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import <TDFAPIKit/TDFAPIKit.h>
#import <TDFAPIHUDPresenter/TDFAPIHUDPresenter.h>

#import "DHTTableViewManager+Register.h"

#import "TDFWXOfficialAccountActionPath.h"

#import "MailInputBox.h"
#import "TDFSKSingleButtonItem.h"
#import "TDFSKDisplayedTextItem.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFWXConpousEditViewController.h"
#import "TDFWechatMarketingService.h"
#import "TDFLeftSwitchItem.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"
#import "UIColor+Hex.h"
#import "DateUtils.h"
@interface TDFWXConpousEditViewController () <MemoInputClient>

{
    int _overwriteFlag;
    TDFWXConpousModel *_saveModel;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)DHTTableViewManager *manager;

//@property (nonatomic, strong)TDFPickerItem *sendConpousWhenOpenCardStartTimeItem;

@property (nonatomic, strong)TDFPickerItem *sendConpousWhenOpenCardEndTimeItem;

//@property (nonatomic, strong)TDFShowDateStrategy *startTimeDataStrategy;

@property (nonatomic, strong)TDFShowDateStrategy *endTimeDataStrategy;


@property (nonatomic, strong)TDFSwitchItem *sendConpousWhenOpenCard;

//@property (nonatomic, strong)TDFSwitchItem *sendConpousWhenPay;/*产品说干掉*/

//@property (nonatomic, strong)TDFSwitchItem *sendConpousWhenRecommend;/*产品说干掉*/

@property (nonatomic, strong)TDFLeftSwitchItem *headerItem;

@property (strong, nonatomic) DHTTableViewSection *section;
@property (strong, nonatomic) TDFSKSingleButtonItem *deleteFromListItem;
@property (strong, nonatomic) TDFSKSingleButtonItem *sendQRCodeToMailItem;
@property (strong, nonatomic) TDFSKDisplayedTextItem *scanQRCodeTipItem;
@property (strong, nonatomic) TDFGeneralAPI *deleteSyncCouponSwitchAPI;
@property (strong, nonatomic) TDFGeneralAPI *sendMailSyncCouponSwitchAPI;
@end

@implementation TDFWXConpousEditViewController


- (TDFGeneralAPI *)deleteSyncCouponSwitchAPI {
    if (!_deleteSyncCouponSwitchAPI) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXDeleteSyncCouponSwitch];
        requestModel.apiVersion = kTDFAPWXDeleteSyncCouponSwitchVersion;
        
        _deleteSyncCouponSwitchAPI = [[TDFGeneralAPI alloc] init];
        _deleteSyncCouponSwitchAPI.requestModel = requestModel;
        _deleteSyncCouponSwitchAPI.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _deleteSyncCouponSwitchAPI;
}

- (TDFGeneralAPI *)sendMailSyncCouponSwitchAPI {
    if (!_sendMailSyncCouponSwitchAPI) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXSendMailSyncCouponSwitch];
        requestModel.apiVersion = kTDFAPWXSendMailSyncCouponSwitchVersion;
        
        _sendMailSyncCouponSwitchAPI = [[TDFGeneralAPI alloc] init];
        _sendMailSyncCouponSwitchAPI.requestModel = requestModel;
        _sendMailSyncCouponSwitchAPI.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _sendMailSyncCouponSwitchAPI;
}

- (TDFSKSingleButtonItem *)deleteFromListItem {
    if (!_deleteFromListItem) {
        TDFSKButtonItemTransaction *transaction = [[TDFSKButtonItemTransaction alloc] init];
        transaction.title = @"将此券从列表中删除";
        transaction.backgroundType = TDFSKButtonItemBackgroundTypeRed;
        _deleteFromListItem = [TDFSKSingleButtonItem item];
        _deleteFromListItem.transaction = transaction;
        _deleteFromListItem.cellHeight = 70;
    }
    
    return _deleteFromListItem;
}

- (TDFSKSingleButtonItem *)sendQRCodeToMailItem {
    if (!_sendQRCodeToMailItem) {
        TDFSKButtonItemTransaction *transition = [[TDFSKButtonItemTransaction alloc] init];
        transition.title = @"发送此优惠券二维码到邮箱";
        transition.backgroundType = TDFSKButtonItemBackgroundTypeRedBoarder;
        transition.titleColor = [UIColor tdf_colorWithRGB:0xCC0000];
        _sendQRCodeToMailItem = [TDFSKSingleButtonItem item];
        _sendQRCodeToMailItem.transaction = transition;
    }
    
    return _sendQRCodeToMailItem;
}

- (TDFSKDisplayedTextItem *)scanQRCodeTipItem {
    if (!_scanQRCodeTipItem) {
        _scanQRCodeTipItem = [TDFSKDisplayedTextItem item];
        _scanQRCodeTipItem.text = @"顾客扫码可直接领取会员卡";
        _scanQRCodeTipItem.textAlignment = NSTextAlignmentCenter;
        _scanQRCodeTipItem.font = [UIFont systemFontOfSize:11];
        _scanQRCodeTipItem.textColor = [UIColor tdf_colorWithRGB:0x666666];
    }
    
    return _scanQRCodeTipItem;
}

- (void)setupItems {
    if (self.cardModel.status != TDFWXCouponSyncStatusTypeSyncing) {
        [self.section addItem:self.deleteFromListItem];
        [self.section addItem:self.sendQRCodeToMailItem];
        [self.section addItem:self.scanQRCodeTipItem];
        
        [self setupDeleteFromListItemAction];
        [self setupSendQRCodeToMailItemAction];
        [self setupApisAction];
    }
}

- (void)setupApisAction {
    @weakify(self)
    self.sendMailSyncCouponSwitchAPI.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        
        [self showAlert:@"发送成功" confirm:nil];
    };
    
    self.deleteSyncCouponSwitchAPI.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        
        if (self.callBack) {
            self.callBack(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
}


- (void)setupDeleteFromListItemAction {
    @weakify(self)
    self.deleteFromListItem.transaction.clickedHandler = ^{
        @strongify(self)
        
        if (self.cardModel.status == TDFWXCouponSyncStatusTypeNone) {
            self.deleteSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchWXAppIdKey] = self.cardModel.wxId;
            self.deleteSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchCardIdKey] = self.cardModel.conpousID;
            [self.deleteSyncCouponSwitchAPI start];
        } else if (self.cardModel.status == TDFWXCouponSyncStatusTypeSynced) {
            
            [self showMessage:@"删除后此券也将不再同步到微信卡券" confirm:^{
                self.deleteSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchWXAppIdKey] = self.cardModel.wxId;
                self.deleteSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchCardIdKey] = self.cardModel.conpousID;
                [self.deleteSyncCouponSwitchAPI start];
            } cancel:nil];
        }
    };
}

- (void)setupSendQRCodeToMailItemAction {
    @weakify(self)
    self.sendQRCodeToMailItem.transaction.clickedHandler = ^{
        @strongify(self)
        
        [MailInputBox show:1 delegate:self title:NSLocalizedString(@"输入EMAIL地址", nil) val:nil isPresentMode:YES];
    };
}

#pragma mark - MemoInputClient
-(void) finishInput:(NSInteger)event content:(NSString*)content{
    self.sendMailSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchCardIdKey] = self.cardModel.conpousID;
    self.sendMailSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchWXAppIdKey] = self.cardModel.wxId;
    self.sendMailSyncCouponSwitchAPI.params[kTDFAPWXSendMailSyncCouponSwitchMailKey] = content;
    
    [self.sendMailSyncCouponSwitchAPI start];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    
    [self setupItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --config view

- (void)configView {
    [self configManager];
    [self configTableView];
    [self configTitleView];
    [self configHeaderView];
    [self configSubView];
    [self configNotification];
}

- (void)configTitleView {
    self.title = @"同步到微信优惠券设置";
}

- (void)configHeaderView {
    
}

- (void)configSubView {
    @weakify(self);
    _saveModel = [self.cardModel copy];
    _overwriteFlag = 0;
    DHTTableViewSection *section = [DHTTableViewSection section];
    self.section = section;
    
    self.headerItem = [[TDFLeftSwitchItem alloc] init];
    self.headerItem.title = [self titleWithStatus:self.cardModel.status];
    self.headerItem.titleColor = [self titleColorWithStatus:self.cardModel.status];
    self.headerItem.requestKey = @"status";
    if (self.cardModel.status == 0) {
        self.headerItem.subTitle = self.cardModel.failReason.length > 0 ?[NSString stringWithFormat:@"失败原因:%@",self.cardModel.failReason]:@"";
    }
    self.headerItem.preValue = self.cardModel.status == 0 ? @(NO) : @(YES);
    self.headerItem.isOn = self.cardModel.status == 0 ? NO : YES;
    self.headerItem.editStyle = [self getStyleWithStatus:self.cardModel.status];
    
    self.headerItem.filterBlock = ^(BOOL isOn) {
        @strongify(self);
        if (!isOn) {
            self.sendConpousWhenOpenCard.isOn = isOn;
            [self updatesendConpousWhenOpenCardInSection:section isOn:isOn];
        }
        self->_saveModel.status = isOn;
        return YES;
    };
    [section addItem:self.headerItem];
    
#if 0
    self.sendConpousWhenOpenCard = [[TDFSwitchItem alloc] init];
    self.sendConpousWhenOpenCard.requestKey = @"openStatus";
    self.sendConpousWhenOpenCard.title = @"开卡成功时发此券";
    self.sendConpousWhenOpenCard.isOn = self.cardModel.openStatus;
    self.sendConpousWhenOpenCard.preValue = @(self.cardModel.openStatus);
    self.sendConpousWhenOpenCard.detail = @"注：已领卡的顾客需要输入手机号进行激活，可在顾客激活成功后发1张券，此类操作仅支持同时段设置一种券。本开关自开启之日立即生效";
    self.sendConpousWhenOpenCard.editStyle = [self getStyleWithStatus:self.cardModel.status];;
    [section addItem:self.sendConpousWhenOpenCard];
    
    if (self.cardModel.openStatus) {
        self.endTimeDataStrategy.dateString = self.cardModel.openEndTime;
        self.sendConpousWhenOpenCardEndTimeItem.textValue = self.cardModel.openEndTime;
        self.sendConpousWhenOpenCardEndTimeItem.preValue = self.cardModel.openEndTime;
        self.sendConpousWhenOpenCardEndTimeItem.editStyle =[self getStyleWithStatus:self.cardModel.status];
        [section addItem:self.sendConpousWhenOpenCardEndTimeItem];
    }
#endif
    
    [self.manager addSection:section];
    
#if 0
    self.sendConpousWhenOpenCard.filterBlock = ^(BOOL isOn) {
        @strongify(self);
        if (!self.headerItem.isOn || self.cardModel.status == 0) {
            [self showMessageWithTitle:@"提示" message:@"此券未同步到微信，无法设置" cancelTitle:@"我知道了"];
            return NO;
        }
        [self updatesendConpousWhenOpenCardInSection:section isOn:isOn];
        return YES;
    };
    ///（开始时间没约束默认为今天、结束时间不能早于开始时间、结束时间不能早于今天）
    
    ///关注时发卡结束时间
    self.sendConpousWhenOpenCardEndTimeItem.filterBlock = ^(NSString *textValue,id requestValue) {
        @strongify(self);
        NSDate *date = [DateUtils DateWithString:textValue type:TDFFormatTimeTypeYearMonthDayString];
        BOOL isVerify = [self verifyDate:date];
        if (isVerify) {
            self->_saveModel.openEndTime = textValue;
        }
        return isVerify;
    };
#endif
}

- (void)changeTimeDataStrategy:(TDFShowDateStrategy *)dataStrategy
                       andItem:(TDFPickerItem *)item
                      withData:(NSString *)dataString
                   andPreValue:(NSString *)preValue{
    dataStrategy.dateString = dataString;
    item.textValue = dataString;
    item.preValue = preValue;
}

- (void)configManager {
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFLeftSwitchCell" withItem:@"TDFLeftSwitchItem"];
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- method
- (TDFEditStyle)getStyleWithStatus:(int)status {
    if (status == 2) {
        return TDFEditStyleUnEditable;
    }
    return TDFEditStyleEditable;
}

- (NSString *)titleWithStatus:(int)status {
    NSString *str;
    switch (status) {
        case 0:
            str = @"此券未同步到微信卡券";
            break;
        case 1:
            str = @"此券已同步到微信卡券";
            break;
        case 2:
            str = @"此券正在同步到微信卡券";
            break;
            
        default:
            break;
    }
    
    return str;
}

- (UIColor *)titleColorWithStatus:(int)status {
    UIColor *strColor;
    switch (status) {
        case 0:
            strColor = [UIColor colorWithHexString:@"#CC0000"];
            break;
        case 1:
            strColor = [UIColor colorWithHexString:@"#0088CC"];
            break;
        case 2:
            strColor = [UIColor colorWithHexString:@"#F56D23"];
            break;
            
        default:
            break;
    }
    
    return strColor;
}

#pragma mark --callBack
///开卡成功发此券
- (void)updatesendConpousWhenOpenCardInSection:(DHTTableViewSection *)section
                                        isOn:(BOOL)isOn {
    self->_saveModel.openStatus = isOn;
    if (isOn) {
        [self changeTimeDataStrategy:self.endTimeDataStrategy
                             andItem:self.sendConpousWhenOpenCardEndTimeItem
                            withData:_saveModel.openEndTime
                         andPreValue:self.cardModel.openEndTime];
        [section insertItem:self.sendConpousWhenOpenCardEndTimeItem
                  belowItem:self.sendConpousWhenOpenCard];
    }else {
        [section removeItem:self.sendConpousWhenOpenCardEndTimeItem];
    }
    [self.manager reloadData];
}

#pragma mark -- Notification
- (void)configNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"取消"];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:@"保存"];
    }else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:@"返回"];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

#pragma mark -- verifyDate
- (BOOL)verify {
    if (_saveModel.openStatus && _saveModel.openEndTime.length == 0) {
        [AlertBox show:@"结束时间不能为空!"];
        return NO;
    }
    return YES;
}

- (BOOL)verifyDate:(NSDate *)endDate {
    NSString *todayStartStr = [[DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearMonthDay] stringByAppendingString:@" 00:00"];
    NSDate *todayStartDate = [DateUtils DateWithString:todayStartStr type:TDFFormatTimeTypeFullTimeString];
    if ([[todayStartDate earlierDate:endDate] isEqual:endDate] && ![todayStartDate isEqualToDate:endDate]) {
        [self showMessageWithTitle:@"提示" message:@"结束时间不可早于今天" cancelTitle:@"我知道了"];
        return NO;
    }
    return YES;
}

#pragma mark -- buttonClick
- (void)leftNavigationButtonAction:(id)sender {
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        __weak typeof(self) weakSelf = self;
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗?", nil) cancelBlock:^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } enterBlock:^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightNavigationButtonAction:(id)sender {
    [self save];
}

#pragma mark -- service
- (void)save {
    if (![self verify]) {
        return;
    }
    [self showProgressHudWithText:@"正在保存"];
    [[TDFWechatMarketingService service] saveSynchronizeConpousInfoWithOAId:self.cardModel.wxId
                                                        andOverwriteFlag:_overwriteFlag
                                                                cardInfo:[_saveModel yy_modelToJSONString]
                                                                  sucess:^(NSURLSessionDataTask *task, id data) {
                                                                      [self.progressHud setHidden:YES];
                                                                      NSString *message = data[@"data"];
                                                                      if (message.length > 0 && _overwriteFlag == 0) {
                                                                          [self showMessageWithTitle:@"提示" message:message cancelBlock:nil enterBlock:^{
                                                                              _overwriteFlag = 1;
                                                                              [self save];
                                                                          }];
                                                                      }else {
                                                                          if (self.callBack) {
                                                                              self.callBack(_saveModel);
                                                                          }
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }
                                                                  }
                                                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                     [self.progressHud setHidden:YES];
                                                                     [AlertBox show:error.localizedDescription];
                                                                 }];
}

#pragma mark -- setter && getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }
    return _tableView;
}

- (DHTTableViewManager *)manager {
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerItems:@[S(TDFSKSingleButtonItem), S(TDFSKDisplayedTextItem)]];
    }
    return _manager;
}

- (TDFPickerItem *)sendConpousWhenOpenCardEndTimeItem {
    if (!_sendConpousWhenOpenCardEndTimeItem) {
        _sendConpousWhenOpenCardEndTimeItem = [[TDFPickerItem alloc] init];
        _sendConpousWhenOpenCardEndTimeItem.title = @"▪︎ 结束时间";
        _sendConpousWhenOpenCardEndTimeItem.requestKey = @"openEndTime";
    }
    return _sendConpousWhenOpenCardEndTimeItem;
}

- (TDFShowDateStrategy *)endTimeDataStrategy {
    if (!_endTimeDataStrategy) {
        _endTimeDataStrategy = [[TDFShowDateStrategy alloc] init];
        _endTimeDataStrategy.pickerName = @"结束时间";
        self.sendConpousWhenOpenCardEndTimeItem.strategy = _endTimeDataStrategy;
    }
    return _endTimeDataStrategy;
}

@end
