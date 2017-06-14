//
//  TDFWXBadgeItem.h
//  RestApp
//
//  Created by Octree on 13/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFComponents/DHTTableViewItem.h>

@interface TDFWXBadgeItem : DHTTableViewItem

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray *badgeNames;
@property (assign, nonatomic) int status;
@property (copy, nonatomic) UIColor *statusBadgeColor;

@end
