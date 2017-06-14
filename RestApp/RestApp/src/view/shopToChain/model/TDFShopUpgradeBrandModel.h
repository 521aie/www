//
//  TDFShopUpgradeBrandModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFShopUpgradeBrandModel : NSObject
/* 序列码号
*/
@property(nonatomic, strong) NSString *code;
/**
 * 店铺名称
 */
@property(nonatomic, strong) NSString *brandName;
/**
 * 店铺编码
 */
@property(nonatomic, strong) NSString *brandCode;
/**
 * 开店的手机号码
 */
@property(nonatomic, strong) NSString *mobile;
/**
 * 管理员用户名
 */
@property(nonatomic, strong) NSString *name;
/**
 * 管理员密码
 */
@property(nonatomic, strong) NSString *password;

/**
 * 门店名称
 */
@property(nonatomic, strong) NSString *shopName;

@end
