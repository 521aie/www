//
//  SelectMenuHandle.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
@protocol SelectSingleMenuHandle <NSObject>

-(void) closeView;

@optional
-(void) finishSelect:(Menu*)menu;

@end
