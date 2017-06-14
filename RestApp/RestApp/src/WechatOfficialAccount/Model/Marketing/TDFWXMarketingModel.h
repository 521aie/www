//
//  TDFWXMarketingModel.h
//  RestApp
//
//  Created by Octree on 14/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"


@interface TDFWXMarketingModel : TDFBaseModel

/**
 *  是否已经被加入连锁的特约商户中
 */
@property (nonatomic) BOOL managedByChain;
/**
 *  是否已经被加入连锁的公众号中
 */
@property (nonatomic) BOOL isWxManagedByChain;
/**
 *  特约商户退款功能申请状态
 */
@property (nonatomic) NSInteger refundApplyStatus;
/**
 *  退款开通数量
 */
@property (nonatomic) NSInteger  refundApplyEstablishCount;
/**
 *  自动关注状态
 */
@property (nonatomic) NSInteger wxAutoFollowStatus;
/**
 *  自动关注开通数量
 */
@property (nonatomic) NSInteger wxAutoFollowEstablishCount;
/**
 *  微信公众号授权数量
 */
@property (nonatomic) NSInteger wxoaAuthCount;
/**
 *  店家公众号授权状态
 */
@property (nonatomic) NSInteger wxoaAuthStatus;
/**
 *  微信支付特约商户申请状态
 */
@property (nonatomic) NSInteger wxpayTraderApplyStatus;
/**
 *  微信支付特约商户开通数量 
 */
@property (nonatomic) NSInteger wxpayTraderEstablishCount;

@end
