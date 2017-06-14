//
//  MakeEditView.h
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NumberInputClient.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "FooterListEvent.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"

@class MenuModule,NavigateTitle2,EditItemText,MBProgressHUD,FooterListView;
@class Make;
@interface MakeEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate,FooterListEvent>{
    MenuModule *parent;
//    MBProgressHUD *hud;
}
@property (nonatomic, strong)UILabel *attentionLabel;

@property (nonatomic, strong)  FooterListView *footView;
@property (nonatomic, retain)  UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;

@property (nonatomic, strong)  EditItemText *txtName;
@property (nonatomic, strong)  UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) Make* make;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *sourceDic;
@property (nonatomic ,assign) id  <NavigationToJump > delegate ;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
-(void) loadData:(Make*) objTemp action:(int)action;
-(IBAction)btnDelClick:(id)sender;

@end
