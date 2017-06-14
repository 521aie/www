//
//  TDFWechatOfficialAccountsViewController.m
//  RestApp
//
//  Created by happyo on 2017/2/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatOfficialAccountsViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFWechatMarketingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "DHTTableViewSection.h"
#import "TDFImageSelectItem.h"
#import "TDFImageSelectView.h"
#import "TDFMemberCouponService.h"
#import "TDFOAAuthIntrouceViewController.h"
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>

@interface TDFWechatOfficialAccountsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *authorizationBottomView;

@property (nonatomic, strong) UIView *unAuthorizationBottomView;

@property (nonatomic, strong) TDFImageSelectView *imageSelectView;

@property (nonatomic, strong) UILabel *lblQrcodeName;

@end

@implementation TDFWechatOfficialAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"店家公众号二维码", nil);
    
    [self configDefaultManager];
    self.tbvBase.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [self.manager registerCell:@"TDFImageSelectCell" withItem:@"TDFImageSelectItem"];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
    
    [self fetchData];
}

- (void)fetchData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService fetchOfficialAccountsQrcodeWithWechatId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];
        
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSDictionary *dict = responseObj;
            
            NSString *imageUrl = dict[@"data"];
            
            [self configureHeaderViewWithAuthorizedStatus:self.isAuthorization];
            
            UIView *footerView = self.isAuthorization ? self.authorizationBottomView : self.unAuthorizationBottomView;
            
            [self configureImageSectionWithImageUrl:imageUrl];
            
            DHTTableViewSection *footerSection = [DHTTableViewSection section];
            footerSection.headerView = footerView;
            footerSection.headerHeight = footerView.frame.size.height;
            
            [self.manager addSection:footerSection];
            
            [self.manager reloadData];
        }
    }];
}

- (void)configureHeaderViewWithAuthorizedStatus:(BOOL)isAuthorized
{
    UIImage *iconImage = [UIImage imageNamed:@"wxoa_qrcode"];
    
    TDFIntroductionHeaderView *headerView;
    if (isAuthorized) {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:NSLocalizedString(@"您的公众号二维码会在顾客微信点菜并结账后展示，有助于您的微信公众号吸收粉丝。", nil) badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization"]];
    } else {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage
                                                       description:NSLocalizedString(@"您的公众号二维码会在顾客微信点菜并结账后展示，有助于您的微信公众号吸收粉丝。由于您的公众号未授权给二维火，需要手动上传二维码。", nil)
                                                         badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]
                                                       detailTitle:NSLocalizedString(@"立即去授权", nil)
                                                       detailBlock:^{
                                                           [self forwardAuthorizationVC];
                                                       }];
    }
    [headerView changeBackAlpha:0];
    self.tbvBase.tableHeaderView = headerView;
    
    DHTTableViewSection *blackSection = [DHTTableViewSection section];
    UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    spliteView.backgroundColor = [UIColor blackColor];
    blackSection.headerView = spliteView;
    blackSection.headerHeight = 1;
    
    [self.manager addSection:blackSection];
}

- (void)forwardAuthorizationVC
{
    TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
    vc.authPopDepthAddition = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configureImageSectionWithImageUrl:(NSString *)imageUrl
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253)];
    
    self.imageSelectView = [[TDFImageSelectView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 233)];
    self.imageSelectView.imageURL = imageUrl.length > 0 ? [NSURL URLWithString:imageUrl] : nil;
    BOOL hidden = (imageUrl.length > 0) ? NO : YES;
    [self.lblQrcodeName setHidden:hidden];
    self.imageSelectView.title = NSLocalizedString(@"上传公众号二维码", nil);
    if (!self.isAuthorization) {
        self.imageSelectView.errorMessage = NSLocalizedString(@"本店公众号未授权，无法自动获取二维码，需手动上传", nil);
    }
    @weakify(self);
    self.imageSelectView.selectBlock = ^ () {
        @strongify(self);
        [self selectImage];
    };
    
    self.imageSelectView.deleteBlock = ^ () {
        @strongify(self);
        [self showDeleteMessage];
    };
    
    [sectionView addSubview:self.imageSelectView];
    section.headerView = sectionView;
    section.headerHeight = 253;
    
    [self.manager addSection:section];
}

