//
//  CitiesVo.h
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface CitiesVo : EntityObject

/**
 * <code>省ID</code>.
 */
@property (nonatomic,strong) NSString *provinceId;
/**
 * <code>城市ID</code>.
 */
@property (nonatomic,strong) NSString *cityId;
/**
 * <code>城市名字</code>.
 */
@property (nonatomic,retain) NSString *cityName;
/**
 * <code>经度</code>.
 */
@property (nonatomic,retain) NSString *longtitude;
/**
 * <code>纬度</code>.
 */
@property (nonatomic,retain) NSString *latitude;
/**
 * <code>城市代码</code>.
 */
@property (nonatomic, assign) long long sortCode;

+ (NSMutableArray *)convertToCityArr:(NSArray *)array;

@end
