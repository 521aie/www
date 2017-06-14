//
//  SimpleBranchVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleShopVo.h"
#import "PlateShopVoList.h"

@interface SimpleBranchVo : NSObject<INameValueItem>
/**
 * branch id
 */
@property(nonatomic, strong) NSString *branchId;

// 分公司编码
@property(nonatomic, strong) NSString *branchCode;

// 分公司名称
@property(nonatomic, strong) NSString *branchName;

@property(nonatomic, assign) BOOL selected;

/**
 * 分公司下的门店
 */
@property(nonatomic, strong) NSMutableArray *simpleShopVoList;



@end
