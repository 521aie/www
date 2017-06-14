//
//  ShopReviewAlertController.m
//  RestApp
//
//  Created by Octree on 18/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopReviewAlertController.h"
#import <Masonry/Masonry.h>
#import "ShopEditView.h"
#import "MainModule.h"
#import "KabawModule.h"
#import "ActionConstants.h"
#import "BackgroundHelper.h"
#import "ShopInfoVO.h"
#import "PaymentModule.h"
#import "TDFShopReviewScrollView.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMediator+PaymentModule.h"
#import "UMMobClick/MobClick.h"
#import "TDFFunctionVo.h"
#import "TDFPaymentModule.h"
#import "TDFMediator+MemberLevelModule.h"
#import "TDFMediator+BrandModule.h"
#import "TDFMediator+MemberModule.h"


@interface ShopReviewAlertController ()

@property (strong, nonatomic) TDFShopReviewScrollView *containerView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong)ShopStatusVo *shopInfo;

@end

@implementation ShopReviewAlertController


#pragma mark - Life Cycle

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
    [self configConstrains];
    __weak typeof (self) weakSelf = self;
    [self.containerView loadDatas:[self datas] forawardBlock:^(NSDictionary *dict) {
        if ([dict[@"style"] intValue] == TDFShopReviewItemStyleNotification) {
            if ([dict[@"click"] boolValue]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"MainNotificationShowDictionary"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                dic[[[Platform Instance] getkey:ENTITY_ID]] = @(YES);
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"MainNotificationShowDictionary"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            return ;
        }
        [weakSelf forwardModule:[dict[@"code"] integerValue]];
    }];
}

#pragma mark Config Views

- (void)configViews {
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    [self.view addSubview: self.containerView];
    [self.view addSubview:self.closeButton];
    [self.view bringSubviewToFront: self.closeButton];
}

- (void)configConstrains {
    
    
    __typeof(self) __weak wself = self;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).offset(-25*SCREEN_WIDTH/320.);
        make.left.equalTo(self.view.mas_left).offset(25*SCREEN_WIDTH/320.);
        make.height.equalTo(@((SCREEN_WIDTH - 25*SCREEN_WIDTH/320.)/27.*37.));

    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.equalTo(wself.containerView.mas_right).offset(-10);
        make.top.equalTo(wself.containerView.mas_top).offset(-20);
    }];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint p = [[touches anyObject] locationInView: self.view];
    
    if (!CGRectContainsPoint(self.containerView.frame, p)) {
        
        [self dismiss];
    }
}

#pragma mark - Action

- (void)buttonTapped {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        UIViewController *shopEditView = [[TDFMediator sharedInstance]TDFMediator_shopEditViewController];
        [rootController pushViewController:shopEditView animated:YES];
    }];
}

- (void)dismiss {

    [self dismissViewControllerAnimated:YES completion:nil];
    [self umengEvent:@"click_close_prompt" attributes:nil  number:@(1)];
}

#pragma mark - Accessorcc

- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[TDFShopReviewScrollView alloc] init];
        
    }
    
    return _containerView;
}

- (UIButton *)closeButton {
    
    if (!_closeButton) {
        
        _closeButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [_closeButton setImage:[UIImage imageNamed:@"shop_review_close"] forState:UIControlStateNormal];
        _closeButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _closeButton.tintColor = [UIColor whiteColor];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize: 22];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}





#pragma mark data

