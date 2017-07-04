//
//  UIImage+TDFQRCode.h
//  RestApp
//
//  Created by guopin on 2017/6/26.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TDFQRCode)
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

+(CIImage *)creatCIQRCodeImage:(NSString *)code;
@end
