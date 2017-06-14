//
//  KindAdditionEditView.h
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "AdditionKindMenuVo.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"

@class MenuModule,MenuService,NavigateTitle2,EditItemText,EditItemRadio,MBProgressHUD;
@class KindMenu;
@interface KindAdditionEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    MenuModule *parent;
    MenuService *service;
    MBProgressHUD *hud;
}
@property (nonatomic, strong)UILabel *attentionLabel;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemText *txtName;

@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) AdditionKindMenuVo* kindMenu;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *dic ;
@property (nonatomic ,assign) id <NavigationToJump> delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;

-(void) loadData:(AdditionKindMenuVo*) objTemp action:(int)action;
-(IBAction)btnDelClick:(id)sender;

@end
