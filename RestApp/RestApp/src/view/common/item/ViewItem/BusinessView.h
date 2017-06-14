//
//  BusinessView.h
//  RestApp
//
//  Created by zxh on 14-8-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessSummaryVO.h"

@interface BusinessView : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblProfitAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblBillNum;
@property (nonatomic, strong) IBOutlet UILabel *lblPeopleAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgAmout;

//控件初始化.
-(void) clearData:(NSString*)dayName;

//数据加载.
-(void) loadData:(NSString*)dayName summary:(BusinessSummaryVO*)summary;

@end
