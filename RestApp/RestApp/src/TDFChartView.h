//
//  TDFChartView.h
//  RestApp
//
//  Created by happyo on 2016/12/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFPoint : NSObject

@property (assign, nonatomic) CGFloat x;

@property (assign, nonatomic) CGFloat y;

+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y;

@end

@interface TDFLine : NSObject

@property (nonatomic, strong) NSArray<TDFPoint *> *points;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) NSString *title;

@end

@interface TDFChartView : UIView

@property (nonatomic, strong) NSArray <TDFLine *> *lines;

@property (strong, nonatomic) NSArray <NSString *> *yAxisValues;

@property (nonatomic, assign) CGFloat yMax;

@property (nonatomic, strong) NSArray <NSString *> *xAxisValues;

@property (nonatomic, strong) UIColor *axisColor;

@property (nonatomic, strong) UIColor *xLabelColor;

@property (nonatomic, strong) UIColor *yLabelColor;

@property (nonatomic, assign) BOOL showPointCircle;

@property (nonatomic, assign) BOOL showPointLabel;

@end

