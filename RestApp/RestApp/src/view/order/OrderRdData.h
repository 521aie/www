//
//  OrderRdData.h
//  RestApp
//
//  Created by apple on 16/4/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderRdData : Jastor
@property (nonatomic ,assign)NSInteger labelId;
@property (nonatomic ,assign)NSInteger maxNumber;
@property (nonatomic ,assign)NSInteger maxSwitch;
@property (nonatomic ,assign)NSInteger minNumber;
@property (nonatomic ,assign)NSInteger minSwitch;
@property (nonatomic ,strong)NSString *labelName;
@end
