//
//  UIBezierPath+curved.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (curved)

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;

@end
