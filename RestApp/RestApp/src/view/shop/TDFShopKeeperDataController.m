//
//  TDFShopKeeperDataController.m
//  RestApp
//
//  Created by Cloud on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

//TDFImageSelectCell

#import "TDFShopKeeperDataController.h"
#import "QRCodeGenerator.h"
#import "TDFQRCode.h"
#import "TDFSeatService.h"
#import "UIViewController+HUD.h"
#import "TDFScanViewController.h"
#import "TDFScanSubviews.h"
#import <TDFComponents/TDFIntroductionHeaderView.h>
#import "DHTTableViewSection.h"
#import "DHTTableViewManager.h"
#import "TDFScanSubviews.h"
#import "TDFBaseEditView.h"
#import "KabawService.h"
#import "ShopReviewInfo.h"
#import "TDFKabawService.h"
#import "ShopTag.h"
#import "DicItemConstants.h"
#import "NameItemVO.h"
#import "ShopReviewCenter.h"
#import "ProvincesVo.h"
#import "TDFOptionPickerController.h"
#import "CitiesVo.h"
#import "TownsVo.h"
#import <TDFMediator+KabawModule.h>
#import "TDFTransService.h"
#import "DicSysItem.h"
#import "MultiCheckHandle.h"
#import "TDFMediator+SupplyChain.h"
#import <TDFMemberPod/TDFQRCodeBindView.h>
#import "TDFCardBgImageItem.h"
#import "ShopImg.h"
#import "ImageUtils.h"
#import "UIImage+TDF_fixOrientation.h"
#import "NSString+Estimate.h"
#import "SystemService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "ColorHelper.h"
#import "TDFSettingService.h"
#import <CoreLocation/CoreLocation.h>
#import "TDFMapLocationViewController.h"
#import "TDFEditViewHelper.h"
#import "MemoInputBox.h"
#import "TDFShopImgStaticItem.h"


typedef enum : NSUInteger {
    TAKEPHOTO_TYPE_SHOP_PHOTO,
    TAKEPHOTO_TYPE_SHOP_DOOR,
    TAKEPHOTO_TYPE_SHOP_LOGO,
} TakePhotoType;



@interface TDFShopHeader:UIView

@property (nonatomic ,strong) UIImageView *iconImgV;

@property (nonatomic ,strong) UILabel *titleL;

@property (nonatomic ,strong) UILabel *tipsL;

@property (nonatomic ,strong) UILabel *desL;


@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic ,copy) NSString *tipStr;


@end

@implementation TDFShopHeader

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [self configLayout];
        [self configConstrains];
    }
    return self;
}

- (void)configLayout {
    
    [self addSubview:self.iconImgV];
    [self addSubview:self.titleL];
    [self addSubview:self.tipsL];
    [self addSubview:self.desL];
}

- (void)configConstrains {
    
    __weak typeof(self) ws = self;
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(10);
        make.right.equalTo(ws.mas_right).offset(-10);
        make.top.equalTo(ws.iconImgV.mas_bottom).offset(10);
    }];
    
    [self.tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(10);
        make.right.equalTo(ws.mas_right).offset(-10);
        make.top.equalTo(ws.titleL.mas_bottom).offset(10);
    }];
    
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(10);
        make.right.equalTo(ws.mas_right).offset(-10);
        make.top.equalTo(ws.tipsL.mas_bottom).offset(10);
        make.bottom.equalTo(ws.mas_bottom).offset(-15);
    }];
    
    [self systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

#pragma mark - Getter

- (UIImageView *)iconImgV {
    
    if (!_iconImgV) {
        
        _iconImgV = [UIImageView new];
        _iconImgV.image = [UIImage imageNamed:@"shopdatanew"];
    }
    return _iconImgV;
}

- (UILabel *)titleL {
    
    if (!_titleL) {
        
        _titleL = [UILabel new];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont boldSystemFontOfSize:18];
        _titleL.textAlignment = NSTextAlignmentCenter;
//        _titleL.text = @"title";
    }
    return _titleL;
}

- (UILabel *)tipsL {
    
    if (!_tipsL) {
        
        _tipsL = [UILabel new];
        _tipsL.numberOfLines = 0;
        _tipsL.font = [UIFont systemFontOfSize:14];
        _tipsL.textAlignment = NSTextAlignmentCenter;
//        _tipsL.text = @"tips";
    }
    return _tipsL;
}

- (UILabel *)desL {
    
    if (!_desL) {
        
        _desL = [UILabel new];
        _desL.numberOfLines = 0;
        _desL.font = [UIFont systemFontOfSize:12];
        _desL.textAlignment = NSTextAlignmentLeft;
        _desL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _desL.text = @"店家资料将显示在顾客端店铺信息页面，所有扫码点餐的顾客都可以查看。审核通过的店铺会展示在顾客端“附近的店”中，顾客可查找到您的店。";
    }
    return _desL;
}

#pragma mark - Setter

- (void)setTitleStr:(NSString *)titleStr {

    _titleStr = titleStr;
    
    [self reLayut];
}

- (void)setTipStr:(NSString *)tipStr {

    _tipStr = tipStr;
    
    [self reLayut];
}

- (void)reLayut {

    self.titleL.text = self.titleStr;
    self.tipsL.text = self.tipStr;
    
    self.titleL.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
    [self.titleL sizeToFit];
    self.tipsL.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
    [self.tipsL sizeToFit];
    self.desL.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
    [self.desL sizeToFit];
    
    
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGRect sRect = self.frame;
    
    sRect.size.height = size.height;
    
    [self setFrame:sRect];
}


@end

@interface TDFShopKeeperDataController ()<MultiCheckHandle,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate,TDFMapLocationViewControllerDelegate,MemoInputClient>

@property (nonatomic, strong) UITableView *tbvBase;

@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic ,strong) DHTTableViewSection *baseSection;

@property (nonatomic ,strong) DHTTableViewSection *addressSection;

@property (nonatomic ,strong) DHTTableViewSection *rangeSection;

@property (nonatomic ,strong) DHTTableViewSection *imgSection;

@property (nonatomic ,strong) TDFTextfieldItem *shopName;

@property (nonatomic ,strong) TDFTextfieldItem *shopTime;

@property (nonatomic ,strong) TDFTextfieldItem *shopPhoneNum;

@property (nonatomic ,strong) TDFTextfieldItem *connectPeople;

@property (nonatomic ,strong) TDFTextfieldItem *email;

@property (nonatomic ,strong) TDFTextfieldItem *connectPeoplesPhone;

@property (nonatomic ,strong) TDFPickerItem *country;

@property (nonatomic ,strong) TDFShowPickerStrategy *countryStrategy;

@property (nonatomic ,strong) TDFPickerItem *province;

@property (nonatomic ,strong) TDFCustomStrategy *provinceStrategy;

@property (nonatomic ,strong) TDFPickerItem *city;

@property (nonatomic ,strong) TDFCustomStrategy *cityStrategy;

@property (nonatomic ,strong) TDFPickerItem *area;

@property (nonatomic ,strong) TDFCustomStrategy *areaStrategy;

@property (nonatomic ,strong) TDFTextfieldItem *customEatArea;

@property (nonatomic ,strong) TDFPickerItem *tapToLocate;

@property (nonatomic ,strong) TDFPickerItem *perConsume;

@property (nonatomic ,strong) TDFCustomStrategy *perConsumeStrategy;

@property (nonatomic ,strong) TDFPickerItem *mainBusiness;

@property (nonatomic ,strong) TDFPickerItem *foodtypes;

@property (nonatomic ,strong) TDFPickerItem *specialService;

