//
//  Target_MemberModule.m
//  RestApp
//
//  Created by happyo on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_MemberModule.h"
#import "CardPublishView.h"
#import "SystemUtil.h"
#import "TDFPromotionListViewConroller.h"
#import "TDFPromotionViewController.h"
#import "SmsListView.h"
#import "SmsReChargeView.h"
#import "SmsOrderConfirmView.h"
#import "SmsTemplateView.h"
#import "KindCardListView.h"
#import "TDFKindCardEditViewController.h"
#import "CardCoverListView.h"
#import "TDFmemberCoupon.h"
#import "MoneyRuleEditView.h"
#import "TDFMemberCouponEditView.h"
#import "TDFRechargeViewController.h"
#import "GiftListView.h"
#import "GiftEditView.h"
#import "MemberView.h"
#import "CardPublishView.h"
#import "MemberRecordView.h"
#import "MemberInfoSummaryView.h"
#import "MemberRecordDayView.h"
#import "TDFmemberStoreValueViewController.h"
#import "TDFMemberSearchViewController.h"
#import "TDFMemberDepositViewController.h"
#import "MemberGiftChangeView.h"
#import "TDFMemberInfoViewController.h"
#import "TDFMScoreGivenViewController.h"
#import "TDFChangeMemberCardPwdViewController.h"
#import "TDFMemberManageViewController.h"
#import "TDFMemberLimitViewController.h"
#import "TDFAddCouponViewController.h"
#import "TDFMemberNewEditController.h"
#import "TDFEditDetailController.h"
#import "TDFMemberSelectGoodsController.h"
#import "TDFCouponBGImgController.h"
#import "TDFMemChooseMakeController.h"
#import "TDFMemChooseBrandController.h"
#import "TDFDiscountLimitSetController.h"
#import "SmsEditView.h"
#import "TDFRechargeCardViewController.h"
#import "TDFMemAliPayKouBeiController.h"
#import "TDFSendChainCardSettingViewController.h"
#import "TDFMemberGiveCardViewController.h"
#import "TDFMemberSwitchViewController.h"
#import "TDFGiftRechargeViewController.h"
#import "TDFMemberBackCardViewController.h"
#import "TDFMemberDegreeValueViewController.h"
#import "TDFMPointsExchangeViewController.h"
#import "TDFTodayVipSpendController.h"
#import "LifeInfoEditView.h"
#import "LifeInfoListView.h"

@implementation Target_MemberModule


// 会员卡 CardPublishView
- (UIViewController *)Action_nativeSendMemberCardViewController:(NSDictionary *)params{
    NSNumber *shouldHideOldNavBar = params[@"shouldHidden"];
    CardPublishView *vc = [[CardPublishView alloc] initWithNibName:@"CardPublishView" bundle:nil];
    vc.needHideOldNavigationBar = [shouldHideOldNavBar boolValue];
    return vc;
}

// 促销活动列表
- (UIViewController *)Action_nativePromotionListViewController:(NSDictionary *)params;
{
    TDFPromotionListViewConroller *vc = [[TDFPromotionListViewConroller alloc] init];
    
    return vc;
}

// 促销活动详情
- (UIViewController *)Action_nativePromotionDetailViewController:(NSDictionary *)params

