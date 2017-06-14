//
//  CusButton.h
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CusButton;
@protocol OrderMuluteDelegate <NSObject>

-(void)MuluteDelegateTag:(CusButton *)target;

@end

@interface CusButton : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic ,assign) id <OrderMuluteDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *DetailLbl;

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;

@property (strong, nonatomic) IBOutlet UIImageView *bg;



-(void)initDelegate:(id<OrderMuluteDelegate>)delegate;
- (void)changeImg:(NSString  *)imgPath name:(NSString *)name imgcolor:(UIColor *)color Bgcolor:(UIColor *)Bgcolor select:(BOOL)select  hidecolor:(UIColor *)hidecolor ;
//- (void)loadRadiusWithcolor:(UIColor *)color  isselect:(BOOL)select  bgcolor:(UIColor*)bgcolor;

- (void)loadRadiusWithcolor:(UIColor *)color isselect:(BOOL)select  bgcolor:(UIColor*)bgcolor origincolor:(UIColor *)origincolor;

@end