@property (nonatomic ,strong) TDFStaticLabelItem *shopIntrodution;

@property (nonatomic ,strong) TDFCardBgImageItem *shopImgItem;

@property (nonatomic ,strong) TDFCardBgImageItem *shopDoorImgItem;

@property (nonatomic ,strong) TDFCardBgImageItem *shopLogoImgItem;
    
@property (nonatomic ,strong) TDFShopImgStaticItem *imgStaticItem;

@property (nonatomic ,strong) KabawService *service;;

@property (nonatomic ,strong) ShopReviewInfo *reviewInfo;

//@property (nonatomic ,strong) NSMutableArray* shopTags;

@property (nonatomic ,strong) NSMutableArray<ShopTag *> *tagLists;

@property (nonatomic ,strong) NSMutableArray<ShopTag *> *tagListsNew;

@property (nonatomic ,strong) NSMutableArray<ShopTag *> *foodStyles;

@property (nonatomic ,strong) NSMutableArray<ShopTag *> *featureServices;

@property (nonatomic ,strong) NSMutableArray<ShopTag *> *mainBussiness;

@property (nonatomic ,strong) TDFShopHeader *header;

@property (nonatomic ,strong) NSMutableArray<BaseShopTag *> *countryList;

@property (nonatomic ,strong) NSMutableArray<ProvincesVo *> *provinceList;

@property (nonatomic ,strong) NSMutableArray<CitiesVo *> *cityList;

@property (nonatomic ,strong) NSMutableArray<TownsVo *> *areaList;

@property (nonatomic ,strong) NSMutableArray<DicSysItem *> *perconsumList;

@property (nonatomic ,strong) NSMutableArray<DicSysItem *> *mainBussinessList;

@property (nonatomic ,strong) NSMutableArray<DicSysItem *> *foodTypesList;

@property (nonatomic ,strong) NSMutableArray<DicSysItem *> *specialServiceList;


@property (nonatomic ,strong) NSMutableArray<ShopImg *> *imgArr;

@property (nonatomic ,strong) NSMutableArray<ShopImg *> *shopImgArr;

@property (nonatomic ,strong) ShopImg *shopDoorImg;

@property (nonatomic ,strong) ShopImg *shopLogoImg;

@property (nonatomic ,assign) TakePhotoType takePhotoType;

@property (nonatomic ,copy) NSString *imgFilePathTemp;

@property (nonatomic, assign) BOOL isChange;




@property (nonatomic ,strong) CLLocationManager *locationM;


@end

@implementation TDFShopKeeperDataController


#pragma mark - lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
    
    self.title = @"店家资料";
    
    [self configDefaultManager];
    
    [self registerCells];
    
    self.tbvBase.tableHeaderView = self.header;
    
    [self addSections];
    
    [self loadShopReviewInfo];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([TDFEditViewHelper isAnyTipsShowedInSections:(NSArray *)self.manager.sections]) {
        
        //[self configRightNavigationBar:@"ico_issue" rightButtonName:@"保存"];
        [self configRightNavigationBar:nil rightButtonName:@"保存"];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];//ico_cancel
        self.isChange = YES;
    } else {
        
        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:@"" rightButtonName:@""];
        self.isChange = NO;
    }
}


#pragma mark - Delegate

- (void)mapLocationViewController:(TDFMapLocationViewController *)viewController didFinishLocating:(TDFMapLocationModel *)location {
    
    if ((self.reviewInfo.longitude == [location.longitude doubleValue])&&(self.reviewInfo.latitude == [location.latitude doubleValue])) {
        
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:location.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:location.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:location.name forKey:@"mapAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.reviewInfo.longitude = location.longitude.doubleValue;
    self.reviewInfo.latitude = location.latitude.doubleValue;
    self.reviewInfo.mapAddress = location.name;
    
    self.tapToLocate.textValue = [NSString stringWithFormat:NSLocalizedString(@"经度:%@,纬度:%@", nil),location.longitude,location.latitude];
    
    [self.manager reloadData];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // 定位是非常频繁的，所以获取到用户信息后,最好马上关闭停止定位，以达到省电效果，在适当的时候再重新打开定位
    [manager stopUpdatingLocation];
    self.locationM = nil;
    
    CLLocation *location = [locations lastObject];
    
    self.reviewInfo.logoLatitude = location.coordinate.latitude;
    self.reviewInfo.logoLongitude = location.coordinate.longitude;
    
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items {
    
    if (event == 1) {
        
        NSMutableArray *list = [self convertTags:items code:MAIN_BUSINESS];
        
        [self dealMainBussinessWithList:list];
        
    }else if (event == 2) {
        
        NSMutableArray *list = [self convertTags:items code:FOOD_STYLE];
        
        [self dealFoodStyleWithList:list];
    }else if (event == 3) {
        
        NSMutableArray *list = [self convertTags:items code:FEATURE_SERVICE];
        
        [self dealFeatureServiceWithList:list];
    }
}

- (void)dealMainBussinessWithList:(NSMutableArray *)list {
    
    self.mainBussiness = [NSMutableArray arrayWithArray:list];
    
    self.mainBusiness.textValue = [NSString stringWithFormat:@"%lu项",(unsigned long)list.count];
    
    self.mainBusiness.detail = [self StringWithTagArr:self.mainBussiness];
    
    [self.manager reloadData];
}

- (void)dealFoodStyleWithList:(NSMutableArray *)list {
    
    self.foodStyles = [NSMutableArray arrayWithArray:list];
    
    self.foodtypes.textValue = [NSString stringWithFormat:@"%lu项",(unsigned long)list.count];
    
    self.foodtypes.detail = [self StringWithTagArr:self.foodStyles];
    
    [self.manager reloadData];
}

- (void)dealFeatureServiceWithList:(NSMutableArray *)list {
    
    self.featureServices = [NSMutableArray arrayWithArray:list];
    
    self.specialService.textValue = [NSString stringWithFormat:@"%lu项",(unsigned long)list.count];
    
    self.specialService.detail = [self StringWithTagArr:self.featureServices];
    
    [self.manager reloadData];
}

- (NSMutableArray *)convertTags:(NSMutableArray *)items code:(NSString *)codeTemp
{
    NSMutableArray *list=[NSMutableArray new];
    if ([ObjectUtil isNotEmpty:items]) {
        ShopTag* shopTag;
        for (DicSysItem *dic in items) {
            shopTag=[self convert:dic code:codeTemp];
            [list addObject:shopTag];
        }
    }
    return list;
}

- (ShopTag *)convert:(DicSysItem*)item code:(NSString*)code
{
    ShopTag* tag=[ShopTag new];
    tag.code=code;
    tag.name=item.name;
    tag.dicSysItemId=item._id;
    tag.entityId = self.reviewInfo.entityId;
    tag.spell = item.spell;
    return tag;
}

- (void)closeMultiView:(NSInteger)event {
    
}

#pragma mark - Load Data

- (void)loadmainBusinessList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[TDFTransService new]  listDicSysItems:MAIN_BUSINESS success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hideAnimated:YES];
        
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *arr = [JsonHelper transList:list objName:@"DicSysItem"];
        self.mainBussinessList = arr;
        
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:1 delegate:self title:_mainBusiness.title dataTemps:arr selectList:self.mainBussiness needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadFoodTypeList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[TDFTransService new]  listDicSysItems:FOOD_STYLE success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hideAnimated:YES];
        
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *arr = [JsonHelper transList:list objName:@"DicSysItem"];
        self.foodTypesList = arr;
        
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:2 delegate:self title:_foodtypes.title dataTemps:arr selectList:self.foodStyles needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadSpecialService {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[TDFTransService new]  listDicSysItems:FEATURE_SERVICE success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hideAnimated:YES];
        
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *arr = [JsonHelper transList:list objName:@"DicSysItem"];
        self.specialServiceList = arr;
        
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:3 delegate:self title:_specialService.title dataTemps:arr selectList:self.featureServices needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadPerConsumeList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[TDFTransService new]  listDicSysItems:PER_SPEND success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hideAnimated:YES];
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[DicSysItem class] json:[data objectForKey:@"data"]];
        self.perconsumList = [NSMutableArray arrayWithArray:arr];
        
        [self showPerconsumePicker];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadProvinceList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] getProvincesList:self.reviewInfo.countryId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        NSArray *list = [NSArray yy_modelArrayWithClass:[ProvincesVo class] json:[data objectForKey:@"data"]];
        
        self.provinceList = [NSMutableArray arrayWithArray:list];
        
        [self showProvincePicker];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadCitysList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    //            [UIHelper showHUD:@"正在加载" andView:self.view andHUD:hud];
    [[TDFKabawService new] getCitiesList:self.reviewInfo.provinceId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        NSArray *list = [NSArray yy_modelArrayWithClass:[CitiesVo class] json:[data objectForKey:@"data"]];
        
        self.cityList = [NSMutableArray arrayWithArray:list];
        
        [self showCityPicker];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


- (void)loadAreasList {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] getTownsList:self.reviewInfo.cityId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        NSArray *list = [NSArray yy_modelArrayWithClass:[TownsVo class] json:[data objectForKey:@"data"]];
        
        self.areaList = [NSMutableArray arrayWithArray:list];
        
        [self showAreaPicker];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

- (void)loadShopReviewInfo {
    
    [self.service loadShopReviewInfoWithTarget:self action:@selector(shopReviewInfoLoaded:)];
}

#pragma mark - normalFunctions

- (void)commit{
    
    NSString *str = [TDFEditViewHelper messageForCheckingItemEmptyInSections:(NSArray *)self.manager.sections withIgnoredCharator:NSLocalizedString(@"▪︎ ", nil)];
    
    if (str) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:str cancelTitle:NSLocalizedString(@"我知道了", nil)];
        
        return;
    }
    
    if (!self.reviewInfo.introduce.length) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:@"店家简介不能为空!" cancelTitle:NSLocalizedString(@"我知道了", nil)];
        
        return;
    }
    
    if (!self.shopImgArr.count) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:@"店铺图片不能为空" cancelTitle:NSLocalizedString(@"我知道了", nil)];
        
        return;
    }
    
    if (!self.shopDoorImg) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:@"店铺门头照不能为空" cancelTitle:NSLocalizedString(@"我知道了", nil)];
        
        return;
    }
    
    [self fillModels];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: [self.reviewInfo yy_modelToJSONObject]];
    
    [[KabawService new] updateShopReviewInfoWithParam:@{ @"shop_audit":  [param yy_modelToJSONString]}
                                    target:self
                                    action:@selector(saveReviewInfoFinished:)];

}

