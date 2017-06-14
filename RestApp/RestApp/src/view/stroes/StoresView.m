//
//  SroresView.m
//  RestApp
//
//  Created by iOS香肠 on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "StoresView.h"
#import "NavigateTitle2.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "KeyBoardUtil.h"
#import "NSString+Estimate.h"
#import "MemberListCell.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ViewFactory.h"
#import "UIImageView+TDFRequest.h"
#import "NameItemVO.h"
#import "DHHeadItem.h"
#import "UIImage+Resize.h"
#import "SelectMultiMenuItem.h"
#import "MJRefresh.h"
#import "BranchShopVo.h"
#import "ChainService.h"
#import "NSMutableArray+DeepCopy.h"
#import "BranchTreeVo.h"
#import "GlobalRender.h"
#import "AlertBox.h"
#import "TDFBranchCompanyListViewController.h"
#import "TDFRootViewController+FooterButton.h"
# import "TDFBuffetShopViewController.h"
#import "TDFInviteShopToJoinViewController.h"

@implementation StoresView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (UITableView *)storeTab {
    if(!_storeTab) {
        _storeTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105) style:UITableViewStylePlain];
        _storeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _storeTab.delegate = self;
        _storeTab.dataSource = self;
    }
    return _storeTab;
}

- (UIView *)panel {
    if(!_panel) {
        _panel = [[UIView alloc] init];
        _panel.backgroundColor = [UIColor colorWithRed:85/255.0f green:85/255.0f blue:85/255.0f alpha:1];
        _panel.alpha = 0.75;
        _panel.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.25;
        view.frame = CGRectMake(6, 3, SCREEN_WIDTH-50-12, 34);
        [_panel addSubview:view];
        
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        cancel.frame = CGRectMake(SCREEN_WIDTH-50, 5, 50, 30);
        [cancel addTarget:self action:@selector(cancleSearch:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_search"];
        icon.frame = CGRectMake(8, 10, 22, 22);
        [_panel addSubview:icon];
        
        [_panel addSubview:cancel];
        
        [_panel addSubview:self.txtKey];
        self.txtKey.frame = CGRectMake(34, 5, view.frame.size.width-CGRectGetMaxX(icon.frame), 32);
    }
    return _panel;
}

- (UITextField *)txtKey {
    if(!_txtKey) {
        _txtKey = [[UITextField alloc] init];
        _txtKey.placeholder = NSLocalizedString(@"输入店名/编码", nil);
        _txtKey.font = [UIFont systemFontOfSize:14];
        _txtKey.textColor = [UIColor whiteColor];
    }
    return _txtKey;
}

- (UIButton *)btnBg {
    if(!_btnBg) {
        _btnBg = [[UIButton alloc] init];
        [_btnBg addTarget:self action:@selector(btnBgClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _btnBg;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    self.viewMode = ListMode;
    
    [self initNavigate];
    
    [self.view addSubview:self.panel];
    [self.view addSubview:self.storeTab];
    [self.view addSubview:self.btnBg];
    
    [self.view bringSubviewToFront:self.filterBtn];
    
    [self initView];
    [self initGrid];
    self.select = NO;
    self.title = NSLocalizedString(@"门店", nil);
    
    self.storeTab.backgroundColor = [UIColor clearColor];
    self.headerItems = [[NSMutableArray alloc] init];
    self.selectList = [[NSMutableArray alloc] init];
    
    [self initSelectPanel];
    [self loadData];
    
    [XHAnimalUtil animationMoveOut:self.selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
}

- (void) initSelectPanel
{
    self.selectRolePanel = [[SelectRolePanel alloc]initWithNibName:@"SelectRolePanel" bundle:nil];
    [self.selectRolePanel.btnSelect setTitle:NSLocalizedString(@"  分公司管理", nil) forState:UIControlStateNormal];
    
    self.selectRolePanel.view.frame = CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT);
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"门店", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
}

- (void)changeTitle {
    
    if (self.viewMode == ListMode) {
        self.titleBox.imgMore.hidden = YES;
        self.titleBox.lblRight.hidden = YES;
        self.titleBox.btnUser.userInteractionEnabled = NO;
    }else if (self.viewMode == BatchMode) {
        self.titleBox.imgMore.hidden = NO;
        self.titleBox.lblRight.hidden = NO;
        self.titleBox.btnUser.userInteractionEnabled = YES;
    }
}

- (void)initView
{
    [self.txtKey setDelegate:self];
    [self.panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    [self.txtKey setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    [self hideDHSearchBar];
    [KeyBoardUtil initWithTarget:self.txtKey];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:_selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
    if (self.viewMode == ListMode) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self configRightNavigationBar:nil rightButtonName:nil];
        self.viewMode = ListMode;
        [self loadData];
        [self.selectList removeAllObjects];
        [self.storeTab reloadData];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
  [self operateStore];
}

- (void)initFootView {
    if (self.viewMode == ListMode) {
        if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
            if ([[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"]) {
                [self generateFooterButtonWithTypes:TDFFooterButtonTypeBatch |TDFFooterButtonTypeAddShop|TDFFooterButtonTypeHelp];
            }else{
              [self generateFooterButtonWithTypes:TDFFooterButtonTypeBatch|TDFFooterButtonTypeHelp];
            }
        }else{
           [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
        }
    }else{
        [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck |TDFFooterButtonTypeHelp];
    }
}


#pragma mark table deal
-(void)initGrid
{
    self.storeTab.opaque=NO;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    [self.storeTab setTableFooterView:view];
    
    [self.storeTab registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:MemberListItemIndetifiner];

    __weak typeof (self)weakSelf = self;
    
    self.storeTab.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            isRefresh = NO;
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            [weakSelf queryShopList];
    }];
    
    self.storeTab.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            isRefresh = YES;
            weakSelf.page = weakSelf.page + 1;
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            [weakSelf queryShopList];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.storeTab.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;

}

- (void)loadData
{
    self.isHasChain = NO;
    [self removeAllFooterButtons];
    [self.selectRolePanel.view removeFromSuperview];
    [self changeTitle];
    self.filterBtn.hidden = YES;
    [self initFootView];
    
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
         [[UIApplication sharedApplication].keyWindow addSubview:self.selectRolePanel.view];
        self.filterBtn.hidden = NO;
    }
   
    self.page = 1;
    [self queryShopList];
    [self queryBranchList];
}

- (void)queryShopList
{
    [self.headList removeAllObjects];
    [self.detailMap removeAllObjects];
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [parma setObject:@"1" forKey:@"page_index"];
    
    @weakify(self);
    [[[TDFChainService alloc] init] queryShopListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.storeTab.header endRefreshing];
        [self.storeTab.footer endRefreshing];
        self.headList = [[NSMutableArray alloc] init];
        self.detailMap = [[NSMutableDictionary alloc] init];
        if ([ObjectUtil isNotEmpty:data[@"data"]]) {
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchShopVo *branchShopVo = [[BranchShopVo alloc] initWithDictionary:dic];
                 [self.headList addObject:branchShopVo];
                
                BranchShopVo *branchShopVoItem = [self.headList firstObject];
                if ([NSString isNotBlank:branchShopVoItem.brandName]) {
                    self.isHasChain = YES;
                    branchShopVoItem.branchId = @"0";
                }else{
                    self.isHasChain = NO;
                }
                if ([ObjectUtil isNotEmpty:[dic objectForKey:@"shopVoList"]]) {
                    NSMutableArray *shopList = [ShopVO convertToShopVoListByArr:[dic objectForKey:@"shopVoList"]];
                    [self.detailMap setObject:shopList forKey:[branchShopVo obtainItemId]];
                }
            }
        }

        
        self.backHeadList = [self.headList deepCopy];
        self.backDetailMap = [self.detailMap mutableCopy];
         [self.storeTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.storeTab.header endRefreshing];
        [self.storeTab.footer endRefreshing];
        [AlertBox show:error.localizedDescription];
    }];
}

//操作
- (void)operateStore {
    
    NSInteger count = [self checkValid];
    if (count == 0) {
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"分公司", nil), NSLocalizedString(@"品牌", nil), nil];
    sheet.tag = 2000;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 2000) {
        if (buttonIndex == 0) {
            [self batchOperate:NSLocalizedString(@"分公司", nil) eventType:buttonIndex];
        }else if(buttonIndex == 1){
            [self batchOperate:NSLocalizedString(@"品牌", nil) eventType:buttonIndex];
        }
    }
}

