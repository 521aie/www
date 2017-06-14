//
//  TDFOAAuthIntrouceViewController.h
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  公众号授权 --  介绍
 */
@interface TDFOAAuthIntrouceViewController : UIViewController

/**
 *  pop depth: 授权成功后会比预设多 pop 一层
 */
@property (nonatomic) NSInteger authPopDepthAddition;

@end
