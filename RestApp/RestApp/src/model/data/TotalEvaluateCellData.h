//
//  TotalEvaluateCellData.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface TotalEvaluateCellData : Jastor

@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *waiterName;
@property (nonatomic, strong) NSString *commentForWaiter;
@property (nonatomic, strong) NSString *commentForShop;
@property (nonatomic, assign) NSInteger commentStatusForWaiter;
@property (nonatomic, assign) NSInteger commentStatusForShop;
@property (nonatomic, assign) long long createdAt;

@end
