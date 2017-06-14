//
//  ShopEditView.m
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "BackgroundHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ShopEditView.h"
#import "KabawService.h"
#import "MBProgressHUD.h"
#import "KabawModule.h"
#import "UIHelper.h"
#import "SystemEvent.h"
#import "EventConstants.h"
#import "EditImageBox.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "KabawModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "EditMultiList.h"
#import "EditItemMemo.h"
#import "ItemTitle.h"
#import "EditMultiList.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "SystemService.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "RatioPickerBox.h"
#import "ObjectUtil.h"
#import "SystemUtil.h"
#import "ShopDetail.h"
#import "DicSysItem.h"
#import "DicItemConstants.h"
#import "MultiCheckView.h"
#import "GlobalRender.h"
#import "Platform.h"
#import "RestConstants.h"
#import "FormatUtil.h"
#import "ShopTag.h"
#import "ShopImg.h"
#import "UIView+Sizes.h"
#import "MemoInputBox.h"
#import "BigImageCell.h"
#import "ImageUtils.h"
#import "ItemFactory.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import "HelpDialog.h"
#import "KeyBoardUtil.h"
#import "MapLocationView.h"
#import "ColorHelper.h"
#import "ShopRemoteShop.h"
#import "CountriesVO.h"
#import "ProvincesVo.h"
#import "CitiesVo.h"
#import "TownsVo.h"
#import "TDFLocationService.h"
#import "ShopReviewAlertController.h"
#import "ShopReviewCenter.h"
#import "MyMD5.h"
#import "ImageUtils.h"
#import "TDFTransService.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMediator+SupplyChain.h"
#import "UIViewController+Picker.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFKabawService.h"
#import "TDFMapLocationViewController.h"

@interface ShopEditView () <TDFLocationServiceDelegate,TDFMapLocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reviewStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTimeLabel;
@property (weak, nonatomic) IBOutlet EditImageBox *shopDoorImageBox;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopDoorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopBoxHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (nonatomic) CLLocationCoordinate2D doorLocation;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) ShopReviewInfo *reviewInfo;
@property (weak, nonatomic) IBOutlet UILabel *doorLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;


#pragma mark - Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianBusinessConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodStyleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *featureConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *townConstrains;
@property (weak, nonatomic) IBOutlet UILabel *doorImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *imgsWarnningLabel;
@property (nonatomic, getter=isInfoChanged) BOOL infoChanged;  // 是否已经修改过数据
@property (strong, nonatomic) NSMutableArray *towns;


//@property (strong)

@end

@implementation ShopEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp
{
    self = [super initWithNibName:@"ShopEditView" bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].kabawService;
        systemService = [ServiceFactory Instance].systemService;
//        hud = [[MBProgressHUD alloc] initWithView:self.view];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        self.publicImgs = [[NSMutableArray alloc]init];
        imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.changed = NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    self.lblLocation.textColor = [ColorHelper getBlueColor];
    self.shopAdressTf.delegate = self;
    self.lblNoSave.layer.cornerRadius = 2;
    self.lblNoSave1.layer.cornerRadius = 2;
    self.lblNoSave.backgroundColor = [UIColor redColor];
    self.lblNoSave1.backgroundColor = [UIColor redColor];
    [self.view insertSubview:self.backgroundImageView atIndex:0];
    [self loadDatas];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"店家资料", nil);
}

- (void)onNavigateEvent:(NSInteger)event
{
    //    if (event==DIRECT_LEFT) {
    //        if (self.backIndex==INDEX_PARENT_VIEW) {
    //            [parent showView:SECOND_MENU_VIEW];
    //        } else if (self.backIndex==INDEX_MAIN_VIEW) {
    //            [parent showView:SECOND_MENU_VIEW];
    //            [parent backToMain];
    //        }
    //    } else if (DIRECT_RIGHT) {
    //        [self commit];
    //    }
    if (event==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self commit];
    }
}
- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self commit];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container] || self.infoChanged];
}

