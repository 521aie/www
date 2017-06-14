//
//  TDFWXCumulativeView.h
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

CF_EXPORT const CGFloat kTDFWXCumulativeViewDefaultHeight;

@interface TDFWXCumulativeView : UIView
@property (strong, nonatomic) NSString *fansCount;
@property (strong, nonatomic) NSString *potentialCost;
@property (strong, nonatomic) NSString *peopleCount;
@end
