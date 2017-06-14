//
//  TDFChainMemberSearchViewController.h
//  RestApp
//
//  Created by chaiweiwei on 16/7/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "MemberUserVo.h"

@interface TDFChainMemberSearchViewController : TDFRootViewController

@property (nonatomic,copy) void (^memberItemSelectedCallBack)(NSDictionary *dic);

@end

