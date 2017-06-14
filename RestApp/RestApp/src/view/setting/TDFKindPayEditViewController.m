//
//  TDFKindPayEditViewController.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindPayEditViewController.h"
#import "DHTTableViewManager.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFPickerItem.h"
#import "TDFTextfieldItem.h"
#import "TDFSwitchItem.h"
#import "TDFShowPickerStrategy.h"
#import "KindPayRender.h"
#import "TDFCustomStrategy.h"
#import "TDFRootViewController+FooterButton.h"
#import "HelpDialog.h"
#import "RestConstants.h"
#import "TDFKindPayAddCouponViewController.h"
#import "TDFDisplayHeaderItem.h"
#import "TDFMultiDisplayHeaderItem.h"
#import "TDFSettingService.h"
#import "AlertBox.h"
#import "TDFMemberCouponService.h"
#import "ObjectUtil.h"

typedef NS_ENUM(NSInteger,TDFKindPayEditViewPushToType) {
    TDFKindPayEditViewPushToTypeNone,
    TDFKindPayEditViewPushToTypeCoupon,
};

@interface TDFKindPayEditViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic,strong) UIView *tableViewFooterView;

@property (nonatomic,strong) TDFPickerItem *kindTypeItem;
@property (nonatomic,strong) TDFTextfieldItem *kindNameItem;
@property (nonatomic,strong) TDFSwitchItem *includeItem;
@property (nonatomic,strong) TDFSwitchItem *openWalletItem;
@property (nonatomic,strong) TDFSwitchItem *alipayItem;

@property (nonatomic,strong) DHTTableViewSection *couponSectionTitle;
@property (nonatomic,strong) DHTTableViewSection *couponSection;
@property (nonatomic,strong) DHTTableViewSection *couponSectionfooter;

@property (nonatomic,strong) UIView *couponSectionFooterView;

@property (nonatomic,strong) NSMutableArray *kindTypeList;

@property (nonatomic,assign) BOOL alipayIsOurAccount;

@end

@implementation TDFKindPayEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =[UIColor whiteColor];
    view.alpha =0.6;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configureManager];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
    if(self.type == TDFBrandKindPayTypeAdd) {
        self.canEdit = YES;
        self.title = NSLocalizedString(@"添加", nil);
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else {
        self.title = self.kindPay.name;
        if(self.canEdit) {
           self.tableView.tableFooterView = self.tableViewFooterView;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles) name:kTDFEditViewIsShowTipNotification object:nil];
        }
    }
    
    if(self.kindPay.thirdType == 1) {
        [self loadAlipayPayment];
    }
    
    [self addSections];
}


- (KindPayVO *)kindPay {
    if(!_kindPay) {
        _kindPay = [[KindPayVO alloc] init];
        _kindPay.kind = KIND_CASH;
        _kindPay.name = NSLocalizedString(@"现金", nil);
        _kindPay.isInclude=YES;
        _kindPay.isOpenCashDrawer=NO;
    }
    return _kindPay;
}

- (NSMutableArray *)kindTypeList {
    if(!_kindTypeList) {
        _kindTypeList = [KindPayRender listType];
        [_kindTypeList enumerateObjectsUsingBlock:^(KindPayVO * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj._id = [NSString stringWithFormat:@"%i",obj.kind];
        }];
    }
    return _kindTypeList;
}

- (void)shouldChangeNavTitles {
    if ([self isAnyTipsShowed]) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    } else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

- (void)addSections {
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.kindTypeItem];
    [section addItem:self.kindNameItem];
    [section addItem:self.alipayItem];
    [section addItem:self.includeItem];
    [section addItem:self.openWalletItem];
    
    [self.manager addSection:section];

    [self initUIWithModelData];
    
    [self updateUIWithModelType];
}

