//
//  BaseDicItem.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseDicItem : BaseSyncShop

/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>所属系统类型ID</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;
/**
 * <code>附件版本</code>.
 */
@property int attachmentVer;
/**
 * <code>字典ID</code>.
 */
@property (nonatomic,retain) NSString *dicId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>值</code>.
 */
@property (nonatomic,retain) NSString *val;
/**
 * <code>附件ID</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;

@end
