//
//  TDFHealthCheckSettingModel.h
//  RestApp
//
//  Created by xueyu on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFHealthCheckSettingModel : NSObject
/**
 * 营业面积
 */
@property (nonatomic , copy) NSString *businessArea;
/**
 * 人均消费
 */
@property (nonatomic , copy) NSString *perCapita;
/**
 * 固定成本
 */
@property (nonatomic , copy) NSString * fixedCost;
/**
 * 毛利率
 */
@property (nonatomic , copy) NSString * grossProfitRate;
/**
 * 前厅人员数量
 */
@property (nonatomic , copy) NSString * hallNum;
/**
 * 后厨人员数量
 */
@property (nonatomic , copy) NSString * kitchenNum;


@end
