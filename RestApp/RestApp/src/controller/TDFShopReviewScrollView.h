//
//  TDFShopReviewScrollView.h
//  RestApp
//
//  Created by xueyu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFShopReviewItem.h"
@interface TDFShopReviewScrollView : UIView

-(void)loadDatas:(NSArray *)data forawardBlock:(ForawardBlock)block;

@end
