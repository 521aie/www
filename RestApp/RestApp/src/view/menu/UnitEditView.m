//
//  UnitEditView.m
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UnitEditView.h"
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "UnitListView.h"
#import "Platform.h"
#import "XHAnimalUtil.h"
#import "MenuRender.h"
#import "RestConstants.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "TDFGoodsService.h"
#import "TDFResponseModel.h"

@implementation UnitEditView

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
    [self inittCurrentView];
    [self initNavigate];
    [self initMainView];
    [self  createData];
    [self updateSize];
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

- (void)inittCurrentView
{
     hud = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
//        id  delegate  = self.sourceDic [@"delegate"];
        id  data  = self.sourceDic [@"data"];
        id delegate  = self.sourceDic [@"delegate"];
        self.delegate  = delegate;
        NSString *actionStr  = [NSString stringWithFormat:@"%@",self.sourceDic[@"action"]];
        [self loadData:data action:actionStr.intValue];
    }
}
#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

    self.title  = NSLocalizedString(@"商品单位", nil);
    [self.titleBox initWithName:NSLocalizedString(@"商品单位", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];

}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:UNIT_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}
- (void)initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"商品单位", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
}

#pragma remote
- (void)loadData:(NameItemVO *)objTemp action:(NSInteger)action
{
    self.action = action;
    self.unit = objTemp;
    
    if (action==ACTION_CONSTANTS_ADD) {

        self.title  = NSLocalizedString(@"添加商品单位", nil);

        //self.titleBox.lblTitle.text=NSLocalizedString(@"添加商品单位", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.unit.itemName;
        self.title = self.unit.itemName;
        [self fillModel];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.unit.itemName];
}
#pragma save-data

-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品单位名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
//    NSString* unitStr=[[Platform Instance] getkey:MENU_UNIT];
     NSString *unitStr= [[NSUserDefaults standardUserDefaults] valueForKey:MENU_UNIT];
    if ([NSString isBlank:unitStr]) {
        unitStr=DEFAULT_MENU_UNITS;
    }
    if (self.action==ACTION_CONSTANTS_ADD) {
//        NSString* strs=[NSString stringWithFormat:@"%@|%@",unitStr,[self.txtName getStrVal]];
//        if ([NSString isNotBlank:strs]) {
//            NSArray *arry =[strs componentsSeparatedByString:@"|"];
//            for (NSInteger i=0; i<arry.count-1; i++) {
//            if ([[arry objectAtIndex:arry.count-1] isEqualToString:[arry objectAtIndex:i]]) {
//                [AlertBox show:NSLocalizedString(@"单位重复无法保存", nil)];
//                return;
//            }
//        }
//        }
////        [[Platform Instance] saveKeyWithVal:MENU_UNIT withVal:strs];
//        [[NSUserDefaults standardUserDefaults] setValue:strs forKey:MENU_UNIT];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self addUnitOnline];
    } else {
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:nil data:nil];
        }
        [self.navigationController popViewControllerAnimated: YES];
//        [parent showView:UNIT_LIST_VIEW];
//        [parent.unitListView reloadDatas];
//        [XHAnimalUtil animalEdit:parent action:self.action];
    }
}

- (void)addUnitOnline
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFGoodsService addFoodUnitWithName:[self.txtName getStrVal] completeBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
//            [parent showView:UNIT_LIST_VIEW];
//            [parent.unitListView reloadDatas];
//            [XHAnimalUtil animalEdit:parent action:self.action];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
        }
    }];
}

-(void) showHelpEvent
{
    [HelpDialog show:@"basemenu"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}

@end