- (void)initUIWithModelData {
    
    //支付类型
    __block KindPay *selectObj = self.kindTypeList[0];
    [self.kindTypeList enumerateObjectsUsingBlock:^(KindPay*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.kind == self.kindPay.kind) {
            selectObj = obj;
            *stop = YES;
        }
    }];
    
    TDFShowPickerStrategy *strategy = (TDFShowPickerStrategy *)self.kindTypeItem.strategy;
    strategy.selectedItem = selectObj;
    
    if(self.kindPay.thirdType == 1 || self.kindPay.thirdType == 9) {
        self.kindTypeItem.textValue = NSLocalizedString(@"网络支付", nil);
        self.kindTypeItem.preValue = NSLocalizedString(@"网络支付", nil);
    }else {
        self.kindTypeItem.textValue = selectObj.name;
        self.kindTypeItem.preValue = selectObj.name;
    }
    
    //支付方式名称
    self.kindNameItem.textValue = self.kindPay.name;
    self.kindNameItem.preValue = self.kindPay.name;
    
    self.includeItem.isOn = self.kindPay.isInclude;
    self.includeItem.preValue = @(self.kindPay.isInclude);
    
    self.openWalletItem.isOn = self.kindPay.isOpenCashDrawer;
    self.openWalletItem.preValue = @(self.kindPay.isOpenCashDrawer);
}

- (void)updateUIWithModelType{
    if(self.kindPay.thirdType == 1 || self.kindPay.thirdType == 9) {
        self.includeItem.shouldShow = NO;
        self.openWalletItem.shouldShow = NO;
        
        self.kindTypeItem.editStyle = TDFEditStyleUnEditable;
        self.kindNameItem.editStyle = TDFEditStyleUnEditable;
        self.tableView.tableFooterView = nil;
        
    }else {
        self.includeItem.shouldShow = YES;
        self.openWalletItem.shouldShow = YES;
    }
    
    [self.manager removeSection:self.couponSectionTitle];
    [self.couponSection removeAllItems];
    [self.manager removeSection:self.couponSection];
    [self.manager removeSection:self.couponSectionfooter];
    
    if(self.kindPay.kind == KIND_COUPON) {
        [self updateUIWhenKindIsCoupon];
    }
    
    [self.manager reloadData];
}

- (void)updateUIWhenKindIsCoupon {
    
    if(!self.canEdit && self.kindPay.voucherArray.count <= 0) {
        //当页面不可编辑 并且没有添加代金券面额的时候 不显示代金券添加section
    }else {
        //代金券
        [self.manager addSection:self.couponSectionTitle];
        [self.manager addSection:self.couponSection];
        [self.manager addSection:self.couponSectionfooter];
    }
    
    if(self.kindPay.voucherArray.count > 0) {
        //代金券的面额
        TDFDisplayHeaderItem *headerItem = [[TDFDisplayHeaderItem alloc] init];
        headerItem.titleArray = @[NSLocalizedString(@"代金券面额", nil),NSLocalizedString(@"代金券售价", nil)];
        [self.couponSection addItem:headerItem];
    }
    @weakify(self);
    [self.kindPay.voucherArray enumerateObjectsUsingBlock:^(TDFVoucher * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        TDFMultiDisplayHeaderItem *item = [[TDFMultiDisplayHeaderItem alloc] init];
        item.leftContent = obj.amount;
        item.rightContent = obj.sellPrice;
        item.editStyle = self.canEdit ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        @weakify(self);
        [item setDeleteBlock:^{
            @strongify(self);
            if (self.kindPay.kind == KIND_COUPON && self.kindPay.voucherArray.count == 1) {
                [AlertBox show:@"无法删除此面额，至少需要添加一条面额才能生效。"];
                return;
            }
            if (self.kindPay.voucherArray.count >1){
            
            [self showMessageWithTitle:NSLocalizedString(@"确定要删除此券吗？", nil) message:nil cancelBlock:nil enterBlock:^{

                NSDictionary *dic = @{@"voucher_id":obj.voucherID};
                [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
                @weakify(self);
                [[TDFSettingService new] deleteVoucher:dic sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud setHidden:YES];
                    NSMutableArray *list = [self.kindPay.voucherArray mutableCopy];
                    [list removeObject:obj];
                    self.kindPay.voucherArray = [list copy];
                    [self updateUIWithModelType];
                } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    @strongify(self);
                    [self.progressHud setHidden:YES];
                    [AlertBox show:error.localizedDescription];
                }];
             
            }];
            }
            else {
                [AlertBox show:@"无法删除此面额，至少需要添加一条面额才能生效。"];
            }
        }];
        [self.couponSection addItem:item];
    }];
}

- (DHTTableViewSection *)couponSectionTitle {
    if(!_couponSectionTitle) {
        _couponSectionTitle = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"代金券面额", nil)];
    }
    return _couponSectionTitle;
}