- (void)initMainView
{
    [self.txtBusinessTime initLabel:NSLocalizedString(@"营业时间", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPhone initLabel:NSLocalizedString(@"联系电话", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.country initLabel:NSLocalizedString(@"• 国家或地域", nil) withHit:@"注：如需修改国家或地区，请联系在线客服。" isrequest:YES delegate:self];
    [self.province initLabel:NSLocalizedString(@"• 省", nil) withHit:nil isrequest:YES delegate:self];
    [self.city initLabel:NSLocalizedString(@"• 城市", nil) withHit:nil isrequest:YES delegate:self];
    [self.town initLabel:NSLocalizedString(@"• 区县", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsPerSpend initLabel:NSLocalizedString(@"人均消费", nil) withHit:nil delegate:self];
    [self.mlsFoodStyle initLabel:NSLocalizedString(@"餐饮菜系", nil) delegate:self];
    [self.mlsMainBusiness initLabel:NSLocalizedString(@"主营业务", nil) delegate:self];
    [self.mlsFeatureService initLabel:NSLocalizedString(@"特色服务", nil) delegate:self];
    [self.txtIntroduce initLabel:NSLocalizedString(@"店家简介", nil) isrequest:YES delegate:self];
    [self.boxPic initLabel:NSLocalizedString(@"店家图片", nil) delegate:self];
//    self.shopCodeTip.text = NSLocalizedString(@"二维码获取方式：\n\n1.打开微信公众平台后台，在公众号管理中心，找到并点击“公众号设置”；\n\n2.在账号详情页面，找到“二维码”，点击“下载更多尺寸”，建议下载边长为12cm的二维码；\n\n3.将下载的二维码通过QQ、微信网页版等方式从电脑传到手机上，然后在此处上传。\n\n4.上传的二维码将会在顾客微信点菜时展示出来，帮助店家微信公众号吸收粉丝。", nil);
//    [self.publicCodeBox initLabel:@"" delegate:self];
//    [self.publicCodeBox initImgList:nil];
    
    self.txtPhone.txtVal.keyboardType = UIKeyboardTypeNumberPad;
    
    UIColor *color = [UIColor colorWithRed:204.0 / 255 green:0 blue:0 alpha:1.0];
    self.shopAdressTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"必填", nil)
                                                                              attributes: @{
                                                                                            NSForegroundColorAttributeName: color
                                                                                            }];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    
    self.mlsFeatureService.tag = SHOP_FEATURESERVICE;
    self.mlsFoodStyle.tag = SHOP_FOODSTYLE;
    self.mlsMainBusiness.tag = SHOP_MAINBUSINESS;
    self.lsPerSpend.tag = SHOP_PERSPEND;
//    self.publicCodeBox.tag = SHOP_PUBLICCODE;
//    self.boxPic.tag = SHOP_PIC;
    self.city.tag = SHOP_CITY;
    self.province.tag = SHOP_PROVINCE;
    self.country.tag = SHOP_COUNTRY;
    self.town.tag = SHOP_TOWN;
    self.shopAdressTf.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
    [KeyBoardUtil initWithTarget:self.shopAdressTf];
    
//    OCTREE
    
    [self.shopDoorImageBox initLabel:@"" delegate:self];
    self.shopDoorImageBox.device = IMAGE_DEVICE_CAMERA;
    [self configViews];
    [self updateConstraints];
}

- (IBAction)valueChanged:(id)sender {
    
    self.infoChanged = YES;
    [self dataChange:nil];
}


#pragma mark - OCTREE BEGIN

-(BOOL)checkFormValid:(NSError * __autoreleasing *)error {
    
    NSString *msg;
    BOOL valid = YES;
    
    if ([self.txtBusinessTime getStrVal].length == 0) {
        
        msg = NSLocalizedString(@"营业时间不能为空", nil);
        valid = NO;
    } else if ([self.txtPhone getStrVal].length == 0) {
    
        valid = NO;
        msg = NSLocalizedString(@"联系电话不能为空", nil);
    } else if ([self.country.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
    
        valid = NO;
        msg = NSLocalizedString(@"国家地域不能为空", nil);
    } else if ([self.province.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
        
        valid = NO;
        msg = NSLocalizedString(@"省份不能为空", nil);
    } else if ([self.city.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
        
        valid = NO;
        msg = NSLocalizedString(@"城市不能为空", nil);
    } else if ([self.town.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)] && self.towns.count > 0) {
        
        valid = NO;
        msg = NSLocalizedString(@"区县不能为空", nil);
    } else if ([self.txtIntroduce getStrVal].length == 0) {
        
        valid = NO;
        msg = NSLocalizedString(@"店家简介不能为空", nil);
    } else if ([self.shopImgs count] == 0) {
    
        valid = NO;
        msg = NSLocalizedString(@"至少选择一张店家照片", nil);
    } else if (self.publicImgs.count == 0) {
    
        valid = NO;
        msg = NSLocalizedString(@"门头照不能为空", nil);
    } else if (self.shopAdressTf.text.length == 0) {
    
        valid = NO;
        msg = NSLocalizedString(@"顾客就餐地址不能为空", nil);
    } else if (self.reviewInfo.longitude == 0 || self.reviewInfo.latitude == 0) {
    
        valid = NO;
        msg = NSLocalizedString(@"请进行地址定位", nil);
    }
    
    if (msg) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.required"
                                    code:40001
                                userInfo:@{ NSLocalizedDescriptionKey : msg}];
    }
    return valid;
}

#pragma mark - Config View

- (void)configViews {

    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = 4;
}

#pragma mark - Action

- (IBAction)commitButtonTapped:(id)sender {
    
    [self commit];
}

- (void)commit {
    
    NSError *error = nil;
    BOOL valid = [self checkFormValid: &error];

    if (!valid) {
        
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:avc animated:YES completion:nil];
        return;
    }
    
    if (!self.isInfoChanged && ![UIHelper currChange:self.container]) {
    
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您未修改任何资料，请修改后再提交", nil)
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:avc animated:YES completion:nil];
        return;
    }
    
    [self fillReviewInfo];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [UIHelper showHUD:NSLocalizedString(@"正在提交", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: [self.reviewInfo yy_modelToJSONObject]];

    [service updateShopReviewInfoWithParam:@{ @"shop_audit":  [param yy_modelToJSONString]}
                                    target:self
                                    action:@selector(saveReviewInfoFinished:)];
}

- (void)saveReviewInfoFinished:(RemoteResult *)result {

    [self.progressHud hide: YES];
    if (!result.isSuccess) {
    
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:result.errorStr
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:avc animated:YES completion:nil];
        return;
    }
    
    self.infoChanged = NO;
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提交成功", nil)
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:avc animated:YES completion:nil];
    
    [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.reviewInfo.status = ShopReviewStateWaiting;
    self.lblNoSave.hidden = YES;
    self.lblNoSave1.hidden = YES;
    self.reviewInfo.createTime = (NSUInteger)[[NSDate date] timeIntervalSince1970];
    [[ShopReviewCenter sharedInstance] setReviewState: ShopReviewStateWaiting];
    [self updateViews];
    [self updateReviewStatusView];
}


#pragma mark Fill Model

