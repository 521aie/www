//
//  TimeArrangeVO.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimeArrange.h"
#import "INameValueItem.h"

@interface TimeArrangeVO : TimeArrange<INameValueItem>

/** 开始时间. */
@property (nonatomic,retain) NSString *btime;

/** 结束时间. */
@property (nonatomic,retain) NSString *etime;

-(NSString*) getBtimeStr;
-(NSString*) getEtimeStr;

@end