- (void)batchOperate:(NSString*)name eventType:(NSInteger)eventType {
    if (eventType == 1) {
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
        [param setObject:[[Platform Instance] getkey:USER_ID] forKey:@"user_id"];
        
        @weakify(self);
        [[TDFChainService new] queryPlateListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            NSMutableArray *plateList = [[NSMutableArray alloc] init];
            
            plateList = [Plate convertToPlateListByArr:[data objectForKey:@"data"]];
            NSMutableArray *plateNameList = [[NSMutableArray alloc] init];
            if ([ObjectUtil isNotEmpty:plateList]){
                for (Plate *plate in plateList) {
                    NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:plate.name andId:plate.id];
                    [plateNameList addObject:nameItem];
                }
            }
            [OptionSelectView show:NSLocalizedString(@"选择品牌", nil) list:plateNameList selectData:nil target:self editItem:@"brand" Placeholder:NSLocalizedString(@"输入名称", nil) event:2 isPresentMode:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        @weakify(self);
        [[TDFChainService new] queryBranchListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            NSMutableArray *branchNameList = [[NSMutableArray alloc] init];
            if ([ObjectUtil isNotEmpty:data[@"data"]]) {
                for (NSMutableDictionary *dic in data[@"data"]) {
                    BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                    NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:branchTreeVo.branchName andId:branchTreeVo.entityId];
                    nameItem.itemValue = [NSString stringWithFormat:@"%d",branchTreeVo.level];
                    [branchNameList addObject:nameItem];
                }
            }
            [OptionSelectView show:NSLocalizedString(@"选择分公司", nil) list:branchNameList selectData:nil target:self editItem:@"branch" Placeholder:NSLocalizedString(@"输入名称", nil) event:3 isPresentMode:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}


- (BOOL)selectOption:(id<INameItem>)data editItem:(id)editItem
{
    NSString *str;
    if ([editItem isKindOfClass:[NSString class]]) {
        str = (NSString *)editItem;
        self.viewMode = BatchMode;
        [self.storeTab reloadData];
        if ([str isEqualToString:@"brand"]) {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[data obtainItemId] forKey:@"plate_id"];
            [param setObject:[JsonHelper arrObjTransJson:self.selectList] forKey:@"shop_vo_list_str"];
            
            [self showProgressHudWithText:NSLocalizedString(@"正在批量更换品牌", nil)];
            
              @weakify(self);
            [[TDFChainService new] batchSetShopPlateWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                 @strongify(self);
                [self.progressHud hide:YES];
                [AlertBox show:NSLocalizedString(@"批量操作品牌成功", nil)];
                [self queryShopList];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                @strongify(self);
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }else{
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[data obtainItemId] forKey:@"branch_entity_id"];
            [param setObject:[JsonHelper arrObjTransJson:self.selectList] forKey:@"shop_vo_list_str"];

            [self showProgressHudWithText:NSLocalizedString(@"正在批量更换分公司", nil)];
             @weakify(self);
            [[TDFChainService new] batchSetShopBranchWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud hide:YES];
                [AlertBox show:NSLocalizedString(@"批量操作分公司成功", nil)];
                 [self queryShopList];
                [self.selectList removeAllObjects];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                @strongify(self);
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];

        }
    }
    return YES;
}
//批量验证是否有选择门店
- (NSInteger)checkValid {
    
    NSMutableArray* ids=[self getStores];
    if (ids==nil || ids.count==0) {
        [AlertBox show:NSLocalizedString(@"请先选择门店后，再进行操作!", nil)];
        return 0;
    }
    return ids.count;
}

//获取选中门店id
- (NSMutableArray*)getStores {
    
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (id<INameItem> item in self.headList) {
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
             if (details != nil) {
                 for (ShopVO *shopVo in details) {
                     if ([shopVo obtainCheckVal]) {
                         [ids addObject:[item obtainItemId]];
                     }
                 }
             }
        }
    }
    return ids;
}


