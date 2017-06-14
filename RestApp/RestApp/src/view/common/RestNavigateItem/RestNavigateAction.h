//
//  RestNavigateAction.h
//  RestApp
//
//  Created by zxh on 14-3-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestNavigateAction <NSObject>
@optional
-(void) onNavigateItemEvent:(id)sender;
@end
