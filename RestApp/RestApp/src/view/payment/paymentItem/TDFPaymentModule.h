//
//  TDFPaymentModule.h
//  RestApp
//
//  Created by xueyu on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopInfoVO.h"
@interface TDFPaymentModule : NSObject
+(NSMutableArray *)menuActions:(ShopStatusVo *)shopInfo;
+(NSMutableArray *)menuActionsWithShopVo:(ShopInfoVO *)shopInfo;
@end
