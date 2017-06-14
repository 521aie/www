//
//  OrderDetailWeight.h
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailWeight : Jastor

@property (nonatomic ,strong)NSString *specId;
@property (nonatomic ,strong)NSString *specName;
@property (nonatomic ,assign)NSInteger specWeight;

@property (nonatomic ,assign)BOOL  Ismore;
@property (nonatomic ,assign)BOOL ischange;
@property (nonatomic ,strong)NSString *iteamName;
@property (nonatomic ,strong)NSString *iteamId;
@property (nonatomic ,strong)NSString *iteamNum;
@end
