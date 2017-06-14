//
//	TDFWXFansAnalyzeInfoModel.h
//
//	Create by 瑞旺 宋 on 17/5/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "TDFFansAnalyzeModel.h"
#import "TDFWXChartModel.h"

@interface TDFWXFansAnalyzeInfoModel : NSObject
@property (nonatomic, strong) NSArray <TDFWXChartModel *> *couponsChart;
@property (nonatomic, strong) NSString *couponsTip;
@property (nonatomic, strong) NSArray <TDFFansAnalyzeModel *> *fansAnalyze;
@property (nonatomic, strong) NSArray <TDFWXChartModel *> *fansChart;
@property (nonatomic, strong) NSString *fansTip;
@property (nonatomic, strong) NSString *potentialConsumer;
@property (nonatomic, strong) NSString *takeCardCount;
@property (strong, nonatomic) NSString *freshFansCount;
@end