- (void)initWithKeyword:(NSString *)keyword
{
    self.headList=[NSMutableArray array];
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray *details=nil;
    NSMutableArray* arr=nil;
   
    for (id<INameItem> head in self.backHeadList) {
        details= [self.backDetailMap objectForKey:[head obtainItemId]];
        BOOL isExist=NO;
        BOOL nameCheck=NO;
        BOOL codeCheck=NO;
          if ([ObjectUtil isNotEmpty:details]) {
              for (id<IMultiNameValueItem> item in details) {
                  nameCheck=[[item obtainItemName] rangeOfString:keyword].location!=NSNotFound;
                  codeCheck=[[item obtainItemValue] rangeOfString:keyword].location!=NSNotFound;
                   if (nameCheck || codeCheck) {
                        arr=[self.detailMap objectForKey:[head obtainItemId]];
                       if (!arr) {
                           arr=[NSMutableArray array];
                       } else {
                           [self.detailMap removeObjectForKey:[head obtainItemId]];
                       }
                       [arr addObject:item];
                       [self.detailMap setObject:arr forKey:[head obtainItemId]];
                       isExist=YES;
                   }
                }
          }
        if (isExist) {
            [self.headList addObject:head];
        }
    }
    [self.headerItems removeAllObjects];
    [self.storeTab reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SystemUtil hideKeyboard];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        [self initWithKeyword:keyword];
        [self startSearchMode];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.viewMode==ListMode)?88:48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<INameItem> item = [self.headList objectAtIndex:section];
    if (item != nil) {
        NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
        if (details != nil) {
            return details.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewMode == ListMode) {
        MemberListCell *cell = (MemberListCell *)[tableView dequeueReusableCellWithIdentifier:MemberListItemIndetifiner];
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.cornerRadius = 10;
        
        if ([ObjectUtil isNotEmpty:self.headList]) {
            id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
            if (item != nil) {
                NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                if (details != nil) {
                    ShopVO *shopVo = details[indexPath.row];
                    cell.name.text = shopVo.name;
                    cell.cardStatus.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"店编码:", nil),shopVo.code];
                    if (shopVo.joinMode == 1) {
                        cell.lblValText.text = NSLocalizedString(@"直营", nil);
                        cell.lblValText.textColor = [UIColor grayColor];
                    }else{
                        if (shopVo.joinMode == 0) {
                            cell.lblValText.text = NSLocalizedString(@"加盟", nil);
                        }else if (shopVo.joinMode == 2)
                        {
                            cell.lblValText.text = NSLocalizedString(@"合作", nil);
                        }else if (shopVo.joinMode == 3)
                        {
                            cell.lblValText.text = NSLocalizedString(@"合营", nil);
                        }
                        cell.lblValText.textColor = [UIColor redColor];
                    }
                    cell.mobile.text = [NSString stringWithFormat:NSLocalizedString(@"品牌:%@", nil),[NSString isBlank:[shopVo obtainOrignName]] ? @"" :[shopVo obtainOrignName]];
                    [cell.imgView tdf_imageRequstWithPath:shopVo.shopPicture placeholderImage:[UIImage imageNamed:@"icon_default_shop"] urlModel:ImageUrlCapture];
                }
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
          //批量操作
        SelectMultiMenuItem *detailItem = (SelectMultiMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
        if (detailItem==nil) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem" owner:self options:nil].lastObject;
        }
        if ([ObjectUtil isNotEmpty:self.headList]) {
            id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
            if (item != nil) {
                NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                if (details != nil) {
                    id<IMultiNameValueItem> item=(id<IMultiNameValueItem>)[details objectAtIndex:indexPath.row];
                    detailItem.lblName.text = [item obtainItemName];
                    detailItem.imgCheck.hidden=![item obtainCheckVal];
                    detailItem.imgUnCheck.hidden=[item obtainCheckVal];
   
                }
        }

        }
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
               return detailItem;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.viewMode == ListMode) {
        if ([ObjectUtil isNotEmpty:self.headList]) {
            id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
            if (item != nil) {
                NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                if (details != nil) {
                    ShopVO *shopVo = details[indexPath.row];
                    TDFMediator *mediator = [[TDFMediator alloc] init];
                    
                    @weakify(self);
                    UIViewController *viewontroller = [mediator TDFMediator_editStoresViewControllerWithShopId:shopVo.id editStoresCallBack:^(BOOL orFresh) {
                        @strongify(self);
                        [self loadData];
                    }];
                    [self.navigationController pushViewController:viewontroller animated:YES];
                }
            }
        }
    }else{
        if ([ObjectUtil isNotEmpty:self.headList]) {
            id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
            if (item != nil) {
                NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                if (details != nil) {
                    id<IMultiNameValueItem> item=[details objectAtIndex:indexPath.row];
                    [item mCheckVal:![item obtainCheckVal]];
                    if ([self.selectList containsObject:item]) {
                        [self.selectList removeObject:item];
                    }
                    if ([item obtainCheckVal]) {
                        [self.selectList addObject:item];
                    }
                    [self.storeTab reloadData];
                }
            }
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headList.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [self.headerItems addObject:headItem];
    [headItem.panel.layer setMasksToBounds:YES];
    headItem.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    if ([ObjectUtil isNotEmpty:self.headList ]) {
            id<INameItem> item = [self.headList objectAtIndex:section];
            headItem.lblName.text = [item obtainItemName];
    }
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    if (0 - point.y >= 44) {
        if (self.isSearchMode == NO) {
            [self.txtKey becomeFirstResponder];
            [self showDHSearchBar];
        }
    }
}

- (IBAction)cancleSearch:(id)sender {
    [self cancelSearchMode];
    self.headList = self.backHeadList;
    self.detailMap = self.backDetailMap;
    [self.storeTab reloadData];
}
- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.txtKey becomeFirstResponder];
        [self showDHSearchBar];
    }
}