- (void)fillReviewInfo {

    ShopDetail *detail = [self transMode];
    ShopRemoteShop *remote = [self transMode1];
    
//    self.reviewInfo.name = detail.name;
    self.reviewInfo.phone = detail.phone2;
    self.reviewInfo.memo = detail.memo;
    self.reviewInfo.introduce = detail.introduce;
    self.reviewInfo.businessTime = detail.businessTime;
    self.reviewInfo.countryId = remote.contryId;
    self.reviewInfo.countryName = remote.contryName;
    self.reviewInfo.provinceId = remote.provinceId;
    self.reviewInfo.provinceName = remote.provinceName;
    self.reviewInfo.cityId = remote.cityId;
    self.reviewInfo.cityName = remote.cityName;
    self.reviewInfo.townId = remote.townId;
    self.reviewInfo.townName = remote.townName;
    
    self.reviewInfo.address = detail.address;
    self.reviewInfo.mapAddress = detail.mapAddress;
    self.reviewInfo.avgPrice = detail.avgPrice;
    
    NSMutableArray *imgs = [NSMutableArray array];
    
    for (ShopImg *img in self.shopImgs) {
        
        [imgs addObject: [img yy_modelToJSONObject]];
    }
    
    ShopImg *img = [self.publicImgs firstObject];
    if (img) {
    
        [imgs addObject: [img yy_modelToJSONObject]];
    }
    
    self.doorImageLabel.hidden = self.publicImgs.count != 0;
    NSArray *businessTags = [self.mlsMainBusiness getCurrList];
    NSArray *foodTags = [self.mlsFoodStyle getCurrList];
    NSArray *specialTags = [self.mlsFeatureService getCurrList];
    NSMutableArray *tags = [NSMutableArray array];
    for (ShopTag *tag in businessTags) {
        
        [tags addObject: [tag yy_modelToJSONObject]];
    }
    
    for (ShopTag *tag in foodTags) {
        
        [tags addObject: [tag yy_modelToJSONObject]];
    }
    
    for (ShopTag *tag in specialTags) {
        
        [tags addObject: [tag yy_modelToJSONObject]];
    }
    
    self.reviewInfo.tagLists = tags;
    self.reviewInfo.imgLists = imgs;
    self.reviewInfo.specialTag = detail.specialTag;
}

#pragma mark - Load Data

- (void)loadShopReviewInfo {

    [service loadShopReviewInfoWithTarget:self action:@selector(shopReviewInfoLoaded:)];
}

- (void)shopReviewInfoLoaded:(RemoteResult *)result {
    
//    NSLog(@"%@", result.content);
    
    if (!result.isSuccess) {
    
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:result.errorStr
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:avc animated:YES completion:nil];
        [self updateViews];
        return;
    }

    NSData *data = [result.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
    self.reviewInfo = [ShopReviewInfo yy_modelWithDictionary: dic[@"data"][@"shop"]];
    
    if (self.reviewInfo.cityId.length > 0) {

       [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
        [[TDFKabawService new] getTownsList:self.reviewInfo.cityId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud setHidden:YES];
            [self parseTownList:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
    
    [self updateViews];
    self.infoChanged = NO;
}

- (void)updateViews {

    NSArray *taglist = self.reviewInfo.tagLists;
    self.shopTags = [JsonHelper transList:taglist objName:@"ShopTag"];
    
    [self.publicImgs removeAllObjects];
    NSDictionary *imgDict = [self.reviewInfo doorImageDictionary];
    if ([ObjectUtil isNotEmpty:imgDict]) {
        ShopImg *imgData= [JsonHelper dicTransObj:imgDict obj:[NSClassFromString(@"ShopImg") new]];
        
        [self.publicImgs addObject:imgData];
    }
    
    self.countryNo = self.reviewInfo.countryId;
    self.provinceNo = self.reviewInfo.provinceId;
    self.cityNo = self.reviewInfo.cityId;
    self.townNo = self.reviewInfo.townId;
    
    if (self.reviewInfo == nil) {
        [self clearDo];
    } else {
        [self fillModel];
    }
    [self updateDoorLocationLabel];
    
    [ShopReviewCenter sharedInstance].reviewState = self.reviewInfo.status;
    [self.shopDoorImageBox initImgObject:self.publicImgs];
    self.doorImageLabel.hidden = self.publicImgs.count != 0;
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [self  updateConstraints];
}

#pragma mark - Delegate

#pragma mark EditImageBox

- (void)editImageBoxWillTakePhoto:(EditImageBox *)box {

    if (box == self.shopDoorImageBox) {
    
        TDFLocationService *locationService = [TDFLocationService sharedInstance];
        locationService.delegate = self;
        [locationService triggerLocationService];
    }
}

#pragma mark TDFLocationServiceDelegate

- (void)locationService:(TDFLocationService *)locationService didUpdateLocation:(CLLocation *)location {

    self.doorLocation = location.coordinate;
    [locationService stopLocationService];
//    self.doorLocationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"纬度：%.6f 精度%.6f", nil), location.coordinate.latitude,
//                                   location.coordinate.longitude];
}

#pragma mark - Update Constrains

- (void)updateConstraints {
    
    self.shopDoorHeightConstraint.constant = self.shopDoorImageBox.frame.size.height;
    self.shopBoxHeightConstraint.constant = self.boxPic.frame.size.height;
    self.memoHeightConstraint.constant = self.txtIntroduce.frame.size.height;
    
    self.mianBusinessConstriant.constant = self.mlsMainBusiness.frame.size.height;
    self.foodStyleConstraint.constant = self.mlsFoodStyle.frame.size.height;
    self.featureConstraint.constant = self.mlsFeatureService.frame.size.height;
    
    self.statusHeightConstraint.constant = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 10;
    CGSize size = self.scrollView.contentSize;
    size.height = self.buttonContainerView.frame.origin.y + self.buttonContainerView.frame.size.height + 20;
    self.scrollView.contentSize = size;
    self.containerHeightConstraint.constant = size.height;
}


#pragma mark - Accessor 

- (UIImageView *)backgroundImageView {

    if (!_backgroundImageView) {
    
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundImageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    }
    return _backgroundImageView;
}
#pragma mark - OCTREE END



#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ShopDetailEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ShopDetailEditView_Change object:nil];
}




#pragma remote
- (void)loadDatas
{
    self.lblNoSave.hidden = YES;
    self.lblNoSave1.hidden = YES;
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [self loadShopReviewInfo];
    
//    [service loadShopDetailTarget:self Callback:@selector(loadFinsh:)  shopCode:shopCode];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnulltask, id _Nonnull data) {
        [self.progressHud hide: YES];
        NSDictionary* map   = data [@"data"];
        NSDictionary *shopDic = [map objectForKey:@"shopDetailVo"];
        self.shopDetail = [JsonHelper dicTransObj:shopDic obj:[ShopDetail alloc]];
        
        NSDictionary *shopRemoteDic = [map objectForKey:@"remoteShopVo"];
        self.shopRemote=[ShopRemoteShop convertShopRemote:shopRemoteDic];
        
        NSArray *list = [map objectForKey:@"shopImgVos"];
        
        self.shopImgs = [JsonHelper transList:list objName:@"ShopImg"];
        
        list = [map objectForKey:@"countries"];
        self.countriesVO=[CountriesVO convertToCountriesArr:list];
        self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
        [self.boxPic initImgList:self.shopImgs];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide: YES];
        [AlertBox show:error.localizedDescription];
        self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
        [self.boxPic initImgList:self.shopImgs];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
    }];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] || self.isInfoChanged act:ACTION_CONSTANTS_EDIT];
