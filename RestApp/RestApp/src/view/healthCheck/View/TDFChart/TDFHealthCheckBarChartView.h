//
//  TDFHealthCheckBarChartView.h
//  RestApp
//
//  Created by 黄河 on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFHealthCheckBarChartView : UIView

@property (nonatomic, strong)NSArray *dataArray;

-(void)loadDatas:(NSDictionary *)dict;
@end

