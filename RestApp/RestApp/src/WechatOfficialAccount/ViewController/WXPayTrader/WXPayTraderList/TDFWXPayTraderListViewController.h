//
//  TDFWXPayTraderListViewController.h
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFWXPayTraderModel.h"
/**
 *  特约商户选择页面
 */
@interface TDFWXPayTraderListViewController : UIViewController

@property (nonatomic) void(^selectBlock)(TDFTraderModel *trader);
@property (nonatomic) BOOL hideAddButton;
@property (nonatomic) void(^addButtonBlock)();

@end
