//
//  TDFOptionTableViewController.h
//  TDFTools
//
//  Created by Octree on 16/8/16.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFOptionTableViewController : UITableViewController

@property (copy, nonatomic) NSArray *options;
@property (copy, nonatomic) NSArray<NSNumber *> *selectedIndexs;

@end
