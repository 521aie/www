//
//  ISampleMenuHandle.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@protocol ISampleMenuHandle <NSObject>

-(void) showItemEvent:(NSString*)event withObj:(id<INameValueItem>)obj;

-(void) backView;

@end
