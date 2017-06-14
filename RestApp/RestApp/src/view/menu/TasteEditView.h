//
//  TasteEditView.h
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "KindAndTasteVo.h"

#import "NavigationToJump.h"
#import "TDFRootViewController.h"

@class MenuModule,MenuService,NavigateTitle2,EditItemText,EditItemRadio,EditItemView,MBProgressHUD;
@class Taste,KindTaste;
@interface TasteEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    MenuModule *parent;
    
    MenuService *service;

}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemView *lblKind;
@property (nonatomic, weak) IBOutlet EditItemText *txtName;
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsRelation;
@property (nonatomic, strong) UITextView *lblTip;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;
@property (nonatomic, weak) IBOutlet UIView *delView;
@property (nonatomic, strong) NSDictionary * dic ;
@property (nonatomic, assign) id <NavigationToJump> delegate;

@property (nonatomic) BOOL changed;
@property (nonatomic) Taste* taste;
@property (nonatomic) KindAndTasteVo* kindTaste;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;

-(void) loadData:(Taste*) objTemp kind:(KindAndTasteVo*)kind action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
