//
//  TDFHealthCheckHistoryItem.h
//  RestApp
//
//  Created by happyo on 2017/5/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

typedef NS_ENUM(NSInteger, TDFHealthCheckDifferType) {
    TDFHealthCheckDifferTypeUnchanged,
    TDFHealthCheckDifferTypeUp,
    TDFHealthCheckDifferTypeDown
};

@interface TDFHealthCheckHistoryItem : DHTTableViewItem

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *score;

@property (nonatomic, strong) NSString *differScore;

@property (nonatomic, assign) TDFHealthCheckDifferType differType;

@end