- (void)selectImage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择图片来源", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"图库", nil) style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [self showImagePickerWithType:0];
                                                               }];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self showImagePickerWithType:1];
                                                            }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alertController addAction:photoLibraryAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 根据类型显示 imagePicker
 
 @param type 0 表示 图库 ，1 表示 拍照
 */
- (void)showImagePickerWithType:(NSInteger)type
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (type == 1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"相机好像不能用哦!", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return;
        }
    } else {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"相册好像不能访问哦!", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        //.. done presenting
    }];
}

- (void)uploadImage:(UIImage *)imageData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
    [TDFMemberCouponService memberUpLoadBGImgWithImg:imageData CompleteBlock:^(TDFResponseModel * response) {
        
        if ([response isSuccess]) {
            NSString *imgUrlStr = [response.responseObject objectForKey:@"data"];
            
            [TDFWechatMarketingService saveOfficialAccountsQrcodeWithWechatId:self.wechatId imagePath:imgUrlStr callback:^(id responseObj, NSError *error) {
                [self.progressHud setHidden:YES];

                if (error) {
                    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
                } else {
                    self.imageSelectView.imageURL = [NSURL URLWithString:imgUrlStr];
                    self.lblQrcodeName.hidden = !(imgUrlStr.length > 0);
                }
            }];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
        }
    }];
}


- (void)showDeleteMessage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self deleteImage];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alertController addAction:enterAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteImage
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    [TDFWechatMarketingService deleteOfficialAccountsQrcodeWithWechatId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];

        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            self.imageSelectView.imageURL = nil;
            self.lblQrcodeName.hidden = YES;
            [self.manager reloadData];
        }

    }];
}


#pragma mark -- UIImagePickerControllerDelegate --

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self uploadImage:image];
}

#pragma mark -- Actions --

- (void)downloadImageToLocal
{
    [MobClick event:@"wechat_qrcode_download"];
    if (self.imageSelectView.imageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.imageSelectView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前无图可下载", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    NSString *msg = nil ;
    
    if(error){
        msg = NSLocalizedString(@"二维码下载失败,请重试", nil) ;
    }else{
        msg = NSLocalizedString(@"二维码下载成功", nil) ;
    }
    
    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:msg cancelTitle:NSLocalizedString(@"我知道了", nil)];
}

- (void)reloadQrcodeImage
{
    [MobClick event:@"wechat_qrcode_get"];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService reloadOfficialAccountsQrcodeWithWechatId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];
        
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSString *imgUrlStr = [responseObj objectForKey:@"data"];
            
            self.imageSelectView.imageURL = [NSURL URLWithString:imgUrlStr];
            self.lblQrcodeName.hidden = NO;
        }
    }];
}


#pragma mark -- Getters && Setters --

