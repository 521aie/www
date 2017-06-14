//
//  ShopEvaluateCellData.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface ShopEvaluateCellData : Jastor

@property (nonatomic ,strong) NSString  *customerName;
@property (nonatomic ,assign) Byte commentStatus;
@property (nonatomic ,strong) NSString *comment;
@property (nonatomic ,assign) long long createdAt;

@end
