//
//  KindTasteEditView.h
//  RestApp
//
//  Created by zxh on 14-7-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"

#import "KindAndTasteVo.h"

#import "NavigationToJump.h"
#import "TDFRootViewController.h"

@class MenuModule,MenuService,NavigateTitle2,EditItemText,EditItemRadio,MBProgressHUD;
@class KindTaste;
@interface KindTasteEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    MenuModule *parent;
    MenuService *service;
    
}
@property (nonatomic, strong)UILabel *attentionLabel;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemText *txtName;

@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic, assign) id <NavigationToJump> delegate;

@property (nonatomic) BOOL changed;
@property (nonatomic) KindAndTasteVo* kindTaste;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *dic ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;

-(void) loadData:(KindAndTasteVo*) objTemp action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