- (void)cancelSearchMode
{
    if (self.isSearchMode) {
        self.txtKey.text = @"";
        [self hideDHSearchBar];
        [SystemUtil hideKeyboard];
    }
}

- (void)showDHSearchBar
{
    self.isSearchMode = YES;
    self.panel.hidden = NO;
    self.panel.frame = CGRectMake(0,-50,SCREEN_WIDTH,40);
    self.storeTab.frame = CGRectMake(0,64,SCREEN_WIDTH,self.navigationController.view.frame.size.height-64);
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.panel.frame = CGRectMake(0,64,SCREEN_WIDTH,40);
    self.storeTab.frame = CGRectMake(0,104,SCREEN_WIDTH,self.navigationController.view.frame.size.height-101);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.panel.hidden = YES;
    self.panel.frame = CGRectMake(0,64,SCREEN_WIDTH,40);
    self.storeTab.frame = CGRectMake(0,104,SCREEN_WIDTH,self.navigationController.view.frame.size.height-101);
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    self.panel.frame = CGRectMake(0,-50,SCREEN_WIDTH,40);
    self.storeTab.frame = CGRectMake(0,64,SCREEN_WIDTH,self.navigationController.view.frame.size.height-64);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"chainhdbrad"];
}

- (void) footerBatchButtonAction:(UIButton *)sender
{
    self.select = NO;
    [self.storeTab setContentOffset:CGPointMake(0, 0) animated:NO];
    [self hideDHSearchBar];
    self.viewMode = BatchMode;
    self.txtKey.text = @"";
    self.categoryId = nil;
    [self configRightNavigationBar:@"ico_bat.png" rightButtonName:NSLocalizedString(@"操作", nil)];
    [self loadData];
}