- (void)leftNavigationButtonAction:(id)sender {
    
    if (self.isChange) {
        
        [self showMessageWithTitle:@"提示" message:@"内容变更尚未保存，确定要退出吗？" cancelBlock:^{
            
        } enterBlock:^{
            
            [super leftNavigationButtonAction:sender];
        }];
        
    }else {
        
        [super leftNavigationButtonAction:sender];
    }
}

- (void)rightNavigationButtonAction:(id)sender {
 
    [self commit];
}

- (void)saveReviewInfoFinished:(RemoteResult *)result {
    
    [self.progressHud hideAnimated: YES];
    if (!result.isSuccess) {
        
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:result.errorStr
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:avc animated:YES completion:nil];
        return;
    }
    
    [self showMessage:@"提交成功" withDuration:3.0];
    
    [self loadShopReviewInfo];
}

- (void)fillModels{

//    NSMutableArray<ShopImg *> *imgArrs = [NSMutableArray array];
//    
//    [imgArrs addObjectsFromArray:self.shopImgArr];
//    
//    if (self.shopDoorImg) {
//        
//        [imgArrs addObject:self.shopDoorImg];
//    }
//    
    self.reviewInfo.imgLists = [NSArray arrayWithArray:self.imgArr];
    
    NSMutableArray<ShopTag *> *tags = [NSMutableArray new];
    
    [tags addObjectsFromArray:self.mainBussiness];
    [tags addObjectsFromArray:self.foodStyles];
    [tags addObjectsFromArray:self.featureServices];
    
    self.reviewInfo.tagLists = [NSArray arrayWithArray:tags];
    
    ShopTag *lastTag = nil;
    
    NSMutableString *specialTagStr = [NSMutableString string];
    
    for (ShopTag *tag in tags) {
        
        if (lastTag) {
            
            [specialTagStr appendString:[NSString stringWithFormat:@",%@",tag.name]];
        }else {
        
            [specialTagStr appendString:tag.name];
            lastTag = tag;
        }
    }
    
    self.reviewInfo.specialTag = specialTagStr;
}

- (void)tapToLocateDidtap {
    
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    //NSString *mapAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"mapAddress"];
    //    //如果是新加坡  153  香港 071  澳门 100 不可编辑   台湾169 可以编辑
    TDFMapLocatorType locatorType;
    if([self.reviewInfo.countryId isEqualToString:@"001"]) {
        locatorType = TDFMapLocatorTypeGaoDe;
    }else {
        locatorType = TDFMapLocatorTypeApple;
    }
    TDFMapLocationViewController *mapLocationVireController = [[TDFMapLocationViewController alloc] initWithLocatorType:locatorType longitude:longitude latitude:latitude];
    mapLocationVireController.locateForService = @"店铺";
    mapLocationVireController.delegate = self;
    [self.navigationController pushViewController:mapLocationVireController animated:YES];
}

- (void)provinceDidSelect:(NameItemVO *)vo {
    
    if ([vo.itemValue isEqualToString:self.reviewInfo.provinceName]) {
        
    }else {
        
        self.city.textValue = nil;
        self.area.textValue = nil;
        
        self.province.textValue = vo.itemName;
        self.reviewInfo.provinceName = vo.itemName;
        self.reviewInfo.provinceId = vo.itemId;
        
        [self.manager reloadData];
    }
}

- (void)cityDidSelect:(NameItemVO *)vo {
    
    if ([vo.itemValue isEqualToString:self.reviewInfo.cityName]) {
        
    }else {
        
        self.area.textValue = nil;
        self.city.textValue = vo.itemName;
        self.reviewInfo.cityName = vo.itemName;
        self.reviewInfo.cityId = vo.itemId;
        
        [self.manager reloadData];
    }
}

- (void)areaDidSelect:(NameItemVO *)vo {
    
    self.area.textValue = vo.itemName;
    self.reviewInfo.townName = vo.itemName;
    self.reviewInfo.townId = vo.itemId;
    
    [self.manager reloadData];
}

- (void)perConsumeDidSelect:(NameItemVO *)vo {
    
    self.perConsume.textValue = vo.itemName;
    
    self.reviewInfo.avgPrice = vo.itemName;
    
    [self.manager reloadData];
}

