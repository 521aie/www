//
//  TDFTableQRCodeView.m
//  RestApp
//
//  Created by Octree on 2/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableQRCodeView.h"
#import "QRCodeGenerator.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "Seat.h"
#import "TDFQRCode.h"

@interface TDFTableQRCodeView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *staticQRCodeTitleLabel;
@property (strong, nonatomic) UILabel *staticQRCodeDetailLabel;
@property (strong, nonatomic) UILabel *dynamicQRCodeTitleLabel;
@property (strong, nonatomic) UILabel *dynamicQRCodeDetailLabel;

@end

@implementation TDFTableQRCodeView

@synthesize qrcodeSwitchButton = _qrcodeSwitchButton,
            qrcodeImageView = _qrcodeImageView,
            qrcodeMaskView = _qrcodeMaskView,
            bindView = _bindView,
            deleteButton = _deleteButton;


#pragma mark - Life Cycle

- (instancetype)initWithSeat:(Seat *)seat {

    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    
        _seat = seat;
        [self configConstraints];
        [self reloadData];
    }
    
    return self;
}


- (void)configConstraints {

    __weak __typeof(self) wself = self;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.top.equalTo(wself.mas_top).with.offset(10);
    }];
    
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(wself.titleLabel.mas_bottom).with.offset(12);
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
    }];
    [self.detailLabel sizeToFit];
    
    [self addSubview:self.staticQRCodeTitleLabel];
    [self.staticQRCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.detailLabel.mas_bottom).with.offset(28);
    }];
    
    [self addSubview:self.staticQRCodeDetailLabel];
    [self.staticQRCodeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.staticQRCodeTitleLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.qrcodeImageView];
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(wself.mas_centerX);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(235);
        make.top.equalTo(wself.staticQRCodeDetailLabel.mas_bottom).with.offset(20);
    }];
    
    [self addSubview:self.qrcodeMaskView];
    [self.qrcodeMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(wself.mas_centerX);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(235);
        make.top.equalTo(wself.staticQRCodeDetailLabel.mas_bottom).with.offset(20);
    }];
    
    [self addSubview:self.qrcodeSwitchButton];
    [self.qrcodeSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(wself.qrcodeImageView.mas_left).with.offset(0);
        make.right.equalTo(wself.qrcodeImageView.mas_right).with.offset(0);
        make.top.equalTo(wself.qrcodeImageView.mas_bottom).with.offset(15);
        make.height.mas_equalTo(40);
    }];
    
    
    [self addSubview:self.dynamicQRCodeTitleLabel];
    [self.dynamicQRCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.qrcodeSwitchButton.mas_bottom).with.offset(28);
    }];
    
    [self addSubview:self.dynamicQRCodeDetailLabel];
    [self.dynamicQRCodeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.dynamicQRCodeTitleLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.bindView];
    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.dynamicQRCodeDetailLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(100);
    }];
    
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.top.equalTo(wself.bindView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
}


- (void)updateFrame {

    __weak __typeof(self) wslef = self;
    [self.bindView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(wslef.bindView.expectedHeight);
    }];
    
    
    [self.subviews makeObjectsPerformSelector:@selector(updateConstraintsIfNeeded)];
    [self.subviews makeObjectsPerformSelector:@selector(layoutIfNeeded)];
    [self layoutIfNeeded];
    CGRect frame = self.frame;
    frame.size.height = self.deleteButton.frame.origin.y + self.deleteButton.frame.size.height + 88;
    self.frame = frame;
}



#pragma mark - Public Methods


- (void)reloadData {

    if (self.seatCode) {
    
        self.qrcodeImageView.image = [self createQRImageWithContent:self.seatCode.shortUrl name:self.seat.name];
    }
    
    [self.bindView reloadData];
    [self updateFrame];
}

#pragma mark - Private Methods

