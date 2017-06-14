//
//  TDFWXMemberCardEditViewController.m
//  RestApp
//
//  Created by 黄河 on 2017/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import <TDFAPIKit/TDFAPIKit.h>
#import <TDFAPIHUDPresenter/TDFAPIHUDPresenter.h>
#import <TDFBatchOperation/TDFBatchOperation.h>

#import "DHTTableViewManager+Validation.h"
#import "MobClick.h"
#import "TDFSwitchItem+Linkage.h"
#import "DHTTableViewManager+Register.h"
#import "TDFCustomStrategy+Generator.h"

#import "TDFWXOfficialAccountActionPath.h"
#import "TDFSynchronizeCardInfoModel.h"
#import "TDFWXSyncedCouponSelectorDelegate.h"

#import "MailInputBox.h"
#import "TDFSKDatePickerStrategy.h"
#import "TDFSKSingleButtonItem.h"
#import "TDFSKDisplayedTextItem.h"
#import "TDFCardSelectorItem.h"
#import "TDFCardSelectorViewController.h"


#import "TDFRootViewController+AlertMessage.h"
#import "TDFWXMemberCardEditViewController.h"
#import "TDFWechatMarketingService.h"
#import "TDFLeftSwitchItem.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"
#import "UIColor+Hex.h"
#import "DateUtils.h"


@interface TDFWXMemberCardEditViewController () <MemoInputClient>

{
    int _overwriteFlag;
    TDFWXMemberCardModel *_saveCardModel;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)DHTTableViewManager *manager;

@property (nonatomic, strong)TDFPickerItem *sendCardWhenAttentionStartTimeItem;

@property (nonatomic, strong)TDFPickerItem *sendCardWhenAttentionEndTimeItem;

@property (nonatomic, strong)TDFPickerItem *sendCardWhenPayStartTimeItem;

@property (nonatomic, strong)TDFPickerItem *sendCardWhenPayEndTimeItem;

@property (nonatomic, strong)TDFShowDateStrategy *startTimeDataStrategy;

@property (nonatomic, strong)TDFShowDateStrategy *endTimeDataStrategy;

@property (nonatomic, strong)TDFShowDateStrategy *payStartTimeDataStrategy;

@property (nonatomic, strong)TDFShowDateStrategy *payEndTimeDataStrategy;

@property (nonatomic, strong)TDFSwitchItem *sendCardWhenAttention;

@property (nonatomic, strong)TDFSwitchItem *sendCardWhenPay;

@property (nonatomic, strong)TDFLeftSwitchItem *headerItem;

@property (strong, nonatomic) DHTTableViewSection *section;
@property (strong, nonatomic) TDFSwitchItem *sendCouponWhenActiveTheCardItem;
@property (strong, nonatomic) TDFPickerItem *scEndTimeItem;
@property (strong, nonatomic) TDFSKDatePickerStrategy *scEndTimeStrategy;
@property (strong, nonatomic) TDFPickerItem *scSelectCouponCanBeSentItem;
@property (strong, nonatomic) TDFCustomStrategy *scSelectCouponCanBeSentStrategy;

@property (strong, nonatomic) TDFSKSingleButtonItem *deleteFromListItem;
@property (strong, nonatomic) TDFSKSingleButtonItem *sendQRCodeToMailItem;
@property (strong, nonatomic) TDFSKDisplayedTextItem *scanQRCodeTipItem;

@property (strong, nonatomic) TDFGeneralAPI *deleteSyncCardSwitchAPI;
@property (strong, nonatomic) TDFGeneralAPI *sendMailSyncCardSwitchAPI;

@property (strong, nonatomic) TDFWXSyncedCouponSelectorDelegate *couponSelectorDelegate;

@property (assign, nonatomic) BOOL shouldShowAlert;
@end

@implementation TDFWXMemberCardEditViewController