-(NSArray *)datas{
    
    NSMutableArray *datas = [NSMutableArray array];
    
    if ([self.shopStatus.allKeys containsObject:@"MainNotification"]) {
        [datas addObject:@{@"image":@"mainNotification",
                           @"style":@(TDFShopReviewItemStyleNotification),
                           }];
    }
    //AliPayReputation
    if ([self.shopStatus.allKeys containsObject:@"AliPayReputation"]) {
        [datas addObject:@{@"buttonTitle":NSLocalizedString(@"参与活动", nil),
                           @"image":@"img_discount",
                           @"style":@(TDFShopReviewItemStyleImage),
                           @"code":@"7" //跳转
                           }];
    }

    if ([self.shopStatus.allKeys containsObject:@"payment"]) {
        [datas addObject:@{@"title":NSLocalizedString(@"请尽快绑定收款账户", nil),
                           @"buttonTitle":NSLocalizedString(@"立即绑定", nil),
                           @"content":NSLocalizedString(@"绑定收款账户后才能收到电子支付的钱。另外，根据央行政策，若未绑定账户，电子支付将不能使用！", nil),
                           @"image":@"shop_bank_img_top",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"1" //跳转
                           }];
    }
    if([self.shopStatus.allKeys containsObject:@"authStatus"]){
        [datas addObject:@{@"title":NSLocalizedString(@"收款账户有误，请修改", nil),
                           @"buttonTitle":NSLocalizedString(@"立即修改收款账户", nil),
                           @"content":NSLocalizedString(@"账户有误将不能收到电子支付的钱，另外，根据央行政策，若未绑定正确的账户，电子支付将不能使用！", nil),
                           @"image":@"shop_bank_warn_top",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"2"
                        }];
    }
    
    if ([self.shopStatus.allKeys containsObject:@"isCustomerPrivilegeSet"]) {
        [datas addObject:@{@"title":NSLocalizedString(@"会员营销新玩法：等级特权", nil),
                           @"buttonTitle":NSLocalizedString(@"立即设置", nil),
                           @"content":NSLocalizedString(@"会员等级特权是一套会员营销方案，你可以针对不同等级的会员设置不同的特权方案，从而提高会员活跃度。", nil),
                           @"image":@"img_privilege_new",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"3" //跳转
                           }];
    }
    
    if ([self.shopStatus.allKeys containsObject:@"hasPlate"]) {
        [datas addObject:@{@"title":NSLocalizedString(@"请添加品牌", nil),
                           @"buttonTitle":NSLocalizedString(@"立即添加", nil),
                           @"content":NSLocalizedString(@"添加品牌后，品牌旗下的所有门店可以共用一套会员等级特。无品牌的门店只能使用自己的会员等级特权。", nil),
                           @"image":@"img_plate_alert",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"4" //跳转
                           }];
    }
    
    if ([self.shopStatus.allKeys containsObject:@"hasCoinTrade"]) {
        [datas addObject:@{@"title":NSLocalizedString(@"您的二维火账户有余额未提现", nil),
                           @"buttonTitle":NSLocalizedString(@"绑定收款账户", nil),
                           @"content":NSLocalizedString(@"顾客使用二维火道具（棒棒糖、巧克力、玫瑰花）支付后，将由二维火折成现金分账给商家，请及时绑定银行卡进行收款。", nil),
                           @"image":@"shop_balance_img_top",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"5"
                           }];
    }
    
    if([self.shopStatus.allKeys containsObject:@"auditStatus"]){
        [datas addObject:@{@"title":NSLocalizedString(@"请尽快完善店家资料", nil),
                           @"buttonTitle":NSLocalizedString(@"立即提交审核", nil),
                           @"content":NSLocalizedString(@"完善资料并提交审核，只有审核通过的店才能在“二维火小二”app的千万流量频道“附近的店”中显示。", nil),
                           @"image":@"shop_review_img_top",
                           @"style":@(TDFShopReviewItemStyleDefaule),
                           @"code":@"6"
                           }];
    }
    return datas;
}

#pragma mark forward
-(void)forwardModule:(NSInteger)code{
    switch (code) {
        case 1:
            [self forwardPayment];
            break;
        case 2:
            [self forwardPayment];
            break;
        case 3:
            [self forwardPrivilege];
            break;
        case 4:
            [self forwardPlate];
        case 5:
            [self forwardPayment];
            break;
        case 6:
            [self forwardShopInfo];
            break;
        case 7:
            [self forwardAlipayReputation];
            break;
        default:
            [self dismiss];
            break;
    }
}

#pragma mark -- 设置埋点


-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}

- (void)forwardPrivilege {

    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        BOOL isBrand = [[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"];
        UIViewController *vc = isBrand ?  [[TDFMediator sharedInstance] TDFMediator_memberChainLevelViewController] :
                                          [[TDFMediator sharedInstance] TDFMediator_memberlevelViewController];
        [rootController pushViewController:vc animated:YES];
    }];
    [MobClick event:@"click_set_member_level_system"];
}

- (void)forwardPlate {

    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_brandManagerListViewControllerWithBrandCallBack:^(BOOL v) {
            
        }];
        [rootController pushViewController:vc animated:YES];
    }];
}

-(void)forwardPayment{
    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        if (self.menues.count >1) {
            [rootController pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentTypeViewControllerWithShopInfo:nil menus:self.menues codeArray:nil]  animated:YES];
        }
    }];
    [self umengEvent:@"click_complete_bank_account" attributes:nil number:@(1)];
}

-(void)forwardShopInfo{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        UIViewController *shopEditView = [[TDFMediator sharedInstance]TDFMediator_shopEditViewController];
        [rootController pushViewController:shopEditView animated:YES];
    }];
}

-(void)forwardAlipayReputation{
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        UINavigationController *rootController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        
        UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFMemAliPayKouBeiController];
        
        [rootController pushViewController:vc animated:YES];
    }];
}
@end
