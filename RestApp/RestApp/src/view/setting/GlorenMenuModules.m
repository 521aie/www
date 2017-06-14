//
//  GlorenMenuModules.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/31.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GlorenMenuModules.h"
#import "ActionConstants.h"
#import "UIMenuDetaiAction.h"


@implementation GlorenMenuModules
+(NSMutableArray *)listNavigateIteamMenu
{
    NSMutableArray* menuItems = [NSMutableArray array];
    
//    
//    UIMenuDetaiAction  *action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品", nil) detail:NSLocalizedString(@"已添加12个分类，118个商品", nil) img:@"ico_nav_color_shangpin" code:PAD_MENU selectstatus:NO content:NSLocalizedString(@"商品是营业前必须要设置的内容，您可以在此处添加您店铺的菜品，设置价格、做法、点菜规格等", nil) isAdviceShow:YES isDefaultShow:YES];
//    [menuItems addObject:action];
    
    UIMenuDetaiAction  *action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"员工", nil) detail:NSLocalizedString(@"已添加4个职级，26个员工", nil) img:@"ico_nav_color_yuangong" code:PAD_EMPLOYEE selectstatus:NO content:NSLocalizedString(@"所有使用二维火系统的员工，都要在员工模块中添加账户才能绑定店铺并开始工作。账户添加完成后，员工可以使用此账户登录二维火收银机、二维火掌柜、火报表、火服务生等应用。如果员工离职，需要将员工解绑.\n您可以在此设置员工的职级和权限，如职级为收银员的员工可以登录并操作收银机，职级为经理的员工可以查看报表等.", nil) isAdviceShow:YES isDefaultShow:YES];
    [menuItems addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"桌位", nil) detail:NSLocalizedString(@"已添加6个区域，68个桌位", nil) img:@"ico_nav_color_zuowei" code:PAD_SEAT selectstatus:NO content:NSLocalizedString(@"您可以在这里将店内所有桌位分别编号并录入，收银开单时就可以选择相应地桌位了。每张桌位都有相对应的桌位二维码，将二维码打印出来贴于桌上，顾客用微信或者火小二扫码后直接点菜下单，发送到厨房。", nil) isAdviceShow:YES isDefaultShow:YES];
    [menuItems addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"套餐", nil) detail:NSLocalizedString(@"设置套餐与菜肴", nil) img:@"ico_nav_color_taocan" code:PAD_SUIT_MENU selectstatus:NO content:NSLocalizedString(@"您可以在这里设置套餐商品，如汉堡可乐套餐等，方便在点菜设备上开单选择", nil) isAdviceShow:NO isDefaultShow:NO];
