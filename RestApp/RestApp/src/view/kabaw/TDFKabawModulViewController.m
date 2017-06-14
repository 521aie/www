//
//  TDFKabawModulViewController.m
//  RestApp
//
//  Created by 黄河 on 2016/10/21.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFKabawModulViewController.h"
#import "ShopReviewCenter.h"
#import "TDFLoginService.h"
#import "ActionConstants.h"
#import "TDFFunctionVo.h"
#import "TDFBaseView.h"
#import "TDFMediator.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "Platform.h"
#import "TDFIsOpen.h"

@interface TDFKabawModulViewController ()
@property (nonatomic, strong)TDFBaseView *baseView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation TDFKabawModulViewController


#pragma mark --init
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseView = [[TDFBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withHeaderImage:nil andHelpText:nil];
    self.title = NSLocalizedString(@"顾客端设置", nil);
    [self.view addSubview:self.baseView];
    [self initBaseView];
    [self loadVersionControl];
    [self initNotification];
}

#pragma mark --notification
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reviewStatusDidChanged)
                                                 name:kShopReviewStateChangedNotification
                                               object:nil];

}

- (void)reviewStatusDidChanged {
    
    [self.baseView.tableView reloadData];
}
#pragma mark --版本控制
- (void)loadVersionControl {
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[[TDFLoginService alloc] init] cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4Takeout" }
     
                                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                         self.progressHud.hidden = YES;
                                                         if ([data objectForKey:@"data"]) {
                                                             BOOL isShow = [[data objectForKey:@"data"] boolValue];
                                                             [self initDataArrayWithIsShow:isShow];
                                                         }
                                                        
                                                     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                         self.progressHud.hidden = YES;
                                                         [AlertBox show:error.localizedDescription];
                                                     }];
}




#pragma mark --BaseVIew
- (void)initBaseView
{
    @weakify(self);
    self.baseView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseView.numberOfRowWithSection = ^(NSInteger section) {
        @strongify(self);
        return (int)self.dataArray.count;
    };
    self.baseView.didSelectRow = ^(UITableView* tableView,NSIndexPath *indexPath){
        @strongify(self);
        if (indexPath.row >= self.dataArray.count) {
            return ;
        }
        TDFFunctionVo *functionVO = self.dataArray[indexPath.row];
        if (functionVO.isLock) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),functionVO.actionName]];
            return ;
        }
        if (![TDFIsOpen isOpen:functionVO.actionCode childFunctionArr:self.childFunctionArr]) {
            for (TDFFunctionVo *item in self.childFunctionArr) {
                if ([item.actionCode isEqualToString:functionVO.actionCode]) {
                    [TDFIsOpen goToModuleDetailViewController:item];
                    return;
                }
            }
        }
        [self pushViewControllerWithCode:functionVO.actionCode];
    };
    self.baseView.loadDataInCell = ^(UITableViewCell *cell,NSIndexPath *indexPath){
        @strongify(self);
        if (indexPath.row < self.dataArray.count) {
            TDFFunctionVo *functionVO = self.dataArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:functionVO.iconImageUrl.hUrl];
            cell.textLabel.text = functionVO.actionName;
            cell.detailTextLabel.text = functionVO.detail;
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 80)];
            UIImageView *lockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pw.png"]];
            lockImage.frame = CGRectMake(0, 10, 15, 15);
            [rightView addSubview:lockImage];
            
            if (functionVO.isLock) {
                cell.accessoryView = rightView;
            }else
            {
                if ([functionVO.actionCode isEqualToString:PAD_CARD_SHOPINFO]) {
                    if (![TDFIsOpen isOpen:functionVO.actionCode childFunctionArr:self.childFunctionArr]) {
                        lockImage.image = [UIImage imageNamed:@"ico_pw_red"];
                        cell.accessoryView = rightView;
                    }else{
                        lockImage.image = [UIImage imageNamed:@"warning_icon_red"];
                        cell.accessoryView = [ShopReviewCenter sharedInstance].shouldShowWarningBadge?rightView:nil;
                    }
                }else
                { if (![TDFIsOpen isOpen:functionVO.actionCode childFunctionArr:self.childFunctionArr]) {
                    lockImage.image = [UIImage imageNamed:@"ico_pw_red"];
                    cell.accessoryView = rightView;
                }else{
                    cell.accessoryView = nil;
                }
                    
                }
            }
        }
    };
    self.baseView.showHelpDialog = ^{
        [HelpDialog show:@"tranModule"];
    };
}

