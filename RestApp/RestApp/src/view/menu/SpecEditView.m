//
//  SpecEditView.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecEditView.h"
#import "MenuModule.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "ItemTitle.h"
#import "MenuSpecDetail.h"
#import "FormatUtil.h"
#import "SpecRender.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "MenuEditView.h"
#import "SingleCheckView.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "SpecListView.h"
#import "MenuModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SpecEditView

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
    [self initDataSource];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.footView.hidden = YES;
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateSize];
}

- (void)initCurrentView
{
    hud  = [[MBProgressHUD alloc]  initWithView:self.view ];
}

- (void)initDataSource
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  data  =  self.sourceDic [@"headListTemp"];
        self.delegate  =  self.sourceDic [@"delegate"];
        NSString *actionStr  = [NSString stringWithFormat:@"%@",self.sourceDic[@"action"]];
        [self loadData:data action:actionStr.intValue];
    }
}
#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

  //  [self.titleBox initWithName:NSLocalizedString(@"商品规格", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title  = NSLocalizedString(@"商品规格", nil);

}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SpecEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SpecEditView_Change object:nil];
}

- (void)initMainView
{
    self.lblTip.text = NSLocalizedString(@"提示：此规格的用料/价格，与基准商品用料/价格一致时，以上两项都填1倍即可。添加完规格后，可以去商品详情里对商品进行规格的设置。", nil);
    [self.txtName initLabel:NSLocalizedString(@"规格名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsRawScale initLabel:NSLocalizedString(@"此规格用料是基准商品用料的几倍", nil) withHit:nil delegate:self];
//    [self.lsRawScale.lblName setWidth:230];
//     [self.lsSpecPrice.lblName setWidth:230];
    
    [self.lsSpecPrice initLabel:NSLocalizedString(@"此规格价格是基准商品价格的几倍", nil) withHit:nil delegate:self];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
   
    self.lsRawScale.tag=MENUSPEC_RAWSCALE;
    self.lsSpecPrice.tag=MENUSPEC_SPECPRICE;
    
    [self.lsRawScale setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    self.lsRawScale.lblVal.clearTextWhenType = YES;
    [self.lsSpecPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    self.lsSpecPrice.lblVal.clearTextWhenType= YES;
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:SPEC_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        if (![self isValid]) {
            return;
        }
        self.isAdjust=0;
        if (self.action==ACTION_CONSTANTS_EDIT) {
            double oldPriceScale=self.specDetail.priceScale;
            double newPriceScale=[self.lsSpecPrice getStrVal].doubleValue;
            if(oldPriceScale!=newPriceScale){
                 UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"“此规格价格是基准商品价格的几倍”一项有更改，将要按照此倍数重新计算关联了此规格的商品单价.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"重新计算所有商品单价", nil),NSLocalizedString(@"重新计算所有商品单价(不包括自定义过单价的商品)", nil), nil];
                sheet.tag=1;
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            } else {
                [self save];
            }
        } else {
            [self save];
        }
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    // [self.navigationController popViewControllerAnimated: YES];
    [self  alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    if (![self isValid]) {
        return;
    }
    self.isAdjust=0;
    if (self.action==ACTION_CONSTANTS_EDIT) {
        double oldPriceScale=self.specDetail.priceScale;
        double newPriceScale=[self.lsSpecPrice getStrVal].doubleValue;
        if(oldPriceScale!=newPriceScale){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"“此规格价格是基准商品价格的几倍”一项有更改，将要按照此倍数重新计算关联了此规格的商品单价.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"重新计算所有商品单价", nil),NSLocalizedString(@"重新计算所有商品单价(不包括自定义过单价的商品)", nil), nil];
            sheet.tag=1;
            [sheet showInView:[UIApplication sharedApplication].keyWindow];
        } else {
            [self save];
        }
    } else {
        [self save];
    }
}


#pragma remote
- (void)loadData:(SpecDetail *)objTemp action:(int)action
{
    [hud hide:YES];
    self.action=action;
    self.specDetail=objTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加规格", nil);
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加规格", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.specDetail.name;
        self.title = self.specDetail.name;
        [self fillModel];
    }
//     [self.titleBox editTitle:NO act:self.action];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
    [self.lsRawScale initData:@"1" withVal:@"1"];
    [self.lsSpecPrice initData:@"1" withVal:@"1"];
}

- (void)fillModel
{
    [self.txtName initData:self.specDetail.name];
    double rawScale=self.specDetail.rawScale;
    NSString* rawScaleStr=[FormatUtil formatDouble4:rawScale];
    [self.lsRawScale initData:[NSString stringWithFormat:@"%@",rawScaleStr] withVal:rawScaleStr];

    NSString* priceScale=[FormatUtil formatDouble4:self.specDetail.priceScale];
    [self.lsSpecPrice initData:[NSString stringWithFormat:@"%@",priceScale] withVal:priceScale];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action  == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"规格名称不能为空!", nil)];
        return NO;
    }
    if ([NSString isNotBlank:[self.lsRawScale getStrVal]] && ![NSString isFloat:[self.lsRawScale getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"此规格用料是基准商品用料的几倍不是数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsRawScale getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"此规格用料是基准商品用料的几倍不能为空!", nil)];
        return NO;
    }
    if ([[self.lsRawScale getStrVal] isEqualToString:@"0"]) {
        [AlertBox show:NSLocalizedString(@"规格用料不能为基准用料的0倍!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsSpecPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"此规格价格是基准商品价格的几倍不能为空!", nil)];
        return NO;
    }
    
    if (![NSString isFloat:[self.lsSpecPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"此规格价格是基准商品价格的几倍不是数字!", nil)];
        return NO;
    }
    return YES;
}

- (SpecDetail *)transSpec
{
    SpecDetail *spec=[SpecDetail new];
    spec.name=[self.txtName getStrVal];
    if ([NSString isBlank:[self.lsRawScale getStrVal]]) {
        spec.rawScale=1;
    } else {
        spec.rawScale=[self.lsRawScale getStrVal].doubleValue;
    }
    spec.priceMode=PRICE_MODE_ADD;
    if ([NSString isBlank:[self.lsSpecPrice getStrVal]]) {
        spec.priceScale=1;
    } else {
        spec.priceScale=[self.lsSpecPrice getStrVal].doubleValue;
    }
    return spec;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    SpecDetail* spec=[self transSpec];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"spec_detail_str"] = [JsonHelper transJson:spec];
        
        @weakify(self);
        [[TDFMenuService new] saveSpecWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            [self remoteFinsh];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else {
        spec.specId=self.specDetail.specId;
        spec._id=self.specDetail._id;
        spec.id = self.specDetail._id;
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"spec_detail_str"] = [JsonHelper transJson:spec];
        param[@"range"] = [NSString stringWithFormat:@"%d",self.isAdjust];
        
           @weakify(self);
        [[TDFMenuService new] updateSpecWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            [self remoteFinsh];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]这个规格吗？如果有商品关联了这个规格，将会全部取消关联.", nil),self.specDetail.name] event:2];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isAdjust=0;
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            self.isAdjust=1;    //重新计算所有商品单价
            [self save];
        } else if (buttonIndex==1) {
            self.isAdjust=2;   //重新计算所有商品单价(不包括自定义过单价的商品).
            [self save];
        }
    } else if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.specDetail.name] andView:self.view andHUD:hud];
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
            [param setObject:self.specDetail._id forKey:@"spec_detail_id"];

//            @weakify(self);
            [[TDFMenuService new] removeSpecWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
//                @strongify(self);
                [hud hide:YES];
                if (self.delegate) {
                    [self.delegate navitionToPushBeforeJump:nil data:nil];
                }
                [self.navigationController popViewControllerAnimated: YES];
//                [parent showView:SPEC_LIST_VIEW];
//                [parent.specListView reLoadData];
//                [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [hud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];

        }
    }
}

- (void)remoteFinsh
{
    if (self. delegate) {
        [self.delegate navitionToPushBeforeJump:nil data:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [parent showView:SPEC_LIST_VIEW];
//    [parent.specListView reLoadData];
//    [XHAnimalUtil animalEdit:parent action:self.action];
    if (self.action==ACTION_CONSTANTS_EDIT) {
        SpecDetail* spec=[self transSpec];
        spec.specId=self.specDetail.specId;
        spec._id=self.specDetail._id;
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuEditView class]]) {
                [(MenuEditView *)viewController  loadSpecChange:spec isAdjust:self.isAdjust];
            }
        }
//        [parent.menuEditView loadSpecChange:spec isAdjust:self.isAdjust];
    }
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList*)obj
{
   
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==MENUSPEC_RAWSCALE) {
        [self.lsRawScale changeData:[NSString stringWithFormat:@"%@",val] withVal:val];
    } else if (eventType==MENUSPEC_SPECPRICE) {
         [self.lsSpecPrice changeData:[NSString stringWithFormat:@"%@",val] withVal:val];
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenuspec"];
}

- (void) updateSize{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]]) {
            CGRect frame = view.frame;
            frame.size.width = SCREEN_WIDTH;
            view.frame = frame;
        }
    }
}

@end
