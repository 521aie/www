//
//  TDFRoleCategoryProxy.h
//  RestApp
//
//  Created by Octree on 12/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFRoleCategoryProxy : NSObject

@property (strong, nonatomic) void(^selectBlock)(NSIndexPath *indexPath);

- (instancetype)initWithTableView:(UITableView *)tableView data:(NSArray *)data;
- (void)reloadWithData:(NSArray *)data;

@end
