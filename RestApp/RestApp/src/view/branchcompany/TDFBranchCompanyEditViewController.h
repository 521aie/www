//
//  TDFBranchCompanyEditViewController.h
//  RestApp
//
//  Created by zishu on 16/7/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "ServiceFactory.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemView.h"
#import "EditItemRadio.h"
#import "BranchTreeVo.h"
#import "BranchVo.h"
#import "UserVO.h"
#import "OptionSelectBox.h"
#import "TDFMediator+BranchCompanyModule.h"
#import "TDFBranchCompanyListViewController.h"

@class NavigateTitle2;
@interface TDFBranchCompanyEditViewController : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditItemRadioEvent,OptionSelectClient,AlertBoxClient>
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, strong) UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong)  EditItemText *nameEditItemText;
@property (nonatomic, strong) EditItemList *superCompany;
@property (nonatomic, strong) EditItemRadio *superCompanyRadio;
@property (nonatomic, strong) EditItemText *linkMan;
@property (nonatomic, strong) EditItemText *phone;
@property (nonatomic, strong) EditItemText *email;
@property (nonatomic, strong) EditItemText *address;
@property (nonatomic, strong) EditItemView *branchCode;
@property (nonatomic, strong) EditItemView *managerName;
@property (nonatomic, strong) EditItemView *pwd;
@property (nonatomic, strong)  UIButton *btnDel;
@property (nonatomic) BOOL changed;
@property (nonatomic) BranchVo* vo;
@property (nonatomic) BranchTreeVo* vo1;
@property (nonatomic) UserVO* userVO;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSString *branchEntityId;
@property (nonatomic ,strong) NSString *branchName;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) NSMutableArray *branchCompanyListArr;
@property (nonatomic,copy) void (^editCallBack)(BOOL orRefresh);

@end
