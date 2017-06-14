//
//  ProvincesVo.h
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface ProvincesVo : EntityObject
/**
 * <code>国家ID</code>.
 */
@property (nonatomic,strong) NSString *contryId;
/**
 * <code>省ID</code>.
 */
@property (nonatomic,strong) NSString *provinceId;
/**
 * <code>省名字</code>.
 */
@property (nonatomic,retain) NSString *provinceName;
/**
 * <code>经度</code>.
 */
@property (nonatomic,retain) NSString *longtitude;
/**
 * <code>纬度</code>.
 */
@property (nonatomic,retain) NSString *latitude;
/**
 * <code>省代码</code>.
 */
@property (nonatomic, assign) long long sortCode;

+ (NSMutableArray *)convertToProvincesArr:(NSArray *)array;
@end