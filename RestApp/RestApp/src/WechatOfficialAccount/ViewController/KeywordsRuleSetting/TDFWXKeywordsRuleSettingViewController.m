
//
//  TDFWXKeywordsRuleSettingViewController.m
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFAPIKit/TDFAPIKit.h>
#import <TDFCategories/TDFCategories.h>
#import <TDFAPIHUDPresenter/TDFAPIHUDPresenter.h>

#import "DHTTableViewManager+Validation.h"
#import "DHTTableViewManager+Register.h"
#import "TDFCustomStrategy+Generator.h"
#import "TDFTextfieldItem+FormatValidatable.h"
#import "TDFPickerItem+FormatValidatable.h"
#import "TDFPickerItem+ValueInterface.h"
#import "TDFSwitchItem+ValueInterface.h"
#import "TDFTextfieldItem+ValueInterface.h"

#import "TDFWXOfficialAccountActionPath.h"
#import "TDFTextfieldItemValidator.h"
#import "TDFSKOptionPickerStrategy.h"
#import "TDFLabelItem.h"
#import "TDFPickerItem.h"
#import "TDFTextfieldItem.h"
#import "TDFSKSingleButtonItem.h"
#import "TDFSKDisplayedTextItem.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "TDFWXKeywordsAutoreplyItem.h"
#import "TDFSKDisplayedImageItem.h"
#import "TDFWXKeywordsRuleModel.h"
#import "TDFSynchronizeCardInfoModel.h"
#import "TDFWXSyncedCardSelectorDelegate.h"
#import "TDFWXSyncedCouponSelectorDelegate.h"

#import "TDFCardSelectorViewController.h"
#import "TDFWXKeywordsRuleSettingViewController.h"



#define TDFWXKeywordsReplyTypeStrings  @[@"纯文字", @"会员卡", @"优惠券"]
#define TDFWXSyncWeChatTipStrings @[@"此处文字最多不可超过60个字。",\
@"此处的会员卡仅限已同步到微信卡券的会员卡。", \
@"此处的优惠券仅限已同步到微信卡券的优惠券。"]

@interface TDFWXKeywordsRuleSettingViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DHTTableViewManager *manager;
@property (strong, nonatomic) DHTTableViewSection *section;

@property (strong, nonatomic) TDFTextfieldItem *ruleNameItem;
@property (strong, nonatomic) TDFTextfieldItem *keywordsItem;
@property (strong, nonatomic) TDFPickerItem *autoreplyContentItem;

@property (strong, nonatomic) TDFPickerItem *cardToReplyItem;
@property (strong, nonatomic) TDFPickerItem *couponToReplyItem;
@property (strong, nonatomic) TDFTextfieldItem *textToReplyItem;

@property (strong, nonatomic) TDFSKDisplayedTextItem *syncWeChatTipItem;
@property (strong, nonatomic) TDFSKSingleButtonItem *deleteRuleItem;
@property (strong, nonatomic) TDFSKDisplayedImageItem *sampleImageItem;
@property (strong, nonatomic) TDFGeneralAPI *saveApi;
@property (strong, nonatomic) TDFGeneralAPI *deleteApi;

@property (strong, nonatomic) dispatch_block_t modifiedHandler;
@property (strong, nonatomic) TDFWXKeywordsRuleModel *rule;
@property (strong, nonatomic) NSString *wxAppId;

@property (strong, nonatomic) TDFWXSyncedCardSelectorDelegate *cardSelectorDelegate;
@property (strong, nonatomic) TDFWXSyncedCouponSelectorDelegate *couponSelectorDelegate;
@end

@implementation TDFWXKeywordsRuleSettingViewController
#pragma mark - life cycle
- (instancetype)initWithModifiedHandler:(dispatch_block_t)modifiedHandler wxAppId:(NSString *)wxAppId {
    return [self initWithRule:nil modifiedHandler:modifiedHandler wxAppId:wxAppId];
}

- (instancetype)initWithRule:(TDFWXKeywordsRuleModel *)rule modifiedHandler:(dispatch_block_t)modifiedHandler wxAppId:(NSString *)wxAppId{
    if (self = [super init]) {
        self.modifiedHandler = modifiedHandler;
        self.rule = rule;
        self.wxAppId = wxAppId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关键词规则设置";
    
    [self nbc_setupNavigationBarType:TDFNavigationBarTypeSaved];
    
    [self configureSubviews];
    [self configureSections];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidChanged:)
                                                 name:kTDFEditViewIsShowTipNotification
                                               object:nil];
    
    [self initializeItemsWithRule:self.rule];
    [self configureItemsStrategy];
}


