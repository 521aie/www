//
//  BaseShop.h
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseEntity.h"

@interface BaseShop : BaseEntity
/**
 * <code>代码</code>.
 */
@property (nonatomic,retain) NSString *code;
/**
 * <code>公共云注册状态</code>.
 */
@property short regStatus;
/**
 * <code>到期时间</code>.
 */
@property (nonatomic,retain) NSDate *expire;
/**
 * <code>ECP号</code>.
 */
@property (nonatomic,retain) NSString *spId;
/**
 * <code>是否已做过初始化</code>.
 */
@property short isInit;
/**
 * <code>选购的产品Id</code>.
 */
@property (nonatomic,retain) NSString *productId;
/**
 * <code>1直营2加盟</code>.
 */
@property short joinMode;
/**
 * <code>品牌ID</code>.
 */
@property (nonatomic,retain) NSString *brandId;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;
/**
 * <code>状态</code>.
 */
@property (nonatomic) short status;
/**
 * <code>客户类型</code>.
 */
@property short customerKind;

/**
 * <code>连锁的EntityId</code>.
 */
@property (nonatomic,retain) NSString *brandEntityId;

/**
 * <code>文件服务器Id</code>.
 */
@property (nonatomic,retain) NSString *fileServerId;

/**
 * <code>文件服务器</code>.
 */
@property (nonatomic,retain) NSString *fileServer;

/**
 * <code>是否开通淘宝</code>.
 */
@property short isTaobao;
/**
 * <code>适用的子类型</code>.
 */
@property (nonatomic,copy)NSString *subType;

@end
