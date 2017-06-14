//
//  handleModify.h
//  RestApp
//
//  Created by 栀子花 on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "EditItemText.h"
#import "IEditItemListEvent.h"
#import "DatePickerClient.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController.h"
#import "OptionPickerClient.h"
@class BillModifyModule,BillModifyService,MBProgressHUD;
@class EditItemList,EditItemView,EditItemText,EditItemRadio,NavigateTitle2,EditItemSignList;
@interface handleModify : TDFRootViewController<INavigateEvent,IEditItemListEvent,DatePickerClient,UIActionSheetDelegate,OptionPickerClient>
{
    BillModifyService *service;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemList *lsStartDate;
@property (nonatomic, strong) IBOutlet EditItemList *lsEndDate;
@property (nonatomic, strong) IBOutlet EditItemList *billType;
@property (nonatomic, strong) IBOutlet EditItemList *billPer;
@property (nonatomic, strong) IBOutlet UIButton *optimize;
@property (weak, nonatomic) IBOutlet UIView *cancleView;
@property (weak, nonatomic) IBOutlet EditItemText *startDateTxt;
@property (weak, nonatomic) IBOutlet EditItemText *endDateTxt;
@property (weak, nonatomic) IBOutlet EditItemText *biiTypeTxt;
@property (weak, nonatomic) IBOutlet EditItemText *percentTxt;
@property (weak, nonatomic) IBOutlet UILabel *lip;
@property (nonatomic, assign)BOOL isCancle;

- (IBAction)btnClick:(id)sender;
- (IBAction)cancleBtnClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(BillModifyModule *)_parent;
-(void) loadDatas;

@end
