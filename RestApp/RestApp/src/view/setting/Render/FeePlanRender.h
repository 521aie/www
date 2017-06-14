//
//  FeePlanRender.h
//  RestApp
//
//  Created by zxh on 14-4-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeePlanRender : NSObject

+(NSMutableArray*) listServiceFeeMode;

+(NSMutableArray*) listMinFeeMode;

+(NSString*) obtainServiceFeeUnit:(short)calBase;

@end
