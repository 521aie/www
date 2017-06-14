//
//  LoanCompanyVO.h
//  RestApp
//
//  Created by zishu on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanCompanyVO : NSObject
/**
 * ID
 */
@property(nonatomic ,strong) NSString *id;
/**
 * 编码
 */
@property(nonatomic ,strong) NSString *code;
/**
 * 名字
 */
@property(nonatomic ,strong) NSString *name;
/**
 * 拼写
 */
@property(nonatomic ,strong) NSString *spell;
/**
 * 地址
 */
@property(nonatomic ,strong) NSString *address;
/**
 * 手机号码
 */
@property(nonatomic ,strong) NSString *phone;
/**
 * 联系人
 */
@property(nonatomic ,strong) NSString *linkman;
/**
 * 联系号码
 */
@property(nonatomic ,strong) NSString *mobile;
/**
 * 状态：0/未启用；1/启用
 */
@property(nonatomic, assign) int status;
/**
 * 跳转URL
 */
@property(nonatomic ,strong) NSString *url;
/**
 * 有效值
 */
@property(nonatomic, assign) int isValid;
/**
 * 创建时间
 */
@property(nonatomic, assign) NSInteger createTime;
/**
 *操作时间
 */
@property(nonatomic, assign) NSInteger opTime;
/**
 *贷款状态:0/无贷款, 1/申请；2/放贷；3/驳回；4/还款；5/结束
 */
@property(nonatomic, strong) NSString *loanStatus;

//预授信额度
@property(nonatomic, strong) NSString *preAmount;

@end
