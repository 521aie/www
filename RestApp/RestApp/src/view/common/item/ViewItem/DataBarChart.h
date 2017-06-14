//
//  ItemTitle.h
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataBarChart : UIView

- (void)initWithAppearance:(UIColor *)color;

- (void)buildBarChart:(NSArray *)barItemList;

@end
