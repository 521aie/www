//
//  TDFLeftHandSectionHeaderView.h
//  RestApp
//
//  Created by happyo on 2017/6/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFLeftHandSectionHeaderView : UIView

@property (nonatomic, strong) void (^clickedBlock)(NSString *clickUrl);

- (void)configureViewWithTitle:(NSString *)title more:(NSString *)more clickUrl:(NSString *)clickUrl;

@end
