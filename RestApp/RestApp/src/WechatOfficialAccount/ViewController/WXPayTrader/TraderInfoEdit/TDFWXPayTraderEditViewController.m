//
//  TDFWXPayTraderEditViewController.m
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayTraderEditViewController.h"
#import "TDFForm.h"
#import "TDFImageSelectItem.h"
#import "TDFImageSelectCell.h"
#import "BackgroundHelper.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "YYModel.h"
#import "DicSysItem.h"
#import "TDFWXPayTraderModel.h"
#import "TDFShowDatePickerStrategy.h"
#import "UIViewController+HUD.h"
#import "TDFWechatMarketingService.h"
#import <TDFAsync/TDFAsync.h>
#import "TDFPaymentService.h"
#import "TDFAsync.h"
#import "TDFAsyncPickerStrategy.h"
#import "ShopInfoVO.h"
#import "NameItemVO.h"
#import "YYModel.h"
#import "TDFCustomStrategy.h"
#import "WXOAConst.h"
#import "OptionSelectView.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"
#import "UIImage+TDF_fixOrientation.h"
#import "TDFMemberCouponService.h"
#import "TDFAuditStatusViewController.h"
#import "TDFAsync.h"
#import "NSString+Sino.h"
#import "DicSysItem+Extension.h"

#define NSStringFromInteger(x) [NSString stringWithFormat:@"%zd", x]

@interface TDFWXPayTraderEditViewController ()<OptionSelectClient, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DHTTableViewManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DHTTableViewManager *tableViewManager;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) TDFWXPayTraderModel *model;

///////////////////////////////////////////////////////////////////////
//////                     联系人                                 //////
///////////////////////////////////////////////////////////////////////

/**
 *  联系人 Header
 */
@property (strong, nonatomic) DHTTableViewSection *contactHeaderSection;
/**
 *  联系人 Section
 */
@property (strong, nonatomic) DHTTableViewSection *contactSection;
/**
 *  联系人姓名
 */
@property (strong, nonatomic) TDFTextfieldItem *contactNameItem;
/**
 *  常用邮箱
 */
@property (strong, nonatomic) TDFTextfieldItem *emailItem;
/**
 *  联系人手机
 */
@property (strong, nonatomic) TDFTextfieldItem *phoneItem;

///////////////////////////////////////////////////////////////////////
//////                       经营信息                             //////
//////////////////////////////////////////////////////////////////////

/**
 *  经营信息 Header
 */
@property (strong, nonatomic) DHTTableViewSection *businessHeaderSection;
/**
 *  经营信息 Section
 */
@property (strong, nonatomic) DHTTableViewSection *businessSection;
/**
 *  公司名称
 */
@property (strong, nonatomic) TDFTextfieldItem *componeyItem;
/**
 *  注册地址
 */
@property (strong, nonatomic) TDFTextfieldItem *addressItem;
/**
 *  商家简介
 */
@property (strong, nonatomic) TDFTextfieldItem *abbreviationItem;
/**
 *  商家类目 Strategy
 */
@property (strong, nonatomic) TDFShowPickerStrategy *traderTypeStrategy;
@property (copy, nonatomic) NSArray<DicSysItem *> *traderTypeItems;
/**
 *  商家类目
 */
@property (strong, nonatomic) TDFPickerItem *traderTypeItem;
/**
 *  经营类目 - Strategy
 */
@property (strong, nonatomic) TDFShowPickerStrategy *businessTypeStrategy;
@property (copy, nonatomic) NSArray<DicSysItem *> *businessTypeItems;
/**
 *  经营类目
 */
@property (strong, nonatomic) TDFPickerItem *businessTypeItem;

/**
 *  经营子类目 - Strategy
 */
@property (strong, nonatomic) TDFShowPickerStrategy *businessSubTypeStrategy;
@property (copy, nonatomic) NSArray<DicSysItem *> *businessSubTypeItems;
/**
 *  经营子类目
 */
@property (strong, nonatomic) TDFPickerItem *businessSubTypeItem;
/**
 *  特殊资质 - 标题
 */
@property (strong, nonatomic) TDFStaticLabelItem *specialCreditTitleItem;
@property (strong, nonatomic) NSMutableArray *specialCreditURLs;
/**
 *  特殊资质 - 图片选择
 */
@property (strong, nonatomic) NSArray *specialCreditItems;
/**
 *  客服电话
 */
@property (strong, nonatomic) TDFTextfieldItem *servicePhoneItem;
/**
 *  营业执照注册号
 */
@property (strong, nonatomic) TDFTextfieldItem *businessLincenseItem;
/**
 *  经营范围
 */
@property (strong, nonatomic) TDFTextfieldItem *businessScopeItem;
/**
 *  营业执照 - 标题
 */
@property (strong, nonatomic) TDFStaticLabelItem *licenseTitleItem;
/**
 *  营业执照 - 图片选择
 */
@property (strong, nonatomic) TDFImageSelectItem *licenseItem;

///////////////////////////////////////////////////////////////////////
//////                    企业法人/经办人                          //////
//////////////////////////////////////////////////////////////////////

/**
 *  企业 -  Header
 */
@property (strong, nonatomic) DHTTableViewSection *enterpriseHeaderSection;
/**
 *  企业 Section
 */
@property (strong, nonatomic) DHTTableViewSection *enterpriseSection;
/**
 *  证件持有人类型 - Strategy
 */
@property (copy, nonatomic) NSArray<DicSysItem *> *certificateHolderTypeItems;
@property (strong, nonatomic) TDFShowPickerStrategy *certificateHolderTypeStrategy;
/**
 *  证件持有人类型
 */
@property (strong, nonatomic) TDFPickerItem *certificateHolderTypeItem;
/**
 *  证件持有人姓名
 */
@property (strong, nonatomic) TDFTextfieldItem *certificateHolderNameItem;
/**
 *  证件类型 - Strategy
 */
@property (copy, nonatomic) NSArray<DicSysItem *> *credentialTypeItems;
@property (strong, nonatomic) TDFShowPickerStrategy *credentialTypeStrategy;
/**
 *  证件类型
 */
@property (strong, nonatomic) TDFPickerItem *credentialTypeItem;
/**
 *  证件 - Title
 */
@property (strong, nonatomic) TDFStaticLabelItem *idCardTitleItem;
/**
 *  证件 - 正面照片选择
 */
@property (strong, nonatomic) TDFImageSelectItem *idCardFrontItem;
/**
 *  证件 - 背面照片选择
 */
@property (strong, nonatomic) TDFImageSelectItem *idCardBackItem;
/**
 *  证件创建日期 - Strategy
 */
@property (strong, nonatomic) TDFShowDatePickerStrategy *idCardCreationStrategy;
/**
 *  证件创建日期
 */
@property (strong, nonatomic) TDFPickerItem *idCardCreationItem;
/**
 *  证件过期日期 - Strategy
 */
@property (strong, nonatomic) TDFShowDatePickerStrategy *idCardExpiredStrategy;
/**
 * 证件失效日期
 */
@property (strong, nonatomic) TDFPickerItem *idCardExpiredItem;
/**
 *  证件号码
 */
@property (strong, nonatomic) TDFTextfieldItem *idCardNumberItem;
///////////////////////////////////////////////////////////////////////
//////                       结算信息                             //////
//////////////////////////////////////////////////////////////////////

@property (strong, nonatomic) DHTTableViewSection *accountHeaderSection;
@property (strong, nonatomic) DHTTableViewSection *accountSection;

/**
 *  账户类型 - Strategy
 */
@property (copy, nonatomic) NSArray<DicSysItem *> *accountTypeItems;
/**
 *  账户类型
 */
@property (strong, nonatomic) TDFPickerItem *accountTypeItem;
/**
 *  账户名称
 */
@property (strong, nonatomic) TDFTextfieldItem *accountNameItem;
/**
 *  开户银行 - Strategy
 */
@property (strong, nonatomic) TDFAsyncPickerStrategy *accountBankStrategy;

@property (copy, nonatomic) NSArray<DicSysItem *> *accountBankItems;
/**
 *  开户银行
 */
@property (strong, nonatomic) TDFPickerItem *accountBankItem;
/**
 *  开户省份
 */