- (void)showPerconsumePicker {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    int i = 0;
    
    int j = 0;
    
    for (DicSysItem *vo in self.perconsumList) {
        
        NameItemVO *item = [[NameItemVO alloc]initWithVal:vo.name andId:vo.dicId];
        
        [arr addObject:item];
        
        if (!([vo.name isEqualToString:self.reviewInfo.avgPrice])) {
            
            i++;
            
        }else {
            
            j = i;
        }
    }
    
    TDFOptionPickerController *vc = [[TDFOptionPickerController alloc] initWithTitle:self.perConsume.title options:arr currentSelectedIndex:j];
    
    vc.competionBlock = ^(NSInteger index){
        
        NameItemVO *vo = arr[index];
        
        [self perConsumeDidSelect:vo];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)showAreaPicker {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    int i = 0;
    
    int j = 0;
    
    for (TownsVo *vo in self.areaList) {
        
        NameItemVO *item = [[NameItemVO alloc]initWithVal:vo.townName andId:vo.townId];
        
        [arr addObject:item];
        
        if (!([vo.townId isEqualToString:self.reviewInfo.townId])) {
            
            i++;
            
        }else {
            
            j = i;
        }
    }
    
    TDFOptionPickerController *vc = [[TDFOptionPickerController alloc] initWithTitle:self.area.title options:arr currentSelectedIndex:j];
    
    vc.competionBlock = ^(NSInteger index){
        
        NameItemVO *vo = arr[index];
        
        [self areaDidSelect:vo];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showCityPicker {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    int i = 0;
    
    int j = 0;
    
    for (CitiesVo *vo in self.cityList) {
        
        NameItemVO *item = [[NameItemVO alloc]initWithVal:vo.cityName andId:vo.cityId];
        
        [arr addObject:item];
        
        if (!([vo.cityId isEqualToString:self.reviewInfo.cityId])) {
            
            i++;
            
        }else {
            
            j = i;
        }
    }
    
    TDFOptionPickerController *vc = [[TDFOptionPickerController alloc] initWithTitle:self.city.title options:arr currentSelectedIndex:j];
    
    vc.competionBlock = ^(NSInteger index){
        
        NameItemVO *vo = arr[index];
        
        [self cityDidSelect:vo];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showProvincePicker {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    int i = 0;
    
    int j = 0;
    
    for (ProvincesVo *vo in self.provinceList) {
        
        NameItemVO *item = [[NameItemVO alloc]initWithVal:vo.provinceName andId:vo.provinceId];
        
        [arr addObject:item];
        
        if (!([vo.provinceId isEqualToString:self.reviewInfo.provinceId])) {
            
            i++;
            
        }else {
            
            j = i;
        }
    }
    
    TDFOptionPickerController *vc = [[TDFOptionPickerController alloc] initWithTitle:self.province.title options:arr currentSelectedIndex:j];
    
    vc.competionBlock = ^(NSInteger index){
        
        NameItemVO *vo = arr[index];
        
        [self provinceDidSelect:vo];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)shopReviewInfoLoaded:(RemoteResult *)res {
    
    if ((!res.isSuccess)) {
        
        [self showErrorMessage:res.errorStr];
        
        return;
    }
    NSData *data = [res.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];

    self.reviewInfo = [ShopReviewInfo yy_modelWithDictionary: dic[@"data"][@"shop"]];
    
    NSArray *tempArr = [NSMutableArray yy_modelArrayWithClass:[ShopTag class] json:[[[dic objectForKey:@"data"] objectForKey:@"shop"] objectForKey:@"tagLists"]];
    _tagLists = [NSMutableArray arrayWithArray:tempArr];
    
    NSArray *tempCountryList =  [NSMutableArray yy_modelArrayWithClass:[BaseShopTag class] json:[[dic objectForKey:@"data"] objectForKey:@"countryList"]];
    _countryList = [NSMutableArray arrayWithArray:tempCountryList];
    
    //    self.shopTags = [JsonHelper transList:taglist objName:@"ShopTag"];
    self.header.titleL.textColor = [self textColorForShopState:self.reviewInfo.status];
    self.header.tipsL.textColor = self.header.titleL.textColor;
    
    self.header.titleStr = self.reviewInfo.statusTitle;
    self.header.tipStr = self.reviewInfo.statusDetail;
    
    [self fillListRanges];
    
    [self LoadTableView];
}

- (void)fillListRanges {
    
    self.mainBussiness = [NSMutableArray new];
    
    self.foodStyles = [NSMutableArray new];
    
    self.featureServices = [NSMutableArray new];
    
    
    
    for (ShopTag *shopt in _tagLists) {
        
        if ([shopt.code isEqualToString:MAIN_BUSINESS]) {
            
            [self.mainBussiness addObject:shopt];
            
        }else if ([shopt.code isEqualToString:FOOD_STYLE]) {
            
            [self.foodStyles addObject:shopt];
            
        }else if ([shopt.code isEqualToString:FEATURE_SERVICE]) {
            
            [self.featureServices addObject:shopt];
            
        }else {
            
        }
    }
    
    [ShopReviewCenter sharedInstance].reviewState = self.reviewInfo.status;
    
    [self fillCountryList];
}

- (void)fillCountryList {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (BaseShopTag *ii in _countryList) {
        
        NameItemVO *item = [[NameItemVO alloc]initWithVal:ii.name  andId:ii.id];
        
        [arr addObject:item];
    }
    
    NameItemVO *item = [[NameItemVO alloc]initWithVal:self.reviewInfo.countryName andId:self.reviewInfo.countryId];
    
    self.countryStrategy.pickerItemList = arr;
    self.countryStrategy.selectedItem = item;
}

- (void)LoadTableView {
    
    self.shopName.preValue = self.reviewInfo.name;
    self.shopName.textValue = self.shopName.preValue;
    
    self.shopTime.preValue = self.reviewInfo.businessTime;
    self.shopTime.textValue = self.shopTime.preValue;
    
    self.shopPhoneNum.preValue = self.reviewInfo.phone;
    self.shopPhoneNum.textValue = self.shopPhoneNum.preValue;
    
    self.connectPeople.preValue = self.reviewInfo.linkName;
    self.connectPeople.textValue = self.connectPeople.preValue;
    
    self.email.preValue = self.reviewInfo.linkEmail;
    self.email.textValue = self.email.preValue;
    
    self.connectPeoplesPhone.preValue = self.reviewInfo.linkTel;
    self.connectPeoplesPhone.textValue = self.connectPeoplesPhone.preValue;
    
    self.country.preValue = self.reviewInfo.countryName;
    self.country.textValue = self.country.preValue;
    
    self.province.preValue = self.reviewInfo.provinceName;
    self.province.textValue = self.province.preValue;
    
    self.city.preValue = self.reviewInfo.cityName;
    self.city.textValue = self.city.preValue;
    
    self.area.preValue = self.reviewInfo.townName;
    self.area.textValue = self.area.preValue;
    
    self.customEatArea.preValue = self.reviewInfo.address;
    self.customEatArea.textValue = self.customEatArea.preValue;
    
    self.tapToLocate.preValue = (self.reviewInfo.longitude&&self.reviewInfo.latitude)?[NSString stringWithFormat:@"经度:%f,纬度:%f",self.reviewInfo.longitude,self.reviewInfo.latitude]:nil;
    self.tapToLocate.textValue = self.tapToLocate.preValue;
    self.tapToLocate.placeholder = @"点击进行定位（必填）";
    
    self.perConsume.preValue = self.reviewInfo.avgPrice?self.reviewInfo.avgPrice:nil;
    self.perConsume.textValue = self.perConsume.preValue;
    
    self.mainBusiness.preValue = [NSString stringWithFormat:@"%lu项",(unsigned long)self.mainBussiness.count];
    self.mainBusiness.textValue = self.mainBusiness.preValue;
    self.mainBusiness.detail = [self StringWithTagArr:self.mainBussiness];
    
    self.foodtypes.preValue = [NSString stringWithFormat:@"%lu项",(unsigned long)self.foodStyles.count];
    self.foodtypes.textValue = self.foodtypes.preValue;
    self.foodtypes.detail = [self StringWithTagArr:self.foodStyles];
    
    self.specialService.preValue = [NSString stringWithFormat:@"%lu项",(unsigned long)self.featureServices.count];
    self.specialService.textValue = self.specialService.preValue;
    self.specialService.detail = [self StringWithTagArr:self.featureServices];
    
    self.shopIntrodution.preValue = self.reviewInfo.introduce;
    self.shopIntrodution.detail = self.reviewInfo.introduce;
    self.shopIntrodution.textValue = self.reviewInfo.introduce.length == 0 ? @"必填":nil;
    
    [self judgeIsWaitingForCheck];
    
    NSArray<ShopImg *> *ImgArr = [NSArray yy_modelArrayWithClass:[ShopImg class] json:self.reviewInfo.imgLists];
    self.imgArr = [NSMutableArray arrayWithArray:ImgArr];
    
    [self loadShopImg];
    
    [self.manager reloadData];
}

- (NSString *)StringWithTagArr:(NSMutableArray<ShopTag *> *)tags {

    ShopTag *lastTag = nil;
    
    NSMutableString *specialTagStr = [NSMutableString string];
    
    for (ShopTag *tag in tags) {
        
        if (lastTag) {
            
            [specialTagStr appendString:[NSString stringWithFormat:@",%@",tag.name]];
        }else {
            
            [specialTagStr appendString:tag.name];
            lastTag = tag;
        }
    }
    return specialTagStr;
}

- (void)loadShopImg {
    
    [self configAllImg];
    
}

- (void)judgeIsWaitingForCheck {

    if (self.reviewInfo.status == ShopReviewStateWaiting) {
        
        for (DHTTableViewSection *section in self.manager.sections) {
            
            for (TDFBaseEditItem *item in section.items) {
                
                item.editStyle = TDFEditStyleUnEditable;
            }
        }
        self.imgStaticItem.commitBlock = nil;
        
        self.imgStaticItem.isWaiting = (self.reviewInfo.status == ShopReviewStateWaiting);
    }
    
    if (self.reviewInfo.status == ShopReviewStateAccept) {
        
        [self removeIsRequired];
    }
}

- (void)removeIsRequired {

    self.shopImgItem.showRightArea = NO;
    self.shopDoorImgItem.showRightArea = NO;
    self.shopLogoImgItem.showRightArea = NO;
}

- (void)configAllImg {

    self.shopImgArr = [NSMutableArray<ShopImg *> array];
    
    self.shopDoorImg = nil;
    
    self.shopLogoImg = nil;
    
    for (ShopImg *img in self.imgArr) {
        
        if (img.type == 0) {//普通
            
            [self.shopImgArr addObject:img];
            
        }else if (img.type == 2) {//门头照
            
            self.shopDoorImg = img;
        
        }else if (img.type == 3) {//店家logo
        
            self.shopLogoImg = img;
        }
    }
    
    [self configShopNormalImgWithArr:self.shopImgArr];
    [self configSHopDoorImgWith:self.shopDoorImg];
    [self configSHopLogoImgWith:self.shopLogoImg];
}

- (void)configShopNormalImgWithArr:(NSMutableArray<ShopImg *> *)imgArr {
    
    
    self.shopImgItem.showRightArea = (imgArr.count == 0)?YES:NO;
    
    self.shopImgItem.cardImageItems = [NSArray array];
    
    NSMutableArray *cards = [NSMutableArray new];
    
    for (ShopImg * shopimg in self.shopImgArr) {
        
        NSString *path = [shopimg obtainFilePath] ? [shopimg obtainFilePath] : [shopimg obtainPath];
        TDFCardBgImageBaseItem *imgItem = [[TDFCardBgImageBaseItem alloc]init];
        
        NSString *obPath = [ImageUtils editImageUrlWithPath:path size:CGSizeMake(600, 600) model:4 quality:80.0f standard:@"1x"];
        
        imgItem.cardImagePath = obPath;
        
        imgItem.preValue = obPath;
        
        [cards addObject:imgItem];
    }
    
    if (cards.count<5) {
        
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc]init];
        
        addItem.titleForAddImageButton = @"添加图片";
        
        if (!(self.reviewInfo.status == ShopReviewStateWaiting)) {
            [cards addObject:addItem];
        }
    }
    
    self.shopImgItem.cardImageItems = cards;
}

- (void)configSHopDoorImgWith:(ShopImg *)img {
    
    self.shopDoorImgItem.showRightArea = (img)?NO:YES;
    
    self.shopDoorImgItem.cardImageItems = [NSArray array];
    
    self.shopDoorImg = img;
    
    if (!img) {
    
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc]init];
        
        addItem.titleForAddImageButton = @"拍照";
        
        self.shopDoorImgItem.cardImageItems = @[addItem];
        
    }else {
    
        NSString *path = [img obtainFilePath] ? [img obtainFilePath] : [img obtainPath];
        TDFCardBgImageBaseItem *imgItem = [[TDFCardBgImageBaseItem alloc]init];
        
        NSString *obPath = [ImageUtils editImageUrlWithPath:path size:CGSizeMake(600, 600) model:4 quality:80.0f standard:@"1x"];
        
        imgItem.cardImagePath = obPath;
        
        imgItem.preValue = obPath;
        
        self.shopDoorImgItem.cardImageItems = @[imgItem];
    }
}

- (void)configSHopLogoImgWith:(ShopImg *)img {
    
    self.shopLogoImgItem.showRightArea = (img)?NO:YES;
    
    self.shopLogoImgItem.cardImageItems = [NSArray array];
    
    self.shopLogoImg = img;
    
    if (!img) {
        
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc]init];
        
        addItem.titleForAddImageButton = @"添加图片";
        
        self.shopLogoImgItem.cardImageItems = @[addItem];
        
    }else {
        
        NSString *path = [img obtainFilePath] ? [img obtainFilePath] : [img obtainPath];
        TDFCardBgImageBaseItem *imgItem = [[TDFCardBgImageBaseItem alloc]init];
        
        NSString *obPath = [ImageUtils editImageUrlWithPath:path size:CGSizeMake(600, 600) model:4 quality:80.0f standard:@"1x"];
        
        imgItem.cardImagePath = obPath;
        
        imgItem.preValue = obPath;
        
        self.shopLogoImgItem.cardImageItems = @[imgItem];
    }
}

