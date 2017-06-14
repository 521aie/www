//
//  orderrview.h
//  duoxuan Button
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusButton.h"
#import "orderMuluSelect.h"

@interface OrderHideSelectView : UIView <OrderMuluteDelegate>
//@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic ,assign)id<changeIteamImg> delegate;
-  (void) initDelegate:(id <changeIteamImg >)delegate;
-  (void) createViewWithArry:(NSArray *)dataArry Imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag hideColor :(UIColor*)hideColor;

- (void)createTypeViewWithCount:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag;
- (void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag;
- (void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color title:(NSString *)title;

@end
