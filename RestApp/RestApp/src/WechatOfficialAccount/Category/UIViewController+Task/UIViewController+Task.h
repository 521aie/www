//
//  UIViewController+Task.h
//  RestApp
//
//  Created by Octree on 4/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Task)

/**
 *  绑定 Task，推出 ViewController 时 cancel task
 *
 *  @param task task
 */
- (void)bindTask:(NSURLSessionTask *)task;

@end
