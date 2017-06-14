//
//  TDFWXFansAnalyzeLineChartView.h
//  RestApp
//
//  Created by tripleCC on 2017/5/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFWXChartModel.h"

@interface TDFWXFansAnalyzeLineChartView : UIView
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSArray <TDFWXChartModel *> *chart;
@end
