//
//  EditPassView.h
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "SingleCheckHandle.h"
#import "TimePickerClient.h"
#import "Employee.h"
#import <libextobjc/EXTScope.h>
#import "TDFChainService.h"
#import "TDFRootViewController.h"

@class EmployeeModule,MBProgressHUD;
@class EditItemText,EditItemView,NavigateTitle2;
@class User;

@interface EditPassView : TDFRootViewController<INavigateEvent>{
    EmployeeModule *parent;
}


@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemView *lblName;
@property (nonatomic, weak) IBOutlet EditItemText *txtPass;
@property (nonatomic, weak) IBOutlet EditItemText *txtPassConfirm;

@property (nonatomic) BOOL changed;
@property (nonatomic) User* user;
@property (nonatomic) Employee* employee;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) loadData:(User*) tempVO employee:(Employee *)employee;

-(void)save;
- (void)showView;
@end
