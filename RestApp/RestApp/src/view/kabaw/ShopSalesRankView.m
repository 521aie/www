//
//  ShopSalesRankView.m
//  RestApp
//
//  Created by xueyu on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "MJRefresh.h"
#import "ObjectUtil.h"
#import "KabawModule.h"
#import "GlobalRender.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "MenuStatisticsVo.h"
#import "MenusRankListView.h"
#import "MenuSalesRankCell.h"
#import "ShopSalesRankView.h"
#import "TDFKabawService.h"
#import "TDFMediator+KabawModule.h"
#import "TDFOptionPickerController.h"

#define SHOP_RANK_LSTYPE 1
#define SHOP_MENU_LSCOUNT 2
#define MenuSalesRankCellIndentifier @"MenuSalesRankCellIndentifier"
@implementation ShopSalesRankView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent= parentTemp;
        service=[ServiceFactory Instance].kabawService;
        self.menus = [[NSMutableArray alloc]init];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.container addSubview:self.tableView];
    [self initMainView];
    [self initNavigate];
    [self initMainGrid];
    [self initNotifaction];
    [self loadDatas];
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 232) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleView addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"本店销量榜", nil);
}

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.noteView]];
}

//- (void)onNavigateEvent:(NSInteger)event
//{
//    if (event==DIRECT_LEFT) {
//        [parent showView:SECOND_MENU_VIEW];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
//    }else{
//      
//        [self save];
//    }
//    
//}
-(void)initMainView{
    [self.lsRankType initLabel:NSLocalizedString(@"排行榜生成方式", nil) withHit:nil isrequest:YES delegate:self];
    self.note.text = NSLocalizedString(@"SHOP_SALE_RANK_NOTE", nil);
    [self.note sizeToFit];
    [self.lsRankType initData:NSLocalizedString(@"自动", nil) withVal:@"1"];
    
    [self.lsMenuCount initLabel:NSLocalizedString(@"▪︎ 设置参与排行的菜品", nil) withHit:NSLocalizedString(@"注：本店销量榜统计的是自昨天向前30个自然日内的销量，可能会与报表里面的“商品排行报表”统计有出入，因为“商品排行报表”是按照营业结束时间来统计的。", nil) delegate:self];
    [self.lsMenuCount initData:NSLocalizedString(@"0个菜", nil) withVal:@"0"];
    [self.lsMenuCount.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    self.lsRankType.tag = SHOP_RANK_LSTYPE;
    self.lsMenuCount.tag = SHOP_MENU_LSCOUNT;
    [self updateSize:YES];
    
}

- (void)initMainGrid
{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *menuSalesRankCell= [UINib nibWithNibName:NSStringFromClass([MenuSalesRankCell class]) bundle:nil];
    [self.tableView registerNib:menuSalesRankCell forCellReuseIdentifier:MenuSalesRankCellIndentifier];
//    __weak typeof (self)weakSelf = self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        isRefreshed = NO;
//
//    }];
//    
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        isRefreshed = YES;
//        weakSelf.page = weakSelf.page + 1;
//    }];
//    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.footer;
//    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
}

-(void)loadDatas{
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.menus removeAllObjects];
    [self.tableView reloadData];

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] getMenuCountSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        [self loadMenusCountFinish:data ];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)initNotifaction
{
    [UIHelper initNotification:self.noteView event:Notification_UI_ShopDetailEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ShopDetailEditView_Change object:nil];
}

- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.noteView] act:ACTION_CONSTANTS_EDIT];
}

#pragma mark 数据加载

-(void)loadMenusCountFinish:(id )dataSource{
    
    NSInteger count = [ObjectUtil getIntegerValue:dataSource key:@"data"];
    if ( count > 0 ) {
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        [[TDFKabawService new] getStatusByEntityIdSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud hide:YES];
            self.status = [ObjectUtil getShortValue:data key:@"data"];
            [self.lsRankType initData:[[GlobalRender getItem:[GlobalRender listRankTypes] withId:[NSString stringWithFormat:@"%d",self.status]] obtainItemName] withVal:[NSString stringWithFormat:@"%d",self.status]];
            [self updateSize:!self.status];
            [self loadAutoOrManualStatus:self.status type:self.status];
           
           
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        self.scrollView.hidden = YES;
        self.noDataTip.hidden = NO;
        self.tipContent.text = NSLocalizedString(@"在顾客使用微信点餐后，才可以使用销量榜功能哦!", nil);
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        return;
    }
 
}

