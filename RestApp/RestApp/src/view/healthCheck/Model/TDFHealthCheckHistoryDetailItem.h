//
//  TDFHealthCheckHistoryDetailItem.h
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

typedef NS_ENUM(NSInteger, TDFHealthCheckLevelType) {
    TDFHealthCheckLevelTypeNormal,
    TDFHealthCheckLevelTypeToBeImproved,
    TDFHealthCheckLevelTypeNeedOptimize
};

@interface TDFHealthCheckHistoryDetailItem : DHTTableViewItem

@property (nonatomic, strong) NSString *iconUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, assign) TDFHealthCheckLevelType levelType;

@property (nonatomic, strong) NSString *levelDesc;

@end
