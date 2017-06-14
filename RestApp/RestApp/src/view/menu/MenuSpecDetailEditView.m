//
//  MenuSpecDetailEditView.m
//  RestApp
//
//  Created by zxh on 14-8-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuSpecDetailEditView.h"
#import "MenuModule.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "MenuSpecDetail.h"
#import "XHAnimalUtil.h"
#import "MenuEditView.h"
#import "FormatUtil.h"
#import "UIView+Sizes.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "SingleCheckView.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "MenuModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "FormatUtil.h"
#import "Menu.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "YYModel.h"
#import "TDFMenuService.h"
@implementation MenuSpecDetailEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        service=[ServiceFactory Instance].menuService;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.changed=NO;
    [self initCurrentView];
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self createData];
}

- (void)initCurrentView
{
     hud = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  data  = self.sourceDic [@"data"];
        id  menu  = self.sourceDic [@"menu"];
        NSString *actionStr  = [NSString stringWithFormat:@"%@",self.sourceDic [@"action"]];
        [self loadData:data menu:menu action:actionStr.intValue];
 }
}
#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:MENU_EDIT_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (DIRECT_RIGHT) {
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self  save];
}

- (void)initMainView
{
    [self.lblName initLabel:NSLocalizedString(@"规格名称", nil) withHit:nil];
    [self.lblRawScale initLabel:NSLocalizedString(@"此规格用料是基准商品用料的几倍", nil) withHit:nil];
    [self.lblRawScale.lblName setWidth:230];
    [self.lblPriceRatio initLabel:NSLocalizedString(@"此规格价格是基准商品价格的几倍", nil) withHit:nil];
    [self.lblPriceRatio.lblName setWidth:230];
    [self.lblDefaultPrice initLabel:NSLocalizedString(@"默认单价", nil) withHit:nil];
    [self.lsPrice initLabel:NSLocalizedString(@"自定义单价(元)", nil) withHit:nil delegate:self];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
- (void)loadData:(MenuSpecDetail*) objTemp menu:(Menu*)menu action:(int)action
{
    [hud hide:YES];
    self.action=action;
    self.menu=menu;
    self.menuSpecDetail=objTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=@"";
        self.title = @"";
    } else {
        self.titleBox.lblTitle.text=self.menu.name;
        self.title = self.menu.name;
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}
 -(void) fillModel
{
    [self.titleBox initWithName:self.menuSpecDetail.specDetailName backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
   [self.lblName initData:self.menuSpecDetail.specDetailName withVal:self.menuSpecDetail.specDetailName];
    NSString* rawScaleStr= [FormatUtil formatDouble4:self.menuSpecDetail.rawScale];
    [self.lblRawScale initData:[NSString stringWithFormat:@"%@",rawScaleStr] withVal:rawScaleStr];
    
    //修改
    NSString* priceRatioStr= [FormatUtil formatDouble4:self.menuSpecDetail.priceRatio];
    [self.lblPriceRatio initData:[NSString stringWithFormat:@"%@",priceRatioStr] withVal:priceRatioStr];
    
    double menuPrice=self.menu.price*self.menuSpecDetail.priceRatio;
    NSString* defaultPrice=[FormatUtil formatDouble4:menuPrice];
    [self.lblDefaultPrice initData:[NSString stringWithFormat:NSLocalizedString(@"%@元", nil),defaultPrice] withVal:defaultPrice];
    
    NSString *nowPrice = [FormatUtil formatDouble4:self.menuSpecDetail.definePrice];
    [self.lsPrice initData:nowPrice withVal:nowPrice];
}
#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_MenuSpecEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuSpecEditView_Change object:nil];
   
}
#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}
#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"自定义单价(元)不能为空!", nil)];
        return NO;
    }
    
    if (![NSString isFloat:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"自定义单价(元)不是数字!", nil)];
        return NO;
    }
    return YES;
}

-(MenuSpecDetail*) transMode
{
    MenuSpecDetail* objUpdate=[MenuSpecDetail new];
    objUpdate.rawScale=self.menuSpecDetail.rawScale;
    objUpdate.menuId=self.menuSpecDetail.menuId;
    objUpdate.specItemId=self.menuSpecDetail.specItemId;
    objUpdate.specDetailName=self.menuSpecDetail.specDetailName;
    objUpdate.sortCode=self.menuSpecDetail.sortCode;
    objUpdate.priceMode=self.menuSpecDetail.priceMode;
    objUpdate.priceRatio=self.menuSpecDetail.priceRatio;
    objUpdate.menuName=self.menuSpecDetail.menuName;
    objUpdate.menuPrice=self.menuSpecDetail.menuPrice;
    objUpdate.addMode=[[self.lblDefaultPrice getStrVal] isEqualToString:[self.lsPrice getStrVal]]?ADDMODE_AUTO:ADDMODE_HAND;
    objUpdate.priceScale=[self.lsPrice getStrVal].doubleValue;
    return objUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    MenuSpecDetail* newMenuSpecDetail=[self transMode];
    if (self.action==ACTION_CONSTANTS_ADD) {
        //        需求中，这种情况不会存在
        //        [service saveMenuMake:newMenuMake event:REMOTE_MENU_MAKE_SAVE];
    }else{
        newMenuSpecDetail.id=self.menuSpecDetail.id;
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_spec_detail_str"] = [newMenuSpecDetail yy_modelToJSONString];
        parma[@"menu_id"] = self.menu.id;
        [UIHelper showHUD:NSLocalizedString(@"正在更新", nil) andView:self.view andHUD:hud];
        @weakify(self);
        [[TDFMenuService new] updateMenuSpecDetailWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            
//            [parent.menuEditView loadMenuMakeSpec:self.menu.id];
//            [parent showView:MENU_EDIT_VIEW];
//            [XHAnimalUtil animalEdit:parent action:self.action];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass: [MenuEditView class]]) {
                    [(MenuEditView *)viewController loadMenuMakeSpec:self.menu._id];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menuSpecDetail.specDetailName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_spec_detail_id"] = [NSString isBlank:self.menuSpecDetail.id]?@"":self.menuSpecDetail.id;
        @weakify(self);
        [[TDFMenuService new] deleteMenuSpecDetailWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
//            [parent showView:MENU_EDIT_VIEW];
//            [parent.menuEditView loadMenuMakeSpec:self.menu.id];
//            [XHAnimalUtil animalEdit:parent action:self.action];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass: [MenuEditView class]]) {
                    [(MenuEditView *)viewController loadMenuMakeSpec:self.menu._id];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma test event
#pragma edititemlist click event.
//List控件变换.
- (void)onItemListClick:(EditItemList*)obj
{
    
}

#pragma 变动的结果.
#pragma 单选页结果处理.

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    [self.lsPrice changeData:val withVal:val];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"basemenu"];
}

@end