//     = [UIHelper currChange:self.container];
}

- (void)uploadImgFinsh:(RemoteResult *)result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.infoChanged = YES;
    if (self.currentImageBox == self.boxPic) {
        [self showProgressHudWithText:NSLocalizedString(@"正在保存图片", nil)];
//        [UIHelper showHUD:NSLocalizedString(@"正在保存图片", nil) andView:self.view andHUD:hud];
//        [service saveShopImgs:imgFilePathTemp Target:self callback:@selector(saveImgsFinish:)];
        [[TDFKabawService new] saveShopImgs:imgFilePathTemp sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud setHidden:YES];
            [self saveShopImg];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];

    } else if (self.currentImageBox == self.shopDoorImageBox){
    
        if ([ObjectUtil isNotEmpty:result.param]) {
            ShopImg *imgData= [JsonHelper dicTransObj:result.param obj:[NSClassFromString(@"ShopImg") new]];
            
            NSString *unique = [NSString stringWithFormat:@"%@%f", [NSUUID UUID].UUIDString, [[NSDate date] timeIntervalSince1970]];
            unique = [MyMD5 md5: unique];
            imgData.attachmentId = unique;
            imgData._id = unique;
            imgData.entityId = self.reviewInfo.entityId;
            imgData.type = ShopImgTypeDoorImage;
            
            [self.publicImgs addObject:imgData];
            self.reviewInfo.logoLatitude = self.doorLocation.latitude;
            self.reviewInfo.logoLongitude = self.doorLocation.longitude;
            [self updateDoorLocationLabel];
        }
        self.doorImageLabel.hidden = self.publicImgs.count != 0;
        [self.currentImageBox initImgObject: self.publicImgs];
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
    }

} 

