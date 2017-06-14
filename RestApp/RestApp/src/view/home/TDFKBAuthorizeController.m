//
//  TDFKBAuthorizeController.m
//  RestApp
//
//  Created by BK_G on 2016/11/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKBAuthorizeController.h"

#import "Masonry.h"

#import "TDFBarcodeService.h"

#import <CoreImage/CoreImage.h>

#import "ColorHelper.h"

@interface TDFKBAuthorizeController ()

@property (nonatomic, strong) UIImageView *qrCode;

@end

@implementation TDFKBAuthorizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"口碑功能授权", nil);
    
    [self layoutUI];
    
    [self sendRequest];
}

- (void)sendRequest {

    [self showProgressHudWithText:NSLocalizedString(@"加载中", nil)];
    
    [TDFBarcodeService kouBeiGetAuthQRCodeCompleteBlock:^(TDFResponseModel * _Nullable response) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.progressHud hide:YES];
            
            if ([response.responseObject objectForKey:@"data"]) {
                
            }
            
            [self createImgWith:[response.responseObject objectForKey:@"data"]];
        });
    }];
}

- (void)layoutUI {
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    
    UILabel *l1 = [self makeOriginLabelWithStr:NSLocalizedString(@"开通口碑店后，若需要增加更多支付宝口碑相关功能，需要进行再次授权。", nil)];
    l1.textColor = [ColorHelper getRedColor];
    l1.font = [UIFont boldSystemFontOfSize:15];
    
    UILabel *l2 = [self makeOriginLabelWithStr:NSLocalizedString(@"例如：如果已经是二维火支付宝直连商户，但需要增加二维火发优惠券时同步一份到口碑店，就需要再次授权。请用口碑开店绑定的支付宝扫描下方二维码才能授权成功。\n口碑功能包含：支付宝支付、口碑营销（优惠券）等等。", nil)];
    l2.textColor = [UIColor grayColor];
    l2.font = [UIFont systemFontOfSize:14];
    
    
    self.qrCode = [[UIImageView alloc]init];
    
    UILabel *l3 = [self makeOriginLabelWithStr:NSLocalizedString(@"请用口碑开店绑定的支付宝扫描二维码授权", nil)];
    l3.textColor = [UIColor darkGrayColor];
    l3.font = [UIFont boldSystemFontOfSize:14];
    l3.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:bgView];
    [self.view addSubview:l1];
    [self.view addSubview:l2];
    [self.view addSubview:self.qrCode];
    [self.view addSubview:l3];
    
    
    __weak typeof(self) weakSelf = self;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(weakSelf.view);
    }];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
    }];
    
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        
        make.top.equalTo(l1.mas_bottom).offset(10);
    }];
    
    [self.qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(l2.mas_bottom).offset(20);
        
        make.centerX.equalTo(weakSelf.view);
        
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.5);
        
        make.height.equalTo(weakSelf.view.mas_width).multipliedBy(0.5);
    }];

    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.qrCode.mas_bottom).offset(20);
        
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
    }];
    
}

- (UILabel *)makeOriginLabelWithStr:(NSString *)str {
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = str;
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentLeft;
    label.preferredMaxLayoutWidth = self.view.frame.size.width-20;
    [label sizeToFit];
    
    return label;
}


#pragma mark - 生成二维码
- (void)createImgWith:(NSString *)str {
    
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3.设置数据
    NSString *info = str;
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKey:@"inputMessage"];
    // 4.生成二维码
    CIImage *outputImage = [filter outputImage];
    self.qrCode.image = [self createNonInterpolatedUIIamgeFormCIImage:outputImage withSize:300];
}

/**
 *  根据CIImage生成指定大小的UIImage 生成清晰的二维码
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIIamgeFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 1.创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceCMYK();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


