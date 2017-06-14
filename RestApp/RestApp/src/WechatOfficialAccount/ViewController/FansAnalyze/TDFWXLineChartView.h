//
//  TDFWXLineChartView.h
//  TDFLineChart
//
//  Created by 黄河 on 2017/4/20.
//  Copyright © 2017年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFWXLinePoint : NSObject
@property (strong, nonatomic) NSString *x;
@property (assign, nonatomic) CGFloat y;
+ (instancetype)pointWithX:(NSString *)x y:(CGFloat)y;
@end

@interface TDFWXLineChartView : UIView
@property (nonatomic, strong) NSArray <NSArray <TDFWXLinePoint *> *> *lines;
@property (strong, nonatomic) NSArray <NSString *> *yAxisValues;

+ (CGFloat)yAxisValueLength:(NSString *)value;
@end
