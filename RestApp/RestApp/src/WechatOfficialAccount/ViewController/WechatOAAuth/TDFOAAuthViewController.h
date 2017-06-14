//
//  TDFOAAuthViewController.h
//  RestApp
//
//  Created by Octree on 16/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFOAAuthViewController : UIViewController

//@property (nonatomic) BOOL showPrompt;

@property (copy, nonatomic) NSString *authURL;
@property (nonatomic) NSInteger authPopDepthAddition;

@end
