//
//  DataBarItem.h
//  RestApp
//
//  Created by Shaojianqing on 15/4/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBarItem : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic) double quantity;

- (id)initWithData:(NSString *)label barColor:(UIColor *)color quantity:(NSInteger)quantity;

@end
