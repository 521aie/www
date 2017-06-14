//
//  autoModify.h
//  RestApp
//
//  Created by 栀子花 on 16/5/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerBox.h"
#import "TDFRootViewController.h"

@class BillModifyModule,BillModifyService,MBProgressHUD;
@class EditItemList,EditItemView,EditItemText,EditItemRadio,NavigateTitle2,EditItemSignList;

@interface autoModify : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient>
{
    BillModifyService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemRadio *doauto;
@property (nonatomic, strong) IBOutlet EditItemList *autoday;
@property (nonatomic, strong) IBOutlet EditItemList *billType;
@property (nonatomic, strong) IBOutlet EditItemList *billPer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(BillModifyModule *)_parent;
- (void) loadData;
@end
