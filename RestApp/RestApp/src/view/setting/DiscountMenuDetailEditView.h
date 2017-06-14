//
//  SelectMenuListView.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySelectMultiMenuListPanel.h"
#import "OptionPickerClient.h"
#import "DHListSelectHandle.h"
#import "ISampleListEvent.h"
#import "SelectMenuClient.h"
#import "INavigateEvent.h"
#import "SettingModule.h"
#import "TDFRootViewController.h"
@class MenuService,MBProgressHUD,NavigateTitle2,MySelectMultiMenuListPanel,SettingModule;
typedef void(^DiscountMenuDetailEditViewCallBack)();

@interface  DiscountMenuDetailEditView: TDFRootViewController<INavigateEvent,ISampleListEvent,DHListSelectHandle,OptionPickerClient>
{
    MenuService *service;
}
@property (nonatomic,copy)DiscountMenuDetailEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet MySelectMultiMenuListPanel *dhListPanel1;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) id<SelectMenuClient> delegate;
@property (nonatomic, strong) NSMutableArray *discountDetailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *menuMap;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableArray *kindMenuList;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (nonatomic, strong) NSMutableArray *allNodeList;
@property (nonatomic, strong) NSString* str;
@property  (nonatomic,strong) NSString*radio;
@property (nonatomic,retain) NSMutableArray *datas;    //原始数据集

- (IBAction)settingBtnClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loadMenusListwithDiscount:(NSString *)discount withDiscountDetailList:(NSMutableArray *)discountDetailList;

@end
