//
//  WXOfficialAccountController.m
//  RestApp
//
//  Created by Octree on 19/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WXOfficialAccountController.h"
#import "EditImageBox.h"
#import "TDFKabawService.h"
#import <Masonry/Masonry.h>
#import "BackgroundHelper.h"
#import "ShopImg.h"
#import "Platform.h"
#import "UIHelper.h"
#import "KabawService.h"
#import "SystemService.h"
#import "ServiceFactory.h"
#import "NSString+Estimate.h"
#import "MBProgressHUD.h"

@interface WXOfficialAccountController ()<IEditImageBoxClient>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) EditImageBox *imageBox;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) KabawService *service;
@property (strong, nonatomic) SystemService *systemService;
@property (copy, nonatomic) NSString *tempImagePath;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation WXOfficialAccountController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = @[];
    [self configViews];
    [self configConstraints];

    self.title = NSLocalizedString(@"店家微信公众号设置", nil);
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.hud];
    [self loadWXImage];
}

- (void)configViews {

    [self.view addSubview: self.backgroundImageView];
    [self.view addSubview: self.scrollView];
    [self.scrollView addSubview: self.containerView];
    [self.containerView addSubview: self.titleLabel];
    [self.containerView addSubview: self.detailLabel];
    [self.containerView addSubview: self.imageBox];
    [self.imageBox initImgObject: self.images];
}


- (void)configConstraints {

    __weak __typeof(self) wself = self;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wself.view);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wself.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wself.scrollView.mas_top);
        make.left.equalTo(wself.scrollView.mas_left);
//        make.height.equalTo(wself.view.mas_height);
        make.width.equalTo(wself.view.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(wself.containerView.mas_top).with.offset(20);
        make.left.equalTo(wself.containerView.mas_left);
        make.width.equalTo(wself.view.mas_width);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wself.titleLabel.mas_bottom).with.offset(15);
        make.left.equalTo(wself.containerView.mas_left).with.offset(15);
        make.width.equalTo(wself.view.mas_width).with.offset(-30);
    }];
    
    [self.imageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wself.detailLabel.mas_bottom).with.offset(20);
        make.left.equalTo(wself.containerView.mas_left);
        make.right.equalTo(wself.containerView.mas_right);
        make.height.mas_equalTo(210);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat height = self.imageBox.frame.origin.y + self.imageBox.frame.size.height;
    height = self.view.frame.size.height > height ? self.view.frame.size.height + 10 : height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(height);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadWXImage {

    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.hud hide:YES];
        NSDictionary * contData  = data [@"data"];
        NSDictionary * wxDict = [contData objectForKey:@"wxQrCodeImg"];
        if ([ObjectUtil isNotEmpty:wxDict]) {
            ShopImg *imgData= [JsonHelper dicTransObj:wxDict obj:[NSClassFromString(@"ShopImg") new]];
            self.images = @[ imgData ];
        }
        [self.imageBox initImgObject:self.images];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.hud hide: YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark - delegate

#pragma mark IEditImageBoxClient

- (void)startRemoveImage:(id<IImageData>)imageData target:(EditImageBox *)targat {

    [UIHelper showHUD:NSLocalizedString(@"正在删除图片，请稍候", nil) andView:self.view andHUD:self.hud];
    ShopImg *image = (ShopImg *)imageData;
    NSMutableArray *array = [NSMutableArray arrayWithObject:image._id];
    @weakify(self);
    [[TDFKabawService new] removeShopImgs:array sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self.hud setHidden:YES];
        self.images = @[];
        [self.imageBox initImgObject: self.images];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.hud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)startUploadImage:(UIImage *)imageData target:(EditImageBox *)targat {

    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    self.tempImagePath = [NSString stringWithFormat:@"%@/shopimg/%@.png", entityId, [NSString getUniqueStrByUUID]];
    [UIHelper showHUD:NSLocalizedString(@"正在上传", nil) andView:self.view andHUD:self.hud];
    [self.systemService uploadImage:self.tempImagePath
                              image:imageData
                              width:1280
                             heigth:1280
                             Target:self
                           Callback:@selector(uploadImgFinsh:)];
}


