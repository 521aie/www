//
//  TDFBarChartVo.h
//  RestApp
//
//  Created by guopin on 16/6/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFBarChartVo : NSObject
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double value2;
@property (nonatomic, copy) NSString *key;
@end