- (TDFGeneralAPI *)deleteSyncCardSwitchAPI {
    if (!_deleteSyncCardSwitchAPI) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXDeleteSyncCardSwitch];
        requestModel.apiVersion = kTDFAPWXDeleteSyncCardSwitchVersion;
        
        _deleteSyncCardSwitchAPI = [[TDFGeneralAPI alloc] init];
        _deleteSyncCardSwitchAPI.requestModel = requestModel;
        _deleteSyncCardSwitchAPI.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _deleteSyncCardSwitchAPI;
}

- (TDFGeneralAPI *)sendMailSyncCardSwitchAPI {
    if (!_sendMailSyncCardSwitchAPI) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXSendMailSyncCardSwitch];
        requestModel.apiVersion = kTDFAPWXSendMailSyncCardSwitchVersion;
        
        _sendMailSyncCardSwitchAPI = [[TDFGeneralAPI alloc] init];
        _sendMailSyncCardSwitchAPI.params[kTDFAPWXSendMailSyncCardSwitchCardIdKey] = self.cardModel.cardID;
        _sendMailSyncCardSwitchAPI.requestModel = requestModel;
        _sendMailSyncCardSwitchAPI.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _sendMailSyncCardSwitchAPI;
}

- (TDFSwitchItem *)sendCouponWhenActiveTheCardItem {
    if (!_sendCouponWhenActiveTheCardItem) {
        _sendCouponWhenActiveTheCardItem = [TDFSwitchItem item]
        .tdf_title(@"激活此卡成功时发券")
        .tdf_detail(@"注：已领卡的顾客需要输入手机号进行激活，可在顾客激活成功后发1张券，此类操作支持设置5种券，但是领券消息仅发送1条。")
        ;
    }
    
    return _sendCouponWhenActiveTheCardItem;
}

- (TDFPickerItem *)scEndTimeItem {
    if (!_scEndTimeItem) {
        _scEndTimeItem = [TDFPickerItem item]
        .tdf_title(@"结束时间")
        .tdf_strategy(self.scEndTimeStrategy)
        ;
    }
    
    return _scEndTimeItem;
}
- (TDFSKDatePickerStrategy *)scEndTimeStrategy {
    if (!_scEndTimeStrategy) {
        _scEndTimeStrategy = [[TDFSKDatePickerStrategy alloc] init];
        _scEndTimeStrategy.mininumDate = [NSDate date];
        _scEndTimeStrategy.pickerName = self.scEndTimeItem.title;
        _scEndTimeStrategy.reformDateBlock = ^NSString *(NSDate *date) {
            return date.tdf_yyyyLmmLddString;
        };
    }
    
    return _scEndTimeStrategy;
}

- (TDFPickerItem *)scSelectCouponCanBeSentItem {
    if (!_scSelectCouponCanBeSentItem) {
        _scSelectCouponCanBeSentItem = [TDFPickerItem item]
        .tdf_title(@"选择激活可赠送的券")
        .tdf_strategy(self.scSelectCouponCanBeSentStrategy)
        ;
    }
    
    return _scSelectCouponCanBeSentItem;
}

