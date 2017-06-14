//
//  MenuAdditionEditView.m
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuAdditionEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "ItemTitle.h"
#import "AdditionListView.h"
#import "XHAnimalUtil.h"
#import "FormatUtil.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "SingleCheckView.h"
#import "NSString+Estimate.h"
#import "SpecListView.h"
#import "MenuModuleEvent.h"
#import "TasteListView.h"
#import "JsonHelper.h"
#import "SampleMenuVO.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "ServiceFactory.h"
#import "TDFRootViewController+FooterButton.h"
@implementation MenuAdditionEditView

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
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self createData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    self.title = NSLocalizedString(@"加料", nil);
  //  [self.titleBox initWithName:NSLocalizedString(@"加料", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];

}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:ADDITION_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        [self save];
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}


-(void) initMainView
{
    [self.lblKind initLabel:NSLocalizedString(@"加料分类", nil) withHit:nil];
    [self.txtName initLabel:NSLocalizedString(@"加料名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsPrice initLabel:NSLocalizedString(@"加价(元)", nil) withHit:nil delegate:self];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsPrice.tag=MENU_PRICE;
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        id data  = self.dic [@"data"];
        id kind  = self.dic [@"kind"];
        id delegate  = self.dic [@"delegate"];
        self.delegate  = delegate;
        NSString *actionStr  = self.dic [@"action"];
        [self loadData:data kind:kind action:actionStr.intValue];
    }
}

#pragma remote
-(void) loadData:(AdditionMenuVo*) objTemp kind:(AdditionKindMenuVo*)kind action:(int)action
{
    [self.progressHud hide:YES];
    self.action=action;
    self.menu=objTemp;
    self.kindMenu=kind;
    [self.lblKind initData:self.kindMenu.kindMenuName withVal:self.kindMenu.kindMenuId];
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
         //self.titleBox.lblTitle.text=NSLocalizedString(@"添加新料", nil);
        self.title =NSLocalizedString(@"添加新料", nil);
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加新料", nil);
        [self clearDo];
    }else{

        self.titleBox.lblTitle.text=self.menu.menuName;
//        self.titleBox.lblTitle.text=self.menu.name;
        self.title  = self.menu.menuName;

        [self fillModel];
    }
    if (self.action== ACTION_CONSTANTS_ADD) {
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    [self.lsPrice initData:@"0" withVal:@"0"];
}

-(void) fillModel
{
    [self.txtName initData:self.menu.menuName];
    NSString* priceStr=[FormatUtil formatDouble4:self.menu.menuPrice];
    [self.lsPrice initData:priceStr withVal:priceStr];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuAdditionEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuAdditionEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
  }


-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [parent showView:ADDITION_LIST_VIEW];
    [parent.additionListView loadDatas];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}


#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"加料名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(Menu*) transModel
{
    Menu* objUpdate=[Menu new];
    objUpdate.kindMenuId=self.kindMenu.kindMenuId;
    objUpdate.name=[self.txtName getStrVal];
    objUpdate.price=[self.lsPrice getStrVal].doubleValue;
    return objUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    Menu* menuNew=[self transModel];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:NSLocalizedString(tip, nil)];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_str"] = [menuNew yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveMenuAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menu.menuName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {

        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.menu.menuName]];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = self.kindMenu.kindMenuId;
//        @weakify(self);
        [[TDFMenuService new] removeMenuAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
//            @strongify(self);
            [self.progressHud hideAnimated:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [parent showView:ADDITION_LIST_VIEW];
            [parent.additionListView loadDatas];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }

}

-(void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud hideAnimated:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:@"" data:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [parent showView:ADDITION_LIST_VIEW];
//    [parent.additionListView loadDatas];
//    [XHAnimalUtil animalEdit:parent action:self.action];

}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenuingr"];
}

#pragma IEditItemListEvent协议.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj.tag==MENU_PRICE) {
        
    }
}

- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==MENU_PRICE) {
        [self.lsPrice changeData:val withVal:val];
    }
}

@end
