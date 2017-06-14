//
//  ShopCodeView.m
//  RestApp
//
//  Created by 刘红琳 on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WXApi.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"
#import "RemoteEvent.h"
#import "ShopCodeView.h"
#import "RemoteResult.h"
#import "EventConstants.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "TDFQRCodeBindView.h"
#import "TDFKabawService.h"
#import "TDFDetailController.h"
#import "TDFScanViewController.h"
#import "UIViewController+HUD.h"
#import "ServiceFactory.h"
#import "TDFQRCode.h"
#import "TDFSeatService.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AVFoundation/AVFoundation.h>

@interface ShopCodeView ()<TDFQRCodeBindViewDelegate, TDFScanViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet TDFQRCodeBindView *codeBindView;
@property (strong, nonatomic) TDFScanViewController *scanController;

@property (nonatomic, getter=isBindingQRCode) BOOL bindingQRCode;
@property (strong, nonatomic) NSArray *bindQRCodes;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindViewHeight;
// 250
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindContainerHeight;
// 710


@end

@implementation ShopCodeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp
{
    
    self = [super initWithNibName:@"ShopCodeView" bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].kabawService;
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initNavigate];
    [self initNotifaction];
    //    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    //    [self loadDataView];
    CGSize size = [UIScreen mainScreen].bounds.size;
    size.height = 1350;
    self.scrollView.contentSize = size;
    self.containerHeightConstraint.constant = 1350;
    
    self.codeBindView.delegate = self;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.codeBindView.limit = 10;
    self.codeBindView.bindButtonTitle = NSLocalizedString(@"绑定新的店铺二维码", nil);
    self.helpButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self loadQRCodeInfo];
}

- (void)initNavigate
{
    self.title = NSLocalizedString(@"店铺二维码", nil);
    [self.footView initDelegate:self btnArrs:nil];
    //    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    //    [self.titleDiv addSubview:self.titleBox.view];
    //    [self.titleBox initWithName:NSLocalizedString(@"店铺二维码", nil) backImg:Head_ICON_BACK moreImg:nil];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.backIndex==INDEX_PARENT_VIEW) {
            //            [parent showView:SECOND_MENU_VIEW];
        } else if (self.backIndex==INDEX_MAIN_VIEW) {
            //            [parent showView:SECOND_MENU_VIEW];
            [parent backToMain];
        }
    }
}

- (void)initNotifaction {
    
}



#pragma mark - BEGIN

- (void)updateConstraints {
    
    
    // 1350
    // 710
    // 250
    CGFloat height = self.codeBindView.expectedHeight - 250;
    self.bindViewHeight.constant = self.codeBindView.expectedHeight;
    self.bindContainerHeight.constant = 710 + height;
    self.containerHeightConstraint.constant = 1350 + height;
    CGSize size = [UIScreen mainScreen].bounds.size;
    size.height = 1350 + height;
    self.scrollView.contentSize = size;
}

#pragma mark - TDFQRCodeBindViewDelegate


- (void)qrcodeBindViewAddButtonTapped:(TDFQRCodeBindView *)view {
    
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"扫描二维码与店铺绑定", nil)
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                              }];
    
    self.scanController = [[TDFScanViewController alloc] initWithTitle:NSLocalizedString(@"绑定店铺二维码", nil)
                                                              subTitle:nil
                                                                detail:detail];
    self.scanController.delegate = self;
    [self.navigationController pushViewController:self.scanController animated:YES];
}


- (void)qrcodeBindView:(TDFQRCodeBindView *)view deleteButtonTappedAtIndex:(NSInteger)index {
    
    [self unbindQRCode:self.bindQRCodes[index]];
}


#pragma mark - TDFScanViewControllerDelegate

- (void)scanViewController:(TDFScanViewController *)viewController didRecognize:(NSString *)text {
    
    [self bindQRCode:text];
}

#pragma mark Network

- (void)bindQRCode:(NSString *)code {
    
    [self.scanController showHUBWithText:NSLocalizedString(@"正在绑定", nil)];
    // [self.service bindShopCodeWithShortURL:code target:self callback:@selector(bindQRCodeFinished:)];
    __weak __typeof(self) wself = self;
    [[self service] bindShopCodeWithShortURL:code
                                      sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                          
                                          [wself bindQRCodeFinishedWithError:nil];
                                      }
                                     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                         
                                         [wself bindQRCodeFinishedWithError:error];
                                     }];
}

- (void)bindQRCodeFinishedWithError:(NSError *)error {
    
    if (error) {
        
        [self.scanController dismissHUD];
        [self.scanController showError:[error localizedDescription] duration:2.5];
        [self.scanController resume];
        return;
    }
    
    self.bindingQRCode = YES;
    [self loadQRCodeInfo];
}

- (void)loadQRCodeInfo {
    
    if (!self.isBindingQRCode) {
        
        [self showHUBWithText:NSLocalizedString(@"正在获取二维码", nil)];
    }
    
    //[self.service getShopCodeWithTarget:self callback:@selector(didLoadCodeInfo:)];
    __weak __typeof(self) wself = self;
    [[self service] getShopCodeWithsucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself didLoadCodeInfoWithObj:data error:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself didLoadCodeInfoWithObj:nil error:error];
    }];
}

