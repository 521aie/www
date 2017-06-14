//
//  Employee.h
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseEmployee : EntityObject

/**
 * <code>部门ID</code>.
 */
@property (nonatomic,retain) NSString *departmentId;
/**
 * <code>姓名</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>性别</code>.
 */
@property short sex;
/**
 * <code>手机</code>.
 */
@property (nonatomic,retain) NSString *mobile;
/**
 * <code>身份证号</code>.
 */
@property (nonatomic,retain) NSString *idCard;
/**
 * <code>出生日期</code>.
 */
@property (nonatomic,retain) NSString *birthday;
/**
 * <code>进公司日期</code>.
 */
@property (nonatomic,retain) NSString *inDate;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;

/**
 * <code>附件</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;
/**
 * <code>身份证正面</code>.
 */
@property (nonatomic,retain) NSString *frontCertId;
/**
 * <code>身份证反面</code>.
 */
@property (nonatomic,retain) NSString *backCertId;

@end
