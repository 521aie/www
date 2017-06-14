//
//  KindAdditionEditView.m
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindAdditionEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "KindMenu.h"
#import "XHAnimalUtil.h"
#import "FormatUtil.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "MenuModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "AdditionListView.h"
#import "HelpDialog.h"
#import "TDFMenuService.h"
#import "TDFRootViewController+FooterButton.h"
@implementation KindAdditionEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.changed=NO;
    [self initHud];
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self  createDataSource];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)initHud
{
     hud = [[MBProgressHUD alloc] initWithView:self.view];
}
#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"加料分类", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==1) {
        [parent showView:ADDITION_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    }else{
        [self save];
    }
}
  
- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}
    
- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}
    
- (UILabel *)attentionLabel
{
    if (!_attentionLabel) {
        _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.txtName.view.frame.size.height + self.txtName.view.frame.origin.y, SCREEN_WIDTH - 16, 40)];
        _attentionLabel.numberOfLines = 0;
        _attentionLabel.font = [UIFont systemFontOfSize:12];
        _attentionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _attentionLabel.text = NSLocalizedString(@"提示：添加完加料分类后，可以去商品分类里对商品分类进行加料的设置。", nil);
    }
    return _attentionLabel;
}


-(void) initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"加料分类", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.attentionLabel];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)createDataSource
{
    if (self.dic) {
        id  data  = self.dic [@"data"];
        int action  = [NSString stringWithFormat:@"%@",self.dic[@"action"]].intValue;
        [self loadData:data action: action];
    }
}
#pragma remote
-(void) loadData:(AdditionKindMenuVo*) objTemp action:(int)action
{
    [hud hide:YES];
    self.action=action;
    self.kindMenu=objTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.attentionLabel.hidden = NO;
        //self.titleBox.lblTitle.text=NSLocalizedString(@"添加加料分类", nil);
        self.title  = NSLocalizedString(@"添加加料分类", nil);
        [self clearDo];
    }else{
        self.attentionLabel.hidden = YES;
        self.titleBox.lblTitle.text=self.kindMenu.kindMenuName;
        self.title  = self.kindMenu.kindMenuName;
        [self fillModel];
    }
  //  [self.titleBox editTitle:NO act:self.action];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}


#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.kindMenu.kindMenuName];
}



#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_KindAdditionEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindAdditionEditView_Change object:nil];
   
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
 //   [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"备注分类名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(KindMenu*) transModel{
    KindMenu* objUpdate=[KindMenu new];
    objUpdate.name=[self.txtName getStrVal];
    objUpdate.isInclude=ISINCLUDE_ADDITION;
    objUpdate.sortCode=@"0";
    objUpdate.deductKind=1;
    objUpdate.deduct=0;
    objUpdate.id=self.kindMenu.kindMenuId;
    return objUpdate;
}


-(void)save{
    if (![self isValid]) {
        return;
    }
    KindMenu* kindMenuNew=[self transModel];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {

        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_str"] = [kindMenuNew yy_modelToJSONString];
//        @weakify(self);
        [[TDFMenuService new] saveKindAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            for (UIViewController *vieController in self.navigationController.viewControllers) {
                if ([vieController isKindOfClass:[AdditionListView class]]) {
                    [(AdditionListView *)vieController loadDatas];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];

    
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_str"] = [kindMenuNew yy_modelToJSONString];
        [[TDFMenuService new] updateKindAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            for (UIViewController *vieController in self.navigationController.viewControllers) {
                if ([vieController isKindOfClass:[AdditionListView class]]) {
                    [(AdditionListView *)vieController loadDatas];
                }
            }
          [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}


-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.kindMenu.kindMenuName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.kindMenu.kindMenuName]];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_id"] = self.kindMenu.kindMenuId;
        [[TDFMenuService new] removeKindAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            for (UIViewController *vieController in self.navigationController.viewControllers) {
                
                if ([vieController isKindOfClass:[AdditionListView class]]) {
                    [(AdditionListView *)vieController loadDatas];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenuingr"];
}


@end
