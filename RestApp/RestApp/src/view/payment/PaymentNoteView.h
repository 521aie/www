//
//  PaymentNoteView.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "ISampleListEvent.h"
#import "XHAnimalUtil.h"
#import "TDFRootViewController.h"
@class PaymentModule, MBProgressHUD, ShopInfoVO;
@interface PaymentNoteView : TDFRootViewController<INavigateEvent,ISampleListEvent,FooterListEvent>
{
    PaymentModule *parent;
    
    MBProgressHUD *hud;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *paymentTextView1;
//@property (nonatomic, strong) IBOutlet UILabel *paymentTextView2;
@property (nonatomic, strong) IBOutlet UITextView *accountName;
//@property (nonatomic, strong) IBOutlet UILabel *accountBank;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
@property (nonatomic, assign) NSInteger showType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp;

- (void)loadData;

@end
