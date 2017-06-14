//
//  TDFTableEditViewController.h
//  RestApp
//
//  Created by Octree on 29/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Seat;
@interface TDFTableEditViewController : UIViewController

@property (strong, nonatomic, readonly) Seat *seat;

- (instancetype)initWithSeat:(Seat *)seat scrollToQRCode:(BOOL)flag;

@end
