//
//  ShopTemplateEditView.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "PrintTemplateVO.h"
#import "TDFRootViewController.h"

typedef void(^ShopTemplateEditViewCallBack) ();

@class SettingService;
@class EditItemList,EditItemView,NavigateTitle2;
@class ShopTemplate;
@interface ShopTemplateEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient>
{
    SettingService *service;
}
@property (nonatomic,copy)ShopTemplateEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet EditItemList *lsWidth;
@property (nonatomic, strong) IBOutlet EditItemList *lsTemplate;
@property (nonatomic, strong) IBOutlet EditItemView *lblType;

@property (nonatomic, strong) NSMutableArray *printTemplates;    //原始数据集

@property (nonatomic, assign) BOOL changed;
@property (nonatomic, strong) ShopTemplate* shopTemplate;
@property (nonatomic, strong) PrintTemplateVO* printVO;
@property (nonatomic, assign) NSInteger action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
