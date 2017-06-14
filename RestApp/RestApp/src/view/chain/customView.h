//
//  customVIew.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class customView;
@protocol  SelectButtonDelegate <NSObject>

- (void)btnSelectView:(customView *)obj;

@end

@interface customView : UIView

@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel *lblTitle;
@property (strong, nonatomic)  UIButton *detaiBusBtn;
@property (nonatomic ,assign)id <SelectButtonDelegate> delegate;

- (void)selectBtn:(id)sender;
- (void)iniithit:(NSString *)hit img:(NSString *)img ;
@end
