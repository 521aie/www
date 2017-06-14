//
//  MenusRankListView.m
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "MJRefresh.h"
#import "GridColHead.h"
#import "KabawModule.h"
#import "XHAnimalUtil.h"
#import "MBProgressHUD.h"
#import "TDFKabawService.h"
#import "ServiceFactory.h"
#import "MenuStatisticsVo.h"
#import "MenuRankListCell.h"
#import "MenusRankListView.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFKabawService.h"
#define MenuRankListCellIndentifier @"MenuRankListCellIndentifier"
@implementation MenusRankListView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        parent= parentTemp;
        service=[ServiceFactory Instance].kabawService;
//        hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.menus = [[NSMutableArray alloc]init];
        self.menuIds = [[NSMutableArray alloc]init];
}
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainGrid];
    [self initData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck];
}
- (void)initNavigate
{
    self.title = NSLocalizedString(@"参与排行的菜品", nil);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 60)];
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configNavigationBar:YES];
//    [self.titleBox initWithName:NSLocalizedString(@"参与排行的菜品", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    
}

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    if ([ObjectUtil isEmpty:self.menuIds]) {
        [UIHelper alertView:self.view andDelegate:self andTitle:NSLocalizedString(@"提示", nil) andMessage:NSLocalizedString(@"您要放弃使用销量榜功能吗？顾客在微店中将不能参考销量榜点餐了。", nil)];
    } else{
        [self save];
    }
}

//- (void)onNavigateEvent:(NSInteger)event
//{
//    if (event==DIRECT_LEFT) {
//        [parent showView:SHOP_SALES_RANK_VIEW];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
//    } else{
//        
//    }
//    
//}
- (void)initMainGrid
{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *menuRankListCell= [UINib nibWithNibName:NSStringFromClass([MenuRankListCell class]) bundle:nil];
   [self.tableView registerNib:menuRankListCell forCellReuseIdentifier:MenuRankListCellIndentifier];
//    __weak typeof (self)weakSelf = self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        weakSelf.page = 1;
////        isRefreshed = NO;
//        [weakSelf initTableViewData];
//    }];
//
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        isRefreshed = YES;
//        weakSelf.page = weakSelf.page + 1;
//        
//        
//    }];
//    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.footer;
//    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
}

-(void)initData{
    [self.menus removeAllObjects];
    [self.menuIds removeAllObjects];
    [self.tableView reloadData];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    self.tableView.contentOffset = CGPointMake(0, 0);
    [[TDFKabawService new ] getMenuSatisticsOrMenuConfigByStatus:1 type:0 sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull dataSource) {
        [self.progressHud hide:YES];
       NSArray *data = dataSource [@"data"];
        if ([ObjectUtil isNotEmpty:data]) {
            
            for (NSDictionary *dict in data) {
                MenuStatisticsVo *vo = [[MenuStatisticsVo alloc]initWithDictionary:dict];
                if (vo.isAutomatic) {
                    [self.menuIds addObject:vo.menuId];
                }
                [self.menus addObject:vo];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}



-(void)loadShopSalesFinish:(RemoteResult *)result
    {
         [self.progressHud hide:YES];
         [self.tableView.header endRefreshing];
         // [self.tableView.footer endRefreshing];
         if (result.isRedo) {
             return;
         }
         if (!result.isSuccess) {
             [AlertBox show:result.errorStr];
             //
//             self.page = self.page - 1;
             return;
         }
        
        
        NSDictionary *dict = [JsonHelper transMap:result.content];
         NSArray *data = [dict objectForKey:@"data"];
//        [self.menus removeAllObjects];
//        [self.menuIds removeAllObjects];
        if ([ObjectUtil isNotEmpty:data]) {
    
             for (NSDictionary *dict in data) {
                 MenuStatisticsVo *vo = [[MenuStatisticsVo alloc]initWithDictionary:dict];
                 if (vo.isAutomatic) {
                    [self.menuIds addObject:vo.menuId];
                 }
                 [self.menus addObject:vo];
             }
         }
        [self.tableView reloadData];
         
         
 }


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ObjectUtil isEmpty:self.menus]?0:self.menus.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuRankListCellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MenuStatisticsVo *vo = self.menus[indexPath.row];
    [cell initDataWithMenuStatisticsVo:vo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.tableView dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"菜名", nil) col2:NSLocalizedString(@"30天内卖出份数", nil)];
    [headItem initColLeft:55 col2:138];
    if (section == 0) {
        return headItem;
    }
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 40;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuRankListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     MenuStatisticsVo *vo = self.menus[indexPath.row];
    if (!vo.isSelf){
        [AlertBox show:NSLocalizedString(@"已下架商品仅作参考，不能参与排行。可先将商品上架再设置。", nil)];
        return;
    }
    
    cell.selectBtn.selected = !cell.selectBtn.selected;
    vo.isAutomatic = cell.selectBtn.selected;
    if (cell.selectBtn.selected) {
        [self.menuIds addObject:vo.menuId];
    } else{
        [self.menuIds removeObject:vo.menuId];
    }
}
#pragma mark
-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    
    [self.menuIds removeAllObjects];
    if (self.menus!=nil && self.menus.count>0) {
        for ( MenuStatisticsVo *vo in self.menus) {
            if (vo.isSelf) {
                vo.isAutomatic = YES;
                [self.menuIds addObject:vo.menuId];
            }
        }
    }
    [self.tableView reloadData];
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    if (self.menus!=nil && self.menus.count>0) {
        
        for ( MenuStatisticsVo *vo in self.menus) {
            if (vo.isSelf) {
                vo.isAutomatic = NO;
      }
        }
    }
    
    [self.menuIds removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark 保存数据
-(void)save{

   [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
   [[TDFKabawService new]  updateMenuSatisticsOrMenuConfigByStatus:1 menuIds:self.menuIds sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
         [self.progressHud hideAnimated:YES];
       [self.navigationController popViewControllerAnimated:YES];
       if (self.callBack) {
           self.callBack(nil);
       }
       
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       [self.progressHud hideAnimated:YES];
       [AlertBox show:error.localizedDescription];
   }];

}

-(void)updateFinish:(RemoteResult *)result{

    [self.progressHud hide:YES];;
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.callBack) {
        self.callBack(nil);
    }
//    [parent showView:SHOP_SALES_RANK_VIEW];
//    [parent.shopSalesRankView loadDatas];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    [self save];
}
@end
