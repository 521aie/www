//
//  TDFLocationService.h
//  OCTMediator
//
//  Created by Octree on 16/7/7.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TDFLocationService;
@protocol TDFLocationServiceDelegate <NSObject>

@optional
- (void)locationService:(TDFLocationService *)service didUpdateLocation:(CLLocation *)location;
- (void)locationService:(TDFLocationService *)service didFailWithError:(NSError *)error;

@end

@interface TDFLocationService : NSObject

@property (weak, nonatomic) id<TDFLocationServiceDelegate> delegate;
//@property (strong, nonatomic, readonly) CLLocation *currentLocation;

/**
 *  singleton
 *
 *  @return shared instance
 */
+ (instancetype)sharedInstance;

/**
 *  开始定位服务
 */
- (void)triggerLocationService;

/**
 *  停止定位服务
 */
- (void)stopLocationService;
@end
