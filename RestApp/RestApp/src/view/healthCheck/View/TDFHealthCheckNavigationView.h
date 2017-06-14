//
//  TDFHealthCheckNavigationView.h
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFHealthCheckNavigationView : UIView

@property (nonatomic, strong) void (^backBlock)();

- (void)updateTitle:(NSString *)title;

@end
