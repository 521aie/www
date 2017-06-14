//
//  CountriesVO.h
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface CountriesVO : EntityObject
/**
 * <code>国家ID</code>.
 */
@property (nonatomic,strong) NSString *contryId;
/**
 * <code>国家名字</code>.
 */
@property (nonatomic,retain) NSString *contryName;
/**
 * <code>经度</code>.
 */
@property (nonatomic,retain) NSString *longtitude;
/**
 * <code>纬度</code>.
 */
@property (nonatomic,retain) NSString *latitude;
/**
 * <code>国家代码</code>.
 */
@property (nonatomic,retain) NSString *countryCode;

+ (NSMutableArray *)convertToCountriesArr:(NSArray *)array;
@end