//    [menuItems addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"传菜", nil) detail:NSLocalizedString(@"设置厨房传菜方案", nil) img:@"ico_nav_color_chuancai" code:PAD_PRODUCE_PLAN selectstatus:NO content:NSLocalizedString(@" 在收银、火服务生、微信等应用上下单后如果厨房要接收到点单信息，那么需要先设创建一个传菜方案，在传菜方案里面设置接收的规则。设置好后，在点菜设备上下单，菜单会在相应区域内打印机上打印出来。您还可以在这里设置不用出单的商品和备用打印机。", nil) isAdviceShow:NO isDefaultShow:NO];
    [menuItems addObject:action];
    
    //    action=[[UIMenuAction alloc] init:NSLocalizedString(@"火小二", nil) detail:NSLocalizedString(@"火小二（二维火卡包,来我店）设置", nil) img:@"ico_nav_color_kabao" code:PAD_KABAW];
    //    [menuItems addObject:action];
    //
    //    action=[[UIMenuAction alloc] init:NSLocalizedString(@"微店营销", nil) detail:NSLocalizedString(@"不被流量绑架，我的顾客我做主", nil) img:@"weidianyingxiao.png" code:PAD_SHOP_QRCODE];
    //    [menuItems addObject:action];
    
    return menuItems;
}

  +(NSMutableArray *)listNavigateIteamShop
{
    NSMutableArray* details=[NSMutableArray array];
    UIMenuDetaiAction *action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"系统参数", nil) detail:NSLocalizedString(@"收银使用基础设置", nil) img:@"ico_nav_xitongcanshu" code:PAD_SETTING selectstatus:NO content:NSLocalizedString(@"对二维火产品进行全局的设置。根据您店铺的实际情况设置，如是否允许拼桌；要不要限制顾客用餐时间；点单时相同数量菜品是否需要合并显示;附加费如何打折等", nil) isAdviceShow:NO isDefaultShow:YES];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"店家信息", nil) detail:NSLocalizedString(@"设置本店基础信息", nil) img:@"ico_nav_color_dianjiaxinxi" code:PAD_SHOPINFO selectstatus:NO content:NSLocalizedString(@"您可以在此处修改您的店铺名称，同时写下您的常用邮箱、手机号码等，方便二维火对您的店铺进行后续服务.", nil) isAdviceShow:NO isDefaultShow:YES];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"营业结束时间", nil) detail:NSLocalizedString(@"设置营业结束时间", nil) img:@"ico_nav_color_yingyejieshushijian" code:PAD_OPEN_TIME selectstatus:NO content:NSLocalizedString(@"设置每天营业截止的时间。报表上的数据根据此时间划分日期，此时间点之前的账单属于当日报表，此时间点之后的账单算入第二天的报表中。不设置的话默认以0：00作为营业结束时间", nil) isAdviceShow:NO isDefaultShow:YES];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"营业班次", nil) detail:NSLocalizedString(@"设置一天的班次", nil) img:@"ico_nav_color_yingyebanci" code:PAD_TIME_ARRANGE selectstatus:NO content:NSLocalizedString(@"根据店内具体情况设置营业班次，例如早班8：00—11：30，中班12：30—2：30。主要用于营业报表的汇总与查询，可以根据不同班次来查询营业额。如果不需要分时段报表查询，此项可以不设置", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"付款方式", nil) detail:NSLocalizedString(@"设置付款方式", nil) img:@"ico_nav_color_fukuanfangshi" code:PAD_KIND_PAY selectstatus:NO content:NSLocalizedString(@"付款方式是收银必须的信息，一定要进行设置，否则收银无法操作。您可以在此添加各种收银方式如现金、银行卡、挂账、免单等常用的收银方式", nil) isAdviceShow:NO isDefaultShow:YES];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"挂账设置", nil) detail:NSLocalizedString(@"管理挂账人,本店签字确认人等", nil) img:@"ico_nav_color_guazhangshezhi" code:PAD_SIGN_PERSON selectstatus:NO content:NSLocalizedString(@"挂账设置是对挂账付款方式下的挂账人和本店签字确认人进行管理，这里设置完成后，收银结账时从选项里进行选择就可以了", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"收银单据", nil) detail:NSLocalizedString(@"管理各类单据的打印格式", nil) img:@"ico_nav_color_dayindanjumuban" code:PAD_BILL_TEMPLATE selectstatus:NO content:NSLocalizedString(@"收银单据将收银系统所使用的所有单据类型都列出来了，可以根据不同的单据选择不同的打印模板", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    return details;
}
+(NSMutableArray *)listNavigateIteamcashier
{
    NSMutableArray* details=[NSMutableArray array];
    UIMenuDetaiAction * action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"收银打印", nil) detail:NSLocalizedString(@"打印相关的设置", nil) img:@"ico_nav_color_shouyindayinmuban" code:PAD_CASH_OUTPUT selectstatus:NO content:NSLocalizedString(@"设置收银打印单据的格式,例如设置打印出来的单据上的商品排列方式；添加客户尾联文字;将店家logo添加到单据上;设置下单时是否要打印消费底联、是否打印划菜联、结账完毕是否自动打印财务联、打印时是否需要打开钱箱", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"零头处理方式", nil) detail:NSLocalizedString(@"结账时的抹零,尾数逢4减1等设置", nil) img:@"ico_nav_color_lingtouchulifangshi" code:PAD_ZERO_PARA selectstatus:NO content:NSLocalizedString(@"包括零头处理和不吉利尾数处理两类。\n零头处理，是对小数点后数字的处理，处理方式有不处理、四舍五入、抹零三种。\n不吉利尾数处理，是对整数的处理，可根据行规或者您当地的习俗进行设置，如尾数是4，扣减额是1。\n零头处理和尾数处理后的金额与原金额的差额也会算到损益上。", nil) isAdviceShow:NO isDefaultShow:YES];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"客单备注", nil) detail:NSLocalizedString(@"添加一些备注内容,开单时可快速选择", nil) img:@"ico_nav_color_kedanbeizhu" code:PAD_TABLE_ITEM selectstatus:NO content:NSLocalizedString(@"用在收银和点菜设备上开单或改单时备注整单的口味要求，例如不放辣、不放糖等等，客单备注会打印在配菜联上。", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"特殊操作原因", nil) detail:NSLocalizedString(@"退货,打折,反结账等操作原因", nil) img:@"ico_nav_color_teshucaozuoyuanyin" code:PAD_SPECIAL_OPERATE selectstatus:NO content:NSLocalizedString(@"包含退货原因、打折原因、撤单原因和反结账原因，它们分别用来备注每次操作的原因，都是在收银或点单设备上做相应操作时供选择，方便后期统计\n退货原因：例如上菜太慢、有异味\n打折原因：例如元旦特价\n撤单原因：例如顾客有事先走了\n反结账原因：例如付款方式选错了", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"附加费", nil) detail:NSLocalizedString(@"设置服务费或者最低消费", nil) img:@"ico_nav_color_fujiafei" code:PAD_FEE_PLAN selectstatus:NO content:NSLocalizedString(@"设置除了商品以外，还要额外收取的费用，例如服务费、最低消费.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"打折方案", nil) detail:NSLocalizedString(@"设置多种折扣方案，供收银使用", nil) img:@"ico_nav_color_dazhefangan" code:PAD_DISCOUNT_PLAN selectstatus:NO content:NSLocalizedString(@"如果您账单打折时希望对不同分类商品设置不同折扣，可在此处进行设置。例如饮料半价，点心八折.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品促销", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"ico_nav_color_menutime_trans" code:PAD_MENU_TIME selectstatus:NO content:NSLocalizedString(@"有活动促销、特价商品时，可以在这里添加。 商品促销有促销价和打折促销两种，促销价是手工输入商品的促销价，打折促销是根据输入的折扣自动计算商品的促销价。优惠方式确定后，收银和点菜设备会显示优惠后价格，并且自动按照优惠价格结算.", nil)isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"电子菜谱排版", nil) detail:NSLocalizedString(@"电子菜谱上的商品展示方式设置", nil) img:@"ico_nav_color_dianzicaipupaiban" code:MARKET_EMENU_STYLE selectstatus:NO content:NSLocalizedString(@"如果您的餐厅为顾客提供Ipad点菜方式，可以在此处设置Ipad电子菜谱的排版方式.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    return details;
}

