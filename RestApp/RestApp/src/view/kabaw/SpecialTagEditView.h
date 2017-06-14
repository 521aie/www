//
//  TasteEditView.h
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialTagModule.h"
#import "FooterListEvent.h"
#import "NavigateTitle2.h"
#import "INavigateEvent.h"
#import "KabawService.h"
#import "EditItemText.h"
#import "SpecialTagVO.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"

@class KabawModule;
@interface SpecialTagEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>
{
    SpecialTagModule *parent;
    
    KabawService *service;
    
    NSString *moduleName;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIView *delView;

@property (nonatomic, strong) SpecialTagVO *specialTag;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSArray *dataArry;
@property (nonatomic ,strong) NSDictionary * dic;
@property (nonatomic ,assign) id <NavigationToJump>delegate ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SpecialTagModule *)parentTemp moduleName:(NSString *)moduleNameTemp;

- (void)loadData:(SpecialTagVO *) objTemp action:(int)action arry:(NSArray *)arry;

- (IBAction)btnDelClick:(id)sender;

@end
