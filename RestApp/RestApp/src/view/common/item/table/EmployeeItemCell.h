//
//  EmployeeItemCell.h
//  RestApp
//
//  Created by zxh on 14-9-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHListSelectHandle.h"

@class Employee,Role;
@interface EmployeeItemCell : UITableViewCell

@property (nonatomic, strong) Employee* item;
@property (nonatomic, strong) id<DHListSelectHandle> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)loadItem:(Employee*)data role:(Role*)role delegate:(id<DHListSelectHandle>) handle;

@end