- (UIColor *)textColorForShopState:(ShopReviewState)state {
    
    switch (state) {
        case ShopReviewStateNone: {
            
            return [UIColor colorWithRed:204.0 / 255 green:0 blue:0 alpha:1.0];
        }
        case ShopReviewStateWaiting: {
            
            return [UIColor colorWithRed:245.0 / 255 green:128.0/255 blue:35.0 / 255 alpha:1.0];
        }
        case ShopReviewStateAccept: {
            
            return [UIColor colorWithRed:7.0 / 255 green:173.0 / 255 blue:31.0 / 255 alpha:1.0];
        }
        case ShopReviewStateReject: {
            
            return [UIColor colorWithRed:204.0 / 255 green:0 blue:0 alpha:1.0];
        }
    }
}

- (void)configDefaultManager
{
    self.tbvBase = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tbvBase.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvBase.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tbvBase];
    
    self.manager = [[DHTTableViewManager alloc] initWithTableView:self.tbvBase];
    UIView *alphaView         = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha           = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
}

- (void)registerCells
{
    [self.manager registerCell:@"TDFBaseEditCell" withItem:@"TDFBaseEditItem"];
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
    [self.manager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
    [self.manager registerCell:@"TDFCardBgImageCell" withItem:@"TDFCardBgImageItem"];
    [self.manager registerCell:@"TDFShopImgStaticCell" withItem:@"TDFShopImgStaticItem"];
}

- (void)addSections
{
    
    DHTTableViewSection *se1 = [DHTTableViewSection sectionWithTitleHeader:@"基本资料"];
    DHTTableViewSection *se2 = [DHTTableViewSection sectionWithTitleHeader:@"营业地址"];
    DHTTableViewSection *se3 = [DHTTableViewSection sectionWithTitleHeader:@"营业范围"];
    DHTTableViewSection *se4 = [DHTTableViewSection sectionWithTitleHeader:@"店家图片"];
    
    [self.manager addSection:se1];
    [self.manager addSection:self.baseSection];
    [self.manager addSection:se2];
    [self.manager addSection:self.addressSection];
    [self.manager addSection:se3];
    [self.manager addSection:self.rangeSection];
    [self.manager addSection:se4];
    [self.manager addSection:self.imgSection];
    
    [self.baseSection addItem:self.shopName];
    [self.baseSection addItem:self.shopTime];
    [self.baseSection addItem:self.shopPhoneNum];
    [self.baseSection addItem:self.connectPeople];
    [self.baseSection addItem:self.email];
    [self.baseSection addItem:self.connectPeoplesPhone];
    
    
    [self.addressSection addItem:self.country];
    [self.addressSection addItem:self.province];
    [self.addressSection addItem:self.city];
    [self.addressSection addItem:self.area];
    [self.addressSection addItem:self.customEatArea];
    [self.addressSection addItem:self.tapToLocate];
    
    
    [self.rangeSection addItem:self.perConsume];
    [self.rangeSection addItem:self.mainBusiness];
    [self.rangeSection addItem:self.foodtypes];
    [self.rangeSection addItem:self.specialService];
    [self.rangeSection addItem:self.shopIntrodution];
    
    [self.imgSection addItem:self.shopImgItem];
    [self.imgSection addItem:self.shopDoorImgItem];
    [self.imgSection addItem:self.shopLogoImgItem];
    [self.imgSection addItem:self.imgStaticItem];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

#pragma mark - Getter

- (CLLocationManager *)locationM {
    if (_locationM == nil) {
        
        // 创建位置管理者
        _locationM = [[CLLocationManager alloc] init];
        
        // 设置代理
        _locationM.delegate = self;
        
    }
    return _locationM;
}

- (DHTTableViewSection *)baseSection {
    
    if (!_baseSection) {
        
//        _baseSection = [DHTTableViewSection sectionWithTitleHeader:@"基本资料"];
        _baseSection = [DHTTableViewSection section];
    }
    return _baseSection;
}

- (DHTTableViewSection *)addressSection {
    
    if (!_addressSection) {
        
//        _addressSection = [DHTTableViewSection sectionWithTitleHeader:@"营业地址"];
        _addressSection = [DHTTableViewSection section];
    }
    return _addressSection;
}

- (DHTTableViewSection *)rangeSection {
    
    if (!_rangeSection) {
        
//        _rangeSection = [DHTTableViewSection sectionWithTitleHeader:@"营业范围"];
        _rangeSection = [DHTTableViewSection section];
    }
    return _rangeSection;
}

- (DHTTableViewSection *)imgSection {
    
    if (!_imgSection) {
        
//        _imgSection = [DHTTableViewSection sectionWithTitleHeader:@"店家图片"];
        _imgSection = [DHTTableViewSection section];
    }
    return _imgSection;
}

- (TDFTextfieldItem *)shopName {
    
    if (!_shopName) {
        
        __weak typeof(self) ws = self;
        
        _shopName = [[TDFTextfieldItem alloc]init];
        _shopName.title = @"店家名称";
        _shopName.isRequired = YES;
        _shopName.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.name = str;
            return YES;
        };
    }
    return _shopName;
}

- (TDFTextfieldItem *)shopTime {
    
    if (!_shopTime) {
        
        __weak typeof(self) ws = self;
        
        _shopTime = [[TDFTextfieldItem alloc]init];
        _shopTime.title = @"营业时间";
        _shopTime.isRequired = YES;
        _shopTime.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.businessTime = str;
            return YES;
        };
    }
    return _shopTime;
}