+(NSMutableArray *)listNavigateIteamTool:(int)billSettingCode
{
    NSMutableArray* details=[NSMutableArray array];
    
    UIMenuDetaiAction * action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"更换排队机", nil) detail:NSLocalizedString(@"使用另一台排队机进行排队", nil) img:@"ico_nav_color_genghuanpaiduiji" code:PAD_CHANGE_QUEUE  selectstatus:NO content:NSLocalizedString(@"为保证数据安全，店内只有一台排队机可以与二维火掌柜后台进行数据通讯，店内的其他排队设备都是通过这台排队机来获取数据的。因此当更换了新的排队机之后，需要在这里将原来的排队机与二维火掌柜后台解绑，然后打开新的排队机来进行数据同步，并自动建立新的绑定.", nil) isAdviceShow:NO isDefaultShow:NO];
    
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"营业数据清理", nil) detail:NSLocalizedString(@"清理账单,报表等营业数据", nil) img:@"ico_nav_color_shujuqingli" code:PAD_DATA_CLEAR  selectstatus:NO content:NSLocalizedString(@"清理指定日期范围内的营业数据，营业数据是指收银过程中产生的历史数据，如：账单、预订单、外卖单等。清理之后，火报表中也不能查到相应数据.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"营业数据清理", nil) detail:NSLocalizedString(@"清理账单,报表等营业数据", nil) img:@"ico_nav_color_shujuqingli" code:PHONE_SCREEN_ADVERTISEMENT  selectstatus:NO content:NSLocalizedString(@"清理指定日期范围内的营业数据，营业数据是指收银过程中产生的历史数据，如：账单、预订单、外卖单等。清理之后，火报表中也不能查到相应数据.", nil) isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    
    UIMenuDetaiAction *actionAd = [[UIMenuDetaiAction alloc] init:NSLocalizedString(@"店内屏幕广告", nil) detail:@"" img:@"ico_nav_color_shujuqingli" code:PHONE_SCREEN_ADVERTISEMENT  selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:actionAd];
    
    UIMenuDetaiAction *actionVoice = [[UIMenuDetaiAction alloc] init:NSLocalizedString(@"叫号语音设置", nil) detail:@"" img:@"ico_nav_color_shujuqingli" code:PHONE_VOICE_SET  selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:actionVoice];
    
    if (billSettingCode==1) {
        action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"账单优化", nil) detail:NSLocalizedString(@"可自动或人工优化账单", nil) img:@"ico_nav_color_zhangdanyouhua" code:PAD_ACCOUNT_OPERATION selectstatus:NO content:NSLocalizedString(@"可自动或人工优化账单", nil) isAdviceShow:NO isDefaultShow:NO];
        [details addObject:action];
     }
       return details;
}