#pragma mark - TDFNavigationClickListenerProtocol
- (void)viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    if (!self.manager.tdf_anyItemInvalid) {
        @weakify(self)
        self.saveApi.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
            @strongify(self)
            [self popViewController];
        };
        
        self.rule.ruleName = self.ruleNameItem.textValue;
        self.rule.text = self.textToReplyItem.textValue;
        self.rule.keywords = self.keywordsItem.textValue;
        self.rule.contentType = [TDFWXKeywordsReplyTypeStrings indexOfObject:self.autoreplyContentItem.textValue] + 1;
        
        self.saveApi.params[kTDFAPWXSaveKeywordsRuleKeywordsRuleJsonKey] = [self.rule yy_modelToJSONString];
        self.saveApi.params[kTDFAPWXSaveKeywordsRuleWxAppIdKey] = self.wxAppId;
        [self.saveApi start];
    }
}

#pragma mark - private configure
- (void)configureSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configureItemsStrategy {
    @weakify(self)
    self.cardToReplyItem.strategy = [TDFCustomStrategy wx_strategyWithBlock:^{
        @strongify(self)
        TDFCardSelectorViewController *viewController = [[TDFCardSelectorViewController alloc] initWithTitle:self.cardToReplyItem.title];
        viewController.delegate = self.cardSelectorDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    self.couponToReplyItem.strategy = [TDFCustomStrategy wx_strategyWithBlock:^{
        @strongify(self)
        TDFCardSelectorViewController *viewController = [[TDFCardSelectorViewController alloc] initWithTitle:self.couponToReplyItem.title];
        viewController.delegate = self.couponSelectorDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];

    TDFSKOptionPickerStrategy *strategy = [[TDFSKOptionPickerStrategy alloc] init];
    strategy.pickerName = self.autoreplyContentItem.title;
    NSInteger selectedIndex = [TDFWXKeywordsReplyTypeStrings indexOfObject:self.autoreplyContentItem.textValue];
    strategy.selectedIndex = selectedIndex != NSNotFound ? selectedIndex : 0;
    strategy.items = TDFWXKeywordsReplyTypeStrings;
    strategy.afterApplyBlock = ^(NSString *item) {
        @strongify(self)
        [self configureAutoreplayContentTitle:item];
    };
    self.autoreplyContentItem.strategy = strategy;
}

- (void)configureAutoreplayContentType:(TDFWXKeywordsReplyType)type {
    NSDictionary *subcontentMap = @{@(TDFWXKeywordsReplyTypeCard) : self.cardToReplyItem,
                                    @(TDFWXKeywordsReplyTypeCoupon) : self.couponToReplyItem,
                                    @(TDFWXKeywordsReplyTypeText) : self.textToReplyItem};
    if (type > TDFWXKeywordsReplyTypeCoupon || TDFWXKeywordsReplyTypeText > type) {
        return;
    }
    
    TDFBaseEditItem *selectedItem = subcontentMap[@(type)];
    selectedItem.shouldShow = YES;
    
    TDFLogInfo(@"selected item title: %@", selectedItem.title);
    
    [[[subcontentMap allValues] tdf_filter:^BOOL(id value) {
        return ![selectedItem isEqual:value];
    }] tdf_forEach:^(id <TDFEditCommonPropertyProtocol> value) {
        value.shouldShow = NO;
    }];
    
    self.syncWeChatTipItem.text = TDFWXSyncWeChatTipStrings[type - 1];
    
    if (self.autoreplyContentItem.preValue) {
        self.autoreplyContentItem.textValue = TDFWXKeywordsReplyTypeStrings[type - 1];
    } else {
        self.autoreplyContentItem.tdf_originValue = TDFWXKeywordsReplyTypeStrings[type - 1];
    }
    
    [self.manager reloadData];
}

- (void)configureAutoreplayContentTitle:(NSString *)title {
    TDFWXKeywordsReplyType type = (TDFWXKeywordsReplyType)[TDFWXKeywordsReplyTypeStrings indexOfObject:title] + 1;
    
    self.rule.contentType = type;
    
    [self configureAutoreplayContentType:type];
}

- (void)configureSections {
    [self.manager addSection:self.section];
    [self.section addItem:self.ruleNameItem];
    [self.section addItem:self.keywordsItem];
    [self.section addItem:self.autoreplyContentItem];
    [self.section addItem:self.cardToReplyItem];
    [self.section addItem:self.couponToReplyItem];
    [self.section addItem:self.textToReplyItem];
    [self.section addItem:self.syncWeChatTipItem];
    
    if (self.rule) {
        [self.section addItem:self.deleteRuleItem];
    } else {
        self.rule = [[TDFWXKeywordsRuleModel alloc] init];
        self.rule.contentType = TDFWXKeywordsReplyTypeCard;
    }
    
    [self.section addItem:self.sampleImageItem];
}


- (void)initializeItemsWithRule:(TDFWXKeywordsRuleModel *)rule {
    [self configureAutoreplayContentType:rule.contentType];
    
    self.ruleNameItem.tdf_originValue = rule.ruleName;
    self.keywordsItem.tdf_originValue = rule.keywords;
    
    self.cardToReplyItem.tdf_originValue = rule.cardName;
    self.couponToReplyItem.tdf_originValue = rule.couponName;
    self.textToReplyItem.tdf_originValue = rule.text;
}

#pragma mark - private Notification
- (void)itemDidChanged:(NSNotification *)notification {
    [self nbc_setupNavigationBarType:[TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections] ? TDFNavigationBarTypeSaved : TDFNavigationBarTypeNormal];
}

- (void)popViewController {
    if (self.modifiedHandler) {
        self.modifiedHandler();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter

- (TDFWXSyncedCouponSelectorDelegate *)couponSelectorDelegate {
    if (!_couponSelectorDelegate) {
        _couponSelectorDelegate = [[TDFWXSyncedCouponSelectorDelegate alloc] initWithWxId:self.wxAppId selectedIndexForCouponsBlock:^NSInteger(NSArray *coupons) {
            return [coupons tdf_indexOfObjectUsingMatchingBlock:^BOOL(TDFSynchronizeCardInfoModel *coupon) {
                return [self.rule.couponId isEqual:coupon.cardId];
            }];
        } finishSelectCouponBlock:^(TDFSynchronizeCardInfoModel *card) {
            self.rule.couponId = card.cardId;
            self.rule.couponName = card.cardName;
            self.couponToReplyItem.textId = card.cardId;
            self.couponToReplyItem.textValue = card.cardName;
            
            [self.manager reloadData];
        }];
    }
    
    return _couponSelectorDelegate;
}

- (TDFWXSyncedCardSelectorDelegate *)cardSelectorDelegate {
    if (!_cardSelectorDelegate) {
        @weakify(self)
        _cardSelectorDelegate = [[TDFWXSyncedCardSelectorDelegate alloc] initWithWxId:self.wxAppId selectedIndexForCardsBlock:^NSInteger(NSArray *cards) {
            @strongify(self)
            return [cards tdf_indexOfObjectUsingMatchingBlock:^BOOL(TDFSynchronizeCardInfoModel *card) {
                return [self.rule.cardId isEqual:card.cardId];
            }];
        } finishSelectCardBlock:^(TDFSynchronizeCardInfoModel *card) {
            @strongify(self)
            
            self.rule.cardId = card.cardId;
            self.rule.cardName = card.cardName;
            self.cardToReplyItem.textId = card.cardId;
            self.cardToReplyItem.textValue = card.cardName;
            
            [self.manager reloadData];
        }];
    }
    
    return _cardSelectorDelegate;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (TDFSKDisplayedImageItem *)sampleImageItem {
    if (!_sampleImageItem) {
        _sampleImageItem = [TDFSKDisplayedImageItem item];
        _sampleImageItem.imageInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        _sampleImageItem.cellHeight = 235;
        _sampleImageItem.image = [UIImage imageNamed:@"wx_keywords_setting_sample"];
    }
    
    return _sampleImageItem;
}

- (TDFSKSingleButtonItem *)deleteRuleItem {
    if (!_deleteRuleItem) {
        TDFSKButtonItemTransaction *transaction = [[TDFSKButtonItemTransaction alloc] init];
        transaction.title = @"删除此规则";
        @weakify(self)
        transaction.clickedHandler = ^{
            @strongify(self)
            
            self.deleteApi.params[kTDFAPWXDeleteKeywordsRuleWXAppIdKey] = self.wxAppId;
            self.deleteApi.params[kTDFAPWXDeleteKeywordsRuleKeywordsRuleIdKey] = self.rule.id;
            self.deleteApi.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
                @strongify(self)
                [self popViewController];
            };

            [self.deleteApi  start];
        };
        
        _deleteRuleItem = [TDFSKSingleButtonItem item];
        _deleteRuleItem.transaction = transaction;
    }
    
    return _deleteRuleItem;
}

- (TDFSKDisplayedTextItem *)syncWeChatTipItem {
    if (!_syncWeChatTipItem) {
        _syncWeChatTipItem = [TDFSKDisplayedTextItem item];
        _syncWeChatTipItem.text = @"此处的会员卡仅限已同步到微信卡包的会员卡。";
        _syncWeChatTipItem.font = [UIFont systemFontOfSize:11];
        _syncWeChatTipItem.textColor = [UIColor tdf_colorWithRGB:0x666666];
        _syncWeChatTipItem.showSplitLine = NO;
    }
    
    return _syncWeChatTipItem;
}

- (TDFTextfieldItem *)textToReplyItem {
    if (!_textToReplyItem) {
        _textToReplyItem = [TDFTextfieldItem item];
        _textToReplyItem.title = @"输入要回复的文字";
        _textToReplyItem.tdf_validatorFilterBlock = [TDFTextfieldItemValidator validateTextLength:60];
        _textToReplyItem.shouldShow = NO;
    }
    
    return _textToReplyItem;
}

- (TDFPickerItem *)couponToReplyItem {
    if (!_couponToReplyItem) {
        _couponToReplyItem = [TDFPickerItem item];
        _couponToReplyItem.title = @"选择要回复的优惠券";
        _couponToReplyItem.shouldShow = NO;
    }
    
    return _couponToReplyItem;
}

- (TDFPickerItem *)cardToReplyItem {
    if (!_cardToReplyItem) {
        _cardToReplyItem = [TDFPickerItem item];
        _cardToReplyItem.title = @"选择要回复的会员卡";
    }
    
    return _cardToReplyItem;
}

- (TDFPickerItem *)autoreplyContentItem {
    if (!_autoreplyContentItem) {
        _autoreplyContentItem = [TDFPickerItem item];
        _autoreplyContentItem.title = @"自动回复内容";
    }
    
    return _autoreplyContentItem;
}

- (TDFTextfieldItem *)keywordsItem {
    if (!_keywordsItem) {
        _keywordsItem = [TDFTextfieldItem item];
        _keywordsItem.placeholder = @"最多60个字";
        _keywordsItem.title = @"关键词";
        _keywordsItem.tdf_validatorFilterBlock = [TDFTextfieldItemValidator validateTextLength:60];
    }
    
    return _keywordsItem;
}

- (TDFTextfieldItem *)ruleNameItem {
    if (!_ruleNameItem) {
        _ruleNameItem = [TDFTextfieldItem item];
        _ruleNameItem.title = @"规则名称";
        _ruleNameItem.tdf_validatorFilterBlock = [TDFTextfieldItemValidator validateTextLength:16];
    }
    
    return _ruleNameItem;
}

- (DHTTableViewSection *)section {
    if (!_section) {
        _section = [DHTTableViewSection section];
    }
    
    return _section;
}

- (DHTTableViewManager *)manager {
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerItems:@[S(TDFWXKeywordsAutoreplyItem),
                                  S(TDFSKDisplayedTextItem),
                                  S(TDFLabelItem),
                                  S(TDFPickerItem),
                                  S(TDFSKSingleButtonItem),
                                  S(TDFSKDisplayedTextItem),
                                  S(TDFTextfieldItem),
                                  S(TDFSKDisplayedImageItem)]];
    }
    
    return _manager;
}

- (TDFGeneralAPI *)deleteApi {
    if (!_deleteApi) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXDeleteKeywordsRule];
        requestModel.apiVersion = kTDFAPWXDeleteKeywordsRuleVersion;
        
        _deleteApi = [[TDFGeneralAPI alloc] init];
        _deleteApi.requestModel = requestModel;
        _deleteApi.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _deleteApi;
}

- (TDFGeneralAPI *)saveApi {
    if (!_saveApi) {
        TDFWXOfficialAccountRequestModel *requestModel = [TDFWXOfficialAccountRequestModel modelWithActionPath:kTDFAPWXSaveKeywordsRule];
        requestModel.apiVersion = kTDFAPWXSaveKeywordsRuleVersion;
        
        _saveApi = [[TDFGeneralAPI alloc] init];
        _saveApi.requestModel = requestModel;
        _saveApi.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _saveApi;
}

@end