- (TDFTextfieldItem *)shopPhoneNum {
    
    if (!_shopPhoneNum) {
        
        __weak typeof(self) ws = self;
        
        _shopPhoneNum = [[TDFTextfieldItem alloc]init];
        _shopPhoneNum.title = @"店铺电话";
        _shopPhoneNum.isRequired = YES;
        _shopPhoneNum.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.phone = str;
            return YES;
        };
    }
    return _shopPhoneNum;
}

- (TDFTextfieldItem *)connectPeople {
    
    if (!_connectPeople) {
        
        __weak typeof(self) ws = self;
        
        _connectPeople = [[TDFTextfieldItem alloc]init];
        _connectPeople.title = @"联系人";
        _connectPeople.isRequired = NO;
        _connectPeople.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.linkName = str;
            return YES;
        };
    }
    return _connectPeople;
}

- (TDFTextfieldItem *)email {
    
    if (!_email) {
        
        __weak typeof(self) ws = self;
        
        _email = [[TDFTextfieldItem alloc]init];
        _email.title = @"常用邮箱";
        _email.isRequired = NO;
        _email.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.linkEmail = str;
            return YES;
        };
    }
    return _email;
}

- (TDFTextfieldItem *)connectPeoplesPhone {
    
    if (!_connectPeoplesPhone) {
        
        __weak typeof(self) ws = self;
        
        _connectPeoplesPhone = [[TDFTextfieldItem alloc]init];
        _connectPeoplesPhone.title = @"联系人电话";
        _connectPeoplesPhone.isRequired = NO;
        _connectPeoplesPhone.filterBlock = ^ (NSString *str){
            
            ws.reviewInfo.linkTel = str;
            return YES;
        };
    }
    return _connectPeoplesPhone;
}

- (TDFPickerItem *)country {
    
    if (!_country) {
        
        __weak typeof(self) ws = self;
        
        _country = [[TDFPickerItem alloc]init];
        _country.editStyle = TDFEditStyleUnEditable;
        _country.title = @"国家或地域";
        _country.detail = @"注：如需修改国家或地区，请联系在线客服";
        _country.isRequired = YES;
        _country.strategy = self.countryStrategy;
        _country.filterBlock = ^(NSString *str,id itemid){
            
            
            ws.reviewInfo.countryName = str;
            ws.reviewInfo.countryId = itemid;
            
            if (![str isEqualToString:ws.reviewInfo.countryName]) {
                
                ws.province.textValue = nil;
                ws.city.textValue = nil;
                ws.area.textValue = nil;
                
                [ws.manager reloadData];
            }
            
            return YES;
        };
    }
    return _country;
}

- (TDFShowPickerStrategy *)countryStrategy {
    
    if (!_countryStrategy) {
        
        _countryStrategy = [[TDFShowPickerStrategy alloc]init];
        
    }
    return _countryStrategy;
}

- (TDFPickerItem *)province {
    
    if (!_province) {
        
        _province = [[TDFPickerItem alloc]init];
        _province.title = @"省";
        _province.isRequired = YES;
        _province.strategy = self.provinceStrategy;
    }
    return _province;
}

