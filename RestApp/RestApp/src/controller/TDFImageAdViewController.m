//
//  TDFImageAdViewController.m
//  RestApp
//
//  Created by happyo on 16/10/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFImageAdViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFImageManagerItem.h"
#import "DHTTableViewSection.h"
#import "DHTTableViewManager.h"
#import "TDFTakeMealService.h"
#import "TDFResponseModel.h"
#import "TDFAddImageView.h"
#import "Platform.h"
#import "ServiceFactory.h"
#import "NSString+Estimate.h"

typedef NS_ENUM(NSUInteger, TDFPhotoSourceType) {
    TDFPhotoTypePhotoLibrary,
    TDFPhotoTypePhotoCamera
};

@interface TDFImageAdViewController () <TDFAddImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TDFAddImageView *addImageView;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSString *imagePathTemp;

@end
@implementation TDFImageAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"图片广告", nil);
    [self configureBackground];
    [self configDefaultManager];
    [self registerCells];
    [self configureTableHeaderView];
    [self configureTableFooterView];
    
    [self fetchImageList];
}

- (void)configureBackground
{
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
}


- (void)registerCells
{
    [self.manager registerCell:@"TDFImageManagerCell" withItem:@"TDFImageManagerItem"];
}

- (void)configureTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 30, 130)];
    
    NSMutableString *info = [NSMutableString stringWithString:NSLocalizedString(@"说明：\n", nil)];
    [info appendString:NSLocalizedString(@"1.最佳图片分辨率为1920×1080；\n", nil)];
    [info appendString:NSLocalizedString(@"2.单张图片容量大小请控制在5M以内；\n", nil)];
    [info appendString:NSLocalizedString(@"3.最多可上传15张图片；\n", nil)];
    [info appendString:NSLocalizedString(@"4.图片播放顺序按照上传时间排列，先上传的先播放。", nil)];
    
    lblHeader.numberOfLines = 5;
    lblHeader.textColor = RGBA(51, 51, 51, 1);
    lblHeader.font = [UIFont systemFontOfSize:15];
    
    NSMutableAttributedString *attributedInfo = [[NSMutableAttributedString alloc] initWithString:info];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedInfo addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [info length])];
    [lblHeader setAttributedText:attributedInfo];
    
    [headerView addSubview:lblHeader];
    self.tbvBase.tableHeaderView = headerView;
}


- (void)configureTableFooterView
{
    self.tbvBase.tableFooterView = self.addImageView;
}

- (void)fetchImageList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFTakeMealService fetchAdImageListWithCompleteBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        NSString *msg = response.error.localizedDescription;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                //
                NSDictionary *dic =response.responseObject;

                NSArray *imageList = dic[@"data"];
    
                [self configureSectionsWithImageList:imageList];
            }
        } else {
            [self showMessageWithTitle:msg message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)configureSectionsWithImageList:(NSArray *)imageList
{
    [self.manager removeAllSections];
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    for (NSDictionary *dict in imageList) {
        TDFImageManagerItem *item = [[TDFImageManagerItem alloc] init];
//        item.placeholderImage = [UIImage imageNamed:@"ShopScreenAd_Header_Icon"];
        item.path = dict[@"path"];
        item.downloadUrl = dict[@"downloadUrl"];
        item.imageId = dict[@"id"];
        item.urlModel = ImageUrlScale;
        @weakify(self);
        item.btnDeleteClicked = ^ () {
            @strongify(self);
            [self showDeleteMessageWithImageId:dict[@"id"]];
        };
        
        [section addItem:item];
    }
    
    if (section.items.count >= 15) {
        self.tbvBase.tableFooterView = nil;
    } else {
        self.tbvBase.tableFooterView = self.addImageView;
    }
    
    [self.manager addSection:section];
    [self.manager reloadData];
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
    
    self.imagePickerController = imagePickerController; // we need this for later
    
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        //.. done presenting
    }];
}

//- (BOOL)couldUploadImage:(UIImage *)image
//{
//    NSData *imageData = UIImagePNGRepresentation(image);
//    
//    NSInteger bytes = imageData.length;
//    
//    if (bytes > 5 * 1024 * 1024) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

- (void)uploadImage:(UIImage *)imageData
{
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *filePath = [NSString stringWithFormat:@"%@/imageAd/%@.png", entityId, [NSString getUniqueStrByUUID]];
    self.imagePathTemp = filePath;
    
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
    [[ServiceFactory Instance].systemService uploadImage:filePath image:imageData width:1920 heigth:1080 Target:self Callback:@selector(uploadImageFinshed:)];
}

- (void)uploadImageFinshed:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:result.errorStr cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return;
    }
    
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    [TDFTakeMealService saveAdImageWithImagePath:self.imagePathTemp completeBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            [self fetchImageList];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)showDeleteMessageWithImageId:(NSString *)imageId
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self deleteImageWithImageId:imageId];
                                                            }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alertController addAction:enterAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteImageWithImageId:(NSString *)imageId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    [TDFTakeMealService deleteAdImageWithFileResId:imageId completeBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            [self fetchImageList];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}


#pragma mark -- UIImagePickerControllerDelegate --

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
//    if ([self couldUploadImage:image]) {
    [self uploadImage:image];
//    } else {
//        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"图片容量超过5M，无法上传", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
//    }
}

#pragma mark -- TDFAddImageViewDelegate --

- (void)addImageViewClicked:(TDFAddImageView *)view
{
    if (view == self.addImageView) {
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择图片来源", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"图库", nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self showImagePickerWithType:TDFPhotoTypePhotoLibrary];
                                                              }];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [self showImagePickerWithType:TDFPhotoTypePhotoCamera];
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
}

#pragma mark -- Getters && Setters --

- (TDFAddImageView *)addImageView
{
    if (!_addImageView) {
        _addImageView = [[TDFAddImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _addImageView.delegate = self;
    }
    
    return _addImageView;
}

@end
