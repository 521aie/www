//
//  TDFBarcodeViewController.m
//  RestApp
//
//  Created by doubanjiang on 16/8/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBarcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "TDFScanLoginViewController.h"
#import "AlertImageView.h"
#import "TDFBarcodeService.h"
#import "TDFBarcodeScanResultModel.h"
#import <YYModel.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TDFBarcodeViewController ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate>

//取景背景视图
@property (nonatomic, strong) UIView                     *cameraView;
//扫描中心视图
@property (nonatomic, strong) UIView                     *scanWindowView;
//关键用来操作扫描结果
@property (nonatomic, strong) AVCaptureSession           *session;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@end

@implementation TDFBarcodeViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.needHideOldNavigationBar = NO;
    
    [self layOutUI];
}

- (void)viewDidAppear:(BOOL)animated {

    
    [self beginScan];
    
    [self beginAnimated];
}

#pragma mark - UI布局
- (void)layOutUI {
    
    self.title  = NSLocalizedString(@"二维码扫描", nil);
    __weak typeof(self) weakSelf = self;
    
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    
    _cameraView                  = [[UIView alloc]init];
    [self.view addSubview:_cameraView];
    
    _scanWindowView              = [[UIView alloc]init];
    
    UIImageView *scanBgView      = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barcodeWindow"]];
    
    [_cameraView addSubview:scanBgView];
    [_cameraView addSubview:_scanWindowView];
    [_cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_equalTo(weakSelf.view);
        
        make.size.mas_equalTo(weakSelf.view);
    }];
    [_scanWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_cameraView);
        
        make.top.equalTo(weakSelf.view).with.offset(100);
        
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [scanBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_cameraView);
        
        make.top.equalTo(weakSelf.view).with.offset(100);
        
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self addMaskView];
}

#pragma mark - 加入遮罩
- (void)addMaskView {

    __weak typeof(self) weakSelf = self;
    
    UIView *m1 = [[UIView alloc]init];
    UIView *m2 = [[UIView alloc]init];
    UIView *m3 = [[UIView alloc]init];
    UIView *m4 = [[UIView alloc]init];
    
    m1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    m2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    m3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    m4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [_cameraView addSubview:m1];
    [_cameraView addSubview:m2];
    [_cameraView addSubview:m3];
    [_cameraView addSubview:m4];
    
    
    [m1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.scanWindowView.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    [m2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scanWindowView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    [m3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m1.mas_bottom);
        make.bottom.equalTo(m2.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.scanWindowView.mas_left);
    }];
    [m4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m1.mas_bottom);
        make.bottom.equalTo(m2.mas_top);
        make.left.equalTo(weakSelf.scanWindowView.mas_right);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    UILabel *saomaLabel      = [[UILabel alloc]init];
    saomaLabel.textAlignment = NSTextAlignmentCenter;
    saomaLabel.font          = [UIFont systemFontOfSize:18];
    saomaLabel.textColor     = [UIColor whiteColor];
    saomaLabel.text          = NSLocalizedString(@"手机扫码 安全登录", nil);
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.numberOfLines  = 2;
    
    tipsLabel.textAlignment  = NSTextAlignmentCenter;
    tipsLabel.font           = [UIFont systemFontOfSize:10];
    tipsLabel.textColor      = [UIColor whiteColor];
    tipsLabel.text           = NSLocalizedString(@"支持扫码快速登录二维火取餐叫号、二维火服务生手表版等应用", nil);
    [tipsLabel sizeToFit];
    [_cameraView addSubview:saomaLabel];
    [_cameraView addSubview:tipsLabel];
    
    [saomaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.scanWindowView.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.scanWindowView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(saomaLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.scanWindowView);
        make.width.mas_equalTo(200);
    }];
}

- (AVCaptureDeviceInput *) input
{
    if (!_input) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _input;
}

#pragma mark - 开始扫描
- (void)beginScan {

    //    iOS 判断应用是否有使用相机的权限
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        return;
    }
    
    if (TARGET_IPHONE_SIMULATOR) {
        
        return;
    }
    _session                          = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:self.input];
    AVCaptureMetadataOutput *output   = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
