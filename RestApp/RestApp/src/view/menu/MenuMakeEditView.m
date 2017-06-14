//
//  MenuMakeEditView.m
//  RestApp
//
//  Created by zxh on 14-7-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuMakeEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "TDFOptionPickerController.h"
#import "NavigateTitle.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "MenuMake.h"
#import "XHAnimalUtil.h"
#import "MenuEditView.h"
#import "FormatUtil.h"
#import "MakeRender.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "SingleCheckView.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "MakeListView.h"
#import "MenuModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "YYModel.h"
@implementation MenuMakeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCurrentView];
    self.changed=NO;
    
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
    [self.titleBox initWithName:NSLocalizedString(@"商品做法", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:MENU_EDIT_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES ];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}
#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuMakeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuMakeEditView_Change object:nil];
}

- (UILabel *)attentionLabel
{
    if (!_attentionLabel) {
        _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.lsMakePrice.view.frame.size.height + self.lsMakePrice.view.frame.origin.y, SCREEN_WIDTH - 16, 40)];
        _attentionLabel.numberOfLines = 0;
        _attentionLabel.font = [UIFont systemFontOfSize:12];
        _attentionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _attentionLabel.text = NSLocalizedString(@"提示：添加完做法后，可以去商品详情里对商品进行做法的设置。", nil);
    }
    return _attentionLabel;
}

- (void)initMainView
{
    [self.lblName initLabel:NSLocalizedString(@"做法名称", nil) withHit:nil];
    [self.lsMakePriceMode initLabel:NSLocalizedString(@"加价模式", nil) withHit:nil delegate:self];
    [self.lsMakePrice initLabel:NSLocalizedString(@"▪︎ 做法加价", nil) withHit:nil delegate:self];
    [self.scrollView addSubview:self.attentionLabel];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsMakePriceMode.tag=MENUMAKE_PRICEMODE;
    self.lsMakePrice.tag=MENUMAKE_PRICE;
    
    [self.lsMakePrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
- (void)loadData:(MenuMake *)objTemp menu:(Menu *)menu action:(NSInteger)action
{
    [hud hide:YES];
    self.action = action;
    self.menuMake = objTemp;
    self.menu = menu;
    [self.btnDel setHidden:(action==ACTION_CONSTANTS_ADD)];
    if (action==ACTION_CONSTANTS_ADD) {
        self.attentionLabel.hidden = NO;
        self.title = NSLocalizedString(@"添加做法", nil);
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加做法", nil);
        [self clearDo];
    } else {
        self.attentionLabel.hidden = YES;
        self.titleBox.lblTitle.text=self.menuMake.name;
          self.title = self.menuMake.name;
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.lblName initData:nil withVal:nil];
    [self.lsMakePriceMode initData:NSLocalizedString(@"不加价", nil) withVal:[NSString stringWithFormat:@"%d",MAKEPRICE_NONE]];
    [self.lsMakePrice initData:@"0" withVal:@"0"];
    [self.lsMakePrice visibal:NO];
}

- (void)fillModel
{
    [self.lblName initData:self.menuMake.name withVal:self.menuMake.name];
    NSString* makePriceModeStr=[NSString stringWithFormat:@"%d",self.menuMake.makePriceMode ];
    [self.lsMakePriceMode initData:[GlobalRender obtainItem:[MakeRender listMakePriceMode] itemId:makePriceModeStr] withVal:makePriceModeStr];
    NSString* priceStr=[FormatUtil formatDouble4:self.menuMake.makePrice];
    [self.lsMakePrice initData:priceStr withVal:priceStr];
    [self.lsMakePrice visibal:(self.menuMake.makePriceMode!=MAKEPRICE_NONE)];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma save-data

- (BOOL)isValid
{
    if ([NSString isBlank:[self.lsMakePriceMode getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"做法加价模式不能为空!", nil)];
        return NO;
    }
    int priceMode=[self.lsMakePriceMode getStrVal].intValue;
    if (priceMode!=MAKEPRICE_NONE) {
        if ([NSString isBlank:[self.lsMakePrice getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"做法加价不能为空!", nil)];
            return NO;
        }
        if (![NSString isFloat:[self.lsMakePrice getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"做法加价不是数字!", nil)];
            return NO;
        }
    }
    return YES;
}

- (MenuMake*) transMode
{
    MenuMake *objUpdate=[MenuMake new];
    objUpdate.makeId = self.menuMake.makeId;
    objUpdate.name = self.menuMake.name;
    objUpdate.menuId = self.menuMake.menuId;
    int priceMode = [self.lsMakePriceMode getStrVal].intValue;
    objUpdate.makePriceMode=priceMode;
    if (priceMode==MAKEPRICE_NONE) {
        objUpdate.makePrice=0;
    } else {
        objUpdate.makePrice= [self.lsMakePrice getStrVal].doubleValue;
    }
    return objUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    MenuMake* newMenuMake = [self transMode];
    
    newMenuMake.id=self.menuMake.id;
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_make_str"] = [newMenuMake yy_modelToJSONString];
    
    @weakify(self);
    [[TDFMenuService new] updateMenuMakeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [hud hide:YES];
//        [parent.menuEditView loadMenuMakeSpec:self.menu.id];
//        [parent showView:MENU_EDIT_VIEW];
//        [XHAnimalUtil animalEdit:parent action:self.action];
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

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menuMake.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_make_id"] = [NSString isBlank:self.menuMake._id]?@"":self.menuMake._id;
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        
        @weakify(self);
        [[TDFMenuService new] deleteMenuMakeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass: [MenuEditView class]]) {
                    [(MenuEditView *)viewController loadMenuMakeSpec:self.menu._id];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
//            [parent.menuEditView loadMenuMakeSpec:self.menu.id];
//            [parent showView:MENU_EDIT_VIEW];
//            [XHAnimalUtil animalEdit:parent action:self.action];
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
-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag==MENUMAKE_PRICEMODE) {
//        [OptionPickerBox initData:[MakeRender listMakePriceMode] itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                     options:[MakeRender listMakePriceMode]
                                                                               currentItemId:[obj getStrVal]];
        
        __weak __typeof(self) wself = self;
        vc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MakeRender listMakePriceMode][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];

    }
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    if (event==MENUMAKE_PRICEMODE) {
        [self.lsMakePriceMode changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.lsMakePrice visibal:([item obtainItemId].intValue!=MAKEPRICE_NONE)];
    }
//    [parent showView:MENUMAKE_EDIT_VIEW];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    [self.lsMakePrice changeData:val withVal:val];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"basemenu"];
}

@end
