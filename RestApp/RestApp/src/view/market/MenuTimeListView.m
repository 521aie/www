//
//  MenuTimeListView.m
//  RestApp
//
//  Created by zxh on 14-6-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridHead.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "TreeBuilder.h"
#import "RemoteEvent.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "MarketModule.h"
#import "TreeNodeUtils.h"
#import "EventConstants.h"
#import "MenuTimeListView.h"
#import "MenuTimePriceCell.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "TDFMediator+SettingModule.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "TDFMemberService.h"
#import "TDFRootViewController+FooterButton.h"
@implementation MenuTimeListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"商品促销", nil);
    [self initHead];
    [self initMainGrid];
//    NSArray* arr=[[NSArray alloc] initWithObjects:@"add", nil];
    self.datas=nil;
    [self.mainGrid reloadData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd|TDFFooterButtonTypeHelp];
//    [self.footView initDelegate:self btnArrs:arr];
//    self.footView.hidden=NO;
    [self loadDatas];
}

-(void) initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品促销", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (isnavigatemenupush) {
        isnavigatemenupush =NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
    }
}

#pragma 数据加载
-(void)loadDatas
{
    [self configNavigationBar:NO];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFMemberService new] listMenuTimeAll:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.datas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MenuTime class] json:dic[@"menuTimes"]]];
        self.details = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MenuTimePrice class] json:dic[@"menuTimePrices"]]];
        self.map = [[NSMutableDictionary alloc] init];
        if ([ObjectUtil isNotEmpty:self.details]) {
            for (MenuTimePrice* menuTimePrice in self.details) {
                if ([ObjectUtil isNull:[self.map objectForKey:menuTimePrice.menuTimeId]]) {
                    [self.map setObject:[[NSMutableArray alloc]init] forKey:menuTimePrice.menuTimeId];
                }
                NSMutableArray* menuTimePriceList = [self.map objectForKey:menuTimePrice.menuTimeId];
                [menuTimePriceList addObject:menuTimePrice];
            }
        }
        
        [self.headerItems removeAllObjects];
        [self.mainGrid reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark table deal
-(void)initMainGrid
{
    self.mainGrid.opaque=NO;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.mainGrid.tableHeaderView =[self tableHeaderView];
}


- (UIView *)tableHeaderView
{
    if (!tableHeaderView) {
        [self layoutHeaderView];
    }
    return tableHeaderView;
}
- (void)layoutHeaderView
{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 190)];
    tableHeaderView.backgroundColor =[UIColor clearColor];
    UIView *view =[[UIView alloc] initWithFrame:tableHeaderView.bounds];
    view.backgroundColor =[UIColor whiteColor];
    view.alpha =0.7;
    [tableHeaderView addSubview:view];
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20,60,60)];
    imageView.image =[UIImage imageNamed:@"ico_nav_color_menutime_trans"];
    [tableHeaderView addSubview:imageView];
    imageView.layer.masksToBounds =YES;
    imageView.layer.cornerRadius = imageView.width/2;
    imageView. layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 1.0f;
    UILabel *conTentLbl =[[UILabel alloc] initWithFrame:CGRectMake(11, imageView.bottom, SCREEN_WIDTH-11-11, 90)];
    [tableHeaderView addSubview: conTentLbl];
    conTentLbl.backgroundColor =[UIColor clearColor];
    conTentLbl.textAlignment = NSTextAlignmentLeft;
    conTentLbl.textColor =[UIColor grayColor];
    conTentLbl.numberOfLines =0;
    conTentLbl.font =[UIFont systemFontOfSize:13];
     conTentLbl.textColor =RGBA(123, 124, 126, 1);
    conTentLbl.text =NSLocalizedString(@"促销活动是一种收银机专用的优惠方式，收银员在收银机上开单时可以选择和使用。顾客端（扫码点餐）专用的优惠，请到“会员-会员优惠”中发布促销活动或优惠券、会员卡等", nil);
    UILabel *detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80+10, conTentLbl.bottom-20, 80, 40)];
    detailLabel.text =NSLocalizedString(@"查看详情", nil);
    detailLabel.textColor =[ColorHelper getBlueColor];
    detailLabel.font =[UIFont systemFontOfSize:13];
    detailLabel.backgroundColor =[UIColor clearColor];
    [tableHeaderView addSubview:detailLabel];
    UIImageView *picImg =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40+10, conTentLbl.bottom-20+10, 20, 20)];
    [tableHeaderView addSubview:picImg];
    picImg.image =[UIImage imageNamed:@"ico_next_blue"];
    UIImageView *picImgSe =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40+4+10, conTentLbl.bottom-20+10, 20, 20)];
    [tableHeaderView addSubview:picImgSe];
    picImgSe.image =[UIImage imageNamed:@"ico_next_blue"];
    
    UIButton *detailBtn =[[UIButton  alloc] initWithFrame:CGRectMake(detailLabel.left, conTentLbl.bottom-20, picImgSe.right, detailLabel.height)];
    [tableHeaderView addSubview:detailBtn];
    detailBtn.backgroundColor =[UIColor clearColor];
    [detailBtn addTarget:self action:@selector(footerHelpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTime *head = [self.datas objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.map objectForKey:head._id];
        if ([ObjectUtil isEmpty:temps] || indexPath.row==temps.count) {
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.lblName.text=NSLocalizedString(@"添加此促销内商品", nil);
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return footerItem;
        } else {
            MenuTimePriceCell *detailItem = (MenuTimePriceCell *)[tableView dequeueReusableCellWithIdentifier:MenuTimepriceCellIndentifier];
        
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"MenuTimePriceCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotEmpty:temps]) {
                MenuTimePrice* item=[temps objectAtIndex: indexPath.row];
                [detailItem initDelegate:self obj:item meuTime:head];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTime *head = [self.datas objectAtIndex:indexPath.section];
    if (![[tableView cellForRowAtIndexPath:indexPath] isMemberOfClass:[GridFooter class]]){
        return;
    }
    self.currMenuTime=head;
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.map objectForKey:head._id];
        if ([ObjectUtil isNotNull:temps] || indexPath.row==temps.count) {
            if ([ObjectUtil isNotEmpty:self.headList]) {
                [self showSelectMenu];
            } else {
                [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"type"] = @"0";
                @weakify(self);
                [[TDFMenuService new] listSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hide:YES];
                    NSMutableDictionary *dic = data[@"data"];
                    NSMutableArray* kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
                    self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
                    
                    self.allNodeList = [TreeBuilder buildTree:kindMenuList];
                    self.headList  = [TreeNodeUtils convertEndNode:self.allNodeList];
                    self.detailMap=[[NSMutableDictionary alloc] init];
                    NSMutableArray* arr=nil;
                    
                    if (self.detailList!=nil && self.detailList.count>0) {
                        for (SampleMenuVO* menu in self.detailList) {
                            arr=[self.detailMap objectForKey:menu.kindMenuId];
                            if (!arr) {
                                arr=[NSMutableArray array];
                            } else {
                                [self.detailMap removeObjectForKey:menu.kindMenuId];
                            }
                            [arr addObject:menu];
                            [self.detailMap setObject:arr forKey:menu.kindMenuId];
                        }
                    }
                    [self showSelectMenu];
                    
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hide:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MenuTime *head = [self.datas objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.map objectForKey:head._id];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count+1;
        } else {
            return 1;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MenuTime *head = [self.datas objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"reason"];
    [headItem initOperateWithAdd:YES edit:YES];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.datas]?self.datas.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimeEditViewWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) showAddEvent:(NSString*)event obj:(id)obj
{
    MenuTime *head = (MenuTime*)obj;
    self.currMenuTime=head;
    if ([ObjectUtil isNotNull:head]) {
        if ([ObjectUtil isNotEmpty:self.headList]) {
            [self showSelectMenu];
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"type"] = @"0";
            @weakify(self);
            [[TDFMenuService new] listSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud hide:YES];
                NSMutableDictionary *dic = data[@"data"];
                NSMutableArray* kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
                self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
                
                self.allNodeList = [TreeBuilder buildTree:kindMenuList];
                self.headList  = [TreeNodeUtils convertEndNode:self.allNodeList];
                self.detailMap=[[NSMutableDictionary alloc] init];
                NSMutableArray* arr=nil;
                
                if (self.detailList!=nil && self.detailList.count>0) {
                    for (SampleMenuVO* menu in self.detailList) {
                        arr=[self.detailMap objectForKey:menu.kindMenuId];
                        if (!arr) {
                            arr=[NSMutableArray array];
                        } else {
                            [self.detailMap removeObjectForKey:menu.kindMenuId];
                        }
                        [arr addObject:menu];
                        [self.detailMap setObject:arr forKey:menu.kindMenuId];
                    }
                }
                [self showSelectMenu];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    MenuTime* time=(MenuTime*)obj;
    self.currMenuTime=time;
      @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimeEditViewWithData:time action:ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"id"] = ids[0];
    @weakify(self);
    [[TDFMemberService new] removeMenuTimePriceWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self loadDatas];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)footerHelpButtonAction:(UIButton *)sender {

    [HelpDialog show:@"menutime"];
}

-(void) showSelectMenu
{
    if (self.currMenuTime.mode==2) {

        NSMutableArray *menuTimeList = [self.map objectForKey:self.currMenuTime._id];
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SelectMultiMenuListView:menuTimeList delegate:self needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SelectMenuListView:self.headList nodes:self.allNodeList datas:self.detailList dic:self.detailMap delegate:self needHideOldNavigationBar:YES];
         [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma  SelectSingleMenuHandle delegate
- (void)closeView
{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishSelectList:(NSArray *)list
{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    self.menuIds = [NSMutableArray array];
    if ([ObjectUtil isNotEmpty:list]) {
        for (NSString *menuId in list) {
            [self.menuIds addObject:menuId];
        }
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_id_str"] = [self.menuIds yy_modelToJSONString];
    param[@"id"] = self.currMenuTime._id;
    @weakify(self);
    [[TDFMemberService new] saveMenuTimePriceListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self loadDatas];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)finishSelectMenu:(SampleMenuVO *)menu
{
   //促销添加商品
    MenuTimePrice* item=[MenuTimePrice new];
    item.menuId=menu._id;
    item.menuTimeId=self.currMenuTime._id;
    item.menuName=menu.name;
    item.menuPrice=menu.price;
    item.isRatio=self.currMenuTime.isRatio;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimePriceEditViewWithData:item action:ACTION_CONSTANTS_ADD CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
