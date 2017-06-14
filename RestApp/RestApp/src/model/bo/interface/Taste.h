//
//  Taste.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseTaste.h"
#import "IMultiNameValueItem.h"
#import "INameValueItem.h"

@interface Taste : BaseTaste<INameValueItem,IMultiNameValueItem>

/**关键字*/
@property (nonatomic,retain) NSString *keyword;

/**
 * <code>口味分类名称</code>.
 */
@property (nonatomic,retain) NSString *kindTasteName;

@property BOOL checkVal;

@end
