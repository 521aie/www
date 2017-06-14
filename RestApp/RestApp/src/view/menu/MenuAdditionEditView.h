//
//  MenuAdditionEditView.h
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "NumberInputClient.h"
#import "YYModel.h"
#import "AdditionKindMenuVo.h"
#import "AdditionMenuVo.h"

#import "NavigationToJump.h"
#import "TDFRootViewController.h"

@class MenuModule,MenuService,NavigateTitle2,EditItemText,EditItemList,EditItemView,MBProgressHUD;
@class SampleMenuVO,KindMenu;
@interface MenuAdditionEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate,IEditItemListEvent,NumberInputClient>{
    MenuModule *parent;
    MenuService *service;
   
}
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemView *lblKind;
@property (nonatomic, weak) IBOutlet EditItemText *txtName;
@property (nonatomic, weak) IBOutlet EditItemList* lsPrice;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) AdditionMenuVo* menu;
@property (nonatomic) AdditionKindMenuVo* kindMenu;
@property (nonatomic) int action;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic ,assign) id <NavigationToJump> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;

-(void) loadData:(AdditionMenuVo*) objTemp kind:(AdditionKindMenuVo*)kind action:(int)action;
-(IBAction)btnDelClick:(id)sender;


@end
