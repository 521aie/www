//
//  TDFWxBillTotalVo.h
//  RestApp
//
//  Created by 栀子花 on 16/7/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface TDFWxBillTotalVo : Jastor
@property(nonatomic,strong)NSString *date;
@property(nonatomic,assign)NSInteger *totalFee;//总金额
@property(nonatomic,assign)NSInteger *shareIncome;
@property(nonatomic,assign)NSInteger *payTagTotalFee;//充值金额


@end
