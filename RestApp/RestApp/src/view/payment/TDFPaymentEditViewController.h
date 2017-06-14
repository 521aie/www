//
//  TDFPaymentEditViewController.h
//  RestApp
//
//  Created by 栀子花 on 2016/12/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "FooterListEvent.h"
#import "FooterListView.h"
#import "TDFRootViewController.h"
#import "TDFPaymentVO.h"
@interface TDFPaymentEditViewController : TDFRootViewController<FooterListEvent>


@property (nonatomic, strong) TDFPaymentVO *paymentVO;
@property (nonatomic, strong) NSMutableDictionary *paymentDict;

@end
