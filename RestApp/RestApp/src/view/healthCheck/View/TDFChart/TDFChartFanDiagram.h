//
//  TDFChartFanDiagram.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/1.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFChartFanDiagram : UIView

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)NSArray *colorArray;

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius;

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius
                 withDataArray:(NSArray *)dataArray
                 andColorArray:(NSArray *)colorArray;
@end