@property (strong, nonatomic) TDFAsyncPickerStrategy *accountProvinceStrategy;
@property (strong, nonatomic) TDFPickerItem *accountProvinceItem;
/**
 *  开户城市
 */
@property (strong, nonatomic) TDFAsyncPickerStrategy *accountCityStrategy;
@property (strong, nonatomic) TDFPickerItem *accountCityItem;
/**
 *  开户支行
 */
@property (strong, nonatomic) TDFCustomStrategy *accountBranchStrategy;
@property (strong, nonatomic) TDFPickerItem *accountBranchItem;
/**
 *  银行帐号
 */
@property (strong, nonatomic) TDFTextfieldItem *accountNumberItem;
/**
 *  开户证明
 */
@property (strong, nonatomic) TDFImageSelectItem *accountPermitItem;

@property (strong, nonatomic) TDFImageSelectItem *currentTriggeredItem;



@end

@implementation TDFWXPayTraderEditViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    if (self.traderId) {
        
        [self loadData];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationItems) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTDFEditViewIsShowTipNotification object:nil];
}


#pragma mark - Methods


#pragma mark Config Views


- (void)updateViews {

    [self configSections];
    [self.tableViewManager reloadData];
}


- (void)configViews {
    
    [self configBackgroundViews];
    [self configContentViews];
    [self updateNavigationItems];
    [self configSections];
    self.title = WXOALocalizedString(@"WXOA_Pay_Trader_Title");
}



- (void)configBackgroundViews {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:v];
    [self.view addSubview:imageView];
}

- (void)configContentViews {

    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
}

- (void)updateNavigationItems {

    [self contentChanged] ? [self enableSaveAndCloseItem] : [self disableSaveAndCloseItem];
}

- (void)enableSaveAndCloseItem {
    
    UIImage *cancelImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_cancel"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState: UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIImage *okImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_ok"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitle:NSLocalizedString(@"保存", nil) forState: UIControlStateNormal];
    [saveButton setImage:okImage forState:UIControlStateNormal];
    saveButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    saveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
}

- (void)disableSaveAndCloseItem {

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
}



/**
 *  是否有内容被修改
 *
 *  @return BOOL
 */

- (BOOL)contentChanged {

    return [TDFEditViewHelper isAnyTipsShowedInSections:self.tableViewManager.sections];
}

- (void)configHeaderView {

    if (self.model.status != TDFWXPayTraderAuditStatuseSuccess) {
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    [self.view addSubview:self.headerView];
}

- (void)updateAccountName {

    //  企业
    if ([self.traderTypeItem.requestValue integerValue] == TDFTraderTypeEnterprise) {
    
        self.accountNameItem.textValue = self.componeyItem.textValue;
    } else {
        self.accountNameItem.textValue = self.certificateHolderNameItem.textValue;
    }
}

#pragma mark Config Sections



- (void)configSections {
    
    [self configContactSection];
    [self configEnterpriseSection];
    [self configBusinessSection];
    [self configAccountSection];
    
    for (DHTTableViewSection *section in self.tableViewManager.sections) {
        
        for (TDFBaseEditItem *item in section.items) {
            item.editStyle = self.readOnly ? TDFEditStyleUnEditable : TDFEditStyleEditable;
        }
    }
    
    self.accountNameItem.editStyle = TDFEditStyleUnEditable;
    self.accountTypeItem.editStyle = TDFEditStyleUnEditable;
    [self updateImageHeaderView];
    [self.tableViewManager reloadData];
}

/**
 *  联系信息 Section 配置
 */
- (void)configContactSection {

    
    self.contactNameItem.tdf_textValue(self.model.name).tdf_preValue(self.model.name).tdf_requestValue(self.model.name);
    self.emailItem.tdf_textValue(self.model.email).tdf_preValue(self.model.email).tdf_requestValue(self.model.email);
    self.phoneItem.tdf_textValue(self.model.phone).tdf_preValue(self.model.phone).tdf_requestValue(self.model.phone);
}

/**
 *  经营信息 Section 配置
 */
- (void)configBusinessSection {
    
    self.specialCreditURLs = [NSMutableArray arrayWithArray:self.model.specialCreditURLs];
    self.componeyItem.tdf_textValue(self.model.company).tdf_preValue(self.model.company).tdf_requestValue(self.model.company);
    self.addressItem.tdf_textValue(self.model.address).tdf_preValue(self.model.address).tdf_requestValue(self.model.address);
    self.abbreviationItem.tdf_textValue(self.model.abbreviation).tdf_preValue(self.model.abbreviation).tdf_requestValue(self.model.abbreviation);
    DicSysItem *item = self.traderTypeItems[self.model.traderType];
    self.traderTypeStrategy.selectedItem = item;
    self.traderTypeItem.tdf_textValue(item.name).tdf_preValue(item.name).tdf_requestValue(item._id);
    item = self.businessTypeItems[self.model.businessType];
    self.businessTypeStrategy.selectedItem = item;
    self.businessTypeItem.tdf_textValue(item.name).tdf_preValue(item.name).tdf_requestValue(item._id);
    item = self.businessSubTypeItems[self.model.businessSubType];
    self.businessSubTypeStrategy.selectedItem = item;
    self.businessSubTypeItem.tdf_textValue(item.name).tdf_preValue(item.name).tdf_requestValue(item._id);
    [self updateSpecialCreditItemsWithNeedInit:YES];
    self.servicePhoneItem.tdf_textValue(self.model.servicePhone).tdf_preValue(self.model.servicePhone).tdf_requestValue(self.model.servicePhone);
    self.businessLincenseItem.tdf_textValue(self.model.businessLicenseNumber).tdf_preValue(self.model.businessLicenseNumber).tdf_requestValue(self.model.businessLicenseNumber);
    self.businessScopeItem.tdf_textValue(self.model.businessScope).tdf_preValue(self.model.businessScope).tdf_requestValue(self.model.businessScope);
    self.licenseItem.requestValue = self.licenseItem.preValue = self.model.businessLicenseURL;
    
    if ([self.businessTypeItem.requestValue isEqualToString:@"0"]) {
        
        _businessSubTypeStrategy.pickerItemList =  [NSMutableArray arrayWithObjects:[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"食品", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"餐饮", nil)],nil];
    } else {
    
        _businessSubTypeStrategy.pickerItemList =  [NSMutableArray arrayWithObjects:[DicSysItem itemWithId:@"2" name:NSLocalizedString(@"便利店", nil)], [DicSysItem itemWithId:@"3" name:NSLocalizedString(@"其他综合零售", nil)],nil];
    }
}
/**
 *  企业法人 Section 配置
 */
- (void)configEnterpriseSection {

    DicSysItem *item = self.certificateHolderTypeItems[self.model.certificateHolderType];
    self.certificateHolderTypeStrategy.selectedItem = item;
    self.certificateHolderTypeItem.tdf_requestValue(item._id).tdf_textValue(item.name).tdf_preValue(item.name);
    self.certificateHolderNameItem.tdf_requestValue(self.model.certificateHolderName)
        .tdf_textValue(self.model.certificateHolderName).tdf_preValue(self.model.certificateHolderName);
    item = self.credentialTypeItems[self.model.credentialType];
    self.credentialTypeStrategy.selectedItem = item;
    self.credentialTypeItem.tdf_requestValue(item._id).tdf_textValue(item.name).tdf_preValue(item.name);
    [self updateCredentialImageItems];
    self.idCardFrontItem.requestValue = self.idCardFrontItem.preValue = self.model.idCardFrontImageURL;
    self.idCardBackItem.requestValue = self.idCardBackItem.preValue = self.model.idCardBackImageURL;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.idCardCreationDate / 1000.0];
    self.idCardCreationStrategy.currentDate = self.model.idCardCreationDate ? date : [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.idCardCreationStrategy.format;
    self.idCardCreationItem.tdf_requestValue(self.model.idCardCreationDate ? date : nil)
                           .tdf_textValue(self.model.idCardCreationDate ? [formatter stringFromDate:date] : nil)
                           .tdf_preValue(self.model.idCardCreationDate ? [formatter stringFromDate:date] : nil);
    
    date = [NSDate dateWithTimeIntervalSince1970:self.model.idCardExpiredDate / 1000.0];
    self.idCardExpiredStrategy.currentDate = self.model.idCardExpiredDate ? date : [NSDate date];
    self.idCardExpiredItem.tdf_requestValue(self.model.idCardExpiredDate ? date : nil)
                          .tdf_textValue(self.model.idCardExpiredDate ? [formatter stringFromDate:date] : nil)
                          .tdf_preValue(self.model.idCardExpiredDate ? [formatter stringFromDate:date] : nil);
    self.idCardNumberItem.tdf_requestValue(self.model.idCardNumber).tdf_textValue(self.model.idCardNumber)
                         .tdf_preValue(self.model.idCardNumber);
}
/**
 *  结算信息 Section 配置
 */
