//
//  TDFAutoFollowEditViewController.h
//  RestApp
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDFAutoFollowModel;
@interface TDFAutoFollowEditViewController : UIViewController

@property (nonatomic) BOOL readOnly;
@property (strong, nonatomic) TDFAutoFollowModel *model;
@property (copy, nonatomic) NSString *traderId;

@end