- (void)unbindQRCode:(TDFQRCode *)code {
    
    [self showHUBWithText:NSLocalizedString(@"正在解除绑定", nil)];
    //[self.service unbindShopCodeShortURL:code.url target:self callback:@selector(unbindFinished:)];
    __weak __typeof(self) wself = self;
    [[self service] unbindShopCodeShortURL:code._id
                                    sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                        
                                        [wself unbindFinishedWithError:nil];
                                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                        
                                        [wself unbindFinishedWithError:error];
                                    }];
}

- (void)unbindFinishedWithError:(NSError *)error {
    
    [self dismissHUD];
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    
    [self loadQRCodeInfo];
}

- (void)didLoadCodeInfoWithObj:(id)obj error:(NSError *)error {
    
    if (!self.isBindingQRCode) {
        
        [self dismissHUD];
    }
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    
    NSDictionary *dict = [obj objectForKey:@"data"];
    self.bindQRCodes = [NSArray yy_modelArrayWithClass:[TDFQRCode class] json:dict[@"bindQrcodeVoList"]];
    self.codeBindView.qrcodePresenters = self.bindQRCodes;
    [self.codeBindView reloadData];
    [self loadShopCode:dict[@"shopQrcodeUrl"]];
    if (self.isBindingQRCode) {
        
        self.bindingQRCode = NO;
        [self showBindingSuccessInfo];
    }
    [self updateConstraints];
}

- (void)showBindingSuccessInfo {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self showSuccessMessage:NSLocalizedString(@"绑定成功", nil) duration:2.3];
    self.scanController = nil;
}

- (void)loadShopCode:(NSString *)code {
    
    [[NSUserDefaults standardUserDefaults]setObject:code forKey:@"data"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIImage* img = [QRCodeGenerator qrImageForString:code imageSize:360];
    self.setQRCodeImageView.image=img;
}

#pragma mark - action

- (IBAction)showMoreInfo:(id)sender {
    
    TDFDetailController *dvc = [[TDFDetailController alloc] initWithTitle:NSLocalizedString(@"店铺二维码", nil) content:NSLocalizedString(@"顾客通过扫描店铺二维码进入店铺主页，查看店家发布的生活圈消息，领取红包优惠，还可以在未到店或排队时预先点菜，进店扫描桌码下单。\n不被流量绑架，自主发起营销活动，扩大餐厅知名度，让客流量源源不断。", nil)];
    
    [self presentViewController:dvc animated:YES completion:nil];
}

#pragma mark - END


//- (void)loadDataView
//{
//    [self showProgressHudWithText:NSLocalizedString(@"正在获取二维码", nil)];
////    [UIHelper showHUD:NSLocalizedString(@"正在获取二维码", nil) andView:self.view andHUD:hud];
//
//    [service loadShopQrCodeTarget:self callback:@selector(getQRCodeFinish:)];
//}
//
//- (void)getQRCodeFinish:(RemoteResult*) result
//{
//    [self.progressHud hide:YES];
//
//    if (result.isRedo) {
//        return;
//    }
//    if (!result.isSuccess) {
//        [AlertBox show:result.errorStr];
//        return;
//    }
//    [self remoteGetQRCodeData:result.content];
//}
//
//- (void)remoteGetQRCodeData:(NSString *) responseStr
//{
//    NSDictionary *map = [JsonHelper transMap:responseStr];
//    NSString *data=[map objectForKey:@"data"];
//    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"data"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    UIImage* img = [QRCodeGenerator qrImageForString:data imageSize:360];
//    self.setQRCodeImageView.image=img;
//}

- (IBAction)shareToWeChatFriendBtnClick:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        currentBtnIndex = WEIXIN_FRIEND;
        [self loadShareImage];
    } else {
        [AlertBox show:NSLocalizedString(@"您还未安装微信！！", nil)];
        return;
    }
}

- (void)shareToWeChatFriendBodyWithText:(NSString *)text Image:(UIImage *)img
{
    NSString* url=[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    UMSocialMessageObject *obj = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:text
                                                                        descr:nil
                                                                    thumImage:img];
    webObj.webpageUrl = url;
    obj.shareObject = webObj;
    [self shareWithPlatformType:(UMSocialPlatformType_WechatSession) message:obj];
    //    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMANALYTICS_KEY
    //                                      shareText:text shareImage:img shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
    //                                       delegate:nil];
}


- (IBAction)shareToWeChatMomentBtnClick:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        currentBtnIndex = WEIXIN_MOMENT;
        NSString* url=[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
        [self loadShareImage];
    } else {
        [AlertBox show:NSLocalizedString(@"您还未安装微信！！", nil)];
        return;
    }
}

