//
//  SummaryOfMonthVO.m
//  RestApp
//
//  Created by zxh on 14-8-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SummaryOfMonthVO.h"
#import "BusinessDayVO.h"
#import "FormatUtil.h"

@implementation SummaryOfMonthVO

-(BusinessDayVO*) convertVO
{
    BusinessDayVO* vo=[BusinessDayVO new];
    vo.currDate=self.period;
    vo.totalNum=self.peopleCount;
    vo.sourceAmount=self.sourceFee;
    vo.totalAmount=self.fee;
    vo.billingNum=self.orderCount;
    vo.profitAmount=self.profit;
    vo.discountAmount=self.discountFee;
    if(self.peopleCount==0){
        vo.aveConsume=0;
    }else{
        vo.aveConsume=self.fee/self.peopleCount;
    }
    return vo;
}
@end
