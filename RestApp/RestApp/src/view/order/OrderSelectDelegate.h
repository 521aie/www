//
//  OrderSelectDelegate.h
//  RestApp
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderDetailMoreCell;
@protocol OrderSelectDelegate <NSObject>
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType   obj:(OrderDetailMoreCell *)obj;

@end
