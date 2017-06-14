//
//  BaseMenuDetail.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseMenuDetail : EntityObject

/**
 * <code>菜肴主键</code>.
 */
@property (nonatomic,retain) NSString *menuId;
/**
 * <code>附件类型</code>.
 */
@property short kind;
/**
 * <code>排序码</code>.
 */
@property int sortCode;
/**
 * <code>附件id</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;
/**
 * <code>说明</code>.
 */
@property (nonatomic,retain) NSString *memo;

@end
