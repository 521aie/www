//
//  TDFLocationService.m
//  OCTMediator
//
//  Created by Octree on 16/7/7.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import "TDFLocationService.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface TDFLocationService ()<AMapLocationManagerDelegate>

@property (strong, nonatomic) AMapLocationManager *locationManager;
//@property (strong, nonatomic) MAMapView *mapView;

@end

@implementation TDFLocationService

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {

    static TDFLocationService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[TDFLocationService alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {

    if (!location) return;
    
//    _currentLocation = location;
    if ([self.delegate respondsToSelector:@selector(locationService:didUpdateLocation:)]) {
    
        [self.delegate locationService:self didUpdateLocation: location];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {

    if ([self.delegate respondsToSelector: @selector(locationService:didFailWithError:)]) {
    
        [self.delegate locationService:self didFailWithError:error];
    }
}


#pragma mark - Public method

- (void)triggerLocationService {

    [self.locationManager startUpdatingLocation];
}

- (void)stopLocationService {

    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Private method

//- (void)startUpdatingLocation {
//
//    [self.locationManager startUpdatingLocation];
//}
//

#pragma mark - Accessor

- (AMapLocationManager *)locationManager {

    if (!_locationManager) {
    
        _locationManager = [[AMapLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
    }
    
    return _locationManager;
}


@end
