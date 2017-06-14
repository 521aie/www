//
//  MenuTimePriceEditView.h
//  RestApp
//
//  Created by zxh on 14-5-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemBase.h"
#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "TDFRootViewController.h"
typedef void(^MenuTimePriceEditViewCallBack) ();

@class MenuTimePrice,FooterListView,EditItemList;
@class NavigateTitle2,EditItemView,EditItemRadio;
@interface MenuTimePriceEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,UIActionSheetDelegate,FooterListEvent,NumberInputClient>
{
}
@property (nonatomic,copy)MenuTimePriceEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemView *lblName;
@property (nonatomic, strong) IBOutlet EditItemView *lblPrice;
@property (nonatomic, strong) IBOutlet EditItemList *lsPrice;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) MenuTimePrice* menuTimePrice;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL changed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)btnDelClick:(id)sender;

@end