- (void)configAccountSection {

    DicSysItem *item = self.accountTypeItems[self.model.traderType];
    self.accountTypeItem.tdf_preValue(item.name).tdf_requestValue(item._id).tdf_textValue(item.name);
    self.accountNameItem.tdf_preValue(self.model.accountName).tdf_requestValue(self.model.accountName)
                        .tdf_textValue(self.model.accountName);
    self.accountNumberItem.tdf_preValue(self.model.accountNumber).tdf_requestValue(self.model.accountNumber)
                          .tdf_textValue(self.model.accountNumber);
    
    self.accountBankItem.tdf_requestValue(self.model.accountBankId)
                        .tdf_preValue(self.model.accountBankName).tdf_textValue(self.model.accountBankName);
    self.accountBankStrategy.currentSelectedItemId = self.model.accountBankId;
    
    self.accountProvinceStrategy.currentSelectedItemId = self.model.accountProvinceId;
    self.accountProvinceItem.tdf_textValue(self.model.accountProvinceName)
                            .tdf_preValue(self.model.accountProvinceName)
                            .tdf_requestValue(self.model.accountProvinceId);
    
    self.accountBranchItem.tdf_textValue(self.model.accountBranchName)
                          .tdf_requestValue(self.model.accountBranchId)
                          .tdf_preValue(self.model.accountBranchName);
    
    self.accountCityStrategy.currentSelectedItemId = self.model.accountCityId;
    self.accountCityItem.tdf_textValue(self.model.accountCityName)
                        .tdf_preValue(self.model.accountCityName)
                        .tdf_requestValue(self.model.accountCityId);
    self.accountPermitItem.requestValue = self.accountPermitItem.preValue = self.model.accountPermitURL;
    self.accountPermitItem.shouldShow = !self.readOnly || self.model.accountPermitURL.length > 0;
}

- (void)updateBusinessSubType {

    if ([self.businessTypeItem.requestValue isEqualToString:@"0"]) {
        
        _businessSubTypeStrategy.pickerItemList =  [NSMutableArray arrayWithObjects:[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"食品", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"餐饮", nil)],nil];
        _businessSubTypeItem.requestValue = @"0";
        _businessSubTypeItem.textValue = NSLocalizedString(@"食品", nil);
        [self.tableViewManager reloadData];
        return;
    }
    _businessSubTypeStrategy.pickerItemList =  [NSMutableArray arrayWithObjects:[DicSysItem itemWithId:@"2" name:NSLocalizedString(@"便利店", nil)], [DicSysItem itemWithId:@"3" name:NSLocalizedString(@"其他综合零售", nil)],nil];
    _businessSubTypeItem.requestValue = @"3";
    _businessSubTypeItem.textValue = NSLocalizedString(@"便利店", nil);
    [self.tableViewManager reloadData];
}

- (void)updateCredentialImageItems {

    self.idCardBackItem.shouldShow = [self.credentialTypeItem.requestValue integerValue] == TDFCredentialTypeIDCard;
    self.idCardBackItem.isRequired = [self.credentialTypeItem.requestValue integerValue] == TDFCredentialTypeIDCard;
    self.idCardTitleItem.title = [self.credentialTypeItem.requestValue integerValue] == TDFCredentialTypeIDCard ? NSLocalizedString(@"身份证图片", nil) : NSLocalizedString(@"护照图片", nil);
    self.idCardFrontItem.separatorHidden = [self.credentialTypeItem.requestValue integerValue] == TDFCredentialTypeIDCard;
    [self.tableViewManager reloadData];
}


- (void)updateImageHeaderView {
    
    self.specialCreditTitleItem.textValue = self.specialCreditURLs.count > 0 ? @"" : NSLocalizedString(@"必填", nil);
    self.licenseTitleItem.textValue = self.licenseItem.requestValue != nil ? @"" : NSLocalizedString(@"必填", nil);
    if ([self.credentialTypeItem.requestValue integerValue] == TDFCredentialTypeIDCard) {
        
        self.idCardTitleItem.textValue = self.idCardFrontItem.requestValue != nil
                                    &&   self.idCardBackItem.requestValue != nil ? @"" : NSLocalizedString(@"必填", nil);
    } else {
    
        self.idCardTitleItem.textValue = self.idCardFrontItem.requestValue != nil ? @"" : NSLocalizedString(@"必填", nil);
    }
}

- (void)updateSpecialCreditItemsWithNeedInit:(BOOL)needInit {
    
    NSInteger count = self.readOnly ? self.specialCreditURLs.count : self.specialCreditURLs.count + 1;
    
    for (NSInteger index = 0; index < 3; index++) {
        
        TDFImageSelectItem *item = self.specialCreditItems[index];
        if (index < self.specialCreditURLs.count) {
            NSString *urlString = self.specialCreditURLs[index];
            item.requestValue = urlString;
            if (needInit) {
                item.preValue = urlString;
            }
        } else {
            item.requestValue = nil;
        }
        item.separatorHidden = index == count - 1;
        item.tdf_shouldShow(index < count).tdf_isRequired(index < count);
    }
}

#pragma mark Upload Image

- (void)selectImage {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择图片来源", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    @weakify(self);
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"图库", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [self presentViewController:avc animated:YES completion:nil];
}


- (void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *pvc = [[UIImagePickerController alloc] init];
    pvc.mediaTypes = @[(NSString*)kUTTypeImage];
    pvc.sourceType = sourceType;
    pvc.delegate = self;
    [self presentViewController:pvc animated:YES completion:nil];
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self uploadImage:[image fixOrientation]];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Network



- (void)uploadImage:(UIImage *)image {

    [self showHUBWithText:NSLocalizedString(@"正在上传", nil)];
    @weakify(self);
    [TDFMemberCouponService memberUpLoadBGImgWithImg:image CompleteBlock:^(TDFResponseModel * model) {
       @strongify(self);
        [self dismissHUD];
        if (model.isSuccess) {
            self.currentTriggeredItem.requestValue = [model.responseObject objectForKey:@"data"];
            if ([self.specialCreditItems containsObject:self.currentTriggeredItem]) {
                [self.specialCreditURLs addObject:self.currentTriggeredItem.requestValue];
                [self updateSpecialCreditItemsWithNeedInit:NO];
            }
            [self updateImageHeaderView];
            [self.tableViewManager reloadData];
            [self updateNavigationItems];
        } else {
            [self showErrorMessage:model.error.localizedDescription];
        }
    }];
}

- (void)loadData {

    [self loadTraderInfo];
}

- (void)loadTraderInfo {
    
    [self showHUBWithText:NSLocalizedString(@"加载中", nil)];
    [[[TDFWechatMarketingService alloc] init] fetchWXPayTraderWithId:self.traderId callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:[error localizedDescription]];
            return;
        }
        self.model = [TDFWXPayTraderModel yy_modelWithJSON:[responseObj objectForKey:@"data"]];
        [self configSections];
        [self configHeaderView];
        [self.tableViewManager reloadData];
    }];
}

#pragma mark Actions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)closeButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}