+(NSMutableArray *)listChainBranchIteam
{
    NSMutableArray *details =[NSMutableArray array];

    UIMenuDetaiAction *action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"分公司", nil) detail:@"" img:@"icon_branch" code:PHONE_BRANCH_MANAGE selectstatus:NO content:@"" isAdviceShow:@"" isDefaultShow:@""];
    [details addObject:action];
    
    action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"门店", nil) detail:@"" img:@"ico_store" code:PHONE_BRANCH_SHOP selectstatus:NO content:@"" isAdviceShow:@"" isDefaultShow:@""];
    [details addObject:action]; 
    
    action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"品牌", nil) detail:@"" img:@"ico_brand" code:PHONE_BRANCH_PLATE selectstatus:NO content:@"" isAdviceShow:@"" isDefaultShow:@""];
    [details addObject:action];
    
    action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"员工", nil) detail:@"" img:@"ico_staff" code:PHONE_BRANCH_USER selectstatus:NO content:@"" isAdviceShow:@"" isDefaultShow:@""];
    [details addObject:action];
    
    return details;
}

+ (NSMutableArray *)listOrderIteam
{
    NSMutableArray *details =[NSMutableArray array];
    
    UIMenuDetaiAction *action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"商品标签设置", nil) detail:@"" img: @"Customer_Recommend" code:PHONE_MENU_LABEL selectstatus:NO content:NSLocalizedString(@"给每个商品设定属性", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"顾客点餐智能提醒与推荐", nil) detail:@"" img:@"Good_Lbl_Set" code:PHONE_MENU_REMIND selectstatus:NO content:NSLocalizedString(@"推荐你想卖的商品", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    action =[[UIMenuDetaiAction alloc]init:NSLocalizedString(@"\"随便点\" 模板设置", nil) detail:@"" img:@"icon_samrtOrder" code:PHONE_SMART_MENU_TEMPLATE selectstatus:NO content:NSLocalizedString(@"设置多种推荐模板,帮忙顾客快速点菜", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    return details;
}

+ (NSMutableArray *)listActionIteam
{
    NSMutableArray *details =[NSMutableArray array];
    UIMenuDetaiAction *action;
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"生活圈", nil) detail:NSLocalizedString(@"免费发布信息到会员手机", nil) img:@"ico_nav_color_shenghuoquan_trans" code:PAD_ISSUE_INFO selectstatus:NO content:NSLocalizedString(@"生活圈是向本店会员的“火小二”应用推送消息的工具。将本店的促销、优惠活动等消息推送到会员的火小二应用中，没有通信费用。消息可为图文混排的形式，上传活动图片，描述优惠与活动规则。发布信息后，手机上安装“火小二”应用的会员就会收到这条信息，并且在“火小二”的店铺页面上也是展示出来。", nil) isAdviceShow:YES isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"短信营销", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"ico_nav_color_duanxinyingxiao_trans" code:PAD_SMS_MARKET selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    
    return details;
    
}

+ (NSMutableArray *)listActionCoupons
{
    NSMutableArray *details =[NSMutableArray array];
    UIMenuDetaiAction *action;
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员卡", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"kindCard.png" code:PAD_KIND_CARD selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"红包", nil) detail:NSLocalizedString(@"在火掌柜中发布红包，顾客在微店主页领取红包之后，可在使用微信支付时抵扣指定的金额.", nil) img:@"ico_nav_color_hongbao_trans" code:PAD_RED_PACKETS selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    
//    [details addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品促销", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"ico_nav_color_menutime_trans" code:PAD_MENU_TIME selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"优惠券", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"coupon_icon.png" code:PHONE_COUPON selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"促销活动", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"ico_nav_color_menutime_trans" code:PHONE_SALE selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"充值优惠设置", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"chongZhiYouHui.png" code:PAD_CHARGE_DISCOUNT selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员等级特权", nil) detail:@"" img:@"icon_member_level" code:PHONE_PRIVILEGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    
    return details;
}

+ (NSMutableArray *)chainListActionCoupons
{
    NSMutableArray *details =[NSMutableArray array];
    UIMenuDetaiAction *action;
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员卡", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"kindCard.png" code:PHONE_BRAND_KIND_CARD selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];

    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"充值优惠设置", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"chongZhiYouHui.png" code:PHONE_BRAND_CHARGE_DISCOUNT selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];

    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"门店会员管理", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"kindCardManage.png" code:PHONE_BRAND_SHOP_MANAGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员等级特权", nil) detail:@"" img:@"icon_member_level" code:PHONE_BRAND_PRIVILEGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    
    return details;
}

