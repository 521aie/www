//
//  TDFShopPowerViewController.m
//  RestApp
//
//  Created by zishu on 16/10/11.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFShopPowerViewController.h"
@implementation TDFShopPowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"门店权限", nil);
    self.delegate = self;
    self.contents = NSLocalizedString(@"总部可以根据门店的属性（直营或加盟）来设定相应的权限。比如是否允许门店可以自己添加门店商品等。", nil);
    self.imageName = @"shoppower";
    [self.view addSubview:self.tableView];
    [self initGrid];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self queryAllPlateList];
}

- (void) queryAllPlateList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    @weakify(self);
    [[TDFChainMenuService new] queryAllPlateListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        self.dataArray = [[NSArray yy_modelArrayWithClass:[Plate class] json:data[@"data"]] mutableCopy];
        if (self.dataArray.count == 0) {
            self.placeholderContents = NSLocalizedString(@"连锁总部还没有任何品牌。先到连锁首页品牌下添加一个吧！", nil);
            [self initPlaceHolderView];
        }else{
            [self.bgView removeFromSuperview];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    
    if (self.dataArray.count > 0 && indexPath.row < self.dataArray.count) {
        Plate *plate = self.dataArray[indexPath.row];
        cell.lblName.text = plate.name;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) showHelpEvent:(NSString *)event
{
    [HelpDialog show:@"ChainShopPower"];
}

- (void) showEditNVItemEvent:(NSString *)event withObj:(id<INameItem>)obj
{
    Plate *vo = (Plate *)obj;
     @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopPowerEditViewController:vo editCallBack:^(BOOL orRefresh) {
         @strongify(self);
        [self queryAllPlateList];
    }];
     [self.navigationController pushViewController:viewController animated:YES];
}
@end
