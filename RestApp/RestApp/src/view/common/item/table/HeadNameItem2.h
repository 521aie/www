//
//  HeadNameItem2.h
//  RestApp
//
//  Created by xueyu on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadNameItem2 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *panel;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
- (void)initWithName:(NSString *)name;
@end
