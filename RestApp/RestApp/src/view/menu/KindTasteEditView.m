//
//  KindTasteEditView.m
//  RestApp
//
//  Created by zxh on 14-7-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindTasteEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "KindTaste.h"
#import "XHAnimalUtil.h"
#import "FormatUtil.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "MenuModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TasteListView.h"
#import "HelpDialog.h"
#import "ServiceFactory.h"
#import "TDFRootViewController+FooterButton.h"
@implementation KindTasteEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;

//        service=[ServiceFactory Instance].menuService;
       
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
    self.title = NSLocalizedString(@"备注分类", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
   // [self.titleBox initWithName:NSLocalizedString(@"备注分类", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];

}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==1) {
        [parent showView:SUITMENUTASTE_LIST_VIEW];
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
        _attentionLabel.text = NSLocalizedString(@"提示：添加完备注分类后，可以去商品分类里对商品分类进行备注的设置。", nil);
    }
    return _attentionLabel;

}

-(void) initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"备注分类名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.attentionLabel];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        id  data  = self.dic [@"data"];
        NSString *actionStr  =  self.dic  [@"action"];
        id delegate  = self.dic [@"delegate"];
        self.delegate  = delegate;
       [self loadData:data action:actionStr.intValue];
    }
    
}

#pragma remote
-(void) loadData:(KindAndTasteVo*) objTemp action:(int)action
{
    
    self.action=action;
    self.kindTaste=objTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.attentionLabel.hidden = NO;
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加备注分类", nil);
        self.title = NSLocalizedString(@"添加备注分类", nil);

        [self clearDo];
    }else{
        self.attentionLabel.hidden = YES;
        self.titleBox.lblTitle.text=self.kindTaste.kindTasteName;
        self.title = self.kindTaste.kindTasteName;
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
  
}

#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.kindTaste.kindTasteName];
}

#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_KindTasteEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindTasteEditView_Change object:nil];
 
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
//    if ( [[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
//          [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
//    }
}

//-(void) delFinish:(RemoteResult*) result
//{
//    [self.progressHud hide:YES];
//    if (result.isRedo) {
//        return;
//    }
//    if (!result.isSuccess) {
//        [AlertBox show:result.errorStr];
//        return;
//    }
//    if (self.delegate) {
//        [self.delegate navitionToPushBeforeJump:@"" data:nil];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
////    [parent showView:TASTE_LIST_VIEW];
////    [parent.tasteListView loadDatas];
////    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
//}


#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"备注分类名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(KindTaste*) transModel{
    KindTaste* objUpdate=[KindTaste new];
    objUpdate.name=[self.txtName getStrVal];
    return objUpdate;
}

- (void)save{
    if (![self isValid]) {
        return;
    }
    KindTaste* kindTaste=[self transModel];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@备注分类", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:self.progressHud];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_taste_str"] = [kindTaste yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveKindTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [parent showView:TASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animalEdit:parent action:self.action];

//            [hud hide:YES];
//            [parent showView:SUITMENUTASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animalEdit:parent action:self.action];

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        kindTaste._id=self.kindTaste.kindTasteId;
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_taste_id"] = [NSString isBlank:self.kindTaste.kindTasteId]?@"":self.kindTaste.kindTasteId;
        parma[@"kind_taste_name"] = [self.txtName getStrVal];
        @weakify(self);
        [[TDFMenuService new] updateKindTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);

            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [parent showView:TASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animalEdit:parent action:self.action];
//            [hud hide:YES];
//            [parent showView:SUITMENUTASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animalEdit:parent action:self.action];
//>>>>>>> feature/function
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}


- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.kindTaste.kindTasteName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.kindTaste.kindTasteName] andView:self.view andHUD:self.progressHud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_taste_id"] = [NSString isBlank:self.kindTaste.kindTasteId]?@"":self.kindTaste.kindTasteId;
//        @weakify(self);
        [[TDFMenuService new] removeKindTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
//            @strongify(self);
            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [parent showView:TASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
//=======
//            [hud hide:YES];
//            [parent showView:SUITMENUTASTE_LIST_VIEW];
//            [parent.tasteListView loadDatas];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
//>>>>>>> feature/function
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)remoteFinsh:(RemoteResult*)  result{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    if (self.delegate ) {
        [self.delegate navitionToPushBeforeJump:@"" data:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [parent showView:TASTE_LIST_VIEW];
//    [parent.tasteListView loadDatas];
//    [XHAnimalUtil animalEdit:parent action:self.action];
}



-(void) pushNotification:(Taste*)taste act:(int)action
{
//    NSString* actionStr=[NSString stringWithFormat:@"%d",action];
//    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
//    [dic setObject:actionStr forKey:@"actionStr"];
//    [dic setObject:taste forKey:@"taste"];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:TasteModule_Data_Change object:dic] ;
    
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenunote"];
}


@end
