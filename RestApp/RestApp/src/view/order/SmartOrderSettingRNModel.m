
//
//  SmartOrderSettingRNModel.m
//  RestApp
//
//  Created by 忘忧 on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmartOrderSettingRNModel.h"
#import "SmartOrderRNManager.h"
#import "RNNativeActionManager.h"
#import "RNRootURL.h"

#import "RCTRootView.h"
#import "RCTBundleURLProvider.h"
#import "RCTLinkingManager.h"

#import "MBProgressHUD.h"
#import "HelpDialog.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "UIHelper.h"
#import "RestConstants.h"

#import "SmartOrderRNService.h"
#import "TDFMemberCouponService.h"
#import "TDFResponseModel.h"

@interface SmartOrderSettingRNModel () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    MBProgressHUD *hud;
}

/**
 图片本地路径
 */
@property (nonatomic, strong) NSString *imageLocalPath;
@property (nonatomic, copy) RCTResponseSenderBlock rnCallBack;
@property (nonatomic, strong) SmartOrderRNService *service;

@end

@implementation SmartOrderSettingRNModel



- (id)init
{
    self = [super init];
    if (self) {
        //        NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
        NSURL *jsCodeLocation = [RNRootURL shareInstance].indexUrl;
        RCTRootView *rootView =
        [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                             moduleName        : @"Project"
                             initialProperties : @{@"language" : @"zh_CN"}
                              launchOptions    : nil];
        self.view = rootView;
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHub) name:RNShowHubNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHub) name:RNHideHubNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVC) name:RNPopVCNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helpAction:) name:RNHelpActionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImage:) name:RNAddImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeImage:) name:RNRemoveImageNotification object:nil];
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)popVC
{
    //pop时需要在主线程完成
    if (self.view.window) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TDF_ROOT_NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
        });
    }
    
    
}

- (void)helpAction:(NSNotification*)notification
{
    NSDictionary * notificationDic = (NSDictionary *)[notification object];
    
    if (notificationDic && self.view.window) {
        NSString * helpActionKey = notificationDic[@"helpAction"];
        
        if (helpActionKey) {
            if ([helpActionKey isEqualToString:@"HelpAction_AddTemplate"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNAddTemplate"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_TemplateSelectPeople"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNTemplateSelectPeople"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_TemplateDetail"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNTemplateDetail"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_SelectMenu"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNSelectMajor"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_TemplatePreview"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNTemplatePreview"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_TemplateHome"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"SmartOrderSettingRNModel"];
                });
                return;
            }
            
            if ([helpActionKey isEqualToString:@"HelpAction_TipSetting"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HelpDialog show:@"RNOrderRecomendeView"];
                });
                return;
            }
            
        }
        
    }
    
}

#pragma mark - MBProgressHUD
- (void)showHub {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideHub {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark Change Image
- (void)addImage:(NSNotification*)notification
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil), NSLocalizedString(@"拍照", nil), nil];
    sheet.tag = 1;
    self.rnCallBack = (RCTResponseSenderBlock)[notification object];
    dispatch_async(dispatch_get_main_queue(), ^{
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    });
}

- (void)removeImage:(NSNotification*)notification
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    sheet.tag = 2;
    self.rnCallBack = (RCTResponseSenderBlock)[notification object];
    dispatch_async(dispatch_get_main_queue(), ^{
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    });
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            //删除图片
            [self removeImage];
        }
    } else {
        if (buttonIndex == 0 || buttonIndex == 1) {
            //添加图片
            [self addImageWithDevice:buttonIndex];
        }
    }
}

/**
 添加图片
 
 @param imageDevice 0图库 1拍照
 */
- (void)addImageWithDevice:(NSInteger)imageDevice
{
    if (imageDevice == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:NSLocalizedString(@"相机好像不能用哦!", nil)];
            return;
        }
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *imagePickerController =  [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if(imageDevice == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:NSLocalizedString(@"相册好像不能访问哦!", nil)];
            return;
        }
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *imagePickerController =  [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageData = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (imageData) {
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            self.imageLocalPath = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]];
        } else {
            self.imageLocalPath = nil;
        }
        [self startUploadImage:imageData];
    }
}

//开始上传图片
- (void)startUploadImage:(UIImage *)imageData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHub];
    });
    
    [self.service RNPostImage:imageData Callback:^(TDFResponseModel * _Nullable response) {
        [self hideHub];
        if (response.isSuccess) {
            NSString *imgUrlStr = [response.responseObject objectForKey:@"data"];
            if (imgUrlStr) {
                NSDictionary *imageUrlDictionary = @{@"local":self.imageLocalPath?:imgUrlStr,@"network":imgUrlStr};
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageUrlDictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //imgUrlStr 是个标准http url ,这里需要检验一下，服务端有时返回0
                if ([imgUrlStr.lowercaseString hasPrefix:@"http://"] || [jsonString.lowercaseString hasPrefix:@"https://"]) {
                    //上传成功
                    self.rnCallBack(@[[NSNull null],jsonString]);
                } else {
                    //上传成功，但是服务器返回url不对，做失败处理
                    self.rnCallBack(@[NSLocalizedString(@"图片上传异常", nil),[NSNull null]]);
                }
            } else {
                self.rnCallBack(@[NSLocalizedString(@"图片上传失败", nil),[NSNull null]]);
            }
            
        } else {
            self.rnCallBack(@[NSLocalizedString(@"图片上传失败", nil),[NSNull null]]);
        }
    }];
}

- (void)removeImage
{
    self.rnCallBack(@[[NSNull null]]);
}

#pragma mark Getter/Setter
- (SmartOrderRNService *)service
{
    if (!_service) {
        _service = [[SmartOrderRNService alloc] init];
    }
    
    return _service;
}

@end