#pragma mark - Action

#pragma mark remove image

/**
 *  公众号二维码移除的回调
 *
 *  @param result 结果
 */

- (void)removeFinish:(RemoteResult *) result {
    [self.hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    self.images = @[];
    [self.imageBox initImgObject: self.images];
}


#pragma mark load & upload image

/**
 *  图片上传的回调
 *
 *  @param result 结果
 */
- (void)uploadImgFinsh:(RemoteResult *)result {
    [self.hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
      [UIHelper showHUD:NSLocalizedString(@"正在保存图片", nil) andView:self.view andHUD:self.hud];
    [[TDFKabawService new] saveWxQrCodeImgs:self.tempImagePath sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.hud hide:YES];
        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.hud];
        NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
        [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.hud hide:YES];
            NSDictionary *contenData  = data [@"data"];
            NSDictionary * wxDict = [contenData objectForKey:@"wxQrCodeImg"];
            if ([ObjectUtil isNotEmpty:wxDict]) {
                ShopImg *imgData= [JsonHelper dicTransObj:wxDict obj:[NSClassFromString(@"ShopImg") new]];
                self.images = @[ imgData ];
            }
            [self.imageBox initImgObject:self.images];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

/**
 *  保存公众号二维码的回调
 *
 *  @param result 结果
 */
- (void)saveImgsFinish:(RemoteResult *) result {
    
    [self.hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.hud];
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    [[TDFKabawService new] loadShopDetailShopCode:shopCode sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.hud hide:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

/**
 *  加载商家信息的回调
 *
 *  @param result 结果
 */
- (void)loadImageFinsh:(RemoteResult *) result {
    
    [self.hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary* map = [JsonHelper transMap:result.content];
    NSDictionary * wxDict = [map objectForKey:@"wxQrCodeImg"];
    if ([ObjectUtil isNotEmpty:wxDict]) {
        ShopImg *imgData= [JsonHelper dicTransObj:wxDict obj:[NSClassFromString(@"ShopImg") new]];
        self.images = @[ imgData ];
    }
    [self.imageBox initImgObject:self.images];
}


#pragma mark - Accessor

- (EditImageBox *)imageBox {

    if (!_imageBox) {
    
        _imageBox = [[EditImageBox alloc] init];
        [_imageBox awakeFromNib];
        [_imageBox initLabel:nil delegate: self];
    }
    
    return _imageBox;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
    
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"店家微信公众号二维码", nil);
        _titleLabel.textColor = [UIColor colorWithWhite:51.0 / 255 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
    
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor colorWithWhite:102.0 / 255 alpha:1.0];
        _detailLabel.font = [UIFont systemFontOfSize: 11];
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = NSLocalizedString(@"二维码获取方式：\n\n1.打开微信公众平台后台，在公众号管理中心，找到并点击“公众号设置”；\n2.在账号详情页面，找到“二维码”，点击“下载更多尺寸”，建议下载边长为12cm的二维码；\n3.将下载的二维码通过QQ、微信网页版等方式从电脑传到手机上，然后在此处上传；\n4.上传的二维码将会在顾客微信点菜时展示出来，帮助店家微信公众号吸收粉丝。", nil);
    }
    
    return _detailLabel;
}

- (UIImageView *)backgroundImageView {

    if (!_backgroundImageView) {
    
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    }
    
    return _backgroundImageView;
}

- (UIScrollView *)scrollView {

    if (!_scrollView) {
    
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.7];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
    }
    
    return _scrollView;
}

- (SystemService *)systemService {

    if (!_systemService) {
    
        _systemService = [ServiceFactory Instance].systemService;
    }
    
    return _systemService;
}

- (KabawService *)service {

    if (!_service) {
    
        _service = [ServiceFactory Instance].kabawService;
    }
    
    return _service;
}

- (MBProgressHUD *)hud {

    if (!_hud) {
    
        _hud = [[MBProgressHUD alloc] initWithView: self.view];
    }
    
    return _hud;
}

- (UIView *)containerView {

    if (!_containerView) {
    
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    
    return _containerView;
}

@end