- (IBAction)btnBgClick:(id)sender
{
    self.select = NO;
    [XHAnimalUtil animationMoveOut:self.selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
}

- (IBAction)filtBtnClick:(id)sender
{
    self.select = !self.select;
    if (self.select) {
        [self showSelectRole];
    }else{
        [XHAnimalUtil animationMoveOut:self.selectRolePanel.view backround:self.btnBg];
        [self animationMoveOut:self.filterBtn backround:self.btnBg];
    }
}

#pragma 右侧分公司列表，定位使用.
- (void)showSelectRole
{
    BranchShopVo *branchShop = [self.headList firstObject];
    BranchTreeVo *branchTreeVo = [self.branchCompanyList firstObject];
    if ([NSString isNotBlank:branchShop.brandName] && [branchTreeVo.branchName isEqualToString:NSLocalizedString(@"总部直属", nil)]) {
          [self.branchCompanyList removeObject:branchTreeVo];
    }
    
    if (self.isHasChain) {
        BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] init];
        branchTreeVo.branchName = NSLocalizedString(@"总部直属", nil);
        branchTreeVo.branchId = @"0";
        [self.branchCompanyList insertObject:branchTreeVo atIndex:0];
    }
    
    [self.selectRolePanel.btnSelect setTitle:NSLocalizedString(@"  分公司管理", nil) forState:UIControlStateNormal];
    [self.selectRolePanel initDelegate:self event:11];
    [self.selectRolePanel loadData:self.branchCompanyList];
    [XHAnimalUtil animationMoveIn:self.selectRolePanel.view backround:self.btnBg];
    [self animationMoveIn:self.filterBtn backround:self.btnBg];
}

- (void) queryBranchList
{
    self.branchCompanyList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFChainService new] queryBranchListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        if ([ObjectUtil isNotEmpty:data[@"data"]]) {
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                branchTreeVo.branchName = [self getName:branchTreeVo.level-1 name:branchTreeVo.branchName];
                [self.branchCompanyList addObject:branchTreeVo];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}

