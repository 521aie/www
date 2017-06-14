//
//  PaymentNoteView.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaymentNoteView.h"
#import "MBProgressHUD.h"
#import "PaymentModule.h"
#import "NavigateTitle2.h"
#import "ViewFactory.h"
#import "UIMenuAction.h"
#import "SecondMenuCell.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "Platform.h"
#import "RestConstants.h"
#import "NSString+Estimate.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "ShopInfoVO.h"
#import "YYModel.h"
@implementation PaymentNoteView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.footView.hidden = YES;
    [self initNavigate];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loadData];
}
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

    [self.footView initDelegate:self btnArrs:nil];
    [self.titleBox initWithName:NSLocalizedString(@"电子支付代收代付协议", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"电子支付代收代付协议", nil);
}

- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:PAYMENT_EDIT_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
    }
}

- (void)loadData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [hud hide:YES];
        self.shopInfoVO = [ShopInfoVO yy_modelWithDictionary:data[@"data"]];
        if ([NSString isNotBlank:self.shopInfoVO.bankAccount]) {
            self.accountName.text = self.shopInfoVO.bankAccount;
        } else {
            self.accountName.text = NSLocalizedString(@"二维火收银机使用商户", nil);
        }
        [self updateView];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
 }

-(void)updateView{

    NSString *day = [NSString stringWithFormat:@"%ld",self.shopInfoVO.fundBillHoldDay];
    self.paymentTextView1.text =[NSString stringWithFormat:NSLocalizedString(@"Bank License", nil),@"0.6%",@"0.6%",day,day] ;
    CGRect paymentTextView1Rect1 = [self.paymentTextView1.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    CGRect rect1 = self.paymentTextView1.frame;
    rect1.size = paymentTextView1Rect1.size;
    self.paymentTextView1.frame = rect1;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}



- (void)refreshUI:(UIView*)container scrollview:(UIScrollView*) scrollView
{
    CGFloat height=0;
    for (UIView*  view in container.subviews) {
        if (view.hidden == NO) {
            [view setTop:height];
            height+=view.height;
        }
        
    }
    int contentHeight= 568 -64;
    height=height>contentHeight?height:contentHeight;
    [container setHeight:(height+88)];
    if (scrollView) {
        scrollView.contentSize=CGSizeMake(320, container.height);
        [container setNeedsDisplay];
    }
}

- (void) showHelpEvent
{
}


@end

