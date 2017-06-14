//
//  TDFActivationCodeModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/3/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFActivationCodeModel : NSObject
/**
 * 序列码号
 */
@property(nonatomic, strong) NSString *code;
/**
 * 店铺名称
 */
@property(nonatomic, strong) NSString *shopName;
/**
 * 店铺编码
 */
@property(nonatomic, strong) NSString *shopCode;
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
 * 收银同步密码
 */
@property(nonatomic, strong) NSString *otherPassword;
/**
 * 是否创建成功：0代表已经被占用，1代表未被占用
 */
@property(nonatomic, assign) int isOccupy;

@end
