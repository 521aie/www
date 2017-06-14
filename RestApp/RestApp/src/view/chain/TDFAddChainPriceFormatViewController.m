//
//  TDFAddChainPriceFormatViewController.m
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFAddChainPriceFormatViewController.h"
#define ADD_PRICE_FORMAT @"ADD_PRICE_FORMAT"
#import "ObjectUtil.h"
@implementation TDFAddChainPriceFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContainer];
    [self initMainView];
    [self initNotifaction];

    [self loadData:self.vo action:self.action];
}

- (void) initMainView
{
    self.nameEditItemText = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
//    [self.nameEditItemText initLabel:NSLocalizedString(@"价格方案名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.nameEditItemText initLabel:NSLocalizedString(@"价格方案名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault wordNum:15 wordStr:@""];
    [self.container addSubview:self.nameEditItemText];
    
    self.shopCountView = [[EditItemView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width, 48)];
    [self.shopCountView awakeFromNib];
    [self.shopCountView initLabel:NSLocalizedString(@"使用此价格的门店", nil) withHit:nil];
    [self.shopCountView initData:@"0" withVal:@"0"];
    [self.container addSubview:self.shopCountView];
    
    self.shopGrid = [[ActionDetailTable alloc] initWithFrame:CGRectMake(0, 96, self.scrollView.frame.size.width, 48)];
    [self.container addSubview:self.shopGrid];
    [self.shopGrid awakeFromNib];
    [self.shopGrid initDelegate:self event:ADD_PRICE_FORMAT addName:NSLocalizedString(@"添加门店", nil) itemMode:ITEM_MODE_DEL];
    [self.shopGrid loadData:nil details:nil detailCount:0];
    
    self.btnDel = [[UIButton alloc] initWithFrame:CGRectMake(10,700, self.view.frame.size.width - 10*2, 40)];
    [self.btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [self.btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    [self.btnDel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.btnDel];
    [self.btnDel setHidden:self.action == ACTION_CONSTANTS_ADD];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];

}

- (void)initContainer
{
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.scrollView.frame.size.height)];
    self.container.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.container];
}

- (void)loadData:(MenuPricePlanVo *)vo action:(NSInteger)action
{    if (action == ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加价格方案", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        self.title = NSLocalizedString(@"编辑价格方案", nil);
        [self getMenuPricePlan];
    }
}

- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_TDFAddChainPriceFormatViewControllert_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TDFAddChainPriceFormatViewControllert_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        return;
    }
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    self.isContinue = NO;
    [self save];
}
- (void) getMenuPricePlan
{
    [self showProgressHudWithText:NSLocalizedString(@"正在查询", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_price_plan_id"] = self.vo.pricePlanId;

    @weakify(self);
    [[TDFChainMenuService new] getMenuPricePlanWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.vo = [MenuPricePlanVo yy_modelWithJSON:data[@"data"]];
        [self fillModel];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) fillModel
{
    [self configNavigationBar:NO];
    [self.nameEditItemText initData:self.vo.pricePlanName];
    NSString *shopCount = [NSString stringWithFormat:@"%d",self.vo.shopCount];
    [self.shopCountView initData:shopCount withVal:shopCount];
    [self processTreeNode:self.vo.simpleBranchVoList grid:self.shopGrid];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    self.btnDel.frame = CGRectMake(10, self.shopGrid.frame.size.height + self.shopGrid.frame.origin.y + 15, self.view.frame.size.width - 10*2, 40);
}

- (void)processTreeNode:(NSMutableArray *)nodes grid:(ActionDetailTable *)grid
{
    NSMutableArray *headList = [NSMutableArray array];
    NSMutableDictionary *detailMap = [NSMutableDictionary dictionary];
    NSMutableArray *childNodes = [NSMutableArray array];
    int count=0;
    NSMutableArray* arr=nil;
    int num = 0;
    for (SimpleBranchVo *node in nodes) {
        num ++ ;
        if (node.branchId == nil) {
            node.branchId = [NSString stringWithFormat:@"%d",num];
        }
        [headList addObject:node];
        childNodes = node.simpleShopVoList;
        if (childNodes==nil || childNodes.count==0) {
            continue;
        }
        for (SimpleShopVo* secondNode in childNodes) {
            secondNode.menuPricePlanName = @"";
            arr = [detailMap objectForKey:node.branchId];
            if (!arr) {
                arr=[NSMutableArray array];
            } else {
                [detailMap removeObjectForKey:node.branchId];
            }
            [arr addObject:secondNode];
            count++;
            [detailMap setObject:arr forKey:node.branchId];
        }
    }
    [grid loadData:headList details:detailMap detailCount:count];
}

- (void)buttonClick:(UIButton *)btn
{
     [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确定要删除此价格方案吗？", nil)];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_price_plan_id"] = self.vo.pricePlanId;
        parma[@"last_ver"] = [NSString stringWithFormat:@"%d",self.vo.lastVer];
        @weakify(self);
        [[TDFChainMenuService new] deleteMenuPricePlanWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.addPriceFormatCallBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)delObjEvent:(NSString*)event obj:(id)obj
{
    if ([ObjectUtil isNotNull:obj]) {
        SimpleShopVo* act=(SimpleShopVo*)obj;
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"menu_price_plan_id"] = self.vo.pricePlanId;
        param[@"shop_entity_id"] = act.entityId;
        @weakify(self);
        [[TDFChainMenuService new] deleteMenuPricePlanShopWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.addPriceFormatCallBack(YES);
            [self getMenuPricePlan];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void) showAddEvent:(NSString *)event
{
    if (![self isValid]) {
        return;
    }
    [self.nameEditItemText.txtVal  resignFirstResponder];
    self.action = ACTION_CONSTANTS_EDIT;
    if ([UIHelper currChange:self.container]) {
        self.isContinue = YES;
        [self save];
    }else{
        [self queryAllShop];
    }
}

- (void) queryAllShop
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_price_plan_id"] = self.vo.pricePlanId;
    
    @weakify(self);
    [[TDFChainMenuService new] queryAllShopWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableArray *array = [[NSArray yy_modelArrayWithClass:[SimpleBranchVo class] json:data[@"data"]] mutableCopy];
        int num = 0;
        NSMutableDictionary *menuMap = [[NSMutableDictionary alloc] init];
        for (SimpleBranchVo *vo in array) {
            num ++ ;
            if (vo.branchId == nil) {
                vo.branchId = [NSString stringWithFormat:@"%d",num];
            }
            if (vo.simpleShopVoList.count != 0) {
                [menuMap setValue:vo.simpleShopVoList forKey:vo.branchId];
            }
        }
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_chainSelecttMenuWithHeadViewController:ADD_PRICE_FORMATINT delegate:self title:NSLocalizedString(@"选择门店", nil) nodeList:array detailMap:menuMap content:nil changeData:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void) closeMultiView:(NSInteger)event
{
//    self.title = self.vo.pricePlanName;
    self.title = NSLocalizedString(@"编辑价格方案", nil);
    self.btnDel.hidden = NO;
    [self getMenuPricePlan];
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items
{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_price_plan_id"] = self.vo.pricePlanId;
    param[@"shop_entity_ids_str"] = [items yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] saveMenuPricePlanShopsWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.addPriceFormatCallBack(YES);
        self.title = NSLocalizedString(@"编辑价格方案", nil);
        self.btnDel.hidden = NO;
        [self getMenuPricePlan];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (MenuPricePlanVo *)menuPricePlanTransMode
{
    MenuPricePlanVo *vo = [[MenuPricePlanVo alloc] init];
    vo.pricePlanId = self.vo.pricePlanId;
    vo.pricePlanName = [self.nameEditItemText getStrVal];
    vo.lastVer = self.vo.lastVer;
    vo.entityId = self.vo.entityId;
    vo.shopCount =self.vo.shopCount;
    return vo;
}

- (void) save
{
    if (![self isValid]) {
        return;
    }
    [self showProgressHudWithText:self.action == ACTION_RAW_PAPER_ADD?NSLocalizedString(@"正在保存", nil):NSLocalizedString(@"正在更新", nil)];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_price_plan_str"] = [[self menuPricePlanTransMode] yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] saveMenuPricePlanWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.action = ACTION_CONSTANTS_EDIT;
        self.addPriceFormatCallBack(YES);
        if (self.isContinue) {
            self.vo = [MenuPricePlanVo yy_modelWithJSON:data[@"data"]];
            [self queryAllShop];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (BOOL)isValid{
    if ([[self.nameEditItemText getStrVal] isEqualToString:NSLocalizedString(@"基础价格", nil)]) {
        [AlertBox show:NSLocalizedString(@"价格方案名称不能为[基础价格]", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.nameEditItemText getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"价格方案名称不能为空", nil)];
        return NO;
    }
    if ([self.nameEditItemText getStrVal].length > 15) {
        [AlertBox show:NSLocalizedString(@"方案名称不能超过15个字。", nil)];
        return NO;
    }
    return YES;
}
@end
