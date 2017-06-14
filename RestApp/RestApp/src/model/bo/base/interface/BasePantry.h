//
//  BasePantry.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BasePantry : EntityObject

/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>是否配全部方案</code>.
 */
@property short isAllPlan;
/**
 * <code>是否自动切单</code>.
 */
@property short isAutoPrint;
/**
 * <code>打印机Ip</code>.
 */
@property (nonatomic,retain) NSString *printerIp;
/**
 * <code>每行字符数</code>.
 */
@property int charCount;
/**
 * <code>是否自动切单</code>.
 */
@property short isCut;
/**
 * <code>打印份数</code>.
 */
@property int printNum;
/**
 * <code>纸张宽度</code>.
 */
@property int paperWidth;
/**
 * <code>是否打印总单</code>.
 */
@property int isTotalPrint;
/**
 * <code>打印机类型</code>.
 */
@property (nonatomic,retain) NSString *printerTypeName;

@property (nonatomic,retain) NSString *printerType;

@end
