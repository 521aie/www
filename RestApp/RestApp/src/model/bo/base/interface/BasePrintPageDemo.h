//
//  BasePrintPageDemo.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BasePrintPageDemo : Base

/**
 * <code>模板分类Id</code>.
 */
@property (nonatomic,retain) NSString *kindPrintTemplateId;
/**
 * <code>模板类型</code>.
 */
@property (nonatomic,retain) NSString *templateType;
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>打印模式</code>.
 */
@property short printMode;
/**
 * <code>行宽或字符数</code>.
 */
@property int lineWidth;
/**
 * <code>左边距</code>.
 */
@property int leftMargin;
/**
 * <code>右边距</code>.
 */
@property int rightMargin;
/**
 * <code>示意图</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;

/**
 * <code>是否默认</code>.
 */
@property short isDefault;

/**
 * <code>示意图ID对应字段</code>.
 */
@property (nonatomic,retain) NSString *previewId;

/**
 * <code>餐店类型</code>.
 */
@property int shopKind;

@end
