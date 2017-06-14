//
//  TDFTableQuickBindViewController.h
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Seat;
@interface TDFTableQuickBindViewController : UITableViewController

- (instancetype)initWithSeatMap:(NSDictionary *)dictionary areas:(NSArray *)areas;

@end