- (DHTTableViewSection *)couponSectionfooter {
    if(!_couponSectionfooter) {
        _couponSectionfooter = [DHTTableViewSection section];
        _couponSectionfooter.footerView = self.couponSectionFooterView;
        _couponSectionfooter.footerHeight = self.couponSectionFooterView.bounds.size.height;
    }
    return _couponSectionfooter;
}

- (DHTTableViewSection *)couponSection {
    if(!_couponSection) {
        _couponSection = [DHTTableViewSection section];
    }
    return _couponSection;
}

- (UIView *)couponSectionFooterView {
    if(!_couponSectionFooterView) {
        _couponSectionFooterView = [[UIView alloc] init];
        _couponSectionFooterView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [[UIButton alloc] init];
        if(self.canEdit) {
            [button setTitle:NSLocalizedString(@"添加新面额", nil) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:RGBA(204, 0, 0, 1) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_add_red"] forState:UIControlStateNormal];
            [_couponSectionFooterView addSubview:button];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            [button addTarget:self action:@selector(couponAddAction) forControlEvents:UIControlEventTouchUpInside];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_couponSectionFooterView.mas_left);
                make.right.equalTo(_couponSectionFooterView.mas_right);
                make.top.equalTo(_couponSectionFooterView.mas_top);
                make.height.mas_equalTo(40);
            }];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor blackColor];
            lineView.alpha = 0.1;
            [_couponSectionFooterView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_couponSectionFooterView.mas_left).with.offset(10);
                make.right.equalTo(_couponSectionFooterView.mas_right).with.offset(-10);
                make.top.equalTo(button.mas_bottom);
                make.height.mas_equalTo(1);
            }];
        }
        
        NSString *text = NSLocalizedString(@"提示：每种代金券下可以添加不同面额的券，收银上使用时相同类型的券会放在一种付款方式入口内，点开后可以选择不同面额的券", nil);
        CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGBA(102, 102, 102, 1);
        label.numberOfLines = 0;
        label.text = text;
        [_couponSectionFooterView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_couponSectionFooterView.mas_left).with.offset(10);
            make.right.equalTo(_couponSectionFooterView.mas_right).with.offset(-10);
            if(self.canEdit) {
                make.top.equalTo(button.mas_bottom);
            }else {
                make.top.equalTo(_couponSectionFooterView.mas_top);
            }
            
            make.bottom.equalTo(_couponSectionFooterView.mas_bottom);
        }];
        
        if(self.canEdit) {
            _couponSectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40+size.height + 10);
        }else {
            _couponSectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height + 10);
        }
    }
    return _couponSectionFooterView;
}

- (UIView *)tableViewFooterView {
    if(!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] init];
        _tableViewFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        UIButton *deletButton = [[UIButton alloc] init];
        [deletButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        deletButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [deletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deletButton.layer.masksToBounds = YES;
        deletButton.layer.cornerRadius = 6;
        [deletButton setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
        deletButton.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 40);
        [deletButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooterView addSubview:deletButton];
    }
    return _tableViewFooterView;
}


- (void)leftNavigationButtonAction:(id)sender {
    if ([self isAnyTipsShowed]) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗？", nil) cancelBlock:^{
            
        } enterBlock:^{
            [super leftNavigationButtonAction:sender];
        }];
    }else {
        [super leftNavigationButtonAction:sender];
    }
}

- (void)rightNavigationButtonAction:(id)sender {
    if(self.kindPay.thirdType == 1){
        //支付宝更新
        [self updateAlipayPayment];
    }else {
        if(self.type == TDFBrandKindPayTypeEdit) {
            [self updateKindPayIsPushToView:TDFKindPayEditViewPushToTypeNone];
        }else {
            [self saveKindPayIsPushToView:TDFKindPayEditViewPushToTypeNone];
        }
    }
}

#pragma mark 数据交互

- (BOOL)isValild {

    //不可输入空格
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"\\S+"];
    bool isMatch = [predicate evaluateWithObject:self.kindPay.name];
    if(!isMatch) {
        [AlertBox show:NSLocalizedString(@"付款方式名称不支持空格", nil)];
        return NO;
    }
    //名称最多可输入10个字
    if(self.kindPay.name.length > 10) {
        [AlertBox show:NSLocalizedString(@"名称最多可输入10个字",nil)];
        return NO;
    }
    
    return YES;
}