- (void)saveButtonTapped {

    NSError *error = nil;
    TDFWXPayTraderModel *model = [self transToModelWithError:&error];
    if (error) {
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    
    if (![self contentChanged]) {
        
        [self showErrorMessage:@"请确认按照要求修改，再提交申请"];
        return;
    }
    
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    model._id = self.traderId;
    [[[TDFWechatMarketingService alloc] init] saveWXPayTraderWithId:self.traderId
                                                               json:[model yy_modelToJSONString]
                                                           callback:^(id responseObj, NSError *error) {
                                                               @strongify(self);
                                                               [self dismissHUD];
                                                               if (error) {
                                                                   [self showErrorMessage:error.localizedDescription];
                                                               } else {
                                                                   [self showAuditInfoWithTraderId:[responseObj objectForKey:@"data"]];
                                                               }
                                                           }];
}

- (void)showAuditInfoWithTraderId:(NSString *)traderId {

    TDFTraderAuditModel *model = [[TDFTraderAuditModel alloc] init];
    model.title = NSLocalizedString(@"您的申请审核中", nil);
    model.detail = NSLocalizedString(@"您的申请资料已成功提交，微信官方会在5个工作日之内审核，请耐心等待。", nil);
    model.applyTime = [[NSDate date] timeIntervalSince1970] * 1000;
    model.status = TDFWXPayTraderAuditStatusAuditing;

    @weakify(self);
    TDFAuditStatusViewController *vc = [TDFAuditStatusViewController statusViewWithAsync:TDFAsync.unit(model)
                                                                                title:WXOALocalizedString(@"WXOA_Pay_Trader_Title")
                                                                        viewProfileBlock:^{
                                                                            @strongify(self);
                                                                            [self showTraderInfoWithTraderId:traderId];
                                                                        }];
    vc.popDepth = 3 + self.auditPopDepthAddition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showTraderInfoWithTraderId:(NSString *)traderId {
    
    TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
    vc.traderId = traderId;
    vc.readOnly = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetchTraderId {
    
    @weakify(self);
    [[TDFWechatMarketingService service] fetchTradersWithCallback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            
            [self showHUBWithText:error.localizedDescription];
            return ;
        }
        
        TDFTraderModel *trader = [[NSArray yy_modelArrayWithClass:[TDFTraderModel class] json:[responseObj objectForKey:@"data"]] firstObject];
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.traderId = trader._id;
        vc.readOnly = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}

- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (NSString *)checkImageItemsSelected {
    
    TDFImageSelectItem *specialCreditItem = [self.specialCreditItems firstObject];
    if ([specialCreditItem.requestValue length] == 0) {
        return NSLocalizedString(@"特殊资质照片不能为空", nil);
    }
    
    if ([self.licenseItem.requestValue length] == 0) {
        return NSLocalizedString(@"营业执照照片不能为空", nil);
    }
    
    if ([self.idCardFrontItem.requestValue length] == 0 ) {
        
        return [self.credentialTypeItem.requestValue isEqualToString:@"0"] ?
        NSLocalizedString(@"身份证正面照片不能为空", nil) : NSLocalizedString(@"护照照片不能为空", nil);
    }
    
    if ([self.idCardBackItem.requestValue length] == 0 && [self.credentialTypeItem.requestValue isEqualToString:@"0"]) {
        return NSLocalizedString(@"身份证背面照片不能为空不能为空", nil);
    }
    
    return nil;
}

- (TDFWXPayTraderModel *)transToModelWithError:(NSError **)error {

    NSString *message = nil;
    message = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.tableViewManager.sections withIgnoredCharator:@" "];
    if (message) {
        *error = [NSError errorWithDomain:@"TDF" code:4000 userInfo:@{ NSLocalizedDescriptionKey: message }];
        return nil;
    }
    
    message = [self checkImageItemsSelected];
    
    if (message) {
        *error = [NSError errorWithDomain:@"TDF" code:4000 userInfo:@{ NSLocalizedDescriptionKey: message }];
        return nil;
    }
    
    if (![self validateEmail:self.emailItem.textValue]) {
        *error = [NSError errorWithDomain:@"TDF" code:4000 userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"邮箱格式不正确", nil) }];
        return nil;
    }
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [TDFEditViewHelper formatSectionsData:self.tableViewManager.sections toDictionary:dictionary];
    TDFWXPayTraderModel *model = [TDFWXPayTraderModel yy_modelWithDictionary:dictionary];
    model.accountProvinceName = self.accountProvinceItem.textValue;
    model.accountCityName = self.accountCityItem.textValue;
    model.accountBankName = self.accountBankItem.textValue;
    model.accountBranchName = self.accountBranchItem.textValue;
    model.specialCreditURLs = self.specialCreditURLs;
    return model;
}

#pragma mark OptionSelectClient

- (BOOL)selectOption:(id<INameItem>)data editItem:(id)editItem {

    self.accountBranchItem.textValue = [data obtainItemName];
    self.accountBranchItem.requestValue = [data obtainItemId];
    [self.tableViewManager reloadData];
    return YES;
}


#pragma mark DHTTbaleViewManagerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = self.headerView.frame;
    frame.origin.y = -self.tableView.contentOffset.y;
    self.headerView.frame = frame;
}

#pragma mark - Accessor

- (UIView *)footView {

    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footView.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc] init];
        button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"提交申请", nil) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.frame = CGRectMake(10, 20, SCREEN_WIDTH - 20, 40);
        button.hidden = self.readOnly;
        [_footView addSubview:button];
    }
    
    return _footView;
}

- (DHTTableViewManager *)tableViewManager {

    if (!_tableViewManager) {
        
        _tableViewManager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_tableViewManager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
        [_tableViewManager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
        [_tableViewManager registerCell:@"TDFImageSelectCell" withItem:@"TDFImageSelectItem"];
        [_tableViewManager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
        [_tableViewManager addSection:self.contactHeaderSection];
        [_tableViewManager addSection:self.contactSection];
        [_tableViewManager addSection:self.businessHeaderSection];
        [_tableViewManager addSection:self.businessSection];
        [_tableViewManager addSection:self.enterpriseHeaderSection];
        [_tableViewManager addSection:self.enterpriseSection];
        [_tableViewManager addSection:self.accountHeaderSection];
        [_tableViewManager addSection:self.accountSection];
        _tableViewManager.delegate = self;
    }
    return _tableViewManager;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor clearColor];
    }
    
    return _tableView;
}



#pragma mark Accessor - Items

///////////////////////////////////////////////////////////////////////
//////                     联系人                                 //////
///////////////////////////////////////////////////////////////////////

/**
 *  联系人 Header
 */
- (DHTTableViewSection *)contactHeaderSection {
    
    if (!_contactHeaderSection) {
        _contactHeaderSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"联系信息", nil)];
    }
    return _contactHeaderSection;
}
/**
 *  联系人 Section
 */
- (DHTTableViewSection *)contactSection {
    
    if (!_contactSection) {

        _contactSection = [DHTTableViewSection section];
        [_contactSection addItem:self.contactNameItem];
        [_contactSection addItem:self.phoneItem];
        [_contactSection addItem:self.emailItem];
    }
    return _contactSection;
}
/**
 *  联系人姓名
 */
- (TDFTextfieldItem *)contactNameItem {
    
    if (!_contactNameItem) {
        
        _contactNameItem = [[TDFTextfieldItem alloc] init];
        _contactNameItem.tdf_title(NSLocalizedString(@"联系人", nil)).tdf_isRequired(YES).tdf_requestKey(@"name");
    }
    return _contactNameItem;
}
/**
 *  常用邮箱
 */
- (TDFTextfieldItem *)emailItem {
    
    if (!_emailItem) {
        _emailItem = [[TDFTextfieldItem alloc] init];
        _emailItem.tdf_title(NSLocalizedString(@"常用邮箱", nil)).tdf_isRequired(YES).tdf_requestKey(@"email")
                  .tdf_keyboardType(UIKeyboardTypeEmailAddress);
    }
    return _emailItem;
}
/**
 *  联系人手机
 */
- (TDFTextfieldItem *)phoneItem {
    
    if (!_phoneItem) {
        _phoneItem = [[TDFTextfieldItem alloc] init];
        _phoneItem.tdf_title(NSLocalizedString(@"联系人手机号", nil)).tdf_isRequired(YES).tdf_requestKey(@"phone")
                .tdf_keyboardType(UIKeyboardTypeNumberPad);
    }
    return _phoneItem;
}

///////////////////////////////////////////////////////////////////////
//////                       经营信息                             //////
//////////////////////////////////////////////////////////////////////
/**
 *  经营信息 Header
 */
