//
//  PairPickerClient.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PairPickerClient <NSObject>

- (BOOL)pickOption:(NSInteger)keyIndex valIndex:(NSInteger)valIndex event:(NSInteger)eventType;

@end