- (UIView *)authorizationBottomView
{
    if (!_authorizationBottomView) {
        _authorizationBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        [_authorizationBottomView addSubview:self.lblQrcodeName];
        [self.lblQrcodeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorizationBottomView);
            make.trailing.equalTo(_authorizationBottomView).with.offset(-10);
            make.leading.equalTo(_authorizationBottomView);
            make.height.equalTo(@12);
        }];
        
        UIButton *btnDownload = [[UIButton alloc] initWithFrame:CGRectZero];
        [btnDownload setBackgroundImage:[UIImage imageNamed:@"wxoa_official_accounts_download_icon"] forState:UIControlStateNormal];
        [btnDownload addTarget:self action:@selector(downloadImageToLocal) forControlEvents:UIControlEventTouchUpInside];
        
        [_authorizationBottomView addSubview:btnDownload];
        [btnDownload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorizationBottomView).with.offset(20);
            make.leading.equalTo(_authorizationBottomView).with.offset(80);
            make.height.equalTo(@54);
            make.width.equalTo(@54);
        }];
        
        UILabel *lblDownload = [[UILabel alloc] initWithFrame:CGRectZero];
        lblDownload.text = NSLocalizedString(@"下载二维码到手机", nil);
        lblDownload.textColor = RGBA(102, 102, 102, 1);
        lblDownload.font = [UIFont systemFontOfSize:12];
        lblDownload.numberOfLines = 2;
        lblDownload.textAlignment = NSTextAlignmentCenter;
        
        [_authorizationBottomView addSubview:lblDownload];
        [lblDownload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnDownload.mas_bottom).with.offset(10);
            make.width.equalTo(@64);
            make.centerX.equalTo(btnDownload);
            make.height.equalTo(@30);
        }];
        
        UIButton *btnReload = [[UIButton alloc] initWithFrame:CGRectZero];
        [btnReload setBackgroundImage:[UIImage imageNamed:@"wxoa_official_accounts_reload_icon"] forState:UIControlStateNormal];
        [btnReload addTarget:self action:@selector(reloadQrcodeImage) forControlEvents:UIControlEventTouchUpInside];
        
        [_authorizationBottomView addSubview:btnReload];
        [btnReload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorizationBottomView).with.offset(20);
            make.trailing.equalTo(_authorizationBottomView).with.offset(-80);
            make.height.equalTo(@54);
            make.width.equalTo(@54);
        }];
        
        UILabel *lblReload = [[UILabel alloc] initWithFrame:CGRectZero];
        lblReload.text = NSLocalizedString(@"重新获取公众号二维码", nil);
        lblReload.textColor = RGBA(102, 102, 102, 1);
        lblReload.font = [UIFont systemFontOfSize:12];
        lblReload.numberOfLines = 2;
        lblReload.textAlignment = NSTextAlignmentCenter;
        
        [_authorizationBottomView addSubview:lblReload];
        [lblReload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnReload.mas_bottom).with.offset(10);
            make.width.equalTo(@64);
            make.centerX.equalTo(btnReload);
            make.height.equalTo(@30);
        }];
    }
    
    return _authorizationBottomView;
}

- (UILabel *)lblQrcodeName
{
    if (!_lblQrcodeName) {
        _lblQrcodeName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblQrcodeName.text = [self.wechatName isEqualToString:@""] ? @"" : [NSString stringWithFormat:NSLocalizedString(@"公众号：%@", nil), self.wechatName];
        _lblQrcodeName.font = [UIFont systemFontOfSize:11];
        _lblQrcodeName.textColor = RGBA(102, 102, 102, 1);
        _lblQrcodeName.textAlignment = NSTextAlignmentRight;
    }
    
    return _lblQrcodeName;
}

- (UIView *)unAuthorizationBottomView
{
    if (!_unAuthorizationBottomView) {
        _unAuthorizationBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 127)];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lblTitle.text = NSLocalizedString(@"公众号二维码获取方式：", nil);
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = RGBA(51, 51, 51, 1);
        
        [_unAuthorizationBottomView addSubview:lblTitle];
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_unAuthorizationBottomView).with.offset(10);
            make.trailing.equalTo(_unAuthorizationBottomView).with.offset(-10);
            make.height.equalTo(@(17));
            make.top.equalTo(_unAuthorizationBottomView);
        }];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        lblDescription.text = NSLocalizedString(@"1.打开微信公众平台后台，在公众号管理中心，找到并点击“公众号设置”；\n2.在账号详情页面，找到“二维码”，点击“下载更多尺寸”，建议下载边长为12cm的二维码；\n3.将下载的二维码通过QQ、微信网页版等方式从电脑传到手机上，然后在此处上传。", nil);
        lblDescription.textColor = RGBA(51, 51, 51, 1);
        lblDescription.font = [UIFont systemFontOfSize:12];
        lblDescription.numberOfLines = 0;
        
        [_unAuthorizationBottomView addSubview:lblDescription];
        [lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_unAuthorizationBottomView).with.offset(10);
            make.trailing.equalTo(_unAuthorizationBottomView).with.offset(-10);
            make.height.equalTo(@100);
            make.top.equalTo(lblTitle.mas_bottom).with.offset(10);
        }];
    }
    
    return _unAuthorizationBottomView;
}


@end
