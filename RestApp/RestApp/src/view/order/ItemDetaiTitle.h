//
//  ItemDetaiTitle.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IteamDetaiTitleEvent.h"
@interface ItemDetaiTitle : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *detailLbl;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblname;
@property (strong, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic ,assign)id<IteamDetaiTitleEvent>delegate;
- (IBAction)btnClick:(UIButton *)sender;

-(void)leftTitle:(NSString *)title;

-(void)loadleftTitle:(NSString *)title rightTitle:(NSString *)btnTitle delegate:(id<IteamDetaiTitleEvent>)delegate;

@end
