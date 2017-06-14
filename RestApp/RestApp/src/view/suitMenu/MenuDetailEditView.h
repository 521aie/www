//
//  MenuDetailEditView.h
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "FooterListEvent.h"
#import "NumberInputClient.h"
#import "Menu.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
@class SuitMenuModule,MBProgressHUD;
@class EditItemList,EditItemText,ItemEndNote,NavigateTitle2;
@class SuitMenuDetail,SuitMenuSample;

@interface MenuDetailEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,UIActionSheetDelegate>{
    SuitMenuModule *parent;
    MBProgressHUD *hud;
}

@property (nonatomic, retain)  UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, retain)  UIScrollView *scrollView;
@property (nonatomic, retain)  UIView *container;

@property (nonatomic, retain)  EditItemText *txtName;
@property (nonatomic, retain)  EditItemList *lsKind;
@property (nonatomic, retain)  EditItemList *lsNum;
@property (nonatomic, retain)  ItemEndNote *lblNote;

@property (nonatomic, retain)  UIButton *btnDel;
@property (nonatomic) BOOL isContinue;

@property (nonatomic) BOOL changed;
@property (nonatomic,retain) Menu* suitMenu;
@property (nonatomic,retain) SuitMenuDetail* suitMenuDetail;
@property (nonatomic,retain) NSString* detailId;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *sourceDic;
@property (nonatomic ,assign) id <NavigationToJump> delegate;
-(IBAction)btnDelClick:(id)sender;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SuitMenuModule *)_parent;

-(void) loadData:(SuitMenuDetail*) suitMenuDetailTemp suitMenu:(Menu*)menu  action:(int)action isContinue:(BOOL)isContinue withArray:(NSMutableArray *)array;

@end
