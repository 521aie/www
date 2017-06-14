//
//  TDFShopReviewView.h
//  RestApp
//
//  Created by xueyu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ForawardBlock)(NSDictionary *dict);
typedef NS_ENUM(NSInteger,style){
   TDFShopReviewItemStyleDefaule,
   TDFShopReviewItemStyleImage,
   TDFShopReviewItemStyleNotification
};
@interface TDFShopReviewItem : UIView
- (instancetype)initWithDictionary:(NSDictionary *)dictionary forawardBlock:(ForawardBlock)callback;
@end