- (TDFCustomStrategy *)provinceStrategy {
    
    if (!_provinceStrategy) {
        
        __weak typeof(self) ws = self;
        _provinceStrategy = [[TDFCustomStrategy alloc]init];
        _provinceStrategy.btnClickedBlock = ^(){
            
            if (ws.reviewInfo.countryId.length>0) {
                
                [ws loadProvinceList];
                
            }else {
                
                [ws showErrorMessage:NSLocalizedString(@"国家/地域不能为空", nil)];
            }
        };
    }
    return _provinceStrategy;
}

- (TDFPickerItem *)city {
    
    if (!_city) {
        
        _city = [[TDFPickerItem alloc]init];
        _city.title = @"城市";
        _city.isRequired = YES;
        _city.strategy = self.cityStrategy;
    }
    return _city;
}

- (TDFCustomStrategy *)cityStrategy {
    
    if (!_cityStrategy) {
        
        __weak typeof(self) ws = self;
        
        _cityStrategy = [[TDFCustomStrategy alloc]init];
        _cityStrategy.btnClickedBlock = ^(){
            
            if (ws.reviewInfo.provinceId.length>0) {
                
                [ws loadCitysList];
                
            }else {
                
                [ws showErrorMessage:NSLocalizedString(@"省不能为空", nil)];
            }
        };
    }
    return _cityStrategy;
}

- (TDFPickerItem *)area {
    
    if (!_area) {
        
        _area = [[TDFPickerItem alloc]init];
        _area.title = @"区县";
        _area.isRequired = YES;
        _area.strategy = self.areaStrategy;
    }
    return _area;
}

- (TDFCustomStrategy *)areaStrategy {
    
    if (!_areaStrategy) {
        
        __weak typeof(self) ws = self;
        
        _areaStrategy = [[TDFCustomStrategy alloc]init];
        _areaStrategy.btnClickedBlock = ^(){
            
            if (ws.reviewInfo.cityId.length>0) {
                
                [ws loadAreasList];
                
            }else {
                
                [ws showErrorMessage:NSLocalizedString(@"城市不能为空", nil)];
            }
        };
    }
    return _areaStrategy;
}

- (TDFTextfieldItem *)customEatArea {
    
    if (!_customEatArea) {
        
        __weak typeof(self) ws = self;
        
        _customEatArea = [[TDFTextfieldItem alloc]init];
        _customEatArea.title = @"顾客就餐地址";
        _customEatArea.isRequired = YES;
        _customEatArea.detail = @"注：顾客就餐地址展示在微店中方便顾客查看，国家城市等选择项仅作标识，不提供给顾客查看。";
        _customEatArea.filterBlock = ^(NSString *str){
            
            ws.reviewInfo.address = str;
            
            return YES;
        };
    }
    return _customEatArea;
}

- (TDFPickerItem *)tapToLocate {
    
    if (!_tapToLocate) {
        
        _tapToLocate = [[TDFPickerItem alloc]init];
        _tapToLocate.title = @"店铺地址定位";
        _tapToLocate.isRequired = YES;
        _tapToLocate.detail = @"注：准确设置店铺位置，方便顾客在 “火小二” 应用中用 “附近的店” 功能搜索到您的餐店。";
        TDFCustomStrategy *stg = [[TDFCustomStrategy alloc]init];
        _tapToLocate.strategy = stg;
        
        __weak typeof(self) ws = self;
        
        stg.btnClickedBlock = ^ (){
            
            [ws tapToLocateDidtap];
        };
    }
    return _tapToLocate;
}

- (TDFPickerItem *)perConsume {
    
    if (!_perConsume) {
        
        _perConsume = [[TDFPickerItem alloc]init];
        _perConsume.title = @"人均消费";
        
        _perConsume.isRequired = NO;
        _perConsume.strategy = self.perConsumeStrategy;
    }
    return _perConsume;
}

- (TDFCustomStrategy *)perConsumeStrategy {
    
    if (!_perConsumeStrategy) {
        
        __weak typeof(self) ws = self;
        _perConsumeStrategy = [[TDFCustomStrategy alloc]init];
        _perConsumeStrategy.btnClickedBlock = ^(){
            
            [ws loadPerConsumeList];
        };
    }
    return _perConsumeStrategy;
}

- (TDFPickerItem *)mainBusiness {
    
    if (!_mainBusiness) {
        
        _mainBusiness = [[TDFPickerItem alloc]init];
        _mainBusiness.title = @"主营业务";
        _mainBusiness.isRequired = NO;
        TDFCustomStrategy *stg = [[TDFCustomStrategy alloc]init];
        _mainBusiness.strategy = stg;
        stg.btnClickedBlock = ^(){
            
            [self loadmainBusinessList];
        };
    }
    return _mainBusiness;
}

- (TDFPickerItem *)foodtypes {
    
    if (!_foodtypes) {
        
        _foodtypes = [[TDFPickerItem alloc]init];
        _foodtypes.title = @"餐饮菜系";
        _foodtypes.isRequired = NO;
        TDFCustomStrategy *stg = [[TDFCustomStrategy alloc]init];
        _foodtypes.strategy = stg;
        stg.btnClickedBlock = ^(){
            
            [self loadFoodTypeList];
        };
    }
    return _foodtypes;
}

- (TDFPickerItem *)specialService {
    
    if (!_specialService) {
        
        _specialService = [[TDFPickerItem alloc]init];
        _specialService.title = @"特色服务";
        _specialService.isRequired = NO;
        TDFCustomStrategy *stg = [[TDFCustomStrategy alloc]init];
        _specialService.strategy = stg;
        stg.btnClickedBlock = ^(){
            
            [self loadSpecialService];
        };
        
    }
    return _specialService;
}

- (TDFStaticLabelItem *)shopIntrodution {
    
    if (!_shopIntrodution) {
        
        __weak typeof(self) ws = self;
        
        _shopIntrodution = [[TDFStaticLabelItem alloc]init];
        _shopIntrodution.title = @"店家简介";
        _shopIntrodution.isRequired = YES;
        _shopIntrodution.placeholder = @"必填";
        
        _shopIntrodution.selectedBlock = ^(){
            
            if (self.reviewInfo.status == ShopReviewStateWaiting) {
                
                return ;
            }
            [MemoInputBox show:1 delegate:ws title:@"店家简介" val:ws.shopIntrodution.detail];
        };
    }
    return _shopIntrodution;
}

//完成Memo输入.
-(void) finishInput:(NSInteger)event content:(NSString*)content
{
    self.shopIntrodution.isShowTip = ![content isEqualToString:self.shopIntrodution.preValue];
    
    self.reviewInfo.introduce = content.length == 0?nil:content;
    
    self.shopIntrodution.detail = content.length == 0?nil:content;
    
    self.shopIntrodution.textValue = self.reviewInfo.introduce.length == 0 ? @"必填":nil;
    
    [self.manager reloadData];
}

- (TDFCardBgImageItem *)shopImgItem {
    
    if (!_shopImgItem) {
        
        __weak typeof(self) ws = self;
        
        _shopImgItem = [[TDFCardBgImageItem alloc] init];
        
        _shopImgItem.imageContentMode = UIViewContentModeScaleAspectFit;
        
        _shopImgItem.title = @"店铺图片";
        
        _shopImgItem.showDelButton = YES;
        
        _shopImgItem.showRightArea = YES;
        
        _shopImgItem.hideRightArr = YES;
        
        _shopImgItem.isRequired = YES;
        
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc] init];
        
        _shopImgItem.cardImageItems = @[addItem];
        
        _shopImgItem.filterBlock = ^(NSInteger idx,TDFFilterType filterType){
        
            ws.takePhotoType = TAKEPHOTO_TYPE_SHOP_PHOTO;
            
            
            if (filterType == TDFFilterTypeAdd) {
                
                if (((TDFCardBgImageBaseItem *)ws.shopImgItem.cardImageItems[idx]).cardImagePath) {
                    
                    return ;
                }
                
                [ws takePhotoWithType];
                
            }else {
            
                [ws showMessageWithTitle:@"提示" message:@"您确认要删除当前的图片吗" cancelBlock:^{
                    
                } enterBlock:^{
                   
                    [ws removeImgAtIndex:idx];
                }];
            }
        };
    }
    return _shopImgItem;
}