- (DHTTableViewSection *)businessHeaderSection {
    
    if (!_businessHeaderSection) {
        
        _businessHeaderSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"经营信息", nil)];
    }
    return _businessHeaderSection;
}
/**
 *  经营信息 Section
 */
- (DHTTableViewSection *)businessSection {
    
    if (!_businessSection) {
    
        _businessSection = [DHTTableViewSection section];
        [_businessSection addItem:self.componeyItem];
        [_businessSection addItem:self.addressItem];
        [_businessSection addItem:self.abbreviationItem];
        [_businessSection addItem:self.traderTypeItem];
        [_businessSection addItem:self.businessTypeItem];
        [_businessSection addItem:self.businessSubTypeItem];
        [_businessSection addItem:self.specialCreditTitleItem];
        for (TDFImageSelectItem *item in self.specialCreditItems) {
            [_businessSection addItem:item];
        }
        [_businessSection addItem:self.servicePhoneItem];
        [_businessSection addItem:self.businessLincenseItem];
        [_businessSection addItem:self.businessScopeItem];
        [_businessSection addItem:self.licenseTitleItem];
        [_businessSection addItem:self.licenseItem];
    }
    return _businessSection;
}
/**
 *  公司名称
 */
- (TDFTextfieldItem *)componeyItem {
    
    if (!_componeyItem) {
        
        _componeyItem = [TDFTextfieldItem item];
        __weak __typeof(_componeyItem) item = _componeyItem;
        _componeyItem.tdf_title(NSLocalizedString(@"公司名称", nil)).tdf_isRequired(NSLocalizedString(@"公司名称", nil)).tdf_requestKey(@"company")
        .tdf_filterBlock(^BOOL(NSString *textValue) {
            if (textValue.tdf_byteLength > 36) {
                
                item.textValue = [textValue tdf_substringWithByteLength:36];
                return NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               [self updateAccountName];
            });
            return textValue.tdf_byteLength <= 36;
        });
    }
    return _componeyItem;
}
/**
 *  注册地址
 */
- (TDFTextfieldItem *)addressItem {
    
    if (!_addressItem) {
        _addressItem = [TDFTextfieldItem item];
        __weak __typeof(_addressItem) item = _addressItem;
        _addressItem.tdf_title(NSLocalizedString(@"注册地址", nil)).tdf_isRequired(YES).tdf_requestKey(@"address")
        .tdf_filterBlock(^BOOL(NSString *textValue) {
            if (textValue.tdf_byteLength > 72) {
                
                item.textValue = [textValue tdf_substringWithByteLength:72];
                return NO;
            }
            return textValue.tdf_byteLength <= 72;
        });
    }
    return _addressItem;
}
/**
 *  商家简介
 */
- (TDFTextfieldItem *)abbreviationItem {
    
    if (!_abbreviationItem) {
        _abbreviationItem = [TDFTextfieldItem item];
        __weak __typeof(_abbreviationItem) item = _abbreviationItem;
        _abbreviationItem.tdf_title(NSLocalizedString(@"商家简称", nil)).tdf_isRequired(YES).tdf_requestKey(@"abbreviation")
        .tdf_detail(NSLocalizedString(@"顾客在您店里用微信支付时可看到该简称。", nil))
        .tdf_filterBlock(^BOOL(NSString *textValue) {
            
            if (textValue.tdf_byteLength > 36) {
                
                item.textValue = [textValue tdf_substringWithByteLength:36];
                return NO;
            }
            
            return textValue.tdf_byteLength <= 36;
        });
    }
    return _abbreviationItem;
}

- (NSArray<DicSysItem *> *)traderTypeItems {

    return @[[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"企业", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"工商个体户", nil)]];
}

- (TDFShowPickerStrategy *)traderTypeStrategy {

    if (!_traderTypeStrategy) {
        
        _traderTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _traderTypeStrategy.pickerName = NSLocalizedString(@"商户类型", nil);
        _traderTypeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.traderTypeItems];
    }
    
    return _traderTypeStrategy;
}
/**
 *  商家类目
 */
- (TDFPickerItem *)traderTypeItem {
    
    if (!_traderTypeItem) {
        _traderTypeItem  = [TDFPickerItem item];
        _traderTypeItem.tdf_title(NSLocalizedString(@"商户类型", nil))
            .tdf_isRequired(YES)
            .tdf_requestKey(@"traderType")
            .tdf_strategy(self.traderTypeStrategy)
            .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
                DicSysItem *item = self.accountTypeItems[[requestValue integerValue]];
                self.accountTypeItem.tdf_requestValue(item.obtainItemId).tdf_textValue(item.obtainItemName);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateAccountName];
                    [self.tableViewManager reloadData];
                });
                return YES;
            });
    }
    return _traderTypeItem;
}

- (NSArray<DicSysItem *> *)businessTypeItems {
    
    return @[[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"餐饮/食品", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"线下零售", nil)]];
}

- (TDFShowPickerStrategy *)businessTypeStrategy {

    if (!_businessTypeStrategy) {
        
        _businessTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _businessTypeStrategy.pickerName = NSLocalizedString(@"经营类目", nil);
        _businessTypeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.businessTypeItems];
    }
    
    return _businessTypeStrategy;
}
/**
 *  经营类目
 */
- (TDFPickerItem *)businessTypeItem {
    
    if (!_businessTypeItem) {
        @weakify(self);
        _businessTypeItem = [TDFPickerItem item].tdf_title(NSLocalizedString(@"经营类目", nil))
                                                .tdf_isRequired(YES)
                                                .tdf_requestKey(@"businessType")
                                                .tdf_strategy(self.businessTypeStrategy)
                                                .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
                                                    @strongify(self);
                                                    if (![self.businessTypeItem.requestValue isEqualToString:requestValue]) {
                                                    
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self updateBusinessSubType];
                                                        });
                                                    }
                                                    return YES;
                                                });
    }
    return _businessTypeItem;
}


- (NSArray<DicSysItem *> *)businessSubTypeItems {

    return @[[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"食品", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"餐饮", nil)], [DicSysItem itemWithId:@"2" name:NSLocalizedString(@"便利店", nil)], [DicSysItem itemWithId:@"3" name:NSLocalizedString(@"其他综合零售", nil)]];
}

- (TDFShowPickerStrategy *)businessSubTypeStrategy {

    if (!_businessSubTypeStrategy) {
        
        _businessSubTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _businessSubTypeStrategy.pickerName = NSLocalizedString(@"经营子类目", nil);
    }
    
    return _businessSubTypeStrategy;
}
/**
 *  经营子类目
 */
- (TDFPickerItem *)businessSubTypeItem {
    
    if (!_businessSubTypeItem) {
        _businessSubTypeItem = [TDFPickerItem item].tdf_title(NSLocalizedString(@"经营子类目", nil))
                                                   .tdf_isRequired(YES)
                                                   .tdf_requestKey(@"businessSubType")
                                                   .tdf_strategy(self.businessSubTypeStrategy);
    }
    return _businessSubTypeItem;
}
/**
 *  特殊资质 - 标题
 */
- (TDFStaticLabelItem *)specialCreditTitleItem {
    
    if (!_specialCreditTitleItem) {
        
         _specialCreditTitleItem = [TDFStaticLabelItem item];
        _specialCreditTitleItem.textValue =  self.readOnly ? @"" : NSLocalizedString(@"必填", nil);
        _specialCreditTitleItem.tdf_title(NSLocalizedString(@"特殊资质", nil))
                               .tdf_isRequired(YES)
                               .tdf_detail(@"注:特殊资质即《餐饮卫生许可证》或《餐饮流通许可证》");
    }
    return _specialCreditTitleItem;
}
/**
 *  特殊资质 - 图片选择
 */

- (TDFImageSelectItem *)generateSpecialCreditItemWithIndex:(NSInteger)index {

    TDFImageSelectItem *specialCreditItem = [[TDFImageSelectItem alloc] init];
    specialCreditItem.title = NSLocalizedString(@"添加图片", nil);
    specialCreditItem.requestKey = @"specialCreditURL-";
    specialCreditItem.prompt = NSLocalizedString(@"上传彩色图片，需小于2MB, 格式为bmp,png,jpeg,jpg或gif", nil);
    @weakify(self);
    __weak __typeof(specialCreditItem) witem = specialCreditItem;
    specialCreditItem.selectBlock = ^(){
        @strongify(self);
        self.currentTriggeredItem = witem;
        [self selectImage];
    };
    specialCreditItem.deleteBlock = ^() {
        @strongify(self);
        witem.requestValue = nil;
        [self.specialCreditURLs removeObjectAtIndex:index];
        [self updateImageHeaderView];
        [self updateSpecialCreditItemsWithNeedInit:NO];
        [self.tableViewManager reloadData];
    };
    return specialCreditItem;
}

