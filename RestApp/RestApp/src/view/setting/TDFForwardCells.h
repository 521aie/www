//
//  TDFForwardCells.h
//  RestApp
//
//  Created by Cloud on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFForwardCells : NSObject

@property (nonatomic ,copy) NSString *actionCode;

@property (nonatomic ,copy) NSString *actionId;

@property (nonatomic ,copy) NSString *clickUrl;

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *detail;

@property (nonatomic ,copy) NSString *iconUrl;

@property (nonatomic ,copy) NSString *lowestVer;


@property (nonatomic ,assign) BOOL isHide;

@property (nonatomic ,assign) BOOL isLock;

@property (nonatomic ,assign) BOOL isSuggestShow;

@property (nonatomic ,assign) BOOL open;


@end