- (TDFCardBgImageItem *)shopDoorImgItem {
    
    if (!_shopDoorImgItem) {
        
        __weak typeof(self) ws = self;
        
        _shopDoorImgItem = [[TDFCardBgImageItem alloc]init];
        
        _shopDoorImgItem.imageContentMode = UIViewContentModeScaleAspectFit;
        
        _shopDoorImgItem.title = @"店铺门头照";
        
        _shopDoorImgItem.showDelButton = YES;
        
        _shopDoorImgItem.isRequired = YES;
        
        _shopDoorImgItem.hideRightArr = YES;
        
        _shopDoorImgItem.detail = @"注：该照片必须现场拍摄，同时要打开自动定位功能，以便认证店铺地址的真实有效性";
        
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc] init];
        
        addItem.topTitleValue = @"拍照";
        
        _shopDoorImgItem.cardImageItems = @[addItem];
        
        _shopDoorImgItem.filterBlock = ^(NSInteger idx,TDFFilterType filterType){
            
            ws.takePhotoType = TAKEPHOTO_TYPE_SHOP_DOOR;
            
            if (filterType == TDFFilterTypeAdd) {
                
                if (((TDFCardBgImageBaseItem *)ws.shopDoorImgItem.cardImageItems[idx]).cardImagePath) {
                    
                    return ;
                }
                
                [ws takePhotoWithType];
                
            }else {
                
                [ws showMessageWithTitle:@"提示" message:@"您确认要删除当前的图片吗" cancelBlock:^{
                    
                } enterBlock:^{
                    
                    [ws removeImgAtIndex:idx];
                }];
            }
        };
    }
    return _shopDoorImgItem;
}

- (TDFCardBgImageItem *)shopLogoImgItem {
    
    if (!_shopLogoImgItem) {
        
        __weak typeof(self) ws = self;
        
        _shopLogoImgItem = [[TDFCardBgImageItem alloc]init];
        
        _shopLogoImgItem.imageContentMode = UIViewContentModeScaleAspectFit;
        
        _shopLogoImgItem.title = @"店家Logo";
        
        _shopLogoImgItem.showDelButton = YES;
        
        _shopLogoImgItem.isRequired = NO;
        
        _shopLogoImgItem.hideRightArr = YES;
        
        _shopLogoImgItem.detail = @"注：此图片会展示在火小二应用以及微信菜单上，作为店家图标，不上传则不显示";
        
        TDFCardBgImageBaseItem *addItem = [[TDFCardBgImageBaseItem alloc] init];
        
        _shopLogoImgItem.cardImageItems = @[addItem];
        
        _shopLogoImgItem.filterBlock = ^(NSInteger idx,TDFFilterType filterType){
            
            ws.takePhotoType = TAKEPHOTO_TYPE_SHOP_LOGO;
            
            if (filterType == TDFFilterTypeAdd) {
                
                if (((TDFCardBgImageBaseItem *)ws.shopLogoImgItem.cardImageItems[idx]).cardImagePath) {
                    
                    return ;
                }
                
                [ws takePhotoWithType];
                
            }else {
                
                [ws showMessageWithTitle:@"提示" message:@"您确认要删除当前的图片吗" cancelBlock:^{
                    
                } enterBlock:^{
                    
                    [ws removeImgAtIndex:idx];
                }];
            }
        };
    }
    return _shopLogoImgItem;
}
    
- (TDFShopImgStaticItem *)imgStaticItem {

    if (!_imgStaticItem) {
        
        _imgStaticItem = [[TDFShopImgStaticItem alloc]init];
        __weak typeof(self) ws = self;
        _imgStaticItem.commitBlock = ^{
            
            [ws commit];
        };
    }
    return _imgStaticItem;
}

- (TDFShopHeader *)header {
    
    if (!_header) {
        
        _header = [[TDFShopHeader alloc]init];
    }
    return _header;
}

- (KabawService *)service {
    
    if (!_service) {
        
        _service = [KabawService new];
    }
    return _service;
}

- (NSMutableArray *)tagLists {
    
    if (!_tagLists) {
        
        _tagLists = [NSMutableArray new];
    }
    return _tagLists;
}

- (NSMutableArray<ShopTag *> *)tagListsNew {
    
    if (!_tagListsNew) {
        
        _tagListsNew = [NSMutableArray new];
    }
    return _tagListsNew;
}

#pragma mark - Multi Image Select (this part contains this controller all functions with images)

- (void)takePhotoWithType {
    
    if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_DOOR) {
        
        [self takePhotoWithCameraOrLocal:YES];
        
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil),NSLocalizedString(@"拍照", nil), nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self takePhotoWithCameraOrLocal:YES];
        
    }else if(buttonIndex == 0){
        
        [self takePhotoWithCameraOrLocal:NO];
    }
}

- (void)takePhotoWithCameraOrLocal:(BOOL )isCamera {
    
    if (isCamera==1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:NSLocalizedString(@"相机好像不能用哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:NSLocalizedString(@"相册好像不能访问哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    
}

// 照片取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 照片选择结束回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *fixedImage = [image fixOrientation];
        
        [self uploadImg:fixedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImg:(UIImage *)img {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    self.imgFilePathTemp = [NSString stringWithFormat:@"%@/shopimg/%@.png", entityId, [NSString getUniqueStrByUUID]];
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
    //    [UIHelper showHUD:NSLocalizedString(@"正在上传", nil) andView:self.view andHUD:hud];
    [[SystemService new] uploadImage:self.imgFilePathTemp image:img width:1280 heigth:1280 Target:self Callback:@selector(uploadImgFinsh:)];
}

- (void)uploadImgFinsh:(RemoteResult *)result
{
    [self.progressHud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    ShopImg *img = [[ShopImg alloc]init];
    img.path = self.imgFilePathTemp;
    img.entityId = [[Platform Instance] getkey:ENTITY_ID];
    img.server = [[NSURL URLWithString:kTDFImageFilePath] host];
    
    [self dealWithNewImg:img];
}

- (void)dealWithNewImg:(ShopImg *)img {

    if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_PHOTO) {
        
        img.type = 0;
        
    }else if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_DOOR) {
    
        img.type = 2;
        
        [self.locationM startUpdatingLocation];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            
            
            [self showMessageWithTitle:@"提示" message:@"定位功能不可用,将导致审核失败" cancelTitle:@"我知道了"];
        }
    }else if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_LOGO) {
    
        img.type = 3;
    }
    
    [self.imgArr addObject:img];
    
    [self configAllImg];
    
    [self.manager reloadData];
}


- (void)removeImgAtIndex:(NSInteger )index {
    
    if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_PHOTO) {
        
        ShopImg *image = self.shopImgArr[index];
        [self.imgArr removeObject:image];
        
    }else if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_DOOR) {
        
        [self.imgArr removeObject:self.shopDoorImg];
        
    }else if (self.takePhotoType == TAKEPHOTO_TYPE_SHOP_LOGO) {
        
        [self.imgArr removeObject:self.shopLogoImg];
    }
    
    [self loadShopImg];
    
    [self.manager reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