- (NSMutableArray *)specialCreditURLs {

    if (!_specialCreditURLs) {
        
        _specialCreditURLs = [NSMutableArray array];
    }
    return _specialCreditURLs;
}

- (NSArray *)specialCreditItems {

    if (!_specialCreditItems) {
        
        _specialCreditItems = @[
                                [self generateSpecialCreditItemWithIndex:0],
                                [self generateSpecialCreditItemWithIndex:1],
                                [self generateSpecialCreditItemWithIndex:2]
                                ];
    }
    return _specialCreditItems;
}
/**
 *  客服电话
 */
- (TDFTextfieldItem *)servicePhoneItem {
    
    if (!_servicePhoneItem) {
        
        _servicePhoneItem = [TDFTextfieldItem item].tdf_title(NSLocalizedString(@"客服电话", nil))
        .tdf_isRequired(YES)
        .tdf_keyboardType(UIKeyboardTypeNumberPad)
        .tdf_requestKey(@"servicePhone");
    }
    return _servicePhoneItem;
}
/**
 *  营业执照注册号
 */
- (TDFTextfieldItem *)businessLincenseItem {
    
    if (!_businessLincenseItem) {
        
        _businessLincenseItem = [TDFTextfieldItem item].tdf_title(NSLocalizedString(@"营业执照注册号", nil))
        .tdf_isRequired(YES)
        .tdf_keyboardType(UIKeyboardTypeASCIICapable)
        .tdf_requestKey(@"businessLicenseNumber")
        .tdf_filterBlock(^BOOL(NSString *string) {
        
            if (string.length > 36) {
                return NO;
            }
            NSCharacterSet *set = [NSCharacterSet alphanumericCharacterSet];
            set = [set invertedSet];
            return [string rangeOfCharacterFromSet:set].location == NSNotFound;
        });
    }
    return _businessLincenseItem;
}
/**
 *  经营范围
 */
- (TDFTextfieldItem *)businessScopeItem {
    
    if (!_businessScopeItem) {
        
        _businessScopeItem = [TDFTextfieldItem item]
        .tdf_title(NSLocalizedString(@"经营范围", nil))
        .tdf_detail(NSLocalizedString(@"请填写营业执照对应的经营范围。", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"businessScope");
    }
    return _businessScopeItem;
}
/**
 *  营业执照 - 标题
 */
- (TDFStaticLabelItem *)licenseTitleItem {
    
    if (!_licenseTitleItem) {
        _licenseTitleItem = [TDFStaticLabelItem item];
        _licenseTitleItem.textValue = self.readOnly ? @"" : NSLocalizedString(@"必填", nil);
        _licenseTitleItem.tdf_title(NSLocalizedString(@"营业执照照片", nil))
        .tdf_isRequired(YES);
    }
    return _licenseTitleItem;
}
/**
 *  营业执照 - 图片选择
 */
- (TDFImageSelectItem *)licenseItem {
    
    if (!_licenseItem) {
        _licenseItem = [[TDFImageSelectItem alloc] init];
        _licenseItem.title = NSLocalizedString(@"添加图片", nil);
        _licenseItem.requestKey = @"businessLicenseURL";
        _licenseItem.prompt = NSLocalizedString(@"上传彩色图片，需小于2MB, 格式为bmp,png,jpeg,jpg或gif", nil);
        @weakify(self);
        _licenseItem.selectBlock = ^(){
            @strongify(self);
            self.currentTriggeredItem = self.licenseItem;
            [self selectImage];
        };
        _licenseItem.deleteBlock = ^() {
            @strongify(self);
            self.licenseItem.requestValue = nil;
            [self updateImageHeaderView];
            [self.tableViewManager reloadData];
        };
    }
    return _licenseItem;
}

///////////////////////////////////////////////////////////////////////
//////                    企业法人/经办人                          //////
//////////////////////////////////////////////////////////////////////

/**
 *  经营信息 Header
 */
- (DHTTableViewSection *)enterpriseHeaderSection {
    
    if (!_enterpriseHeaderSection) {
        
        _enterpriseHeaderSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"企业法人/经办人", nil)];
    }
    return _enterpriseHeaderSection;
}
/**
 *  经营信息 Section
 */
- (DHTTableViewSection *)enterpriseSection {
    
    if (!_enterpriseSection) {
        
        _enterpriseSection = [DHTTableViewSection section];
        [_enterpriseSection addItem:self.certificateHolderTypeItem];
        [_enterpriseSection addItem:self.certificateHolderNameItem];
        [_enterpriseSection addItem:self.credentialTypeItem];
        [_enterpriseSection addItem:self.idCardTitleItem];
        [_enterpriseSection addItem:self.idCardFrontItem];
        [_enterpriseSection addItem:self.idCardBackItem];
        [_enterpriseSection addItem:self.idCardCreationItem];
        [_enterpriseSection addItem:self.idCardExpiredItem];
        [_enterpriseSection addItem:self.idCardNumberItem];
        
    }
    return _enterpriseSection;
}



/**
 *  证件持有人类型
 */

- (NSArray<DicSysItem *> *)certificateHolderTypeItems {
    
    return @[[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"企业法人", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"经办人", nil)]];
}

- (TDFShowPickerStrategy *)certificateHolderTypeStrategy {

    if (!_certificateHolderTypeStrategy) {
        _certificateHolderTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _certificateHolderTypeStrategy.pickerName = NSLocalizedString(@"证件持有人类型", nil);
        _certificateHolderTypeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.certificateHolderTypeItems];
    }
    return _certificateHolderTypeStrategy;
}

- (TDFPickerItem *)certificateHolderTypeItem {
    
    if (!_certificateHolderTypeItem) {
    
        _certificateHolderTypeItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"证件持有人类型", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"certificateHolderType")
        .tdf_strategy(self.certificateHolderTypeStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            return YES;
        });
    }
    return _certificateHolderTypeItem;
}
/**
 *  证件持有人姓名
 */
- (TDFTextfieldItem *)certificateHolderNameItem {
    
    if (!_certificateHolderNameItem) {
        @weakify(self);
        _certificateHolderNameItem = [TDFTextfieldItem item]
        .tdf_title(NSLocalizedString(@"企业法人/经办人姓名", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"certificateHolderName")
        .tdf_filterBlock(^BOOL(NSString *string) {
            @strongify(self);
            if (string.tdf_byteLength > 36) {
                self.certificateHolderNameItem.textValue = [string tdf_substringWithByteLength:36];
                return NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateAccountName];
            });
            return YES;
        });
    }
    
    return _certificateHolderNameItem;
}
/**
 *  证件类型
 */

- (NSArray<DicSysItem *> *)credentialTypeItems {

    return @[[DicSysItem itemWithId:@"0" name:NSLocalizedString(@"身份证", nil)], [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"护照", nil)]];
}

- (TDFShowPickerStrategy *)credentialTypeStrategy {

    if (!_credentialTypeStrategy) {
        
        _credentialTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _credentialTypeStrategy.pickerName = NSLocalizedString(@"证件类型", nil);
        _credentialTypeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.credentialTypeItems];
    }
    
    return _credentialTypeStrategy;
}

- (TDFPickerItem *)credentialTypeItem {
    
    if (!_credentialTypeItem) {
        @weakify(self);;
        _credentialTypeItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"证件类型", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"credentialType")
        .tdf_strategy(self.credentialTypeStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if (![requestValue isEqualToString:self.credentialTypeItem.requestValue]) {
                
                self.idCardBackItem.requestValue = nil;
                self.idCardFrontItem.requestValue = nil;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               [self updateImageHeaderView];
               [self updateCredentialImageItems];
            });
            return YES;
        });
    }
    return _credentialTypeItem;
}
/**
 *  证件 - Title
 */
