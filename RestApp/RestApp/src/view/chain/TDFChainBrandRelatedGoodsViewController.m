//
//  TDFChainBrandRelatedGoodsViewController.m
//  RestApp
//
//  Created by zishu on 16/10/8.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainBrandRelatedGoodsViewController.h"
#import "ObjectUtil.h"
@implementation TDFChainBrandRelatedGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"品牌关联商品", nil);
    self.delegate = self;
    self.contents = NSLocalizedString(@"总部可以根据不同品牌的定位，从连锁商品总库中挑选适合该品牌的商品。当总部发布商品时，品牌相关门店就可以更新关联的所有商品了。", nil);
    self.imageName = @"brandrelatemenu";
    [self.view addSubview:self.tableView];
    [self initGrid];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self listRelationPlate];
}

- (void) listRelationPlate
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
     @weakify(self);
    [[TDFChainMenuService new] getPlatesWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.dataArray = [[NSArray yy_modelArrayWithClass:[PlateMenuListVo class] json:data[@"data"]] mutableCopy];
        if (self.dataArray.count == 0) {
            self.placeholderContents = NSLocalizedString(@"连锁总部还没有任何品牌。先到连锁首页品牌下添加一个吧！", nil);
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
        PlateMenuListVo *plate = self.dataArray[indexPath.row];
        cell.lblName.text = plate.plateName;
        if (plate.menuCnt == 0) {
            cell.lblVal.textColor = [ColorHelper getRedColor];
            cell.lblVal.text = NSLocalizedString(@"未关联商品", nil);
        }else{
            cell.lblVal.textColor = [ColorHelper getBlueColor];
            cell.lblVal.text = [NSString stringWithFormat:NSLocalizedString(@"共计%ld个商品", nil),(long)plate.menuCnt];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) showEditNVItemEvent:(NSString *)event withObj:(id<INameItem>)obj
{
    PlateMenuListVo *vo = (PlateMenuListVo *)obj;
    [self showProgressHudWithText:NSLocalizedString(@"正在查询", nil)];
    [self getPlateMenus:vo];
}

- (void) getPlateMenus:(PlateMenuListVo *)vo
{
    self.plateEntityId = vo.plateEntityId;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"plate_entity_id"] = vo.plateEntityId;
    
    @weakify(self);
    [[TDFChainMenuService new] getPlateMenusWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableArray *array = [[NSArray yy_modelArrayWithClass:[PlateMenuDetailVo class] json:data[@"data"]] mutableCopy];
        NSMutableDictionary *menuMap = [[NSMutableDictionary alloc] init];
        for (PlateMenuDetailVo *vo in array) {
            if (vo.plateMenuVos.count != 0) {
                [menuMap setValue:vo.plateMenuVos forKey:vo.kindMenuId];
            } 
        }
        NSString *content;
        if ([ObjectUtil isEmpty:array]) {
            content = NSLocalizedString(@"              连锁旗下还没有任何商品，\n                   请先添加商品。", nil);
        }else{
            content = @"";
        }
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_chainSelecttMenuWithHeadViewController:CHAIN_BAND_RELATE_MENU delegate:self title:[NSString stringWithFormat:NSLocalizedString(@"%@-关联商品", nil),vo.plateName] nodeList:array detailMap:menuMap content:content changeData:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) closeMultiView:(NSInteger)event
{
    
}

- (void) showHelpEvent:(NSString *)event
{
    [HelpDialog show:@"ChainBrandRelateMenu"];
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items
{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"plate_entity_id"] = self.plateEntityId;
    param[@"menu_ids"] = [items yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] savePlateMenusWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self listRelationPlate];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

@end
