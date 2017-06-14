//
//  BaseMenuTimePrice.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseMenuTimePrice : EntityObject

/**
 * <code>菜肴ID</code>.
 */
@property (nonatomic,retain) NSString *menuId;
/**
 * <code>价格</code>.
 */
@property double price;
/**
 * <code>是否可打折</code>.
 */
@property short isRatio;
/**
 * <code>分时段ID</code>.
 */
@property (nonatomic,retain) NSString *menuTimeId;

@end
