//
//  MainButton.h
//  RestApp
//
//  Created by zxh on 14-8-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#define MAIN_BUTTON_HEIGHT 88

#import "NetworkBox.h"
#import "HomeModule.h"
#import <UIKit/UIKit.h>
#import "UIMenuAction.h"
#import "MenuSelectHandle.h"

@class MenuSelectHandle;
@interface MainButton : UIView

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *btnImg;
@property (nonatomic, strong) IBOutlet UIImageView *imgLock;

@property (nonatomic, strong) UIMenuAction *menu;
@property (nonatomic, strong) HomeModule *homeModule;

- (void)loadData:(UIMenuAction *)menu delegate:(HomeModule *)handle;

- (IBAction)btnMenuClick:(id)sender;

@end