- (TDFCustomStrategy *)scSelectCouponCanBeSentStrategy {
    if (!_scSelectCouponCanBeSentStrategy) {
        @weakify(self)
        _scSelectCouponCanBeSentStrategy = [TDFCustomStrategy wx_strategyWithBlock:^{
            @strongify(self)
            
            TDFCardSelectorViewController *viewController = [[TDFCardSelectorViewController alloc] initWithTitle:@"选择激活卡可发的券"];
            viewController.delegate = self.couponSelectorDelegate;
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }
    
    return _scSelectCouponCanBeSentStrategy;
}

- (TDFSKSingleButtonItem *)deleteFromListItem {
    if (!_deleteFromListItem) {
        TDFSKButtonItemTransaction *transaction = [[TDFSKButtonItemTransaction alloc] init];
        transaction.title = @"将此卡从列表中删除";
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
        transition.title = @"发送此会员卡二维码到邮箱";
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

- (TDFWXSyncedCouponSelectorDelegate *)couponSelectorDelegate {
    if (!_couponSelectorDelegate) {
        @weakify(self)
        _couponSelectorDelegate = [[TDFWXSyncedCouponSelectorDelegate alloc] initWithWxId:self.cardModel.wxId selectedIndexForCouponsBlock:^NSInteger(NSArray *coupons) {
            @strongify(self)
            return [coupons tdf_indexOfObjectUsingMatchingBlock:^BOOL(TDFSynchronizeCardInfoModel *coupon) {
                return [coupon.cardId isEqualToString:self.cardModel.couponId];
            }];
        } finishSelectCouponBlock:^(TDFSynchronizeCardInfoModel *card) {
            @strongify(self)
            self.scSelectCouponCanBeSentItem.textValue = card.cardName;
            self.cardModel.couponId = card.cardId;
            self.cardModel.couponName = card.cardName;
            
            self->_saveCardModel.couponId = card.cardId;
            self->_saveCardModel.couponName = card.cardName;
            
            [self.manager reloadData];
        }];
    }
    
    return _couponSelectorDelegate;
}
#pragma private
- (void)setupItemsLinkage {
    @weakify(self)
    self.sendCouponWhenActiveTheCardItem.filterBlock = ^BOOL(BOOL isOn) {
        @strongify(self)
        if (self.shouldShowAlert && (!self.headerItem.isOn || self.cardModel.status == 0)) {
            [self showMessageWithTitle:@"提示" message:@"此卡未同步到微信，无法设置" cancelTitle:@"我知道了"];
            return NO;
        }
        
        if (self.shouldShowAlert) {
            [MobClick event:@"wechat_card_couponset" attributes:@{@"wechat_card_couponset" : @(isOn)}];
        }
        
        self->_saveCardModel.activeStatus = isOn;
        
        return YES;
    };
    
    self.sendCouponWhenActiveTheCardItem
    .tdf_attachLinkageItem(self.scEndTimeItem)
    .tdf_attachLinkageItem(self.scSelectCouponCanBeSentItem)
    .tdf_attachBlock(^(BOOL on){
        @strongify(self)
        [self.manager reloadData];
    });
}

- (void)setupDeleteFromListItemAction {
    @weakify(self)
    self.deleteFromListItem.transaction.clickedHandler = ^{
        @strongify(self)
        
        if (self.cardModel.status == TDFWXCardSyncStatusTypeNone) {
            self.deleteSyncCardSwitchAPI.params[kTDFAPWXDeleteSyncCardSwitchWXAppIdKey] = self.cardModel.wxId;
            self.deleteSyncCardSwitchAPI.params[kTDFAPWXDeleteSyncCardSwitchCardIdKey] = self.cardModel.cardID;
            [self.deleteSyncCardSwitchAPI start];
        } else if (self.cardModel.status == TDFWXCardSyncStatusTypeSynced) {
            
            [self showMessage:@"删除后此卡也将不再同步到微信卡包" confirm:^{
                self.deleteSyncCardSwitchAPI.params[kTDFAPWXDeleteSyncCardSwitchWXAppIdKey] = self.cardModel.wxId;
                self.deleteSyncCardSwitchAPI.params[kTDFAPWXDeleteSyncCardSwitchCardIdKey] = self.cardModel.cardID;
                [self.deleteSyncCardSwitchAPI start];
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

- (void)setupApisAction {
    @weakify(self)
    self.sendMailSyncCardSwitchAPI.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        
        [self showAlert:@"发送成功" confirm:nil];
    };
    
    self.deleteSyncCardSwitchAPI.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        
        if (self.callBack) {
            self.callBack(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)setupItems {
    [self.section addItem:self.sendCouponWhenActiveTheCardItem];
    [self.section addItem:self.scEndTimeItem];
    [self.section addItem:self.scSelectCouponCanBeSentItem];
    
    if (self.cardModel.status != TDFWXCardSyncStatusTypeSyncing) {
        [self.section addItem:self.deleteFromListItem];
        [self.section addItem:self.sendQRCodeToMailItem];
        [self.section addItem:self.scanQRCodeTipItem];
        
        [self setupDeleteFromListItemAction];
        [self setupSendQRCodeToMailItemAction];
        [self setupApisAction];
    }
    
    [self setupItemsLinkage];
}

- (void)initializeItemWithCard:(TDFWXMemberCardModel *)card {
    
    self.sendCouponWhenActiveTheCardItem.isOn = card.activeStatus;
    self.sendCouponWhenActiveTheCardItem.preValue = @(card.activeStatus);
    
    self.scEndTimeItem.textValue = card.activeEndTime;
    self.scEndTimeItem.preValue = card.activeEndTime;
    
    self.scEndTimeStrategy.date = card.activeEndTime.tdf_yyyyLMMLddDate;
    
    self.scSelectCouponCanBeSentItem.textValue = card.couponName;
    self.scSelectCouponCanBeSentItem.preValue = card.couponName;
    
    [[self.section.items
        tdf_filter:^BOOL(id value) {
            return [value isKindOfClass:[TDFBaseEditItem class]];
        }]
        tdf_forEach:^(TDFBaseEditItem *value) {
            value.editStyle = [self getStyleWithStatus:card.status];
        }];
    
    self.shouldShowAlert = NO;
    [self.sendCouponWhenActiveTheCardItem tdf_safeExecuteFilterBlock];
    self.shouldShowAlert = YES;
}


#pragma mark - MemoInputClient
-(void) finishInput:(NSInteger)event content:(NSString*)content{
    self.sendMailSyncCardSwitchAPI.params[kTDFAPWXSendMailSyncCardSwitchCardIdKey] = self.cardModel.cardID;
    self.sendMailSyncCardSwitchAPI.params[kTDFAPWXSendMailSyncCardSwitchWXAppIdKey] = self.cardModel.wxId;
    self.sendMailSyncCardSwitchAPI.params[kTDFAPWXSendMailSyncCardSwitchMailKey] = content;
    
    [self.sendMailSyncCardSwitchAPI start];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    
    [self setupItems];
    [self initializeItemWithCard:self.cardModel];
}

#pragma mark --config view

- (void)configView {
    [self configManager];
    [self configTableView];
    [self configTitleView];
    [self configSubView];
    [self configNotification];
}

- (void)configTitleView {
    self.title = @"同步到微信会员卡设置";
}

- (void)configSubView {
    _saveCardModel = [self.cardModel copy];
    @weakify(self);
    _overwriteFlag = 0;
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    self.section = section;
    
    self.headerItem = [[TDFLeftSwitchItem alloc] init];
    self.headerItem.requestKey = @"status";
    self.headerItem.title = [self titleWithStatus:self.cardModel.status];
    self.headerItem.titleColor = [self titleColorWithStatus:self.cardModel.status];
    if (self.cardModel.status == 0) {
        self.headerItem.subTitleColor = [UIColor colorWithHeX:0xCC0000];
        self.headerItem.subTitle = self.cardModel.failReason.length > 0 ?[NSString stringWithFormat:@"失败原因:%@",self.cardModel.failReason]:@"";
    }
    self.headerItem.preValue = self.cardModel.status == 0 ? @(NO) : @(YES);
    self.headerItem.isOn = self.cardModel.status == 0 ? NO : YES;
    self.headerItem.editStyle = [self getStyleWithStatus:self.cardModel.status];
    
    self.headerItem.filterBlock = ^(BOOL isOn) {
        @strongify(self);
        if (!isOn) {
            self.sendCardWhenAttention.isOn = isOn;
            self.sendCardWhenPay.isOn = isOn;
            [self updateSendCardWhenPayInSection:section isOn:isOn];
            [self updateSendCardWhenAttentionInSection:section isOn:isOn];
        }
        self->_saveCardModel.status = isOn;
        return YES;
    };
    [section addItem:self.headerItem];
    
    self.sendCardWhenAttention = [[TDFSwitchItem alloc] init];
    self.sendCardWhenAttention.requestKey = @"followStatus";
    self.sendCardWhenAttention.title = @"在顾客关注时发卡";
    self.sendCardWhenAttention.isOn = self.cardModel.followStatus;
    self.sendCardWhenAttention.preValue = @(self.cardModel.followStatus);
    self.sendCardWhenAttention.detail = @"注：该卡同步到您授权的公众号后，顾客关注公众号时，自动给顾客发送1条领卡消息，发卡消息以卡的形式推送给顾客，仅支持同时段设置一张卡为关注时发卡。";
    self.sendCardWhenAttention.editStyle = [self getStyleWithStatus:self.cardModel.status];;
    [section addItem:self.sendCardWhenAttention];
    
    if (self.cardModel.followStatus) {
        self.startTimeDataStrategy.dateString = self.cardModel.followStartTime;
        self.sendCardWhenAttentionStartTimeItem.textValue = self.cardModel.followStartTime;
        self.sendCardWhenAttentionStartTimeItem.preValue = self.cardModel.followStartTime;
        self.sendCardWhenAttentionStartTimeItem.editStyle = [self getStyleWithStatus:self.cardModel.status];
        [section addItem:self.sendCardWhenAttentionStartTimeItem];
        
        self.endTimeDataStrategy.dateString = self.cardModel.followEndTime;
        self.sendCardWhenAttentionEndTimeItem.textValue = self.cardModel.followEndTime;
        self.sendCardWhenAttentionEndTimeItem.preValue = self.cardModel.followEndTime;
        self.sendCardWhenAttentionEndTimeItem.editStyle =[self getStyleWithStatus:self.cardModel.status];
        [section addItem:self.sendCardWhenAttentionEndTimeItem];
    }
    
    self.sendCardWhenPay = [[TDFSwitchItem alloc] init];
    self.sendCardWhenPay.requestKey = @"payStatus";
    self.sendCardWhenPay.title = @"在顾客支付时发卡";
    self.sendCardWhenPay.isOn = self.cardModel.payStatus;
    self.sendCardWhenPay.preValue = @(self.cardModel.payStatus);
    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc] initWithString:@"注：该卡同步到您授权的公众号后，顾客使用微信支付后，将收到消息提醒顾客领取卡，如果已经领过卡，不会发送消息，此项可设置会员卡，仅支持开通1种卡。\n"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"请确认您已开通特约商户，并且您的公众号认证主体与您店里使用的微信支付的认证主体一致，否则消息无法发出。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName : [UIColor redColor]}];
    [infoString appendAttributedString:attributedStr];
    
    self.sendCardWhenPay.attributedDetail = infoString;
    self.sendCardWhenPay.editStyle = [self getStyleWithStatus:self.cardModel.status];
    [section addItem:self.sendCardWhenPay];
    
    if (self.cardModel.payStatus) {
        [self changeTimeDataStrategy:self.payStartTimeDataStrategy
                             andItem:self.sendCardWhenPayStartTimeItem
                            withData:self.cardModel.payStartTime
                         andPreValue:self.cardModel.payStartTime];
        self.sendCardWhenPayStartTimeItem.editStyle = [self getStyleWithStatus:self.cardModel.status];
        [section addItem:self.sendCardWhenPayStartTimeItem];
        
        [self changeTimeDataStrategy:self.payEndTimeDataStrategy
                             andItem:self.sendCardWhenPayEndTimeItem
                            withData:self.cardModel.payEndTime
                         andPreValue:self.cardModel.payEndTime];
        self.sendCardWhenPayEndTimeItem.editStyle = [self getStyleWithStatus:self.cardModel.status];
        [section addItem:self.sendCardWhenPayEndTimeItem];
    }
    
    [self.manager addSection:section];
    
    self.sendCardWhenAttention.filterBlock = ^(BOOL isOn) {
        [MobClick event:@"wechat_card_followset" attributes:@{@"wechat_card_followset" : @(isOn)}];
        
        @strongify(self);
        if (!self.headerItem.isOn || self.cardModel.status == 0) {
            [self showMessageWithTitle:@"提示" message:@"此卡未同步到微信，无法设置" cancelTitle:@"我知道了"];
            return NO;
        }
        [self updateSendCardWhenAttentionInSection:section isOn:isOn];
        return YES;
    };
    
    self.sendCardWhenPay.filterBlock = ^(BOOL isOn){
        [MobClick event:@"wechat_card_payset" attributes:@{@"wechat_card_payset" : @(isOn)}];
        
        @strongify(self);
        if (!self.headerItem.isOn || self.cardModel.status == 0) {
            [self showMessageWithTitle:@"提示" message:@"此卡未同步到微信，无法设置" cancelTitle:@"我知道了"];
            return NO;
        }
        [self updateSendCardWhenPayInSection:section isOn:isOn];
        return YES;
    };
    
    ///（开始时间没约束默认为今天、结束时间不能早于开始时间、结束时间不能早于今天）
    ///关注时发卡开始时间
    self.sendCardWhenAttentionStartTimeItem.filterBlock = ^(NSString *textValue,id requestValue) {
        @strongify(self);
        if (self.sendCardWhenAttentionEndTimeItem.textValue.length == 0) {
            self->_saveCardModel.followStartTime = textValue;
            return YES;
        }
        NSDate *endDate = [DateUtils DateWithString:self.sendCardWhenAttentionEndTimeItem.textValue type:TDFFormatTimeTypeYearMonthDayString];
        NSDate *date = [DateUtils DateWithString:textValue type:TDFFormatTimeTypeYearMonthDayString];
        BOOL isVerify = [self verifyDate:date andEndDate:endDate];
        if (isVerify) {
            self->_saveCardModel.followStartTime = textValue;
        }
        return isVerify;
    };
    
    ///关注时发卡结束时间
    self.sendCardWhenAttentionEndTimeItem.filterBlock = ^(NSString *textValue,id requestValue) {
        @strongify(self);
        NSDate *startDate = [DateUtils DateWithString:self.sendCardWhenAttentionStartTimeItem.textValue type:TDFFormatTimeTypeYearMonthDayString];
        NSDate *date = [DateUtils DateWithString:textValue type:TDFFormatTimeTypeYearMonthDayString];
        BOOL isVerify = [self verifyDate:startDate andEndDate:date];
        if (isVerify) {
            self->_saveCardModel.followEndTime = textValue;
        }
        return isVerify;
    };
    ///支付时发卡开始时间
    self.sendCardWhenPayStartTimeItem.filterBlock = ^(NSString *textValue,id requestValue) {
        @strongify(self);
        if (self.sendCardWhenPayEndTimeItem.textValue.length == 0) {
            self->_saveCardModel.payStartTime = textValue;
            return YES;
        }
        NSDate *endDate = [DateUtils DateWithString:self.sendCardWhenPayEndTimeItem.textValue type:TDFFormatTimeTypeYearMonthDayString];
        NSDate *date = [DateUtils DateWithString:textValue type:TDFFormatTimeTypeYearMonthDayString];
        BOOL isVerify = [self verifyDate:date andEndDate:endDate];
        if (isVerify) {
            self->_saveCardModel.payStartTime = textValue;
        }
        return isVerify;
    };
    ///支付时发卡结束时间
    self.sendCardWhenPayEndTimeItem.filterBlock = ^(NSString *textValue,id requestValue) {
        @strongify(self);
        NSDate *startDate = [DateUtils DateWithString:self.sendCardWhenPayStartTimeItem.textValue type:TDFFormatTimeTypeYearMonthDayString];
        NSDate *date = [DateUtils DateWithString:textValue type:TDFFormatTimeTypeYearMonthDayString];
        BOOL isVerify = [self verifyDate:startDate andEndDate:date];
        if (isVerify) {
            self->_saveCardModel.payEndTime = textValue;
        }
        return isVerify;
    };
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
            str = @"此卡未同步到微信卡券";
            break;
        case 1:
            str = @"此卡已同步到微信卡券";
            break;
        case 2:
            str = @"此卡正在同步到微信卡券";
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
///关注时发卡回调
- (void)updateSendCardWhenAttentionInSection:(DHTTableViewSection *)section
                                        isOn:(BOOL)isOn {
    self->_saveCardModel.followStatus = isOn;
    if (isOn) {
        _saveCardModel.followStartTime = _saveCardModel.followStartTime.length > 0 ? _saveCardModel.followStartTime :[DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearMonthDay];
        [self changeTimeDataStrategy:self.startTimeDataStrategy
                             andItem:self.sendCardWhenAttentionStartTimeItem
                            withData:_saveCardModel.followStartTime
                         andPreValue:self.cardModel.followStartTime];
        [section insertItem:self.sendCardWhenAttentionStartTimeItem
                  belowItem:self.sendCardWhenAttention];
        
        [self changeTimeDataStrategy:self.endTimeDataStrategy
                             andItem:self.sendCardWhenAttentionEndTimeItem
                            withData:self.cardModel.followEndTime
                         andPreValue:self.cardModel.followEndTime];
        [section insertItem:self.sendCardWhenAttentionEndTimeItem
                  belowItem:self.sendCardWhenAttentionStartTimeItem];
    }else {
        [section removeItem:self.sendCardWhenAttentionStartTimeItem];
        [section removeItem:self.sendCardWhenAttentionEndTimeItem];
    }
    [self.manager reloadData];
}

///支付时发卡回调
- (void)updateSendCardWhenPayInSection:(DHTTableViewSection *)section
                                        isOn:(BOOL)isOn {
    _saveCardModel.payStatus = isOn;
    if (isOn) {
        _saveCardModel.payStartTime = _saveCardModel.payStartTime.length >0 ? _saveCardModel.payStartTime:[DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearMonthDay];
        [self changeTimeDataStrategy:self.payStartTimeDataStrategy
                             andItem:self.sendCardWhenPayStartTimeItem
                            withData:_saveCardModel.payStartTime
                         andPreValue:self.cardModel.payStartTime];
        [section insertItem:self.sendCardWhenPayStartTimeItem
                  belowItem:self.sendCardWhenPay];
        
        [self changeTimeDataStrategy:self.payEndTimeDataStrategy
                             andItem:self.sendCardWhenPayEndTimeItem
                            withData:_saveCardModel.payEndTime
                         andPreValue:self.cardModel.payEndTime];
        [section insertItem:self.sendCardWhenPayEndTimeItem
                  belowItem:self.sendCardWhenPayStartTimeItem];
    }else {
        [section removeItem:self.sendCardWhenPayStartTimeItem];
        [section removeItem:self.sendCardWhenPayEndTimeItem];
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
    if ((_saveCardModel.followStatus && _saveCardModel.followEndTime.length == 0) || (_saveCardModel.payStatus &&  _saveCardModel.payEndTime.length == 0)) {
        [AlertBox show:@"结束时间不能为空!"];
        return NO;
    }
    return YES;
}


- (BOOL)verifyDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    if ([[startDate earlierDate:endDate] isEqual:endDate]&& ![startDate isEqualToDate:endDate]) {
        [self showMessageWithTitle:@"提示" message:@"结束时间不可早于开始时间" cancelTitle:@"我知道了"];
        return NO;
    }
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
    
    if ([self.manager tdf_anyItemInvalid]) {
        return;
    }
    
    self->_saveCardModel.activeEndTime = self.scEndTimeItem.textValue;
    self->_saveCardModel.activeStatus = self.sendCouponWhenActiveTheCardItem.isOn;
    
    [self showProgressHudWithText:@"正在保存"];
    [[TDFWechatMarketingService service] saveSynchronizeCardInfoWithOAId:self.cardModel.wxId
                                                        andOverwriteFlag:_overwriteFlag
                                                                cardInfo:[_saveCardModel yy_modelToJSONString]
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
                                                                              self.callBack(_saveCardModel);
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
        [_manager registerItems:@[S(TDFSKSingleButtonItem),
                                  S(TDFSKDisplayedTextItem)]];
    }
    return _manager;
}

- (TDFPickerItem *)sendCardWhenAttentionStartTimeItem {
    if (!_sendCardWhenAttentionStartTimeItem) {
        _sendCardWhenAttentionStartTimeItem = [[TDFPickerItem alloc] init];
        _sendCardWhenAttentionStartTimeItem.title = @"▪︎ 开始时间";
        _sendCardWhenAttentionStartTimeItem.requestKey = @"followStartTime";
    }
    return _sendCardWhenAttentionStartTimeItem;
}

- (TDFPickerItem *)sendCardWhenAttentionEndTimeItem {
    if (!_sendCardWhenAttentionEndTimeItem) {
        _sendCardWhenAttentionEndTimeItem = [[TDFPickerItem alloc] init];
        _sendCardWhenAttentionEndTimeItem.title = @"▪︎ 结束时间";
        _sendCardWhenAttentionEndTimeItem.requestKey = @"followEndTime";
    }
    return _sendCardWhenAttentionEndTimeItem;
}

- (TDFPickerItem *)sendCardWhenPayStartTimeItem {
    if (!_sendCardWhenPayStartTimeItem) {
        _sendCardWhenPayStartTimeItem = [[TDFPickerItem alloc] init];
        _sendCardWhenPayStartTimeItem.title = @"▪︎ 开始时间";
        _sendCardWhenPayStartTimeItem.requestKey = @"payStartTime";
    }
    return _sendCardWhenPayStartTimeItem;
}

- (TDFPickerItem *)sendCardWhenPayEndTimeItem {
    if (!_sendCardWhenPayEndTimeItem) {
        _sendCardWhenPayEndTimeItem = [[TDFPickerItem alloc] init];
        _sendCardWhenPayEndTimeItem.title = @"▪︎ 结束时间";
        _sendCardWhenPayEndTimeItem.requestKey = @"payEndTime";
    }
    return _sendCardWhenPayEndTimeItem;
}

- (TDFShowDateStrategy *)startTimeDataStrategy {
    if (!_startTimeDataStrategy) {
        _startTimeDataStrategy = [[TDFShowDateStrategy alloc] init];
        _startTimeDataStrategy.pickerName = @"开始时间";
        self.sendCardWhenAttentionStartTimeItem.strategy = _startTimeDataStrategy;
    }
    return _startTimeDataStrategy;
}

- (TDFShowDateStrategy *)endTimeDataStrategy {
    if (!_endTimeDataStrategy) {
        _endTimeDataStrategy = [[TDFShowDateStrategy alloc] init];
        _endTimeDataStrategy.pickerName = @"结束时间";
        self.sendCardWhenAttentionEndTimeItem.strategy = _endTimeDataStrategy;
    }
    return _endTimeDataStrategy;
}

- (TDFShowDateStrategy *)payStartTimeDataStrategy {
    if (!_payStartTimeDataStrategy) {
        _payStartTimeDataStrategy = [[TDFShowDateStrategy alloc] init];
        _payStartTimeDataStrategy.pickerName = @"开始时间";
        self.sendCardWhenPayStartTimeItem.strategy = _payStartTimeDataStrategy;
    }
    return _payStartTimeDataStrategy;
}

- (TDFShowDateStrategy *)payEndTimeDataStrategy {
    if (!_payEndTimeDataStrategy) {
        _payEndTimeDataStrategy = [[TDFShowDateStrategy alloc] init];
        _payEndTimeDataStrategy.pickerName = @"结束时间";
        self.sendCardWhenPayEndTimeItem.strategy = _payEndTimeDataStrategy;
    }
    return _payEndTimeDataStrategy;
}

@end
