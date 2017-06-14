//
//  RestAppConstants.m
//  Pods
//
//  Created by chaiweiwei on 2016/10/12.
//
//

#import "RestAppConstants.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if ENTERPRISE
NSString * const WX_APP_ID = @"wxbc6632cd90329698";
NSString * const WX_APP_SSECRET = @"b72c5523b76c1549c44d8758216d639b";
NSString * const MAP_KEY = @"c4489a8ac5d6424a5f308f495a36144d";
NSString * const JPUSH_KEY = @"8db4c6cb9ee15b41bf9a293c";
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#else
NSString * const WX_APP_ID = @"wx9ea214b5b0a4de1e";
NSString * const WX_APP_SSECRET = @"33482ec38de4aeefb0fccf11f997fe77";
NSString * const MAP_KEY = @"3cc9587737955181879902b260d6b969";
NSString * const JPUSH_KEY = @"9ceed2d9f3fe403963bb5ab4";
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#endif


NSString * const AUTO_LOGIN_IMAGE = @"LaunchImage";

NSString * const APP_API_KEY = @"100008";
NSString * const APP_API_SECRET = @"540d5a0d2ead402f841c9c690c50165f";
NSString * const APP_BOSS_API_KEY = @"200006";
NSString * const APP_BOSS_API_SIGNKEY = @"BoivJgAlmBUO05yoxD6RU/SZ/nhLvpXT40v2ceqKJ1s=";

NSString * const UMANALYTICS_KEY = @"5804415c67e58ea586000355";
NSString * const WEIXIN_AppId = @"wxe441c9b1bc05c906";
NSString * const WEIXIN_AppSecret = @"12c67c2fbd79712a41f780ddcaace23b";

NSInteger const TDFAPPIdentifier = 1;

//NSString * const TDFAppDisplayName = NSLocalizedString(@"二维火掌柜", nil);

BOOL const TDFLoginPodShouldHideOpenShopButton = NO;

#if DEBUG
NSString * const kTDFProjectDmallAPI = @"http://10.1.6.64:8080/dmall-api";
NSString * const kTDFProjectClusterRoot = @"http://10.1.6.140/zmcluster";
NSString * const kTDFProjectAPIRoot = @"http://10.1.6.136:8080/api";
NSString * const kTDFProjectBossAPI = @"http://10.1.7.91:8080/boss-api";
NSString * const kTDFProjectIntegralAPI = @"http://10.1.87.218:8080";
NSString * const kTDFProjectSupplyChainAPI = @"http://10.1.5.85:8080/supplychain-api";
NSString * const kTDFProjectSupplyAPIRoot = @"http://10.1.6.85:8080/retail-api";
NSString * const kTDFProjectEnvelopeURL = @"http://weidian.2dfire.com/hongbao/receive.do?couponId=%ld";
NSString * const kTDFProjectReportURL = @"http://d.2dfire-daily.com/report/index.html?session_id=%@&shop_code=%@&shop_name=%@&entity_id=%@&request_url=%@&dev=debug&version=sso";
NSString * const kTDFProjectRerpServerURL = @"http://server.2dfire-daily.com/rerp4";
NSString * const kTDFProjectKLoanURL = @"%@?dianmianid=%@&dianmianname=%@&man=%@&phone=%@";
NSString * const kTDFProjectImageFilePath = @"http://ifiletest.2dfire.com";
NSString * const kTDFProjectImageOriginPath = @"http://zmfile.2dfire-daily.com";
NSString * const kTDFProjectSupplyReportURL = @"http://10.1.5.213/nginx/report/index.html?session_key=%@&session_id=%@&shop_code=%@&shop_name=%@&entity_id=%@&request_url=%@&dev=debug&identification_key=scm";
NSString * const kTDFProjectSupplyReportUrlExtend = @"&member_user_id=%@&plat_form_type=1";
NSString * const kTDFProjectPurchaseShareURL = @"http://d.2dfire-daily.com/static-supplychain/styles/share.html";
NSString * const kTDFProjectPandoraReportURLRoot = @"http://pandora.2dfire-daily.com";

#endif
