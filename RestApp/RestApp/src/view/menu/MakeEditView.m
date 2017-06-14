//
//  MakeEditView.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MakeEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "TDFOptionPickerController.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "MenuMake.h"
#import "XHAnimalUtil.h"
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
#import "TDFRootViewController+FooterButton.h"

@implementation MakeEditView

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        parent=_parent;
////        hud = [[MBProgressHUD alloc] initWithView:self.view];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container];
    [self.container addSubview:self.txtName];
    UIView *delView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 66)];
    [self.container addSubview:delView];
    [delView addSubview:self.btnDel];
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self createDataSource];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma set--get
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *) btnDel
{
    if (!_btnDel) {
        _btnDel = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH - 20, 44)];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

- (UIView *)container {

    if (!_container) {
        
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _container.backgroundColor = [UIColor clearColor];
    }
    return _container;
}

- (EditItemText *) txtName
{
    if (!_txtName) {
        _txtName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 48)];
    }
    return _txtName;
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}

 - (void)createDataSource
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  delegate  = self.sourceDic [@"delegate"] ;
        self.delegate  = delegate ;
        id  headListTemp  =  self.sourceDic [@"headListTemp"];
        NSString *actionStr  = [NSString stringWithFormat:@"%@", self.sourceDic [@"action"]];
        [self loadData:headListTemp action:actionStr.intValue];
    }
}
#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
  //  [self.titleBox initWithName:NSLocalizedString(@"商品做法", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"商品做法", nil);
//    [self.titleBox initWithName:NSLocalizedString(@"商品做法", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
 
}

-(void) onNavigateEvent:(NSInteger)event{
//    if (event==1) {
//        [parent showView:MAKE_LIST_VIEW];
//        [XHAnimalUtil animalEdit:parent action:self.action];
//    }else{
//        [self save];
//    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
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
        _attentionLabel.text = NSLocalizedString(@"提示：添加完做法后，可以去商品详情里对商品进行做法的设置。", nil);
    }
    return _attentionLabel;
}


-(void) initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"做法名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.attentionLabel];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}


#pragma remote
-(void) loadData:(Make*) objTemp action:(int)action
{
    [self.progressHud hide:YES];
    self.action=action;
    self.make=objTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.attentionLabel.hidden = NO;
        self.title  = NSLocalizedString(@"添加做法", nil);
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加做法", nil);

        [self clearDo];
    }else{
        self.attentionLabel.hidden = YES;
        self.titleBox.lblTitle.text=self.make.name;
        self.title = self.make.name;
        [self fillModel];
    }
 
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    }
}


#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.make.name];
    
}


#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_MakeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MakeEditView_Change object:nil];

}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
//    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    if (self.action  == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

#pragma save-data

-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"做法名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(Make*) transMake
{
    Make* make=[Make new];
    make.name=[self.txtName getStrVal];
    return make;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    Make* make=[self transMake];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:self.progressHud];

    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"make_str"] = [JsonHelper transJson:make];
        
        @weakify(self);
        [[TDFMenuService new] saveMakeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
//            [parent showView:MAKE_LIST_VIEW];
//            [parent.makeListView reLoadData];
//            [XHAnimalUtil animalEdit:parent action:self.action];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.make.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:self.progressHud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"make_id"] = self.make._id;
//        @weakify(self);
        [[TDFMenuService new] removeMakeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
//            @strongify(self);
            [self.progressHud hide:YES];
//            [parent showView:MAKE_LIST_VIEW];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

#pragma test event
#pragma edititemlist click event.

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenucook"];
}

@end
