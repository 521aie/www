//
//  MenuGridPanel.h
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainButton.h"
#import "ShopInfoVO.h"

@class HomeView;
@interface MenuGridPanel : UIViewController
{
    HomeView *homeView;
    
    NSMutableArray *dailyItems;
    
    
   
}

@property (nonatomic, strong) IBOutlet UIView* dailyBox;
@property (nonatomic, strong) IBOutlet UIView* menuBox;
@property (nonatomic, strong) IBOutlet UIView* saleBox;

@property (nonatomic ,assign) NSInteger index;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeView;

- (void)initDataView:(ShopStatusVo *)shopInfo andalliteam:(NSMutableArray *)iteams;

@end