- (void)loadAutoOrManualStatus:(NSInteger )status  type:(NSInteger)type
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] getMenuSatisticsOrMenuConfigByStatus:status type:type sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [self loadShopSalesFinish:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


-(void)loadShopSalesFinish:(id)dataSource {
   
    NSArray *data = dataSource [@"data"];
    [self.menus removeAllObjects];
    if ([ObjectUtil isNotEmpty:data])
    {
        for (NSDictionary *dict in data)
            {
            MenuStatisticsVo *vo = [[MenuStatisticsVo alloc]initWithDictionary:dict];
            [self.menus addObject:vo];
        }
     }
    
    if (self.status&&self.menus.count==0) {
        self.scrollView.hidden = NO;
        self.noDataTip.hidden = YES;
        CGRect rect = self.tableView.frame;
        rect.size.height = 44 * self.menus.count+20;
        self.tableView.frame = rect;
        [self.tableView reloadData];
        [self updateSize:!self.status];
        return;
    }
     if ([ObjectUtil isNotEmpty:self.menus]) {
        self.scrollView.hidden = NO;
        self.noDataTip.hidden = YES;
        CGRect rect = self.tableView.frame;
        rect.size.height = 44 * self.menus.count+20;
        self.tableView.frame = rect;
        [self.tableView reloadData];
        [self updateSize:!self.status];
    } else {
        self.scrollView.hidden = YES;
        self.noDataTip.hidden = NO;
        self.tipContent.text = NSLocalizedString(@"在顾客使用微信点餐后，才可以使用销量榜功能哦!", nil);
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        return;
    }
    
    
    
 }
#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ObjectUtil isEmpty:self.menus]?0:self.menus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuSalesRankCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuSalesRankCellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MenuStatisticsVo *vo = self.menus[indexPath.row];
    [cell initDataWithMenuStatisticsVo:vo number:indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma IEditItemListEvent delegate
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SHOP_RANK_LSTYPE)
    {
//        [OptionPickerBox initData:[GlobalRender listRankTypes] itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[GlobalRender listRankTypes]
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[GlobalRender listRankTypes][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if (obj.tag == SHOP_MENU_LSCOUNT){
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_menusRankListViewControllerHideOldNavigationBar:YES withCallBack:^(id data) {
            [self loadDatas];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        
//        [parent showView:MENUS_RANK_LIST_VIEW];
//        [parent.menuRankListView initData];
  }
}
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType{

    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == SHOP_RANK_LSTYPE){
        [self.lsRankType changeData:[item obtainItemName] withVal:[item  obtainItemId]];

         self.status = [[item obtainItemId] intValue];

        [self loadAutoOrManualStatus:[[item obtainItemId] intValue] type:[[item obtainItemId] intValue]];

        BOOL isAuto = [[item obtainItemId] isEqualToString:@"0"];

        [self updateSize:isAuto];
    }
     return YES;
}
-(void)updateSize:(BOOL)isAuto{  
    if (isAuto) {
        CGRect rect = self.noteView.frame;
        rect.size.height = self.note.frame.size.height + self.note.frame.origin.y + 5;
        self.noteView.frame = rect;
        self.lsMenuCount.hidden = YES;
        self.note.hidden = NO;
        CGRect backRect = self.backView.frame;
        backRect.size.height = rect.size.height;
        self.backView.frame = backRect;
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self.tableView setTop:self.tableView.top + 5];
    }else{
    CGRect rect = self.noteView.frame;
    rect.size.height = self.lsMenuCount.frame.size.height + self.lsMenuCount.frame.origin.y -1;
        self.noteView.frame = rect;
        self.lsMenuCount.hidden = NO;
        [self.lsMenuCount initData:[NSString stringWithFormat:NSLocalizedString(@"%ld个菜", nil), (long) self.menus.count] withVal:@"0"];
        self.note.hidden = YES;
        CGRect backRect = self.backView.frame;
        backRect.size.height = rect.size.height;
        self.backView.frame = backRect;
         [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self.tableView setTop:self.tableView.top + 50];
    }
}

#pragma mark 保存
-(void)save{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    
    if (self.status) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (MenuStatisticsVo *vo in self.menus) {
            [array addObject:vo.menuId];
        }
        [self  UpdateMenuSaticsOrMenuConfigByStatus:array];
        
    }else{
        [self  UpdateMenuSaticsOrMenuConfigByStatus: nil];
     }
    
}

- (void) UpdateMenuSaticsOrMenuConfigByStatus:(NSMutableArray *)arry
{
    [[TDFKabawService new]  updateMenuSatisticsOrMenuConfigByStatus:self.status menuIds:arry sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
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
//    [parent showView:SECOND_MENU_VIEW];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}

@end