- (void)shareToWeChatMomentBodyWithImage:(UIImage *)img{
    //    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMANALYTICS_KEY
    //                                      shareText: shareImage:img shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,nil]
    //                                       delegate:self];
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"%@,把美食与爱随身携带!", nil),[[Platform Instance]getkey:SHOP_NAME]];
    NSString* url=[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    UMSocialMessageObject *obj = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:text
                                                                        descr:nil
                                                                    thumImage:img];
    webObj.webpageUrl = url;
    obj.shareObject = webObj;
    [self shareWithPlatformType:(UMSocialPlatformType_WechatTimeLine) message:obj];
}

- (void)shareWithPlatformType:(UMSocialPlatformType)platformType message:(UMSocialMessageObject *)obj {
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [AlertBox show:NSLocalizedString(@"分享失败", nil)];
        }else{
            [AlertBox show:NSLocalizedString(@"分享成功", nil)];
        }
    }];
}

- (void)loadShareImage
{
    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] findShopImageNotificationSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self dismissHUD];
        [self remoteLoadShareImageData:data];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self dismissHUD];
        [AlertBox show:error.localizedDescription];
    }];
    
}

- (void)remoteLoadShareImageData:(id) data
{
    if (currentBtnIndex==WEIXIN_FRIEND) {
        //        NSDictionary *map = [JsonHelper transMap:responseStr];
        NSDictionary *map = data ;
        if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]]&&[ObjectUtil isEmpty:[map objectForKey:@"notification"]]) {
            [self shareToWeChatFriendBodyWithText:NSLocalizedString(@"查看店铺优惠，领取超大红包，预先点菜，快来体验吧", nil) Image:[UIImage imageNamed:@"ico_weixin_share"]];
        } else if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]] && [ObjectUtil isNotEmpty:[map objectForKey:@"notification"]]) {
            [self shareToWeChatFriendBodyWithText:[[map objectForKey:@"notification"] objectForKey:@"name"] Image:[UIImage imageNamed:@"ico_weixin_share"]];
        } else if ([ObjectUtil isEmpty:[map objectForKey:@"notification"]] && [ObjectUtil isNotEmpty:[map objectForKey:@"shopImg"]]){
            NSString *filePath = [[map objectForKey:@"shopImg"] objectForKey:@"filePath"];
            NSURL *imageUrl = [NSURL URLWithString:filePath];
            NSData *shareData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *shareImag = [UIImage imageWithData:shareData];
            [self shareToWeChatFriendBodyWithText:NSLocalizedString(@"查看店铺优惠，领取超大红包，预先点菜，快来体验吧", nil) Image:shareImag];
        } else {
            [self shareToWeChatFriendBodyWithText:[[map objectForKey:@"notification"] objectForKey:@"name"] Image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[map objectForKey:@"shopImg"] objectForKey:@"filePath"]]]]];
        }
    } else if (currentBtnIndex==WEIXIN_MOMENT) {
        //        NSDictionary *map = [JsonHelper transMap:responseStr];
        NSDictionary *map = data ;
        if ([ObjectUtil isEmpty:[map objectForKey:@"shopImg"]]) {
            [self shareToWeChatMomentBodyWithImage:[UIImage imageNamed:@"ico_weixin_share"]];
        } else {
            NSString *filePath = [[map objectForKey:@"shopImg"] objectForKey:@"filePath"];
            NSURL *imageUrl = [NSURL URLWithString:filePath];
            NSData *shareData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *shareImag = [UIImage imageWithData:shareData];
            [self shareToWeChatMomentBodyWithImage:shareImag];
        }
    }
    //    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (IBAction)downLoadQRCodeBtnClick:(UIButton *)sender
{
    
    [self showProgressHudWithText:NSLocalizedString(@"正在下载", nil)];
    [[TDFKabawService new] downLoadShopQrCodeSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary * contentData  = data [@"data"];
        [self remoteLoadData:contentData ];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}



- (void)remoteLoadData:(NSDictionary*) map
{
    NSString *downLoadPath = [map objectForKey:@"downLoadPath"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Platform Instance].serverPath, downLoadPath]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *img=[UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    
    NSString *msg = nil ;
    if (error != NULL) {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            msg = @"保存图片失败，请在iPhone的\"设置-隐私-照片\"选项中，允许二维火掌柜访问你的手机相册。";
        } else {
            msg = NSLocalizedString(@"保存图片失败", nil) ;
        }
    } else {
        msg = NSLocalizedString(@"保存图片成功", nil) ;
    }
    [AlertBox show:msg];
}

- (IBAction)helpButtonTapped:(id)sender {
    
    [HelpDialog show:@"shopqrcode"];
}
//复制链接
- (IBAction)pasteLinkBtnClick:(UIButton *)sender
{
    NSString* url=[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    [[UIPasteboard generalPasteboard] setPersistent:YES];
    [[UIPasteboard generalPasteboard] setValue:url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    [AlertBox show:NSLocalizedString(@"二维码链接已经复制到剪贴版了哦！", nil)];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"shopmarket"];
}

- (TDFSeatService *)service {
    
    return [[TDFSeatService alloc] init];
}
@end
