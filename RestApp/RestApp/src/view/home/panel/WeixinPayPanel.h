//
//  WeixinPayPanel.h
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CMButton.h"
#import "ShopInfoVO.h"
#import <UIKit/UIKit.h>

@class HomeView;
@interface WeixinPayPanel : UIViewController<CMButtonClient>
{
    HomeView *homeView;
}
@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UILabel *lblNotOpenWXPayTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblNotOpenWXPayDetail;
@property (nonatomic, strong) IBOutlet UILabel *lblOpenWXPay;
@property (nonatomic, strong) CMButton *weixinPayBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp;

- (void)initDataView;

@end