- (TDFStaticLabelItem *)idCardTitleItem {
    
    if (!_idCardTitleItem) {
        _idCardTitleItem = [TDFStaticLabelItem item];
        _idCardTitleItem.tdf_title(NSLocalizedString(@"身份证图片", nil))
        .tdf_isRequired(YES)
        .tdf_detail(@"注：请本人手持证件拍照上传");
        _idCardTitleItem.textValue = self.readOnly ? @"" : NSLocalizedString(@"必填", nil);
    }
    return _idCardTitleItem;
}
/**
 *  证件 - 正面照片选择
 */
- (TDFImageSelectItem *)idCardFrontItem {
    
    if (!_idCardFrontItem) {
        
        _idCardFrontItem = [[TDFImageSelectItem alloc] init];
        _idCardFrontItem.title = NSLocalizedString(@"正面图片", nil);
        _idCardFrontItem.requestKey = @"idCardFrontImageURL";
        _idCardFrontItem.prompt = NSLocalizedString(@"上传彩色图片，需小于2MB, 格式为bmp,png,jpeg,jpg或gif", nil);
        @weakify(self);
        _idCardFrontItem.selectBlock = ^(){
            @strongify(self);
            self.currentTriggeredItem = self.idCardFrontItem;
            [self selectImage];
        };
        _idCardFrontItem.deleteBlock = ^() {
            @strongify(self);
            self.idCardFrontItem.requestValue = nil;
            [self updateImageHeaderView];
            [self.tableViewManager reloadData];
        };
    }
    return _idCardFrontItem;
}
/**
 *  证件 - 背面照片选择
 */
- (TDFImageSelectItem *)idCardBackItem {
    
    if (!_idCardBackItem) {
        
        _idCardBackItem = [[TDFImageSelectItem alloc] init];
        _idCardBackItem.title = NSLocalizedString(@"背面图片", nil);
        _idCardBackItem.requestKey = @"idCardBackImageURL";
        _idCardBackItem.prompt = NSLocalizedString(@"上传彩色图片，需小于2MB, 格式为bmp,png,jpeg,jpg或gif", nil);
        @weakify(self);
        _idCardBackItem.selectBlock = ^(){
            @strongify(self);
            self.currentTriggeredItem = self.idCardBackItem;
            [self selectImage];
        };
        _idCardBackItem.deleteBlock = ^() {
            @strongify(self);
            self.idCardBackItem.requestValue = nil;
            [self updateImageHeaderView];
            [self.tableViewManager reloadData];
        };
    }
    return _idCardBackItem;
}
/**
 *  证件创建日期
 */

- (TDFShowDatePickerStrategy *)idCardCreationStrategy {

    if (!_idCardCreationStrategy) {
        _idCardCreationStrategy = [[TDFShowDatePickerStrategy alloc] init];
        _idCardCreationStrategy.pickerName = NSLocalizedString(@"证件有效期开始时间", nil);
        _idCardCreationStrategy.mode = UIDatePickerModeDate;
        _idCardCreationStrategy.format = @"yyyy-MM-dd";
    }
    return _idCardCreationStrategy;
}

- (TDFPickerItem *)idCardCreationItem {
    
    if (!_idCardCreationItem) {
        
        @weakify(self);
        _idCardCreationItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"证件有效期开始时间", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"idCardCreationDate")
        .tdf_strategy(self.idCardCreationStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            self.idCardExpiredStrategy.mininumDate = (NSDate *)requestValue;
            return YES;
        }).tdf_mapRequestBlock(^id(NSDate *value) {
        
            return @((TDFMilliTimeInterval)(value.timeIntervalSince1970 * 1000));
        });
    }
    return _idCardCreationItem;
}
/**
 * 证件失效日期
 */

- (TDFShowDatePickerStrategy *)idCardExpiredStrategy {

    if (!_idCardExpiredStrategy) {
        
        _idCardExpiredStrategy = [[TDFShowDatePickerStrategy alloc] init];
        _idCardExpiredStrategy.pickerName = NSLocalizedString(@"证件有效期截止时间", nil);
        _idCardExpiredStrategy.mode = UIDatePickerModeDate;
        _idCardExpiredStrategy.format = @"yyyy-MM-dd";
    }
    return _idCardExpiredStrategy;
}
- (TDFPickerItem *)idCardExpiredItem {
    
    if (!_idCardExpiredItem) {
       
        @weakify(self);
        _idCardExpiredItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"证件有效期截止时间", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"idCardExpiredDate")
        .tdf_strategy(self.idCardExpiredStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            self.idCardCreationStrategy.maxinumDate = (NSDate *)requestValue;
            return YES;
        }).tdf_mapRequestBlock(^id(NSDate *value) {
            
            return @((TDFMilliTimeInterval)(value.timeIntervalSince1970 * 1000));
        });
    }
    return _idCardExpiredItem;
}
/**
 *  证件号码
 */
- (TDFTextfieldItem *)idCardNumberItem {

    if (!_idCardNumberItem) {
        
        _idCardNumberItem = [TDFTextfieldItem item]
        .tdf_title(NSLocalizedString(@"证件号码", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"idCardNumber")
        .tdf_keyboardType(UIKeyboardTypeASCIICapable);
    }
    
    return _idCardNumberItem;
}
///////////////////////////////////////////////////////////////////////
//////                       结算信息                             //////
//////////////////////////////////////////////////////////////////////

- (DHTTableViewSection *)accountHeaderSection {

    if (!_accountHeaderSection) {
     
        _accountHeaderSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"结算信息", nil)];
    }
    
    return _accountHeaderSection;
}

- (DHTTableViewSection *)accountSection {
    
    if (!_accountSection) {
        
        _accountSection = [DHTTableViewSection section];
        [_accountSection addItem:self.accountTypeItem];
        [_accountSection addItem:self.accountNameItem];
        [_accountSection addItem:self.accountBankItem];
        [_accountSection addItem:self.accountProvinceItem];
        [_accountSection addItem:self.accountCityItem];
        [_accountSection addItem:self.accountBranchItem];
        [_accountSection addItem:self.accountNumberItem];
        [_accountSection addItem:self.accountPermitItem];
    }
    
    return _accountSection;
}

/**
 *  账户类型
 */
- (TDFPickerItem *)accountTypeItem {
    
    if (!_accountTypeItem) {
        
        _accountTypeItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"账户类型", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"accountType");
    }
    return _accountTypeItem;
}
/**
 *  账户名称
 */
- (TDFTextfieldItem *)accountNameItem {
    
    if (!_accountNameItem) {
        
        _accountNameItem = [TDFTextfieldItem item]
        .tdf_title(NSLocalizedString(@"开户名称", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"accountName");
        _accountNameItem.editStyle = TDFEditStyleUnEditable;
    }
    return _accountNameItem;
}
/**
 *  开户银行
 */

- (TDFAsyncPickerStrategy *)accountBankStrategy {

    if (!_accountBankStrategy) {
        
        _accountBankStrategy = [[TDFAsyncPickerStrategy alloc] init];
        _accountBankStrategy.pickerName = NSLocalizedString(@"开户银行", nil);
        @weakify(self);
        _accountBankStrategy.async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
           @strongify(self);
            [self showHUBWithText:NSLocalizedString(@"加载中", nil)];
            [[[TDFPaymentService alloc] init] getBanksWithParam:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self dismissHUD];
                callback(data[@"data"], nil);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self dismissHUD];
                callback(nil, error);
            }];
        }].fmap(^id(NSArray *obj) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:obj.count];
            for (NSDictionary *dict in obj) {
                
                [array addObject:[DicSysItem itemWithId:dict[@"bankName"] name:dict[@"bankDisplayName"]]];
            }
            return array;
        });
    }
    
    return _accountBankStrategy;
}

- (TDFPickerItem *)accountBankItem {
    
    if (!_accountBankItem) {
        
        @weakify(self);
        _accountBankItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"开户银行", nil))
        .tdf_requestKey(@"accountBankId")
        .tdf_isRequired(YES)
        .tdf_strategy(self.accountBankStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if (![self.accountBankItem.requestValue isEqualToString:requestValue]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accountProvinceItem.tdf_requestValue(nil).tdf_textValue(nil);
                    self.accountCityItem.tdf_requestValue(nil).tdf_textValue(nil);
                    self.accountBranchItem.tdf_requestValue(nil).tdf_textValue(nil);
                    [self.tableViewManager reloadData];
                });
            }
            return YES;
        });
    }
    return _accountBankItem;
}

