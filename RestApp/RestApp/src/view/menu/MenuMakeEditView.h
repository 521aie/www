//
//  MenuMakeEditView.h
//  RestApp
//
//  Created by zxh on 14-7-29.
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
#import "Menu.h"

@class MenuModule, NavigateTitle2, EditItemView, MBProgressHUD, FooterListView, MenuMake;
@interface MenuMakeEditView : TDFRootViewController<INavigateEvent,NumberInputClient,IEditItemListEvent,OptionPickerClient,UIActionSheetDelegate,FooterListEvent>
{
    MenuModule *parent;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UILabel *attentionLabel;

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemView *lblName;
@property (nonatomic, strong) IBOutlet EditItemList *lsMakePriceMode;
@property (nonatomic, strong) IBOutlet EditItemList *lsMakePrice;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) MenuMake *menuMake;
@property (nonatomic, strong) Menu *menu;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL changed;
@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, strong) id <NavigationToJump> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;

- (void)loadData:(MenuMake *)objTemp menu:(Menu *)menu action:(NSInteger)action;

- (IBAction)btnDelClick:(id)sender;

@end
