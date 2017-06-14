//
//  TDFWXPayTraderEditViewController.h
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFWXPayTraderEditViewController : UIViewController

/**
 *  不能编辑，只能浏览
 */
@property (nonatomic) BOOL readOnly;

/**
 *  微信特约商户的 Id, 连锁需要设置
 *  单店可以为空
 */
@property (copy, nonatomic) NSString *traderId;
@property (nonatomic) NSInteger auditPopDepthAddition;

@end
