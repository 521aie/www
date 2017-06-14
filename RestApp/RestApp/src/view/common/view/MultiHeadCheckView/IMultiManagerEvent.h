//
//  IMultiManagerEvent.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMultiManagerEvent <NSObject>

-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items;

-(void)managerEvent:(NSInteger)event;

-(void)closeMultiView:(NSInteger)event;

@end
