//
//  NavigateMenuModel.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/16.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "NavigateMenuModel.h"
#import "ActionConstants.h"

@implementation NavigateMenuModel
- (NSMutableArray *)createListwithcode:(NSString *)code
{
    NSMutableArray* menuItems=[NSMutableArray array];

    UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"顾客端设置", nil) detail:NSLocalizedString(@"设置微店中的店铺信息展示", nil) img:@"ico_nav_dianjiaxinxi" code:PAD_CARD_SHOPINFO];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"基础设置", nil) detail:NSLocalizedString(@"顾客端点餐的基础设置", nil) img:@"ico_nav_xitongcanshu" code:PAD_BASE_SETTING];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"微店营销", nil) detail:NSLocalizedString(@"店铺二维码下载及微店主页分享", nil) img:@"shop_qrcode_logo" code:PAD_SHOP_QRCODE];
    [menuItems addObject:action];
    
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"预订设置", nil) detail:NSLocalizedString(@"开通预订时需要的设置信息", nil) img:@"ico_nav_yudingshezhi" code:PAD_RESERVE_SETTING];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"外卖设置", nil) detail:NSLocalizedString(@"开通外卖时需要的设置信息", nil) img:@"ico_nav_waimaishezhi" code:PAD_TAKEOUT_SETTING];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"卡设置", nil) detail:NSLocalizedString(@"管理会员卡", nil) img:@"ico_nav_kashezhi" code:PAD_KIND_CARD];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"充值优惠", nil) detail:NSLocalizedString(@"管理会员卡的充值优惠", nil) img:@"ico_nav_chongzhiyouhui" code:PAD_CHARGE_DISCOUNT];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"积分兑换", nil) detail:NSLocalizedString(@"不同积分数的兑换规则", nil) img:@"ico_nav_jifenduihuan" code:PAD_DEGREE_EXCHANGE];
    [menuItems addObject:action];
    
    //    action=[[UIMenuAction alloc] init:NSLocalizedString(@"服务铃", nil) detail:NSLocalizedString(@"加菜,催菜后是否需要审核", nil) img:@"ico_nav_fuwuling" code:PAD_CARD_SERVICE];
    //    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"排队桌位类型", nil) detail:NSLocalizedString(@"排队桌位类型", nil) img:@"ico_nav_zhuoweileixing" code:PAD_QUEUE_SEAT];
    [menuItems addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"黑名单", nil) detail:NSLocalizedString(@"添加顾客黑名单，杜绝恶意骚扰", nil) img:@"blackList.png" code:PAD_BLACK_LIST];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"个性化换肤", nil) detail:NSLocalizedString(@"您可以在这里定义您店铺独有的二维火小二皮肤", nil) img:@"icon_skin" code:PHONE_CHANGE_SKIN];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"商品页首与页尾", nil) detail:NSLocalizedString(@"顾客端菜肴详情页面可以添加页首页尾图片，用于宣传品牌历史、团队形象、材料原产地、活…", nil) img:@"商品页首页尾图片_icon" code:PHONE_MENU_PICTURE_PAGE];
    [menuItems addObject:action];
    
   action = [[UIMenuAction alloc] init:NSLocalizedString(@"收货入库单", nil) detail:NSLocalizedString(@"收货入库单", nil) img:@"ico_shouhuo.png" code:SUPPLY_IN];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"退货出库单", nil) detail:NSLocalizedString(@"退货出库单", nil) img:@"ico_tuihuo.png" code:SUPPLY_OUT];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"内部调拨单", nil) detail:NSLocalizedString(@"内部调拨单", nil) img:@"ico_diaobo.png" code:SUPPLY_GET];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"供应商管理", nil) detail:NSLocalizedString(@"对供应商进行管理", nil) img:@"ico_gongyingshang.png" code:SUPPLY_SUPPLIER];
    [menuItems addObject:action];
    
   action = [[UIMenuAction alloc] init:NSLocalizedString(@"原料", nil) detail:@"" img:@"ico_yuanliao" code:SUPPLY_RAW];
   [menuItems  addObject:action];
    
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"商品原料配比", nil) detail:NSLocalizedString(@"各商品的原料配比", nil) img:@"ico_yuanliaopeibi" code:SUPPLY_MENU_RAW];
    [menuItems addObject:action];
    
   action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存查询", nil) detail:@"" img:@"ico_kucunchaxun.png" code:SUPPLY_STOCK];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存调整", nil) detail:@"" img:@"ico_kucuntiaozheng.png" code:SUPPLY_CHANGE];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存盘存", nil) detail:@"" img:@"ico_pancun.png" code:SUPPLY_STORE];
    [menuItems addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"仓库管理", nil) detail:@"" img:@"ico_cangku.png" code:SUPPLY_WAREHOUSE];
    [menuItems addObject:action];
    
    return menuItems;
}

@end
