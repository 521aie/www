//
//  UnitEditView.m
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitUnitEditView.h"

#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "SuitUnitListView.h"
#import "Platform.h"
#import "XHAnimalUtil.h"
#import "MenuRender.h"
#import "RestConstants.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFGoodsService.h"
#import "TDFResponseModel.h"
#import "TDFRootViewController+AlertMessage.h"

@implementation SuitUnitEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.changed=NO;
    [self initNavigate];
    [self initMainView];
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品单位", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==DIRECT_LEFT) {
        [parent showView:SUITUNIT_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        [self save];
    }
}

-(void) initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"商品单位", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
}


#pragma remote
-(void) loadData:(NameItemVO*) objTemp action:(int)action
{
    self.action=action;
    self.unit=objTemp;
    
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加商品单位", nil);
        [self clearDo];
    }else{
        self.titleBox.lblTitle.text=self.unit.itemName;
        [self fillModel];
    }
}


#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.unit.itemName];
}



#pragma save-data

-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品单位名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(void)save{
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
//        [[NSUserDefaults standardUserDefaults] setValue:strs forKey:MENU_UNIT];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [self addUnitOnline];

    }else{
        [parent showView:SUITUNIT_LIST_VIEW];
        [parent.suitUnitListView reloadDatas];
        [XHAnimalUtil animalEdit:parent action:self.action];
    }
    
}

- (void)addUnitOnline
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFGoodsService addFoodUnitWithName:[self.txtName getStrVal] completeBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            [parent showView:SUITUNIT_LIST_VIEW];
            [parent.suitUnitListView reloadDatas];
            [XHAnimalUtil animalEdit:parent action:self.action];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
        }
    }];
}

-(void) showHelpEvent
{
    [HelpDialog show:@"basemenu"];
}

@end
