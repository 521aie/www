//
//  TDFTableQRCodeView.h
//  RestApp
//
//  Created by Octree on 2/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFQRCodeBindView.h"

@class Seat;
@class TDFQRCode;
@interface TDFTableQRCodeView : UIView

@property (strong, nonatomic, readonly) UIButton *qrcodeSwitchButton;
@property (strong, nonatomic, readonly) UIImageView *qrcodeImageView;
@property (strong, nonatomic, readonly) UILabel *qrcodeMaskView;
@property (strong, nonatomic, readonly) TDFQRCodeBindView *bindView;
@property (strong, nonatomic, readonly) UIButton *deleteButton;
@property (strong, nonatomic) Seat *seat;
@property (strong, nonatomic) TDFQRCode *seatCode;

//  停用 & 重新启用

- (instancetype)initWithSeat:(Seat *)seat;

- (void)reloadData;

@end
