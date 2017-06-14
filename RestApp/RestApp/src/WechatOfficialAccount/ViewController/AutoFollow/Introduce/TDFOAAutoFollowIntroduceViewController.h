//
//  TDFOAAutoFollowIntroduceViewController.h
//  RestApp
//
//  Created by Octree on 4/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFWXPayTraderModel.h"
/**
 *  公众号自动关注
 */
@interface TDFOAAutoFollowIntroduceViewController : UIViewController

/**
 *  是否已经开通
 */
@property (nonatomic) BOOL alreadyOpend;
@property (copy, nonatomic) NSString *traderId;
@property (nonatomic) TDFAutoFollowAuditStatus status;
@property (nonatomic) TDFWXPayTraderAuditStatus traderStatus;

@end
