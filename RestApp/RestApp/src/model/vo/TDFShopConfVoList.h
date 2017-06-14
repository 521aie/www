//
//  TDFShopConfVoList.h
//  RestApp
//
//  Created by 栀子花 on 2016/10/27.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFShopConfVoList : NSObject

@property (nonatomic, assign) NSInteger autoSend; //开关打开1，关闭0
@property (nonatomic, strong) NSString * couponId;	//优惠券ID
@property (nonatomic, strong) NSString *couponName; //	优惠券名字
@property (nonatomic, strong) NSString *shopConfId;  //开关ID
@property (nonatomic, assign) NSInteger  type;	//1是赞助 2是分享



@end
