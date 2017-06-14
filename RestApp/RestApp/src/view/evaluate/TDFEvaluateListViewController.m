//
//  TDFEvaluateListViewController.m
//  RestApp
//
//  Created by 黄河 on 2016/10/22.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFEvaluateListViewController.h"
#import "FooterListEvent.h"
#import "ActionConstants.h"
#import "TDFFunctionVo.h"
#import "TDFBaseView.h"
#import "TDFMediator.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "Platform.h"
#import "TDFIsOpen.h"

@interface TDFEvaluateListViewController ()<FooterListEvent>
@property (nonatomic, strong)TDFBaseView *baseView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation TDFEvaluateListViewController


#pragma mark --init
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [self initDataArray];
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
    self.title = NSLocalizedString(@"顾客评价", nil);
    [self.view addSubview:self.baseView];
    [self.baseView initFooterListViewWithArray:nil withDelegate:self andShowHelp:YES];
    [self initBaseView];
}

#pragma mark -- initData
//创建二级菜单
- (void)initDataArray
{
    TDFFunctionVo *functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_WHOLE_REVIEW;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.detail = NSLocalizedString(@"顾客对店铺的综合评价", nil);
    functionVO.actionName = NSLocalizedString(@"综合评价", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_zonghepingjia.png";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = PAD_SHOP_REVIEW;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.detail = NSLocalizedString(@"顾客对店铺的评价汇总", nil);
    functionVO.actionName = NSLocalizedString(@"店铺评价", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_dianpupingjia.png";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = SHOP_WAITER_REVIEW;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.detail = NSLocalizedString(@"顾客对服务生的评价汇总", nil);
    functionVO.actionName = NSLocalizedString(@"服务生评价", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_nav_fuwushengpingjia.png";
    [_dataArray addObject:functionVO];
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
            
            UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 80)];
            UIImageView *lockImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pw_red"]];
            lockImage1.frame = CGRectMake(0, 10, 15, 15);
            [rightView1 addSubview:lockImage1];
            
            cell.accessoryView = functionVO.isLock ? rightView : [TDFIsOpen isOpen:functionVO.actionCode childFunctionArr:self.childFunctionArr]?nil:rightView1;
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

#pragma mark --FooterListEvent

- (void)showHelpEvent
{
    [HelpDialog show:@"shopevaluate"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
