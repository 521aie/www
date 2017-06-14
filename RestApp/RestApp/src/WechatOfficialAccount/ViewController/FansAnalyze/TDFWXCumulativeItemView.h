//
//  TDFWXCumulativeItemView.h
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFWXCumulativeItemView : UIView
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *countString;
@property (strong, nonatomic) NSString *linkString;
- (void)addTarget:(id)target linkAction:(SEL)action;
@end
