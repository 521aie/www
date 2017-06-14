//
//  TDFPriceFormatViewController.m
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFPriceFormatViewController.h"

@implementation TDFPriceFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.title = NSLocalizedString(@"价格方案", nil);
    self.contents = NSLocalizedString(@"不同城市或区域的门店，租金等成本不同，商品的价格也会不同。总部就可以设定多套商品价格方案，灵活绑定适合的门店。注意，每个门店只能关联一套价格方案。", nil);
    self.imageName = @"prieformat";
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self initGrid];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    [self listRelationPlate];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) listRelationPlate
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFChainMenuService new] queryMenuPricePlanWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.dataArray = [[NSArray yy_modelArrayWithClass:[MenuPricePlanVo class] json:data[@"data"]] mutableCopy];
        if (self.dataArray.count == 0) {
            self.placeholderContents = NSLocalizedString(@"        您还没有添加过价格方案，\n         赶快添加一个吧！", nil);
            [self initPlaceHolderView];
        }else{
            [self.bgView removeFromSuperview];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
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
        MenuPricePlanVo *plate = self.dataArray[indexPath.row];
        cell.lblName.text = plate.pricePlanName;
        cell.lblVal.textColor = [UIColor grayColor];
        cell.lblVal.text = [NSString stringWithFormat:NSLocalizedString(@"%ld家门店使用此价格", nil),(long)plate.shopCount];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) showEditNVItemEvent:(NSString *)event withObj:(id<INameItem>)obj
{
    MenuPricePlanVo *vo = (MenuPricePlanVo *)obj;
    @weakify(self);
    UIViewController *viewControler = [[TDFMediator sharedInstance] TDFMediator_chainAddPriceFormatViewController:vo action:ACTION_CONSTANTS_EDIT isContinue:NO editCallBack:^(BOOL reFresh) {
        @strongify(self);
        [self listRelationPlate];
    }];
    [self.navigationController pushViewController:viewControler animated:YES];
}
- (void) showAddEvent:(NSString *)event
{
    @weakify(self);
    UIViewController *viewControler = [[TDFMediator sharedInstance] TDFMediator_chainAddPriceFormatViewController:nil action:ACTION_CONSTANTS_ADD isContinue:NO editCallBack:^(BOOL reFresh) {
         @strongify(self);
        [self listRelationPlate];
    }];
    [self.navigationController pushViewController:viewControler animated:YES];
}

- (void) showHelpEvent:(NSString *)event
{
    [HelpDialog show:@"ChainPriceFormat"];
}

- (void) leftNavigationButtonAction:(id)sender
{
    self.priceFormatCallBack(YES);
    [super leftNavigationButtonAction:sender];
}

@end