- (TDFAsyncPickerStrategy *)accountProvinceStrategy {

    if (!_accountProvinceStrategy) {
        _accountProvinceStrategy = [[TDFAsyncPickerStrategy alloc] init];
        _accountProvinceStrategy.pickerName = NSLocalizedString(@"开户省份", nil);
        @weakify(self);
        _accountProvinceStrategy.shouldShowPickerBlock = ^BOOL() {
            @strongify(self);
            if ([self.accountBankItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户银行不能为空", nil)];
                return NO;
            }
            return YES;
        };
        _accountProvinceStrategy.async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
            @strongify(self);
            [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
            [[[TDFPaymentService alloc] init] getProvinceWithParam:@{
                                                                     @"bank_name": self.accountBankItem.requestValue
                                                                     } sucess:^(NSURLSessionDataTask * task, id obj) {
                                                                         [self dismissHUD];
                                                                         callback(obj[@"data"], nil);
                                                                     } failure:^(NSURLSessionDataTask * task, NSError * error) {
                                                                         [self dismissHUD];
                                                                         callback(nil, error);
                                                                     }];
        }].fmap(^id(NSArray *array) {
            
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dict in array) {
                [items addObject:[DicSysItem itemWithId:dict[@"provinceNo"] name:dict[@"provinceName"]]];
            }
            return items;
        });
    }
    return _accountProvinceStrategy;
}

- (TDFPickerItem *)accountProvinceItem {

    if (!_accountProvinceItem) {
        
        @weakify(self);
        _accountProvinceItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"开户省份", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"accountProvinceId")
        .tdf_strategy(self.accountProvinceStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if (![self.accountProvinceItem.requestValue isEqualToString:requestValue]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accountCityItem.tdf_requestValue(nil).tdf_textValue(nil);
                    self.accountBranchItem.tdf_requestValue(nil).tdf_textValue(nil);
                    [self.tableViewManager reloadData];
                });
            }
            return YES;
        });
    }
    
    return _accountProvinceItem;
}

- (TDFAsyncPickerStrategy *)accountCityStrategy {

    if (!_accountCityStrategy) {
        
        _accountCityStrategy = [[TDFAsyncPickerStrategy alloc] init];
        _accountCityStrategy.pickerName = NSLocalizedString(@"开户城市", nil);
        @weakify(self);
        _accountCityStrategy.shouldShowPickerBlock = ^BOOL() {
            @strongify(self);
            if ([self.accountBankItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户银行不能为空", nil)];
                return NO;
            }
            
            if ([self.accountProvinceItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户省份不能为空", nil)];
                return NO;
            };
            
            return YES;
        };
        
        _accountCityStrategy.async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
            @strongify(self);
            NSDictionary *param = @{@"bank_name": self.accountBankItem.requestValue,
                                    @"province_no": self.accountProvinceItem.requestValue };
            [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
            [[[TDFPaymentService alloc] init] getCitiesWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self dismissHUD];
                callback(data[@"data"], nil);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                @strongify(self);
                [self dismissHUD];
                callback(nil, error);
            }];
        }].fmap(^id(NSArray *array) {
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:array.count];
            for (NSMutableDictionary *dict in array) {
                [items addObject:[DicSysItem itemWithId:dict[@"cityNo"] name:dict[@"cityName"]]];
            }
            return items;
        });
    }
    return _accountCityStrategy;
}

- (TDFPickerItem *)accountCityItem {
    
    if (!_accountCityItem) {
        
        @weakify(self);
        _accountCityItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"开户城市", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"accountCityId")
        .tdf_strategy(self.accountCityStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if (![self.accountCityItem.requestValue isEqualToString:requestValue]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accountBranchItem.tdf_requestValue(nil).tdf_textValue(nil);
                    [self.tableViewManager reloadData];
                });
            }
            return YES;
        });
    }
    
    return _accountCityItem;
}


/**
 *  开户支行
 */

- (TDFCustomStrategy *)accountBranchStrategy {

    if (!_accountBranchStrategy) {
        _accountBranchStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        _accountBranchStrategy.btnClickedBlock = ^ (){
            @strongify(self);
            if ([self.accountBankItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户银行不能为空", nil)];
                return;
            }
            
            if ([self.accountProvinceItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户省份不能为空", nil)];
                return;
            }
            
            if ([self.accountCityItem.requestValue length] == 0) {
                [self showErrorMessage:NSLocalizedString(@"开户城市不能为空", nil)];
                return;
            }
            
            [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
            
            NSDictionary *param = @{
                                           @"bank_name": self.accountBankItem.requestValue,
                                           @"city_no": self.accountCityItem.requestValue
                                           };

            [[[TDFPaymentService alloc] init] getSubBanksWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self dismissHUD];
                NSArray *array = data[@"data"];
                NSMutableArray<INameItem> *accountBranchList = [NSMutableArray<INameItem> array];
                
                for (NSMutableDictionary *dictionary in array) {
                    ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:dictionary];
                    NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
                    [accountBranchList addObject:nameItem];
                }
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:self.accountBranchItem.textValue andId:self.accountBranchItem.requestValue];
                [OptionSelectView show:NSLocalizedString(@"开户支行", nil) list:accountBranchList selectData:nameItem target:self editItem:self.accountBranchItem Placeholder:NSLocalizedString(@"输入支行关键字", nil) event:1 isPresentMode:YES];
                [self.tableViewManager reloadData];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self dismissHUD];
                [self showErrorMessage:error.localizedDescription];
            } ];
        };
    }
    
    return _accountBranchStrategy;
}
- (TDFPickerItem *)accountBranchItem {
    
    if (!_accountBranchItem) {
        
        _accountBranchItem = [TDFPickerItem item]
        .tdf_title(NSLocalizedString(@"开户支行", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"accountBranchId")
        .tdf_strategy(self.accountBranchStrategy);
    }
    return _accountBranchItem;
}
/**
 *  银行帐号
 */
- (TDFTextfieldItem *)accountNumberItem {
    
    if (!_accountNumberItem) {
        
        _accountNumberItem = [TDFTextfieldItem item]
        .tdf_title(NSLocalizedString(@"银行帐号", nil))
        .tdf_isRequired(YES)
        .tdf_keyboardType(UIKeyboardTypeNumberPad)
        .tdf_requestKey(@"accountNumber");
    }
    return _accountNumberItem;
}

/**
 *  开户证明 - 图片选择
 */
- (TDFImageSelectItem *)accountPermitItem {
    
    if (!_accountPermitItem) {
        _accountPermitItem = [[TDFImageSelectItem alloc] init];
        _accountPermitItem.title = @"添加开户许可证";
        _accountPermitItem.requestKey = @"accountPermitURL";
        _accountPermitItem.prompt = NSLocalizedString(@"上传彩色图片，需小于2MB, 格式为bmp,png,jpeg,jpg或gif", nil);
        @weakify(self);
        _accountPermitItem.selectBlock = ^(){
            @strongify(self);
            self.currentTriggeredItem = self.accountPermitItem;
            [self selectImage];
        };
        _accountPermitItem.deleteBlock = ^() {
            @strongify(self);
            self.accountPermitItem.requestValue = nil;
            [self.tableViewManager reloadData];
        };
    }
    return _accountPermitItem;
}


- (NSArray *)accountTypeItems {

    return @[
             [DicSysItem itemWithId:@"0" name:NSLocalizedString(@"对公账户", nil)],
             [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"法人账户", nil)]
             ];
}


- (UIView *)headerView {

    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"以下资料已审核通过并上线", nil);
        label.textColor = [UIColor colorWithHeX:0x07AD1F];
        label.font = [UIFont systemFontOfSize:15];
        label.frame = CGRectMake(5, 12, 200, 20);
        [_headerView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, 10, 56, 56)];
        imageView.image = [UIImage imageNamed:@"wxoa_trader_opened"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:imageView];
        _headerView.clipsToBounds = NO;
    }
    
    return _headerView;
}
@end