- (void)pushViewControllerWithCode:(NSString *)actionCode
{
    NSDictionary *switchU = [Platform Instance].allFunctionSwitchDictionary[actionCode];
    if (switchU[@"mediatorMethod"]) {
        SEL action = NSSelectorFromString(switchU[@"mediatorMethod"]);
        if ([[TDFMediator sharedInstance] respondsToSelector:action]) {
            UIViewController *viewController = [[TDFMediator sharedInstance] performSelector:action withObject:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- initData
//创建二级菜单
-(void) initDataArrayWithIsShow:(BOOL)isShow
{
    TDFFunctionVo *functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_CARD_SHOPINFO;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.detail = NSLocalizedString(@"设置顾客端中的店铺信息展示", nil);
    functionVO.actionName = NSLocalizedString(@"店家资料", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_dianjiaxinxi";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_BASE_SETTING;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.detail = NSLocalizedString(@"顾客端点餐的基础设置", nil);
    functionVO.actionName = NSLocalizedString(@"基础设置", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_xitongcanshu";
    [_dataArray addObject:functionVO];
    
//    functionVO = [TDFFunctionVo new];
//    functionVO.actionCode = PAD_SHOP_QRCODE;
//    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
//    functionVO.detail = NSLocalizedString(@"店铺二维码下载及顾客端主页分享", nil);
//    functionVO.actionName = NSLocalizedString(@"店铺二维码", nil);
//    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
//    functionVO.iconImageUrl.hUrl = @"ico_shop_qrcode_l";
//    [_dataArray addObject:functionVO];
    
//    functionVO = [TDFFunctionVo new];
//    functionVO.actionCode = PHONE_SHOP_LOGO;
//    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
//    functionVO.actionName = NSLocalizedString(@"店铺LOGO", nil);
//    functionVO.detail = NSLocalizedString(@"展示在“火小二”应用及微信扫码菜单中作为店标", nil);
//    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
//    functionVO.iconImageUrl.hUrl = @"ico_shop_logo";
//    [_dataArray addObject:functionVO];
    
//    functionVO = [TDFFunctionVo new];
//    functionVO.actionCode = PHONE_WEIXIN_CODE;
//    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
//    functionVO.actionName = NSLocalizedString(@"店家微信公众号设置", nil);
//    functionVO.detail = NSLocalizedString(@"上传店家公众号二维码的帮助说明", nil);
//    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
//    functionVO.iconImageUrl.hUrl = @"wx_official_logo";
//    [_dataArray addObject:functionVO];
                                                                                                                                                                                                                                                           
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PHONE_SALES_RANKING;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"本店销量榜", nil);
    functionVO.detail = NSLocalizedString(@"菜品销售情况的排行榜", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_sales_rank";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_RESERVE_SETTING;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"预订设置", nil);
    functionVO.detail = NSLocalizedString(@"开通预订时需要的设置信息", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_yudingshezhi";
    [_dataArray addObject:functionVO];
    
    if (isShow) {
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_TAKEOUT_SETTING;
        functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
        functionVO.actionName = NSLocalizedString(@"外卖设置", nil);
        functionVO.detail = NSLocalizedString(@"开通外卖时需要的设置信息", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_nav_waimaishezhi";
        [_dataArray addObject:functionVO];
    }
    /*
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_QUEUE_SEAT;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"排队桌位类型", nil);
    functionVO.detail = NSLocalizedString(@"排队桌位类型", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_zhuoweileixing";
    [_dataArray addObject:functionVO];*/
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PHONE_SELECT_MENU;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"必选商品", nil);
    functionVO.detail = NSLocalizedString(@"锅底、餐具等商品自动加入购物车", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_force_goods";
    [_dataArray addObject:functionVO];
    
    TDFFunctionVo *functionVOOne = [TDFFunctionVo new];
    functionVOOne = [TDFFunctionVo new];
    functionVOOne.actionCode = PHONE_ORDER_REPETITION;
    functionVOOne.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVOOne.actionName = NSLocalizedString(@"顾客点餐重复提醒", nil);
    functionVOOne.detail = NSLocalizedString(@"可设置点餐时商品重复的提醒", nil);
    functionVOOne.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVOOne.iconImageUrl.hUrl = @"reminder_repeate_icon";
    [_dataArray addObject:functionVOOne];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_BLACK_LIST;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"黑名单", nil);
    functionVO.detail = NSLocalizedString(@"添加顾客黑名单，杜绝恶意骚扰", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"blackList.png";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PHONE_MENU_PICTURE_PAGE;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"商品页首与页尾", nil);
    functionVO.detail = NSLocalizedString(@"顾客端菜肴详情页面可以添加页首页尾图片，用于宣传品牌历史、团队形象、材料原产地、活…", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"商品页首页尾图片_icon";
    [_dataArray addObject:functionVO];

    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PHONE_CHANGE_SKIN;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"个性化换肤", nil);
    functionVO.detail = NSLocalizedString(@"您可以在这里定义您店铺独有的二维火小二皮肤", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"icon_skin";
    [_dataArray addObject:functionVO];
    
    [self.baseView.tableView reloadData];
}
@end
