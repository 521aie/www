//
//  OrderRemindData.h
//  RestApp
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderRemindData : Jastor

@property (nonatomic ,strong)NSString *entityId;
@property (nonatomic ,assign)NSInteger labelId;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *recommendText;
@property (nonatomic ,assign)NSInteger templateType;
@property (nonatomic ,assign)NSInteger labelType;
@end
