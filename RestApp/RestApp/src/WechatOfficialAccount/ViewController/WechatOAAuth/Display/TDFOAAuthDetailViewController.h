//
//  TDFOAAuthDetailViewController.h
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  微信公众号授权   ---   详情页面
 */
@class TDFOfficialAccountModel;
@interface TDFOAAuthDetailViewController : UIViewController

@property (nonatomic) NSUInteger popDepth;
@property (strong, nonatomic) TDFOfficialAccountModel *officialAccount;

@end