- (void)saveImgsFinish:(RemoteResult *) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self fillPicWithAgainLoginInfo:data];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
        
        if(self.lblNoSave.hidden == NO || self.lblNoSave1.hidden == NO)
        {
            [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
   // [service loadShopDetailImageTarget:self Callback:@selector(loadImageFinsh:)  shopCode:shopCode];
}

- (void)saveShopImg
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    //    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud setHidden:YES];
        self.infoChanged  = NO;
        [self fillPicWithAgainLoginInfo:data];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
        
        if(self.lblNoSave.hidden == NO || self.lblNoSave1.hidden == NO)
        {
            [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadImageFinsh:(RemoteResult *) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    if (self.currentImageBox==self.boxPic) {
      
        NSDictionary* map = [JsonHelper transMap:result.content];
        NSArray *list = [map objectForKey:@"shopImgVos"];
        self.shopImgs = [JsonHelper transList:list objName:@"ShopImg"];
        [self.currentImageBox initImgList:self.shopImgs];
        self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
    }
    
    /*else if (self.currentImageBox==self.shopDoorImageBox) {
        [self.publicImgs removeAllObjects];
        NSDictionary* map = [JsonHelper transMap:result.content];
        NSDictionary * wxDict = [map objectForKey:@"wxQrCodeImg"];
        if ([ObjectUtil isNotEmpty:wxDict]) {
            ShopImg *imgData= [JsonHelper dicTransObj:wxDict obj:[NSClassFromString(@"ShopImg") new]];
            [self.publicImgs addObject:imgData];
        }
        [self.currentImageBox initImgObject:self.publicImgs];
    }*/
    
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
    
    if(self.lblNoSave.hidden == NO || self.lblNoSave1.hidden == NO)
    {
        [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }
}

- (void)loadFinsh:(RemoteResult *) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
        [self.boxPic initImgList:self.shopImgs];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
        return;
    }
    NSDictionary* map = [JsonHelper transMap:result.content];
    
    NSDictionary *shopDic = [map objectForKey:@"shopDetail"];
    self.shopDetail = [JsonHelper dicTransObj:shopDic obj:[ShopDetail alloc]];
    
    NSDictionary *shopRemoteDic = [map objectForKey:@"remoteShop"];
    self.shopRemote=[ShopRemoteShop convertShopRemote:shopRemoteDic];

    NSArray *list = [map objectForKey:@"shopImgs"];
    
    self.shopImgs = [JsonHelper transList:list objName:@"ShopImg"];
    
    list = [map objectForKey:@"contries"];
    self.countriesVO=[CountriesVO convertToCountriesArr:list];
    self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
    [self.boxPic initImgList:self.shopImgs];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
}

- (void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
       [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)loadSysFinsh:(id ) data
{
    NSArray *list = [data objectForKey:@"data"];
    self.allTags = [JsonHelper transList:list objName:@"DicSysItem"];
    
    if ([self.codeTag isEqualToString:PER_SPEND]) {
        
//        [OptionPickerBox initData:self.allTags itemId:self.perTag];
//        [OptionPickerBox show:self.titleName client:self event:self.currShopTag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.titleName
                                                                                      options:self.allTags
                                                                                currentItemId:self.perTag];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
        
            [wself pickOption:self.allTags[index] event:self.currShopTag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:self.currShopTag delegate:self title:self.titleName dataTemps:self.allTags selectList:self.currTags needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
//        [parent showView:MULTI_CHECK_VIEW];
//        [parent.multiCheckView initDelegate:self.currShopTag delegate:self title:self.titleName];
//        [parent.multiCheckView reload:self.allTags selectList:self.currTags];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
}





- (void)showItemList:(EditItemList *)obj array:(NSMutableArray *)array;
{
//    [OptionPickerBox initData:array itemId:[obj getStrVal]];
    if (obj.tag == SHOP_COUNTRY || obj.tag == SHOP_PROVINCE || obj.tag == SHOP_CITY || obj.tag == SHOP_TOWN) {
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:array
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:array[index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtBusinessTime initData:nil];
    [self.txtPhone initData:nil];
    
    [self.lsPerSpend initData:nil withVal:nil];
    [self.mlsFoodStyle initData:nil];
    [self.mlsMainBusiness initData:nil];
    [self.mlsFeatureService initData:nil];
    
    [self.txtIntroduce initData:nil];
    [self.country initData:NSLocalizedString(@"中国", nil) withVal:@"001"];
    [self.province initData:@"" withVal:@""];
    [self.city initData:@"" withVal:@""];
    [self.town initData:@"" withVal:@""];
    self.shopAdressTf.text = @"";
    self.lblLocation.text = @"";
}

- (void)updateDoorLocationLabel {

    if (self.reviewInfo.logoLatitude != 0 && self.reviewInfo.logoLongitude != 0) {
        
        self.doorLocationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"纬度：%.6f 经度：%.6f", nil),
                                       self.reviewInfo.logoLatitude, self.reviewInfo.logoLongitude];
    } else {
        
        self.doorLocationLabel.text = @"";
    }
}

- (void)fillModel
{
    [self.txtBusinessTime initData:self.reviewInfo.businessTime];
    [self.txtPhone initData:self.reviewInfo.phone];
    self.shopAdressTf.text = self.reviewInfo.address;
    [self.txtIntroduce initData:self.reviewInfo.introduce];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.shopRemote.longtitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:self.shopRemote.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:self.shopDetail.mapAddress forKey:@"mapAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.reviewInfo.countryId isEqualToString:@""]) {
        
        self.reviewInfo.countryId = @"001";
    }
    
    if( self.reviewInfo.longitude == 0 && self.reviewInfo.latitude == 0)
    {
        self.lblLocation.text = NSLocalizedString(@"点击进行地址定位（必填）", nil);
        self.lblLocation.textColor = [ColorHelper getRedColor];
    } else {
        self.lblLocation.text = [NSString stringWithFormat:NSLocalizedString(@"经度:%f,纬度:%f", nil),self.reviewInfo.longitude,self.reviewInfo.latitude];
        self.lblLocation.textColor = [ColorHelper getBlueColor];
    }
    [self.country initData:self.reviewInfo.countryName withVal:self.reviewInfo.countryId];
    if(self.reviewInfo.countryName.length > 0){
        self.country.unEnditable = YES;
    }else {
        self.country.unEnditable = NO;
    }
    [self.province initData:self.reviewInfo.provinceName withVal:self.reviewInfo.provinceId];
    [self.city initData:self.reviewInfo.cityName withVal:self.reviewInfo.cityId];
    [self.town initData:self.reviewInfo.townName withVal:self.reviewInfo.townId];
    
    NSMutableArray* perSpends = [self filterShopTag:PER_SPEND];
    if ([ObjectUtil isNotEmpty:perSpends]) {
        ShopTag* shopTag = [perSpends firstObject];
        [self.lsPerSpend initData:shopTag.name withVal:shopTag._id];
    } else {
        [self.lsPerSpend initData:nil withVal:nil];
    }
    
    [self updateDoorLocationLabel];
    
    [self.mlsFoodStyle initData:[self filterShopTag:FOOD_STYLE]];
    [self.mlsMainBusiness initData:[self filterShopTag:MAIN_BUSINESS]];
    [self.mlsFeatureService initData:[self filterShopTag:FEATURE_SERVICE]];
    [self.lsPerSpend initData:self.reviewInfo.avgPrice withVal:self.reviewInfo.avgPrice];
    
    [self updateReviewStatusView];
}

- (void)updateReviewStatusView {

    self.reviewTimeLabel.textColor = [self textColorForShopState: self.reviewInfo.status];
    self.reviewStatusLabel.textColor = self.reviewTimeLabel.textColor;
    self.reviewStatusLabel.text = self.reviewInfo.statusTitle;
    self.reviewTimeLabel.text = self.reviewInfo.statusDetail;
    
    BOOL userInteractionEnabled = self.reviewInfo.status != ShopReviewStateWaiting;
    
    for (UIView *view in self.container.subviews) {
        
        if (view != self.buttonContainer) {
        
            view.userInteractionEnabled = userInteractionEnabled;
        }
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
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

- (NSMutableArray *)filterShopTag:(NSString *)code
{
    NSMutableArray *tags = [NSMutableArray array];
    if (self.shopTags!=nil && self.shopTags.count>0 ) {
        for (ShopTag *tag in self.shopTags) {
            if ([tag.code isEqualToString:code]) {
                [tags addObject:tag];
            }
        }
    }
    return tags;
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList *)obj
{
    self.obj = obj;
    [SystemUtil hideKeyboard];
    if (obj.tag==SHOP_PERSPEND) {
        self.titleName = NSLocalizedString(@"人均消费", nil);
        self.codeTag = PER_SPEND;
        self.perTag = [obj getStrVal];
        self.currShopTag = obj.tag;

        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
     //   [systemService listDicSysItems:self.codeTag Target:self Callback:@selector(loadSysFinsh:)];
         [[TDFTransService new]  listDicSysItems:self.codeTag success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
             [self.progressHud setHidden: YES];
             [self loadSysFinsh:data];
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud setHidden:YES];
             [AlertBox show:error.localizedDescription];
         }];
        
    } else if (_obj.tag == SHOP_PROVINCE) {
        if ([self.country.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
            [AlertBox show:NSLocalizedString(@"国家/地域不能为空", nil)];
        } else {
            //请求省
           [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            [[TDFKabawService new] getProvincesList:self.countryNo sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self.progressHud setHidden:YES];
                NSArray *list = [data objectForKey:@"data"];
                self.provinceVO=[ProvincesVo convertToProvincesArr:list];
                NSMutableArray *provincesArr = [[NSMutableArray alloc] init];
                if ([ObjectUtil isNotEmpty:self.provinceVO]) {
                    for (ProvincesVo *province in self.provinceVO) {
                        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:province.provinceName andId:province.provinceId];
                        [provincesArr addObject:nameItem];
                    }
                }
                [self showItemList:self.obj array:provincesArr];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    } else if (_obj.tag == SHOP_CITY) {
        if ([self.province.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
            [AlertBox show:NSLocalizedString(@"省份不能为空", nil)];
        } else {
            //请求城市
           [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//            [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
            [[TDFKabawService new] getCitiesList:self.provinceNo sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self.progressHud setHidden:YES];
                NSArray *list = [data objectForKey:@"data"];
                self.cityVO=[CitiesVo convertToCityArr:list];
                NSMutableArray *citiesArr = [[NSMutableArray alloc] init];
                if ([ObjectUtil isNotEmpty:self.cityVO]) {
                    for (CitiesVo *city in self.cityVO) {
                        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:city.cityName andId:city.cityId];
                        [citiesArr addObject:nameItem];
                    }
                }
                [self showItemList:self.obj array:citiesArr];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    } else if (_obj.tag == SHOP_TOWN) {
        if ([self.city.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
            [AlertBox show:NSLocalizedString(@"城市不能为空", nil)];
        } else {
            //请求区县
            [self showItemList:self.obj array:self.towns];
        }
    } else if (_obj.tag == SHOP_COUNTRY) {
        NSMutableArray *countriesArr = [[NSMutableArray alloc]init];
        if ([ObjectUtil isNotEmpty:self.countriesVO]) {
            for (CountriesVO *country in self.countriesVO) {
                NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:country.contryName andId:country.contryId];
                [countriesArr addObject:nameItem];
            }
        } else {
            NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:self.shopRemote.contryName andId:self.shopRemote.contryId];
            self.countryNo = self.shopRemote.contryId;
            [countriesArr addObject:nameItem];
        }
        [self showItemList:self.obj array:countriesArr];
    }
}

//多选List控件变换.
- (void)onMultiItemListClick:(EditMultiList *)obj
{
    if (obj.tag==SHOP_MAINBUSINESS) {
        self.titleName=NSLocalizedString(@"主营业务", nil);
        self.codeTag=MAIN_BUSINESS;
    } else if (obj.tag==SHOP_FOODSTYLE) {
        self.titleName=NSLocalizedString(@"餐饮菜系", nil);
        self.codeTag=FOOD_STYLE;
    } else if (obj.tag==SHOP_FEATURESERVICE) {
        self.titleName=NSLocalizedString(@"特色服务", nil);
        self.codeTag=FEATURE_SERVICE;
    }
    self.currShopTag = obj.tag;
    self.currTags = [obj getCurrList];
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFTransService new]  listDicSysItems:self.codeTag success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  hide: YES];
        [self loadSysFinsh:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show: error.localizedDescription];
    }];

}