- (void)loadAlipayPayment {
    [TDFMemberCouponService alipayPaymentCompleteBlock:^(TDFResponseModel * _Nullable response) {
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
        if ([ObjectUtil isNotEmpty:dic]) {
            NSDictionary *data =dic[@"data"];
            if ([ObjectUtil isNotEmpty:data]) {
                BOOL alipayStatus = [data[@"alipayIsOurAccount"] boolValue];
                if(!alipayStatus){
                    self.alipayIsOurAccount = [data[@"alipayIsEnjoyPreferential"] boolValue];
                    self.alipayItem.shouldShow = YES;
                    self.alipayItem.isOn = self.alipayIsOurAccount;
                    self.alipayItem.preValue = @(self.alipayIsOurAccount);
                    [self.manager reloadData];
                }
            }
        }
    }];
}

- (void)updateAlipayPayment {
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [TDFMemberCouponService alipayPaymentType:[NSString stringWithFormat:@"%@",@(self.alipayIsOurAccount)] CompleteBlock:^(TDFResponseModel * _Nullable response ) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)clearTip {
    self.kindTypeItem.preValue = self.kindTypeItem.textValue;
    self.kindNameItem.preValue = self.kindNameItem.textValue;
    
    self.includeItem.preValue = @(self.includeItem.isOn);
    self.openWalletItem.preValue = @(self.openWalletItem.isOn);
    self.alipayItem.preValue = @(self.alipayItem.isOn);
    [self.manager reloadData];
}

- (void)updateKindPayIsPushToView:(TDFKindPayEditViewPushToType)toView{
    if(![self isValild]) return;
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [[TDFSettingService new] updateKindPay:self.kindPay sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        switch (toView) {
            case TDFKindPayEditViewPushToTypeNone:{
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case TDFKindPayEditViewPushToTypeCoupon:{
                [self clearTip];
                [self pushToCouponView];
            }
                break;
        }
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)saveKindPayIsPushToView:(TDFKindPayEditViewPushToType)toView {
    if(![self isValild]) return;
    if (toView == TDFKindPayEditViewPushToTypeNone &&self.kindPay.kind  == KIND_COUPON && !self.kindPay.voucherArray) {
        [AlertBox show:NSLocalizedString(@"至少添加一条新面额才能保存", nil)];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [[TDFSettingService new] saveKindPay:self.kindPay sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        switch (toView) {
            case TDFKindPayEditViewPushToTypeNone:{
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:{
                self.type = TDFBrandKindPayTypeEdit;
                self.kindPay._id = data[@"data"];
                self.kindTypeItem.editStyle = TDFEditStyleUnEditable;
                [self clearTip];
                
                self.title = self.kindPay.name;
                self.tableView.tableFooterView = self.tableViewFooterView;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles) name:kTDFEditViewIsShowTipNotification object:nil];
                
                if(toView == TDFKindPayEditViewPushToTypeCoupon) {
                    [self pushToCouponView];
                }
            }
                break;
        }
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)deleteAction {
    
    NSString *tip;
    if([self isChain] && self.kindPay.kind == KIND_SAVING_CARD) {
        tip = NSLocalizedString(@"若连锁旗下存在\"付款方式由总部管理\"的门店，删除此付款方式后，该门店的收银机将无法使用此付款方式，确定删除吗？", nil);
    }else {
        tip = [NSString stringWithFormat:NSLocalizedString(@"确定要删除[%@]吗?", nil), self.kindPay.name];
    }
    
    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:tip cancelBlock:nil enterBlock:^{
        [self removeKindPays];
    }];
}

- (void)removeKindPays {
    [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.kindPay.name]];
    NSMutableArray *arry  = [[NSMutableArray alloc] initWithObjects:self.kindPay._id, nil];
    @weakify(self);
    [[TDFSettingService new] removeKindPays:arry sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    }
    return _tableView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}

- (TDFPickerItem *)kindTypeItem {
    if(!_kindNameItem) {
        _kindTypeItem = [[TDFPickerItem alloc] init];
        if(self.type == TDFBrandKindPayTypeEdit) {
            _kindTypeItem.editStyle = TDFEditStyleUnEditable;
        }
        _kindTypeItem.title = NSLocalizedString(@"支付类型", nil);
        TDFShowPickerStrategy *strategy = [[TDFShowPickerStrategy alloc] init];
        strategy.pickerName = NSLocalizedString(@"支付类型", nil);
        strategy.pickerItemList = self.kindTypeList;
        _kindTypeItem.strategy = strategy;
        @weakify(self);
        _kindTypeItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            
            self.kindPay.kind = [requestValue intValue];
            self.kindPay.name = textValue;
            
            self.kindNameItem.textValue = textValue;
            
            [self updateUIWithModelType];
            return YES;
        };
    }
    return _kindTypeItem;
}

- (TDFTextfieldItem *)kindNameItem {
    if(!_kindNameItem) {
        _kindNameItem = [[TDFTextfieldItem alloc] init];
        _kindNameItem.editStyle = self.canEdit ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        _kindNameItem.title = NSLocalizedString(@"付款方式名称", nil);
        @weakify(self);
        _kindNameItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.kindPay.name = textValue;
            return YES;
        };
    }
    return _kindNameItem;
}
- (TDFSwitchItem *)includeItem {
    if(!_includeItem) {
        _includeItem = [[TDFSwitchItem alloc] init];
        _includeItem.editStyle = self.canEdit ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        _includeItem.title = NSLocalizedString(@"是否计入实收", nil);
        _includeItem.isOn = YES;
        _includeItem.preValue = @(YES);
        _includeItem.detail = NSLocalizedString(@"开关打开后，此付款方式的金额将会计入实收金额。", nil);
        @weakify(self);
        _includeItem.filterBlock = ^(BOOL isOn) {
            @strongify(self);
            self.kindPay.isInclude = isOn;
            return YES;
        };
        
    }
    return _includeItem;
}
- (TDFSwitchItem *)openWalletItem {
    if(!_openWalletItem) {
        _openWalletItem = [[TDFSwitchItem alloc] init];
        _openWalletItem.editStyle = self.canEdit ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        _openWalletItem.title = NSLocalizedString(@"付款完成后自动打开钱箱", nil);
        _openWalletItem.isOn = NO;
        _openWalletItem.preValue = @(NO);
        @weakify(self);
        _openWalletItem.filterBlock = ^(BOOL isOn) {
            @strongify(self);;
            self.kindPay.isOpenCashDrawer = isOn;
            return YES;
        };
    }
    return _openWalletItem;
}
- (TDFSwitchItem *)alipayItem {
    if(!_alipayItem) {
        _alipayItem = [[TDFSwitchItem alloc] init];
        _alipayItem.editStyle = self.canEdit ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        _alipayItem.shouldShow = NO;
        _alipayItem.title = NSLocalizedString(@"支付宝扫码点餐时享受支付宝优惠", nil);
        _alipayItem.detail = NSLocalizedString(@"注：打开此开关，顾客端用支付宝扫码点餐时，既享受店家设置的优惠券、优惠活动等优惠，同时也享受店家在支付宝端（比如口碑）设置过的优惠。", nil);
        @weakify(self);
        _alipayItem.filterBlock = ^(BOOL isOn) {
            @strongify(self);
            self.alipayIsOurAccount = isOn;
            return YES;
        };
    }
    return _alipayItem;
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFDisplayHeaderCell" withItem:@"TDFDisplayHeaderItem"];
    [self.manager registerCell:@"TDFMultiDisplayHeaderCell" withItem:@"TDFMultiDisplayHeaderItem"];
}

- (void)couponAddAction {
    if(self.type == TDFBrandKindPayTypeAdd){
        [self saveKindPayIsPushToView:TDFKindPayEditViewPushToTypeCoupon];
    }else {
        if([self isAnyTipsShowed]){
            [self updateKindPayIsPushToView:TDFKindPayEditViewPushToTypeCoupon];
        }else {
            [self pushToCouponView];
        }
    }
}

- (void)pushToCouponView {
    TDFKindPayAddCouponViewController *VC = [[TDFKindPayAddCouponViewController alloc] init];
    VC.kindPayId = self.kindPay._id;
    [VC setAddCouponCallBack:^(TDFVoucher *voucher) {
        NSMutableArray *list = [self.kindPay.voucherArray mutableCopy];
        if(!list) {
            list = [NSMutableArray array];
        }
        [list addObject:voucher];
        self.kindPay.voucherArray = [list copy];
        [self updateUIWithModelType];
    }];
    [self.navigationController pushViewController:VC animated:YES];
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    if([self isChain]) {
        [HelpDialog show:@"BrandKindPay"];
    }else {
        [HelpDialog show:@"kindpay"];
    }
}

- (BOOL)isChain{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