+ (NSMutableArray *)listActionMember
{
    NSMutableArray *details =[NSMutableArray array];
    UIMenuDetaiAction *action;
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"发会员卡", nil) detail:NSLocalizedString(@"发送促销短信到会员手机", nil) img:@"ico_nav_fadianzika.png" code:PAD_MAKE_CARD selectstatus:NO content:NSLocalizedString(@"您可以使用此功能向本店会员群发营销短信，信息将以短信的形式，发送到会员手机.", nil) isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员换卡", nil) detail:NSLocalizedString(@"在火掌柜中发布红包，顾客在微店主页领取红包之后，可在使用微信支付时抵扣指定的金额.", nil) img:@"member_charge_card@2x.png" code:PHONE_CARD_CHANGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    
    [details addObject:action];

    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员充值", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"member_rechange@2x.png" code:PHONE_CARD_CHARGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员赠分", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"present_red_mark@2x.png" code:PHONE_GIVE_DEGREE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"会员退卡", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"member_retreat_card@2x.png" code:PHONE_CARD_RETURN selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"改卡密码", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"change_password@2x.png" code:PHONE_CARD_PASSWORD selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"积分兑换设置", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"icon_gift.png" code:PAD_DEGREE_EXCHANGE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"积分兑换", nil) detail:NSLocalizedString(@"指定商品在一段时间内特价或打折", nil) img:@"integration_exchange@2x.png" code:PHONE_CARD_DEGREE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
    [details addObject:action];
    
    return details;
}


+ (NSMutableArray *)listMenuAndSuit
{
    NSMutableArray *details =[NSMutableArray array];
//    UIMenuDetaiAction *action;
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品与套餐", nil) detail:@"" img:@"menuedit" code:PAD_MENU_EDIT selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"分类管理", nil) detail:@"" img:@"menukind" code:PAD_MENU_KIND selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    
//    [details addObject:action];
//    return details;
//}
//
//+ (NSMutableArray *) listMenuSpecAndTaste
//{
//    NSMutableArray *details =[NSMutableArray array];
//    UIMenuDetaiAction *action;
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品规格", nil) detail:@"" img:@"menuspec" code:PAD_MENU_SPEC selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品做法", nil) detail:@"" img:@"menumake" code:PAD_MENU_MAKE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品加料", nil) detail:@"" img:@"menuaddition" code:PAD_MENU_ADDITION selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品备注", nil) detail:@"" img:@"menutaste" code:PAD_MENU_TASTE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品促销", nil) detail:@"" img:@"menutime" code:PAD_MENU_TIME selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"打折方案", nil) detail:@"" img:@"ratio" code:PAD_MENU_RATIO_FORMAT selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    return details;
}

+ (NSMutableArray *) listChainMenuActions
{
    NSMutableArray *details =[NSMutableArray array];
//    UIMenuDetaiAction *action;
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"商品库", nil) detail:NSLocalizedString(@"总部一个总的商品仓库，只有总部有权限人员可以进行管理，可以选择商品下发到门店.", nil) img:@"menuwarehouse" code:PAD_BRAND_MENU_WAREHOUSE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"品牌关联商品", nil) detail:NSLocalizedString(@"连锁每个独立品牌都设定好旗下关联商品，商品可以关联若干个品牌。", nil) img:@"brandrelatemenu" code:PAD_BRAND_RELATEMENU selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"价格方案", nil) detail:NSLocalizedString(@"一套价格方案绑定一个门店，适用于不同地区不同成本门店，同一个商品可卖不同价格。", nil) img:@"prieformat" code:PAD_BRAND_PRICESCHEME selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"门店权限", nil) detail:NSLocalizedString(@"直营和加盟的门店，分别设置不同权利。", nil) img:@"shoppower" code:PAD_BRAND_STOREAUTHORITY selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
//    
//    
//    action=[[UIMenuDetaiAction alloc] init:NSLocalizedString(@"发布到门店", nil) detail:NSLocalizedString(@"可设定发布时间，统一将商品下发到不同门店。", nil) img:@"pblishtoshop" code:PAD_BRAND_PUBLISHTOSTORE selectstatus:NO content:@"" isAdviceShow:NO isDefaultShow:NO];
//    [details addObject:action];
    return details;
}

@end
