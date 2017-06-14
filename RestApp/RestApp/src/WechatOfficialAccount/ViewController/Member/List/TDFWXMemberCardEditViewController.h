//
//  TDFWXMemberCardEditViewController.h
//  RestApp
//
//  Created by 黄河 on 2017/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "TDFRootViewController.h"
#import "TDFWXMemberCardModel.h"
@interface TDFWXMemberCardEditViewController : TDFRootViewController
@property (nonatomic, strong)TDFWXMemberCardModel *cardModel;

@property (nonatomic, copy)void(^callBack)(TDFWXMemberCardModel *cardModel);
@end
