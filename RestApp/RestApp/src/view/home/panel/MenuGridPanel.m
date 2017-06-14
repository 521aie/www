//
//  MenuGridPanel.m
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeView.h"
#import "MainButton.h"
#import "HomeModule.h"
#import "UIView+Sizes.h"
#import "GlobalRender.h"
#import "MenuGridPanel.h"
#import "FuctionActionData.h"
#import "GlorenMenuModules.h"
#import "UIMenuDetaiAction.h"
#import "ActionConstants.h"
#import "ShopReviewCenter.h"

@implementation MenuGridPanel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeView = homeViewTemp;
        dailyItems = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)initDataView:(ShopStatusVo *)shopInfo andalliteam:(NSMutableArray *)iteams
{
    if ([self isChain]) {
        [dailyItems removeAllObjects];
//        dailyItems =[GlorenMenuModules listChainIteam:shopInfo];
        [self renderMenuGridView:dailyItems container:self.dailyBox];
    }else if([self isBranch]) {
        [dailyItems removeAllObjects];
        dailyItems =[GlorenMenuModules listChainBranchIteam];
        [self renderMenuGridView:dailyItems container:self.dailyBox];
    }else {
        
        NSMutableArray *arry =[[NSMutableArray alloc]init];
        NSMutableArray *arry1 =[[NSMutableArray alloc]init];
        NSMutableArray *arrt2 =[[NSMutableArray alloc]init];
        NSMutableArray *memberArry =[[NSMutableArray alloc]init];
        
        [dailyItems removeAllObjects];
//        NSMutableArray *dataArr =[GlorenMenuModules listNavigateIteamDaily:shopInfo];
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        if (dailyItems.count<=0) {
            if (iteams!=nil && iteams.count>0) {
                for (FuctionActionData *data in iteams) {
                    NSString *str =[NSString stringWithFormat:@"%@",data.code];
                    NSString *namestr =[NSString stringWithFormat:@"%@",data.name];
                    //服务器是否显示
                    if (data.status ==1) {
                        if (data.isUserHide ==3) {
                            for (UIMenuDetaiAction *menu in dataArr ) {
                                if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
                                    
                                    if ([str isEqualToString:PAD_WEIXIN_SUM] || [str isEqualToString:PAD_WEIXIN_DETAL]) {
                                        
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                        
                                        
                                    }
                                } else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)]) {
                                    
                                    if ([str isEqualToString:PHONE_KOUBEI_SHOP]) {
                                        
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                    }
                                }else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)]) {
                                    
                                    if ([str isEqualToString:PAD_MENU]) {
                                        
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)])
                                {
                                    if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]|| [str isEqualToString:PAD_DEGREE_EXCHANGE]||[str isEqualToString:PHONE_MEMBER_LIST]||[str isEqualToString:PHONE_CARD_CHANGE]) {
                                        [memberArry addObject:data];
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                        
                                        
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)])
                                {
                                    if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString:PHONE_CHANGE_SKIN] || [str isEqualToString:PHONE_MENU_PICTURE_PAGE]) {
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                        
                                        
                                    }
                                    
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)])
                                {
                                    if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
                                        if (data.isHide ==0||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                        
                                        
                                    }
                                    
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)])
                                {
                                    if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString: CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]) {
                                        if (data.isHide ==0 ||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                        if (data.isHide==1) {
                                            [arrt2 addObject:menu];
                                        }
                                        
                                        
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)])
                                {
                                    if ([str isEqualToString:PAD_SIGN_BILL]) {
                                        if (data.isHide ==0 ||data.isHide==3) {
                                            [arry addObject:menu];
                                        }
                                    }
                                }
                                else if ([menu.name isEqualToString:namestr]  ) {
                                    if (data.isHide ==0 ||data.isHide==3) {
                                        [arry addObject:menu];
                                    }
                                    
                                }
                                //剔除重复数据
                                arry1 =[self removesameiteaminarry:arry];
                            }
                        }
                        else if (data.isUserHide ==0)
                            
                        {
                            for (NSInteger i=0; i<dataArr.count;i++) {
                                UIMenuDetaiAction *menu = dataArr[i];
                                if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
                                    
                                    if ([str isEqualToString:PAD_WEIXIN_SUM] || [str isEqualToString:PAD_WEIXIN_DETAL]) {
                                        [arry addObject:menu];
                                    }
                                }else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)]) {
                                    
                                    if ([str isEqualToString:PHONE_KOUBEI_SHOP]) {
                                        [arry addObject:menu];
                                    }
                                }else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)]) {
                                    
                                    if ([str isEqualToString:PAD_MENU]) {
                                        [arry addObject:menu];
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)])
                                {
                                    if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]|| [str isEqualToString:PAD_DEGREE_EXCHANGE]||[str isEqualToString:PHONE_CARD_CHANGE]||[str isEqualToString:PHONE_MEMBER_LIST]) {
                                        [memberArry addObject:data];
                                        [arry addObject:menu];
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)])
                                {
                                    if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString:PHONE_CHANGE_SKIN] || [str isEqualToString:PHONE_MENU_PICTURE_PAGE]) {
                                        
                                        [arry addObject:menu];
                                    }
                                    
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)])
                                {
                                    if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
                                        [arry addObject:menu];
                                    }
                                    
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)])
                                {
                                    if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString: CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]) {
                                        [arry addObject:menu];
                                    }
                                }
                                else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)])
                                {
                                    if ([str isEqualToString:PAD_SIGN_BILL]) {
                                        [arry addObject:menu];
                                    }
                                }
                                else if ([menu.name isEqualToString:namestr ]  ) {
                                    [arry addObject:menu];
                                    
                                }
                                //剔除重复数据
                                arry1 =[self removesameiteaminarry:arry];
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                }
            }
            
            NSMutableArray *arry3 =[self removesameiteaminarry:arrt2];
            [arry1 removeObjectsInArray:arry3];
            self.index =0;
            for (FuctionActionData *data in memberArry) {
                if (data.isUserHide!=1) {
                    if (data.isHide!=1) {
                        self.index++;
                    }
                }
            }
            
            //排序
            for (NSInteger i=0; i<dataArr.count; i++) {
                UIMenuDetaiAction *menu1 =dataArr[i];
                for (UIMenuDetaiAction *obj in arry1) {
                    if ([menu1.name isEqualToString:obj.name]) {
                        [dailyItems addObject:menu1];
                    }
                }
            }
            
        }
        if (self.index==memberArry.count && self.index>4) {
            for (UIMenuDetaiAction *data in dataArr) {
                if ([data.name isEqualToString:NSLocalizedString(@"会员", nil)]) {
                    [dailyItems addObject:data];
                }
            }
        }
        else
        {
            for (UIMenuDetaiAction *data in dataArr) {
                if ([data.name isEqualToString:NSLocalizedString(@"会员", nil)]) {
                    [dailyItems removeObject:data];
                }
            }
        }
        dailyItems =[self removesameiteaminarry:dailyItems];
        NSMutableArray *menuALLArr =[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<dataArr.count; i++) {
            UIMenuDetaiAction *menu1 =dataArr[i];
            for (UIMenuDetaiAction *obj in dailyItems) {
                if ([menu1.name isEqualToString:obj.name]) {
                    [menuALLArr addObject:menu1];
                }
            }
        }

        [self renderMenuGridView:menuALLArr container:self.dailyBox];
    }
}


