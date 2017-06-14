//
//  KindTasteEditView.h
//  RestApp
//
//  Created by zxh on 14-7-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

#import "INavigateEvent.h"
#import "KindAndTasteVo.h"
@class SuitMenuModule,NavigateTitle2,EditItemText,EditItemRadio,MBProgressHUD;
@class KindTaste;
@interface SuitKindTasteEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    SuitMenuModule *parent;
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
@property (nonatomic) KindAndTasteVo* kindTaste;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SuitMenuModule *)_parent;

-(void) loadData:(KindAndTasteVo*) objTemp action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
