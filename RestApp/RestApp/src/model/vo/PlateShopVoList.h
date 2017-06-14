//
//  PlateShopVoList.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
@interface PlateShopVoList : NSObject <INameValueItem>

/**
 *  门店entityId
 */
@property(nonatomic, strong) NSString *shopEntityId;

/**
 *  门店名字
 */
@property(nonatomic, strong) NSString *shopName;

/**
 * 1直营2加盟.
 */
@property(nonatomic, assign) int joinMode;

/**
 * 是否勾选
 */
@property(nonatomic, assign) BOOL isSelected;

@end
