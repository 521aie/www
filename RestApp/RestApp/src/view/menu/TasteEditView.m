//
//  TasteEditView.m
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Taste.h"
#import "UIHelper.h"
#import "ItemTitle.h"
#import "TasteEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "EditItemView.h"
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
#import "UIView+Sizes.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "TDFRootViewController+FooterButton.h"
@implementation TasteEditView

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
    [self initNotifaction];
    [self initNavigate];
    [self initMainView];
    [self createData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (UITextView *)lblTip
{
    if (!_lblTip) {
        _lblTip = [[UITextView alloc] initWithFrame:CGRectZero];
        _lblTip.text = NSLocalizedString(@"提示：把顾客点菜时可能会提到的要求设置成商品备注，点单时进行快速选择，例如为菜肴设置口味要求:加辣，不加辣，不加冰等.设置完成后，可以在分类中关联备注，点这个分类里的商品时就可以使用这个备注信息了。", nil);
        _lblTip.userInteractionEnabled = NO;
        _lblTip.textColor = [UIColor grayColor];
        _lblTip.font = [UIFont systemFontOfSize:13];
        CGSize size = [_lblTip.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblTip.font} context:nil].size;
        _lblTip.frame = CGRectMake(0, 229, SCREEN_WIDTH, size.height + 1);
    }
    return _lblTip;
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

    self.title = NSLocalizedString(@"商品备注", nil) ;
    [self.titleBox initWithName:NSLocalizedString(@"商品备注", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];

}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [parent showView:SUITMENUTASTE_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else {
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


- (void)initMainView
{
    [self.container addSubview:self.lblTip];
    [self.lblKind initLabel:NSLocalizedString(@"备注分类", nil) withHit:nil];
    [self.txtName initLabel:NSLocalizedString(@"备注内容", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.rdoIsRelation initLabel:NSLocalizedString(@"关联到所有分类", nil) withHit:nil delegate:nil];
    [self.rdoIsRelation visibal:NO];
    self.lblTip.text=nil;
    self.lblTip.text=NSLocalizedString(@"提示：把顾客点菜时可能会提到的要求设置成商品备注，点单时进行快速选择，例如为菜肴设置口味要求:加辣，不加辣，不加冰等.设置完成后，可以在分类中关联备注，点这个分类里的商品时就可以使用这个备注信息了。", nil);
    [self.lblTip sizeToFit];

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)createData
{
    
    if ([ObjectUtil  isNotEmpty: self.dic]) {
        id data  = self.dic [@"data"];
         NSString  *actionStr  =  self.dic [@"action"];
        id delegate = self.dic [@"delegate"];
        self.delegate  = delegate ;
        id kind  =  self.dic [@"kind"];
        [self loadData:data kind:kind action:actionStr.intValue ];
    }
    
}


#pragma remote
-(void) loadData:(Taste*) objTemp kind:(KindAndTasteVo*)kind action:(int)action
{
    [self.progressHud hide:YES];
    self.action=action;
    self.taste=objTemp;
    self.kindTaste=kind;
    [self.lblKind initData:self.kindTaste.kindTasteName withVal:self.kindTaste.kindTasteId];
    [self.delView setHidden:action==ACTION_CONSTANTS_ADD];
    [self.delView setHeight:action==ACTION_CONSTANTS_ADD?0:73];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加备注", nil);
        [self configLeftNavigationBar: Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加备注", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.taste.name;
        [self fillModel];
    }
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}


#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
//    [self.rdoIsRelation initShortData:0];
}

-(void) fillModel
{
    [self.txtName initData:self.taste.name];
    [self.rdoIsRelation visibal:NO];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_TasteEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TasteEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action  == ACTION_CONSTANTS_EDIT) {
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
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:@"" data:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"备注名称不能为空!", nil)];
        return NO;
    }
   return YES;
}

-(Taste*) transModel{
    Taste* objUpdate=[Taste new];
    if (![self.kindTaste.kindTasteId isEqualToString:@"-1"]) {
        objUpdate.kindTasteId=self.kindTaste.kindTasteId;
    }
    objUpdate.name=[self.txtName getStrVal];
    return objUpdate;
}


-(void)save{
    if (![self isValid]) {
        return;
    }
    Taste* taste=[self transModel];


    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:self.progressHud];

    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"taste_str"] = [taste yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);

            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.taste.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.taste.name] andView:self.view andHUD:self.progressHud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"taste_id"] = [NSString isBlank:self.taste._id]?@"":self.taste._id;
        //        @weakify(self);
        [[TDFMenuService new] removeTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            //            @strongify(self);

            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void)remoteFinsh:(RemoteResult*) result{
    [self.progressHud hide:YES];
 
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
    [self.navigationController popViewControllerAnimated: YES];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenunote"];
}

@end