- (UIImage*)createQRImageWithContent:(NSString*)content name:(NSString*)seatName {
    UIImage* img = [QRCodeGenerator qrImageForString:content imageSize:self.qrcodeImageView.bounds.size.width];
    CGSize finalSize=CGSizeMake(400, 400);
    UIGraphicsBeginImageContext(finalSize);
    [img drawInRect:CGRectMake(30,40,340,340)];
    
    NSString* headStr=[NSString stringWithFormat:NSLocalizedString(@"桌号:%@", nil),seatName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [headStr drawInRect:CGRectMake(0, 20, 400, 30) withAttributes:@{
                                                                   NSFontAttributeName: [UIFont systemFontOfSize:25],
                                                                   NSParagraphStyleAttributeName: style
                                                                   }];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIColor *)detailTextColor {

    return [UIColor colorWithWhite:102.0/ 255 alpha:1.0];
}

#pragma mark - Accessor

- (UIButton *)deleteButton {

    if (!_deleteButton) {
    
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        _deleteButton.layer.cornerRadius = 6;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton setTitle:NSLocalizedString(@"删除此桌位", nil) forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _deleteButton;
}

- (TDFQRCodeBindView *)bindView {

    if (!_bindView) {
    
        _bindView = [[TDFQRCodeBindView alloc] initWithLimit:10];
    }
    
    return _bindView;
}

- (UILabel *)qrcodeMaskView {

    if (!_qrcodeMaskView) {
    
        _qrcodeMaskView = [[UILabel alloc] init];
        _qrcodeMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _qrcodeMaskView.textAlignment = NSTextAlignmentCenter;
        _qrcodeMaskView.text = NSLocalizedString(@"此桌码已停用", nil);
        _qrcodeMaskView.font = [UIFont systemFontOfSize:20];
        _qrcodeMaskView.textColor = [UIColor colorWithHeX:0xCC0000];
    }
    
    return _qrcodeMaskView;
}

- (UIImageView *)qrcodeImageView {

    if (!_qrcodeImageView) {
    
        _qrcodeImageView = [[UIImageView alloc] init];
        _qrcodeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _qrcodeImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    
    return _qrcodeImageView;
}

- (UIButton *)qrcodeSwitchButton {

    if (!_qrcodeSwitchButton) {
    
        _qrcodeSwitchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _qrcodeSwitchButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        _qrcodeSwitchButton.layer.cornerRadius = 6;
        _qrcodeSwitchButton.layer.masksToBounds = YES;
        [_qrcodeSwitchButton setTitle:NSLocalizedString(@"停用此二维码", nil) forState:UIControlStateNormal];
        [_qrcodeSwitchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _qrcodeSwitchButton;
}


- (UILabel *)dynamicQRCodeDetailLabel {
    
    if (!_dynamicQRCodeDetailLabel) {
    
        _dynamicQRCodeDetailLabel = [[UILabel alloc] init];
        _dynamicQRCodeDetailLabel.numberOfLines = 0;
        _dynamicQRCodeDetailLabel.font = [UIFont systemFontOfSize:15];
        _dynamicQRCodeDetailLabel.textColor = self.detailTextColor;
        _dynamicQRCodeDetailLabel.text = NSLocalizedString(@"1.如果您已经有二维火提供的已打印好的二维码，在此处与本桌进行绑定，然后将二维码贴在对应的餐桌或桌牌上供顾客使用。绑定的新二维码与上面自动生成的二维码对应的都是本桌信息。\n2.如果桌子比较大，可以贴多个不同二维码，并绑定同一个桌号，方便多位顾客一起点餐。", nil);
    }
    
    return _dynamicQRCodeDetailLabel;
}

- (UILabel *)dynamicQRCodeTitleLabel {

    if (!_dynamicQRCodeTitleLabel) {
    
        _dynamicQRCodeTitleLabel = [[UILabel alloc] init];
        _dynamicQRCodeTitleLabel.font = [UIFont systemFontOfSize:15];
        _dynamicQRCodeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _dynamicQRCodeTitleLabel.text = NSLocalizedString(@"绑定的二维码", nil);
        [_dynamicQRCodeTitleLabel sizeToFit];
    }
    
    return _dynamicQRCodeTitleLabel;
}

- (UILabel *)staticQRCodeDetailLabel {

    if (!_staticQRCodeDetailLabel) {
    
        _staticQRCodeDetailLabel = [[UILabel alloc] init];
        _staticQRCodeDetailLabel.numberOfLines = 0;
        _staticQRCodeDetailLabel.font = [UIFont systemFontOfSize:15];
        _staticQRCodeDetailLabel.textColor = self.detailTextColor;
        _staticQRCodeDetailLabel.text = NSLocalizedString(@"1.下载并打印此自动生成的二维码，贴在对应的餐桌或桌牌上。\n2.如果您店内的桌码存在被人拍走进行恶意点菜骚扰的情况，您可以停用此二维码，使用新绑定的桌码。", nil);
    }
    
    return _staticQRCodeDetailLabel;
}

- (UILabel *)staticQRCodeTitleLabel {

    if (!_staticQRCodeTitleLabel) {
    
        _staticQRCodeTitleLabel = [[UILabel alloc] init];
        _staticQRCodeTitleLabel.font = [UIFont systemFontOfSize:15];
        _staticQRCodeTitleLabel.text = NSLocalizedString(@"自动生成的二维码", nil);
        _staticQRCodeTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_staticQRCodeTitleLabel sizeToFit];
    }
    
    return _staticQRCodeTitleLabel;
}


- (UILabel *)detailLabel {

    if (!_detailLabel) {
    
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.text = NSLocalizedString(@"1.桌位二维码需要贴在对应的餐桌上或桌牌上，顾客使用二维火小二、微信、支付宝等应用扫描此二维码后，可用手机进行开单、加菜、结账、呼叫服务员等操作。\n2.服务员可以在二维火收银和二维火服务生应用上查看顾客发来的信息，为对应桌位提供服务。", nil);
        _detailLabel.textColor = self.detailTextColor;
        _detailLabel.numberOfLines = 0;
    }
    
    return _detailLabel;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
    
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = NSLocalizedString(@"本桌二维码", nil);
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}




@end