- (void)updateViewSize
{
    CGFloat yAxis = 0;
    NSArray *subViews = self.view.subviews;
    for (UIView *view in subViews) {
        [view setTop:yAxis];
        yAxis+=view.height;
    }
}
- (NSMutableArray *)removesameiteaminarry:(NSMutableArray *)arry
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    for (NSInteger i=0; i<arry.count ;i++) {
        UIMenuAction *menu =arry[i];
        if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
            menu.img=@"ico_elect_pay";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)]) {
            menu.name =NSLocalizedString(@"顾客端设置", nil);
            menu.img = @"weidianyingxiao.png";
//            menu.showBadge = [ShopReviewCenter sharedInstance].shouldShowWarningBadge;
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)]) {
            menu.img =@"img_member_small";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)]) {
            menu.img =@"ico_nav_baobiao";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)]) {
            menu.img =@"ico_nav_pingjia";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"红包", nil)]) {
            menu.img =@"ico_nav_hongbao_trans" ;
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"短信营销", nil)]) {
            menu.img =@"ico_nav_duanxinyingxiao_trans";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"生活圈", nil)]) {
            menu.name =NSLocalizedString(@"生活圈", nil);
            menu.img =@"ico_nav_shenghuoquan_trans";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)]) {
            menu.img =@"ico_nav_guazhangchuli_trans";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"商品促销", nil)]) {
            menu.img=@"ico_nav_menutime_trans";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"智能点餐", nil)])
        {
            menu.img =@"ico_color_order_trans";
        }
        else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)])
        {
            menu.img =@"ico_koubei";
        }else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)])
        {
            menu.img =@"chainmenu";
        }
        [dic setObject:menu forKey:menu.code];
    }
    
    return [[dic allValues] mutableCopy];
}

- (void)renderMenuGridView:(NSArray *)itemList container:(UIView *)container
{
    NSArray *viewList = [container subviews];
    UIView *view = nil;
    MainButton *btn= nil;
    int index=0;
    
    for (UIView *view in viewList) {
        view.hidden=YES;
    }
    
    for (int i=0; i<itemList.count; i++) {
        view=[viewList objectAtIndex:index];
        UIMenuAction *menuData = [itemList objectAtIndex:i];
        if (![view isKindOfClass:[MainButton class]]) {
            continue;
        }
        btn = (MainButton *)view;
        [btn loadData:menuData delegate:[HomeModule sharedInstance]];
        ++index;
    }
    
    CGFloat height = 0;
    if (itemList.count%4==0) {
        height = MAIN_BUTTON_HEIGHT*(itemList.count/4);
    } else {
        height = MAIN_BUTTON_HEIGHT*(itemList.count/4+1);
    }
    
    
    [container setHeight:height];
}
- (BOOL)isChain
{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]) {
        return YES;
    }
    return NO;
}
- (BOOL)isBranch
{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRANCH]]) {
        return YES;
    }
    return NO;
}

@end
