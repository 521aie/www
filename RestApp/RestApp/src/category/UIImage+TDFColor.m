//
//  UIImage+TDFColor.m
//  RestApp
//
//  Created by chaiweiwei on 2017/1/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIImage+TDFColor.h"

@implementation UIImage (TDFColor)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
