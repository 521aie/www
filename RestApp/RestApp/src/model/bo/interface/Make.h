//
//  Make.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseMake.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "SortItemValue.h"

@interface Make : BaseMake<INameValueItem,SortItemValue>

/**菜肴数组*/
@property (nonatomic,retain) NSString *menuArr;

/** 关键字 */
@property (nonatomic,retain) NSString *keyword;

/** 加价模式 */
@property (nonatomic) short makePriceMode;

/** 做法加价 */
@property (nonatomic) double makePrice;

@end
