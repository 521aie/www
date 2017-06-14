//
//  BusinessStatisticsVoList.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface BusinessStatisticsVoList : Jastor

@property (nonatomic ,strong) NSString *orderDate;

@property (nonatomic ,strong) NSString *orderMonth;

@property (nonatomic ,strong) NSString *payKindName;

@property (nonatomic ,assign) double payAmount;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
