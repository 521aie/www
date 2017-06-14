//
//  TDFRightMenuItem.h
//  RestApp
//
//  Created by Cloud on 2017/4/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

@interface TDFRightMenuItem : DHTTableViewItem

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, copy) NSString  *title;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) void (^clickedBlock)();

@end
