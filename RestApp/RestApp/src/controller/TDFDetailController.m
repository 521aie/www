
//
//  TDFDetailController.m
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFDetailController.h"
#import "TDFDetailViewController.h"

@interface TDFDetailController ()



@end

@implementation TDFDetailController

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {

    if (self = [super init]) {
    
        self.viewControllers = @[[[TDFDetailViewController alloc] initWithTitle:title content:content]];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.00];
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{
                                          NSForegroundColorAttributeName: [UIColor whiteColor]
                                          };
}


@end
