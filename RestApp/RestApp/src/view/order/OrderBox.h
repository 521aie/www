//
//  OrderBox.h
//  RestApp
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGuiGeView.h"
@interface OrderBox : UIView
@property (strong, nonatomic) IBOutlet OrderGuiGeView *bgview;

@property (strong, nonatomic) IBOutlet UIView *view;
-(void)createIteam:(NSArray *)arry;
-(CGFloat )getHeight;
@end