//Demo控件.
- (void)onItemMemoListClick:(EditItemMemo *)obj
{
    [MemoInputBox show:1 delegate:self title:NSLocalizedString(@"店家简介", nil) val:[self.txtIntroduce getStrVal]];
}

#pragma 多选页结果处理.
- (void)multiCheck:(NSInteger)event items:(NSMutableArray *) items
{
    NSString *code=nil;
    NSMutableArray *list=nil;
    if (event==SHOP_MAINBUSINESS) {
        code=MAIN_BUSINESS;
        list=[self convertTags:items code:code];
        [self.mlsMainBusiness changeData:list];
    } else if (event==SHOP_FOODSTYLE) {
        code=FOOD_STYLE;
        list=[self convertTags:items code:code];
        [self.mlsFoodStyle changeData:list];
    } else if (event==SHOP_FEATURESERVICE) {
        code=FEATURE_SERVICE;
        list=[self convertTags:items code:code];
       [self.mlsFeatureService changeData:list];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
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

- (void)closeMultiView:(NSInteger)event
{
//    [parent showView:SHOP_EDIT_VIEW];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO *vo=(NameItemVO *)item;
    if (event==SHOP_PERSPEND) {
        [self.lsPerSpend changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    if (event == SHOP_COUNTRY) {
        [self.country changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ([NSString isNotBlank:self.countryNo]) {
            if (![self.countryNo isEqualToString:[vo obtainItemId]]) {
                [self.province initData:@"" withVal:@""];
                [self.city initData:@"" withVal:@""];
                [self.town initData:@"" withVal:@""];
            }
        }
        self.countryNo = [vo obtainItemId];
    }
    
    if (event == SHOP_PROVINCE) {
        [self.province changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ([NSString isNotBlank:self.provinceNo]) {
            if (![self.provinceNo isEqualToString:[vo obtainItemId]]) {
                [self.city initData:@"" withVal:@""];
                [self.town initData:@"" withVal:@""];
            }
        }
        self.provinceNo = [vo obtainItemId];
    }
    
    if (event == SHOP_CITY) {
        [self.city changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ([NSString isNotBlank:self.cityNo]) {
            if (![self.cityNo isEqualToString:[vo obtainItemId]]) {
                [self.town initData:@"" withVal:@""];
                [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//                [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
                self.towns = [NSMutableArray array];
            }
        }
        self.cityNo = [vo obtainItemId];
      //  [service getTownsList:self.cityNo Target:self callback:@selector(loadTownsFinish:)];
        [[TDFKabawService new] getTownsList:self.cityNo sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud setHidden:YES];
            [self parseTownList:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
    if (event == SHOP_TOWN) {
        
        [self.town changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        self.townNo = [vo obtainItemId];
    }

//    [UIHelper refreshUI:self.container scrollview:self.scrollView];
//    [self updateConstraints];
    return YES;
}

- (void)parseTownList:(id) data
{
    NSArray *list = [data objectForKey:@"data"];
    self.townVO = [TownsVo convertToTownArr:list];
    NSMutableArray *townsArr = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:self.townVO]) {
        for (TownsVo *town in self.townVO) {
            NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:town.townName andId:town.townId];
            [townsArr addObject:nameItem];
        }
    }
    self.towns = townsArr;
    self.townConstrains.constant = self.towns.count == 0 ? 0 : 48;
    self.town.hidden = self.towns.count == 0;
    [self updateConstraints];
}


- (void)startRemoveImage:(id<IImageData>)imageData target:(EditImageBox *)targat
{
    self.currentImageBox = targat;
    if (targat == self.boxPic) {
    
        [self showProgressHudWithText:NSLocalizedString(@"正在删除图片，请稍候", nil)];
//        [UIHelper showHUD:NSLocalizedString(@"正在删除图片，请稍候", nil) andView:self.view andHUD:hud];
        ShopImg *image = (ShopImg *)imageData;
        NSMutableArray *array = [NSMutableArray arrayWithObject:image._id];
//        [service  removeShopImgs:array Target:self Callback:@selector(removeFinish:)];
        [[TDFKabawService new] removeShopImgs:array sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud setHidden:YES];
            [self adginLoginShopInfo];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else if (targat == self.shopDoorImageBox) {
    
        [self.publicImgs removeAllObjects];
        [self.shopDoorImageBox initImgList: @[]];
        self.reviewInfo.logoLatitude = 0;
        self.reviewInfo.logoLongitude = 0;
        self.doorImageLabel.hidden = NO;
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        [self updateDoorLocationLabel];
    }
    
}


- (void)adginLoginShopInfo
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide: YES];
        [self fillPicWithAgainLoginInfo:data];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self updateConstraints];
        if(self.lblNoSave.hidden == NO || self.lblNoSave1.hidden == NO)
        {
            [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)fillPicWithAgainLoginInfo:(id)data
{
    if (self.currentImageBox==self.boxPic) {
        
        NSDictionary* map =  data [@"data"];
        NSArray *list = [map objectForKey:@"shopImgVos"];
        self.shopImgs = [JsonHelper transList:list objName:@"ShopImg"];
        [self.currentImageBox initImgList:self.shopImgs];
        self.imgsWarnningLabel.hidden = self.shopImgs.count > 0;
    }
    
}

- (void)startUploadImage:(UIImage *)imageData target:(EditImageBox *)targat
{
    //添加到集合中
    shopImage = imageData;
    self.currentImageBox = targat;
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    imgFilePathTemp = [NSString stringWithFormat:@"%@/shopimg/%@.png", entityId, [NSString getUniqueStrByUUID]];
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
//    [UIHelper showHUD:NSLocalizedString(@"正在上传", nil) andView:self.view andHUD:hud];
    [systemService uploadImage:imgFilePathTemp image:shopImage width:1280 heigth:1280 Target:self Callback:@selector(uploadImgFinsh:)];
}

//完成Memo输入.
-(void) finishInput:(NSInteger)event content:(NSString*)content
{
    [self.txtIntroduce changeData:content];
     [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
}

#pragma save-data

-(ShopDetail *) transMode
{
    ShopDetail* tempUpdate=[ShopDetail new];
    tempUpdate._id=self.shopDetail._id;
    tempUpdate.name=self.shopDetail.name;
    tempUpdate.zipCode=self.shopDetail.zipCode;
    tempUpdate.linkman=self.shopDetail.linkman;
    tempUpdate.entityId=self.shopDetail.entityId;
    tempUpdate.memo=self.shopDetail.memo;
    tempUpdate.address = self.shopAdressTf.text;
    tempUpdate.mapAddress=self.shopDetail.mapAddress;
    if ([NSString isNotBlank:[self.txtPhone getStrVal]]) {
        tempUpdate.phone2=[self.txtPhone getStrVal];
    }
    if ([NSString isNotBlank:[self.txtIntroduce getStrVal]]) {
        tempUpdate.introduce=[self.txtIntroduce getStrVal];
    }
    if ([NSString isNotBlank:[self.txtBusinessTime getStrVal]]) {
        tempUpdate.businessTime = [self.txtBusinessTime getStrVal];
    }
    NSString* tagStr=nil;
    NSMutableArray* tags=[NSMutableArray array];
    if ([NSString isNotBlank:[self.lsPerSpend getStrVal]]) {
        tagStr=[self tagToStr:PER_SPEND dicId:[self.lsPerSpend getStrVal] label:self.lsPerSpend.lblVal.text];
        [tags addObject:tagStr];
        tempUpdate.avgPrice=self.lsPerSpend.lblVal.text;
    }
    NSMutableArray* tempList=[self convertObj:[self.mlsMainBusiness getCurrList]];
    [tags addObjectsFromArray:tempList];
    
    tempList=[self convertObj:[self.mlsFoodStyle getCurrList]];
    [tags addObjectsFromArray:tempList];
    
    tempList=[self convertObj:[self.mlsFeatureService getCurrList]];
    [tags addObjectsFromArray:tempList];
    
    NSMutableString* businessStr=[self convertStr:[self.mlsMainBusiness getCurrList]];
    NSMutableString* foodStr=[self convertStr:[self.mlsFoodStyle getCurrList]];
    NSMutableString* featureStr=[self convertStr:[self.mlsFeatureService getCurrList]];
    
    NSMutableString* result=[NSMutableString string];
    if (businessStr!=nil && businessStr.length>0) {
        [result appendString:businessStr];
    }
    if (foodStr!=nil && foodStr.length>0) {
        if (result.length>0) {
            [result appendString:@","];
        }
        
        [result appendString:foodStr];
    }
    
    if (featureStr!=nil && featureStr.length>0) {
        if (result.length>0) {
            [result appendString:@","];
        }
        [result appendString:featureStr];
    }
    tempUpdate.specialTag = result;
    tempUpdate.tags=tags;
    return tempUpdate;
}
-(ShopRemoteShop *) transMode1
{
    ShopRemoteShop* tempUpdate=[ShopRemoteShop new];
    if ([NSString isNotBlank:[self.country getStrVal]]) {
        tempUpdate.contryName = [self.country lblVal].text;
        tempUpdate.contryId = self.countryNo;
    }
    if ([NSString isNotBlank:[self.province getStrVal]]) {
        tempUpdate.provinceName=[self.province lblVal].text;
        tempUpdate.provinceId = self.provinceNo;
    }
    if ([NSString isNotBlank:[self.city getStrVal]]) {
        tempUpdate.cityName=[self.city lblVal].text;
        tempUpdate.cityId = self.cityNo;
    }
    if ([NSString isNotBlank:[self.town getStrVal]]) {
        tempUpdate.townName=[self.town lblVal].text;
        tempUpdate.townId = self.townNo;
    }
    tempUpdate.shopCode=[[Platform Instance] getkey:SHOP_CODE];
    tempUpdate.isAuto = self.shopRemote.isAuto;
    tempUpdate.longtitude = self.shopRemote.longtitude;
    tempUpdate.latitude =self.shopRemote.latitude;
    tempUpdate.mapPoint = [NSString stringWithFormat:NSLocalizedString(@"经度:%@,纬度:%@", nil),self.shopRemote.longtitude,self.shopRemote.latitude];
    return tempUpdate;
}

-(NSMutableString*) convertStr:(NSMutableArray*)oldList
{
    NSMutableString* tags=[NSMutableString string];
    if(oldList!=nil && oldList.count>0){
        for (ShopTag* tag in oldList) {
            if (tags.length>0) {
                [tags appendString:@","];
            }
            [tags appendString:tag.name];
        }
    }
    
    return tags;
}

- (NSMutableArray* )convertObj:(NSMutableArray*)oldList
{
    NSString *tagStr=nil;
    NSMutableArray* tags=[NSMutableArray array];
    
    if(oldList!=nil && oldList.count>0){
        for (ShopTag* tag in oldList) {
            tagStr=[self tagToStr:tag.code dicId:tag.dicSysItemId label:tag.name];
            [tags addObject:tagStr];
        }
    }
    return tags;
}

- (NSString *)tagToStr:(NSString*)code dicId:(NSString*)dicId label:(NSString*)label
{
    return [NSString stringWithFormat:@"%@-%@-%@",code,dicId,label];
}


- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"shop"];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateConstraints];
}

- (IBAction)locationBtnClick:(UIButton *)sender {
    
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

- (void)mapLocationViewController:(TDFMapLocationViewController *)viewController didFinishLocating:(TDFMapLocationModel *)location {
    [self refreshLongtitude:location.longitude latitude:location.latitude address:location.name];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:self.reviewInfo.address]) {
        self.lblNoSave1.hidden = YES;
    }else{
        self.lblNoSave1.hidden = NO;
    }
    
    self.lblNoSave.hidden = NO;
//    [self.titleBox initWithName:NSLocalizedString(@"店家资料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void)refreshLongtitude:(NSString *)longtitude latitude:(NSString *)latitude address:(NSString *)address
{
    if ([self.shopRemote.longtitude isEqualToString:longtitude] && [self.shopRemote.latitude isEqualToString:latitude]) {
       [self dataChange:nil];
    }else{
        self.shopRemote.longtitude = longtitude;
        self.shopRemote.latitude = latitude;
        self.shopDetail.mapAddress = address;
        [[NSUserDefaults standardUserDefaults] setObject:longtitude forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"mapAddress"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.reviewInfo.longitude = [longtitude doubleValue];
        self.reviewInfo.latitude = [latitude doubleValue];
        self.lblLocation.text = [NSString stringWithFormat:NSLocalizedString(@"经度:%@,纬度:%@", nil),longtitude,latitude];
        self.lblLocation.textColor = [ColorHelper getBlueColor];
        self.lblNoSave1.hidden = NO;
        self.infoChanged = YES;
        
        __weak __typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [wself dataChange:nil];
        });
    }
}

@end
