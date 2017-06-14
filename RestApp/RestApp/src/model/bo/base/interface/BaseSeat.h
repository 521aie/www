//
//  BaseSeat.h
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseSeat : EntityObject

/**
 * <code>区域ID</code>.
 */
@property (nonatomic,retain) NSString * areaId;
/**
 * <code>座位名称</code>.
 */
@property (nonatomic,retain) NSString * name;
/**
 * <code>座位代码</code>.
 */
@property (nonatomic,retain) NSString * code;
/**
 * <code>建议人数</code>.
 */
@property int adviseNum;
/**
 * <code>座位类型</code>.
 */
@property short seatKind;
/**
 * <code>顺序</code>.
 */
@property int sortCode;
/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString * memo;
/**
 * <code>是否接受预订</code>.
 */
@property short isReserve;

@property (nonatomic) NSInteger count;

@property (copy, nonatomic) NSString *seatMappingId;

@end