{
    TDFPromotionViewController *vc =[[TDFPromotionViewController alloc] init];
    TDFPromotionVO *vo = params[@"promotionVO"];
    vc.promotionVO = vo;
    
    NSNumber *isAddNum = params[@"isAdd"];
    vc.isAdd = [isAddNum boolValue];
    vc.delegate = params[@"delegate"];
    
    return vc;
}
// 生活圈
- (UIViewController *)Action_nativeLifeInfoListViewController:(NSDictionary *)params{
    LifeInfoListView *vc = [[LifeInfoListView alloc]initWithNibName:[SystemUtil getXibName:@"LifeInfoListView"] bundle:nil parent:nil];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

- (UIViewController *)Action_nativeLifeInfoEditViewController:(NSDictionary *)params{
    LifeInfoEditView  *vc = [[LifeInfoEditView alloc]initWithNibName:[SystemUtil getXibName:@"LifeInfoEditView"] bundle:nil parent:nil];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

- (UIViewController *)Action_nativeSmsListViewController:(NSDictionary *)params{

    SmsListView *vc = [[SmsListView alloc] init];
    return vc;
}

//短信编辑
- (UIViewController *)Action_nativeSmsEditViewController:(NSDictionary *)params{
    SmsEditView *vc = [[SmsEditView alloc]init];
    vc.domesticRemainCount = [params[@"domesticremainCount"] integerValue];
    vc.overseasRemainCount = [params[@"overseasremainCount"] integerValue];
    vc.callback = params[@"callback"];
    vc.isCouponShare = [[params allKeys] containsObject:@"isCouponShare"]?[params[@"isCouponShare"] boolValue]:NO;
    
    vc.couponTicketId = [[params allKeys] containsObject:@"couponTicketId"]?params[@"couponTicketId"]:nil;
    
    vc.membertext = [[params allKeys] containsObject:@"membertext"]?params[@"membertext"]:nil;
    
    vc.promotiontext = [[params allKeys] containsObject:@"promotiontext"]?params[@"promotiontext"]:nil;
    
    vc.needHideOldNavigationBar = YES;
    return vc;
    
}

//短信模板
- (UIViewController *)Action_nativeSmsTemplateViewController:(NSDictionary *)params{
    
    SmsTemplateView *vc = [[SmsTemplateView alloc]initWithNibName:@"SmsTemplateView" bundle:nil];
    vc.params = params;
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

//接收人群
-(UIViewController *)Action_nativeSmsReciverListViewController:(NSDictionary *)params{
    
    SmsReciverListView *vc = [[SmsReciverListView alloc]initWithNibName:@"SmsReciverListView" bundle:nil ];
    vc.dict = params;
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}


- (UIViewController *)Action_nativeSmsReChargeViewController:(NSDictionary *)params{
    SmsReChargeView *vc = [[SmsReChargeView alloc]init];
    vc.params = params;
    return vc;
}

- (UIViewController *)Action_nativeSmsOrderConfirmViewController:(NSDictionary *)params{
    SmsOrderConfirmView *vc = [[SmsOrderConfirmView alloc]initWithNibName:@"SmsOrderConfirmView" bundle:nil];
    vc.params = params;
    vc.needHideOldNavigationBar = YES;
    return vc;
}

- (UIViewController *)Action_nativeKindCardListViewController:(NSDictionary *)params{
    KindCardListView *vc = [[KindCardListView alloc]init];
    
    vc.needHideOldNavigationBar = YES;
    return vc;
}

- (UIViewController *)Action_nativeKindCardEditViewController:(NSDictionary *)params{
    TDFKindCardEditViewController *vc = [[TDFKindCardEditViewController alloc]init];
    vc.cardType = [params[@"cardType"] integerValue];
    vc.callback = params[@"callback"];
    vc.kindCard = params[@"kindCard"];
    vc.kindCards = params[@"datas"];
    return vc;
}

//会员卡背景
- (UIViewController *)Action_nativeCardCoverListViewController:(NSDictionary *)params{
    CardCoverListView *vc = [[CardCoverListView alloc]initWithNibName:@"CardCoverListView" bundle:nil];
    vc.fontColor = params[@"fontColor"];
    vc.shopName = params[@"shopName"];
    vc.cardName = params[@"cardName"];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

//优惠券列表
- (UIViewController *)Action_nativeTDFMemberCouponViewController:(NSDictionary *)params{
    TDFmemberCoupon *vc = [TDFmemberCoupon new];
    vc.couponBlock = params[@"callback"];
    vc.type = [params[@"type"] integerValue];
    vc.plateEntityId = [params objectForKey:@"plateEntityId"];
    vc.plateId = [params objectForKey:@"plateId"];
    vc.plateShopName = [params objectForKey:@"plateName"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberCouponEditViewController:(NSDictionary *)params{
    TDFMemberCouponEditView *vc = [TDFMemberCouponEditView new];
    vc.callback = params[@"callback"];
    vc.action = [params[@"action"] intValue];
    vc->originObj = params[@"data"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberPlantEditViewController:(NSDictionary *)params{
    TDFMemberPlantEditView *vc = [TDFMemberPlantEditView new];
    vc.params = params;
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}
-(UIViewController *)Action_nativeTDFMemberCheckCouponViewController:(NSDictionary *)params{
    TDFMemberCheckCouponView *vc = [TDFMemberCheckCouponView new];
    vc.callback = params[@"callback"];
    vc.data = params[@"data"];
    vc.delegate = [params objectForKey:@"vc"];
    return vc;
}

-(UIViewController *)Action_nativeTDFRechargeViewController:(NSDictionary *)params{

    TDFRechargeCardViewController *vc  = [TDFRechargeCardViewController  new];
    vc.needHideOldNavigationBar  = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFMoneyRuleEditViewController:(NSDictionary *)params{
    MoneyRuleEditView *vc = [[MoneyRuleEditView alloc]initWithNibName:@"MoneyRuleEditView" bundle:nil parent:nil];
    vc.action = [params[@"action"] intValue];
    vc.moneyRules = params[@"moneyRule"];
    vc.kindCard = params[@"kindcard"];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}



-(UIViewController *)Action_nativeTDFGiftListViewController:(NSDictionary *)params{
    GiftListView *vc = [[GiftListView alloc]init];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFGiftEditViewController:(NSDictionary *)params{
    GiftEditView *vc = [[GiftEditView alloc]initWithNibName:@"GiftEditView" bundle:nil];
    vc.action = [params[@"action"] intValue];
    vc.gift = params[@"gift"];
    vc.callback = params[@"callback"];
    vc.giftType = [params[@"giftType"] intValue];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFCardPublishViewController:(NSDictionary *)params{
    CardPublishView *vc = [[CardPublishView alloc]initWithNibName:@"CardPublishView" bundle:nil];
    vc.needHideOldNavigationBar = YES;
    return vc;
}


//-(UIViewController *)Action_nativeTDFMemberPublishViewController:(NSDictionary *)params{
//    MemberPublishView *vc = [[MemberPublishView alloc]initWithNibName:@"MemberPublishView" bundle:nil parent:nil];
//    vc.isCardApp = [params[@"isCardApp"] boolValue];
//    vc.keyWord = params[@"keyword"];
//    vc.memberCards = params[@"cards"];
//    vc.cardDatas = params[@"kindcards"];
//    vc.remainNum = [params[@"remainNum"] integerValue];
//    vc.evenType = [params[@"action"] integerValue];
//    vc.callback = params[@"callback"];
//    vc.needHideOldNavigationBar = YES;
//    return vc;
//}

//-(UIViewController *)Action_nativeTDFMemberSwitchViewController:(NSDictionary *)params{
//    MemberSwitchView *vc = [[MemberSwitchView alloc]initWithNibName:@"MemberSwitchView" bundle:nil];
//    vc.inputMobile = params[@"keyword"];
//    vc.allCards = params[@"kindcards"];
//    vc.memberCards = params[@"cards"];
//    vc.currentCard = [params[@"index"] integerValue];
//    vc.isCardApp = [params[@"isCardApp"] boolValue];
//    vc.remainNum = [params[@"remainNum"] integerValue];
//    vc.action = [params[@"action"] integerValue];
//    vc.callback = params[@"callback"];
//    vc.needHideOldNavigationBar = YES;
//    return vc;
//}

-(UIViewController *)Action_nativeTDFMemberGiveCardViewController:(NSDictionary *)params {
    TDFMemberGiveCardViewController *viewController = [[TDFMemberGiveCardViewController alloc] init];
    viewController.callBack = params[@"callBack"];
    viewController.searchMobile = params[@"mobile"];
    viewController.countryCode  = params  [@"countryCode"];
    return viewController;
}

-(UIViewController *)Action_nativeMemberSwitchViewController:(NSDictionary *)params {
    TDFMemberSwitchViewController *memberSwitch = [[TDFMemberSwitchViewController alloc] init];
    memberSwitch.callBack = params[@"callBack"];
    memberSwitch.currentCardID = params[@"cardId"];
    memberSwitch.smsAndCardModel = params[@"smsAndCardModel"];
    
    return memberSwitch;
}


-(UIViewController *)Action_nativeTDFMemberSearchViewController:(NSDictionary *)params{
    TDFMemberSearchViewController *vc =[[TDFMemberSearchViewController alloc] initWithFunctionCode:[params[@"code"] intValue]];
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberDepositViewController:(NSDictionary *)params{
    TDFMemberDepositViewController *vc =[[TDFMemberDepositViewController alloc]init];
    vc.customerRegisterId = params[@"customerRegisterID"];
    vc.customerId = params[@"customerId"];
    vc.currentCardID = params[@"currentCardID"];
    vc.callback = params[@"callback"];
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberStoreValueViewController:(NSDictionary *)params{
    TDFmemberStoreValueViewController *vc = [[TDFmemberStoreValueViewController   alloc] init];
    vc.userId = params[@"userId"];
    vc.currendCard = params[@"card"];
    vc.cardModel = params[@"cardModel"];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
    
}

-(UIViewController *)Action_nativeTDFMemberDegreeStoreValueViewController:(NSDictionary *)params
{
    TDFMemberDegreeValueViewController * vc  = [[TDFMemberDegreeValueViewController  alloc] init];
    vc.userId = params[@"userId"];
    vc.currendCard = params[@"card"];
    vc.cardModel = params[@"cardModel"];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;

}

-(UIViewController *)Action_nativeTDFMemberGiftChangeViewController:(NSDictionary *)params{
    TDFMPointsExchangeViewController *viewController = [[TDFMPointsExchangeViewController alloc] init];
    viewController.customerRegisterId = params[@"customerRegisterID"];
    viewController.customerId = params[@"customerId"];
    viewController.currentCardID = params[@"currentCardID"];
    viewController.callback = params[@"callback"];
    return viewController;
}

-(UIViewController *)Action_nativeTDFScoreGivenViewController:(NSDictionary *)params{
    TDFMScoreGivenViewController *vc =[[TDFMScoreGivenViewController alloc] init];
    vc.customerRegisterId = params[@"customerRegisterID"];
    vc.customerId = params[@"customerId"];
    vc.currentCardID = params[@"currentCardID"];
    vc.callback = params[@"callback"];
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberBackCardViewController:(NSDictionary *)params
{
    TDFMemberBackCardViewController *vc =[[TDFMemberBackCardViewController alloc] init];
    vc.customerRegisterId = params[@"customerRegisterID"];
    vc.customerId = params[@"customerId"];
    vc.currentCardID = params[@"currentCardID"];
    vc.callback = params[@"callback"];
    return vc;
}

-(UIViewController *)    Action_nativeTDFChangeMemberCardPwdViewController:(NSDictionary *)params{
    TDFChangeMemberCardPwdViewController *vc =[[TDFChangeMemberCardPwdViewController alloc] init];
    vc.customerRegisterId = params[@"customerRegisterID"];
    vc.customerId = params[@"customerId"];
    vc.currentCardID = params[@"currentCardID"];
    vc.callback = params[@"callback"];
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberRecordViewController:(NSDictionary *)params{
    MemberRecordView *vc = [[MemberRecordView alloc]initWithNibName:@"MemberRecordView" bundle:nil];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberRecordDayViewController:(NSDictionary *)params{
    MemberRecordDayView *vc = [[MemberRecordDayView alloc]initWithNibName:@"MemberRecordDayView" bundle:nil parent:nil];
    vc.code = [params[@"code"] integerValue];
    vc.dateStr = params[@"date"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}


-(UIViewController *)Action_nativeTDFMemberInfoViewController:(NSDictionary *)params{
    TDFMemberInfoViewController *vc = [[TDFMemberInfoViewController alloc] init];
    vc.customerRegisterId = params[@"customerRegisterID"];
    vc.customerId = params[@"customerId"];
    vc.callback = params[@"callback"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

//-(UIViewController *)Action_nativeTDFMemberListViewController:(NSDictionary *)params{
//    MemberListView *vc = [[MemberListView alloc]initWithNibName:@"MemberListView" bundle:nil parent:nil];
//    vc.needHideOldNavigationBar = YES;
//    return vc;
//}

-(UIViewController *)Action_nativeTDFMemberInfoSummaryViewController:(NSDictionary *)params{
    MemberInfoSummaryView *vc = [[MemberInfoSummaryView alloc]initWithNibName:@"MemberInfoSummaryView" bundle:nil];
    vc.needHideOldNavigationBar = YES;
    return vc;
}

-(UIViewController *)Action_nativeTDFMemberViewController:(NSDictionary *)params{
    MemberView *vc = [[MemberView alloc] init];
    vc.codeArray = params[@"data"][@"actionCodeArrs"];
    vc.childFunctionArr = params[@"data"][@"isOpenFunctionArrs"];
    vc.needHideOldNavigationBar = YES;
    return vc;
}
//门店会员
-(UIViewController *)Action_nativeMemberManageViewController:(NSDictionary *)params
{
    TDFMemberManageViewController *vc = [[TDFMemberManageViewController alloc] init];
    
    return vc;
}

///门店会员管理权限
-(UIViewController *)Action_nativeMemberLimitViewController:(NSDictionary *)params
{
    TDFMemberLimitViewController *vc = [[TDFMemberLimitViewController alloc]init];
    vc.entityId = params[@"entityId"];
    return vc;
}

/***添加优惠券分类界面*/
-(UIViewController *)Action_nativeTDFAddCouponViewController:(NSDictionary *)params {
    
    TDFAddCouponViewController *vc = [[TDFAddCouponViewController alloc]init];
    vc.finish = params[@"callback"];
    
    if ([params objectForKey:@"plateId"]) {
        
        vc.plateId = [params objectForKey:@"plateId"];
    }
    if ([params objectForKey:@"plateEntityId"]) {
        
        vc.plateEntityId = [params objectForKey:@"plateEntityId"];
    }
    
    return vc;
    
}

/***编辑保存过的优惠券界面*/
-(UIViewController *)Action_nativeTDFMemberNewEditController:(NSDictionary *)params {
    
    TDFMemberNewEditController *vc = [[TDFMemberNewEditController alloc]init];
    vc.title = [params objectForKey:@"titleStr"];
    vc.couponType = [[params objectForKey:@"couponType"] integerValue];
    vc.finishEditing = params[@"callback"]?params[@"callback"]:nil;
    
    if ([params objectForKey:@"imgPath"]) {
        
        vc.bgImgPath = [params objectForKey:@"imgPath"];
    }else{
        
        [vc passData:[params objectForKey:@"data"]];
        vc.isChange = YES;
    }
    
    if ([params objectForKey:@"plateId"]) {
        
        vc.plateId = [params objectForKey:@"plateId"];
    }
    
    if ([params objectForKey:@"plateEntityId"]) {
        
        vc.plateEntityId = [params objectForKey:@"plateEntityId"];
    }
    return vc;
}

/***优惠券编辑页面编辑详情*/
-(UIViewController *)Action_nativeTDFEditDetailController:(NSDictionary *)params {
    
    TDFEditDetailController *vc = [[TDFEditDetailController alloc]init];
    vc.block = params[@"callback"];
    
    if ([params objectForKey:@"text"]) {
        
        vc.text = [params objectForKey:@"text"];
    }
    return vc;
}

/***优惠券编辑页面选择使用商品*/
-(UIViewController *)Action_nativeTDFMemberSelectGoodsController:(NSDictionary *)params {
    
    TDFMemberSelectGoodsController *vc = [[TDFMemberSelectGoodsController alloc]init];
    vc.block = params[@"callback"];
    vc.passDataArr = [params objectForKey:@"passDataArr"];
    vc.couponType = [[params objectForKey:@"couponType"] integerValue];
    
    return vc;
}

/***优惠券编辑页面选择背景*/
-(UIViewController *)Action_nativeTDFCouponBGImgController:(NSDictionary *)params {
    
    TDFCouponBGImgController *vc = [[TDFCouponBGImgController alloc]init];
    vc.uploadSuc = params[@"callback"];
    vc.delegate = [params objectForKey:@"vc"];
    
    return vc;
}

/***优惠券编辑页面选择商品后选择规格做法*/
-(UIViewController *)Action_nativeTDFMemChooseMakeController:(NSDictionary *)params {
    
    TDFMemChooseMakeController *vc = [[TDFMemChooseMakeController alloc]init];
    
    vc.title = [params objectForKey:@"title"];
    
    vc.vo = [params objectForKey:@"vo"];
    
    vc.block = params[@"callback"];
    
    return vc;
}

/***连锁跳转优惠券选择品牌列表*/
-(UIViewController *)Action_nativeTDFMemChooseBrandController:(NSDictionary *)params {
    
    TDFMemChooseBrandController *vc = [[TDFMemChooseBrandController alloc]init];
    
    vc.type = [params objectForKey:@"type"];
    
    return vc;
}

/***连锁跳转优惠权限设置*/
-(UIViewController *)Action_nativeTDFDiscountLimitSetController:(NSDictionary *)params {
    
    TDFDiscountLimitSetController *vc = [[TDFDiscountLimitSetController alloc]init];
    
    vc.plateId = [params objectForKey:@"plateId"];
    
    vc.permission = [params objectForKey:@"permission"];
    
    vc.plateName = [params objectForKey:@"plateName"];
    
    return vc;
}

/***进入支付宝口碑随机立减*/
-(UIViewController *)Action_nativeTDFMemAliPayKouBeiController:(NSDictionary *)params {
    
    TDFMemAliPayKouBeiController *vc = [[TDFMemAliPayKouBeiController alloc]init];
    
    return vc;
}

/* 连锁发连锁卡设置 */
- (UIViewController *)Action_nativeTDFSendChainCardSettingViewController:(NSDictionary *)params {
    TDFSendChainCardSettingViewController *viewController = [[TDFSendChainCardSettingViewController alloc] init];
    
    return viewController;
}

- (UIViewController *)Action_nativeTDFGiftRechargeViewController:(NSDictionary *)params
{
    TDFGiftRechargeViewController *viewController  = [[TDFGiftRechargeViewController  alloc] init];
    return viewController;
}

/**
 * 当日会员消费记录
 */
- (UIViewController *)Action_nativeTDFTodayVipSpendController:(NSDictionary *)params {

    TDFTodayVipSpendController *vc = [TDFTodayVipSpendController new];
    
    vc.date = params[@"date"];
    
    return vc;
}

@end