-(NSString*) getName:(int)level name:(NSString*)name
{
    if (level==0) {
        return name;
    }
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    for (int i=0; i<level; i++) {
        [result appendString:NSLocalizedString(@"▪︎", nil)];
    }
    [result appendString:@""];
    [result appendString:name];
    return [NSString stringWithString:result];
}

- (void)singleCheck:(NSInteger)event item:(id<INameItem>) item
{
    BranchTreeVo *branchTreeVo = (BranchTreeVo *)item;
    [self scrocll:branchTreeVo];
    [XHAnimalUtil animationMoveOut:self.selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
    self.select = NO;
}

- (void)scrocll:(BranchTreeVo*)branchTreeVo
{
    if ([ObjectUtil isNotEmpty:self.branchCompanyList] && [ObjectUtil isNotNull:branchTreeVo]) {
        NSInteger index = [GlobalRender getPos:self.headList itemId:branchTreeVo.branchId];
        CGFloat offset = index*38;
        for (NSUInteger i=0;i<index;++i) {
            BranchTreeVo *nodeTemp = [self.headList objectAtIndex:i];
            if ([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap objectForKey:[nodeTemp obtainItemId]];
                if ([ObjectUtil isNotEmpty:menus]) {
                    if (self.viewMode == ListMode) {
                      offset += 85*menus.count;
                    }else{
                        offset += 44*menus.count;
                    }
                }
            }
        }
        [self.storeTab setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

- (void)closeSingleView:(NSInteger)event
{
//    [XHAnimalUtil animationMoveOut:self.selectRolePanel.view backround:self.btnBg];
//    [self animationMoveOut:self.filterBtn backround:self.btnBg];
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *branchListContoller = [mediator TDFMediator_branchCompanyListViewControllerWithType:ModuleType delegate:nil branchCompanyList:nil branchCompanyListArr:nil isFromBranchEditView:NO listCallBack:^(BOOL orFresh) {
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x + SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
            //           self.btnBg.hidden = NO;
            
           self.selectRolePanel.view.frame = CGRectMake(self.selectRolePanel.view.frame.origin.x + SCREEN_WIDTH, self.selectRolePanel.view.frame.origin.y, self.selectRolePanel.view.bounds.size.width, self.selectRolePanel.view.bounds.size.height);
            self.filterBtn.frame = CGRectMake(self.filterBtn.frame.origin.x + SCREEN_WIDTH, self.filterBtn.frame.origin.y, self.filterBtn.bounds.size.width, self.filterBtn.bounds.size.height);
        }];

//        [XHAnimalUtil animationMoveIn:self.selectRolePanel.view backround:self.btnBg];
//        [self animationMoveIn:self.filterBtn backround:self.btnBg];
    }];
    [self.navigationController pushViewController:branchListContoller animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x - SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
        //           self.btnBg.hidden = NO;
        
        self.selectRolePanel.view.frame = CGRectMake(self.selectRolePanel.view.frame.origin.x - SCREEN_WIDTH, self.selectRolePanel.view.frame.origin.y, self.selectRolePanel.view.bounds.size.width, self.selectRolePanel.view.bounds.size.height);
        self.filterBtn.frame = CGRectMake(self.filterBtn.frame.origin.x - SCREEN_WIDTH, self.filterBtn.frame.origin.y, self.filterBtn.bounds.size.width, self.filterBtn.bounds.size.height);
    }];

}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - self.selectRolePanel.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.5;
    [UIView commitAnimations];
    
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    for (id<INameItem> item in self.headList) {
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            for (id<IMultiNameValueItem> item in details) {
                [item mCheckVal:YES];
                [self.selectList addObject:item];
            }
            [self.storeTab reloadData];
        }
    }
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    for (id<INameItem> item in self.headList) {
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            for (id<IMultiNameValueItem> item in details) {
                [item mCheckVal:NO];
                [self.selectList removeAllObjects];
            }
            [self.storeTab reloadData];
            
        }
    }
}

- (void) footerAddShopButtonAction:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择添加门店" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancleAction];
    
    UIAlertAction *addShopAction = [UIAlertAction actionWithTitle:@"创建新门店" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TDFBuffetShopViewController *viewController = [[TDFBuffetShopViewController alloc] init];
        viewController.openShopMode = TDFBrandOpenShop;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [alert addAction:addShopAction];
    
    UIAlertAction *inviteShopAction = [UIAlertAction actionWithTitle:@"邀请门店加入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TDFInviteShopToJoinViewController *viewController = [[TDFInviteShopToJoinViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [alert addAction:inviteShopAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
