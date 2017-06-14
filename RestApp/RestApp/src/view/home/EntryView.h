//
//  EntryView.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeModule.h"
#import "UserService.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WeixinUserInfo.h"

@interface EntryView : UIViewController
{
    UserService *userService;
    
    BOOL buttonAdd;
}
@property (nonatomic, strong) IBOutlet UILabel* lblUser;       //用户.
@property (nonatomic, strong) IBOutlet UILabel* lblDay;        //日期.
@property (nonatomic, strong) IBOutlet UIButton *btnManage;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenShop;

- (void)loadShopData;

- (IBAction)manageBtnClick:(id)sender;

- (IBAction)extraBtnClick:(id)sender;

@end
