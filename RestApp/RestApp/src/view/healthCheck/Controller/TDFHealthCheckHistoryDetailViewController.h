//
//  TDFHealthCheckHistoryDetailViewController.h
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>

@interface TDFHealthCheckHistoryDetailViewController : TDFRootViewController

@property (nonatomic, strong) NSString *resultId;

@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, strong) NSString *score;

@end