//    CGRect scanCrop = [self getScanCrop:_scanWindowView.frame readerViewBounds:_cameraView.bounds];
    
    CGRect scanCrop = [self getRectOfInterest:_scanWindowView.frame ViewoHoleBounds:_cameraView.bounds];
    
    NSLog(@"x:%f y:%f width:%f height:%f",scanCrop.origin.x,scanCrop.origin.y,scanCrop.size.width,scanCrop.size.height);
    
    output.rectOfInterest             = scanCrop;

    [_session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity                = AVLayerVideoGravityResizeAspectFill;
    layer.frame                       = _cameraView.frame;
    
    [_cameraView.layer insertSublayer:layer atIndex:0];
    [_session startRunning];
}

#pragma mark - 得到扫描二维码结果
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        SystemSoundID completeSound;
        NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"beep" withExtension:@"ogg"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(audioPath), &completeSound);
        AudioServicesPlaySystemSound(completeSound);
        
        [self sendRequestWithBarcode:metadataObject.stringValue];
        
    }
}

#pragma mark - 发送网络请求
- (void)sendRequestWithBarcode:(NSString *)Str {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:Str forKey:@"code"];
    
    [[[TDFBarcodeService alloc]init] barcodeLoginWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        //        http://10.1.5.44:8080/cash-api/calling/v1/get_login_qrcode?device_id=9f7ed06a1d53be25生成二维码code地址，
        
        TDFBarcodeScanResultModel *model = [TDFBarcodeScanResultModel yy_modelWithDictionary:[(NSDictionary *)data objectForKey:@"data"]];
        
        [self scanSuccessWithType:model.name andBarcode:Str];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [self scanFailed:error];
        
    }];
}

#pragma mark - 二维码校验正确执行事件
- (void)scanSuccessWithType:(NSString *)type andBarcode:(NSString *)barcode{
    
    [self.navigationController popViewControllerAnimated:NO];

    TDFScanLoginViewController *scanLVC = [[TDFScanLoginViewController alloc]init];
    
    scanLVC.type = type;
    scanLVC.code = barcode;
    
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:scanLVC animated:YES];
}

#pragma mark - 二维码校验错误执行事件
- (void)scanFailed:(NSError *)error {

    AlertTextView *alertView = [[AlertTextView alloc]initWithContent:error.localizedDescription location:CGPointMake(self.view.frame.size.width/2, [UIScreen mainScreen].bounds.size.height-70)];
    
    [alertView setBackColor:[UIColor colorWithRed:192/255.0 green:0 blue:6/255.0 alpha:1] alpha:1 textColor:[UIColor whiteColor]];
    [alertView setViewSizeFont:nil label:180];
    [alertView showAlertView];
    [alertView dismissAfterTimeInterval:2.0 alertFinish:^{
        
        [_session startRunning];
    }];
}

#pragma mark - 根据参数取得扫面范围reck
- (CGRect)getRectOfInterest:(CGRect)rectFrame ViewoHoleBounds:(CGRect)holeBounds {

    CGFloat x,y,width,heigth;
    
    x = (rectFrame.origin.x)/(holeBounds.size.width);
    
    y = (rectFrame.origin.y)/(holeBounds.size.height);
    
    width = (rectFrame.size.width)/(holeBounds.size.width);
    
    heigth = (rectFrame.size.height)/(holeBounds.size.height);
    
    return CGRectMake(y, x, heigth, width);
}

#pragma mark - 扫描器开始进行动画
- (void)beginAnimated {
    
    UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 5)];
    lineImgView.image        = [UIImage imageNamed:@"barcodeline"];
    
    [_scanWindowView addSubview:lineImgView];
    
    [UIView animateWithDuration:2.0 delay:00 options:UIViewAnimationOptionRepeat animations:^{
       
        lineImgView.frame    = CGRectMake(0, 200, 200, 5);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
