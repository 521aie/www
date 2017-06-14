//
//  BaseShopTemplate.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseShopTemplate : EntityObject

/**
 * <code>打印模式</code>.
 */
@property short printMode;
/**
 * <code>行宽或字符数</code>.
 */
@property int lineWidth;
/**
 * <code>模板来源</code>.
 */
@property short templateSource;

/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>模板附件版本</code>.
 */
@property int attachmentVer;
/**
 * <code>数据提供器文件版本</code>.
 */
@property int providerAttachmentVer;
/**
 * <code>单据类型</code>.
 */
@property (nonatomic,retain) NSString *templateType;
/**
 * <code>系统模板ID</code>.
 */
@property (nonatomic,retain) NSString *printTemplateId;
/**
 * <code>模板文件</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;
/**
 * <code>数据提供器文件</code>.
 */
@property (nonatomic,retain) NSString *providerAttachmentId;

@property short kind;

@end
