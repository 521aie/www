//
//  TDFBranchCompanyListViewController.h
//  RestApp
//
//  Created by zishu on 16/7/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "ServiceFactory.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController.h"


typedef NS_ENUM(NSInteger, TDFBranchType) {
    ModuleType = 1,//入口进
    EditType = 2,//详情进
};
@protocol OptionSelectClient <NSObject>
@optional

- (BOOL)selectOption:(id<INameItem>)data branchId:(NSString *)branchId;

@end
@class NavigateTitle2,TDFBranchCompanyViewController;
@interface TDFBranchCompanyListViewController : TDFRootViewController<INavigateEvent,FooterListEvent,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,ISampleListEvent>

{
    TDFBranchCompanyViewController *module;
    BOOL isRefresh;
    UIView *bgView;
}

@property (nonatomic,copy) void (^listCallBack)(BOOL orRefresh);
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *txtKey;
@property (nonatomic, strong) UITableView *branchCompanyTab;
@property (nonatomic, assign) BOOL isSearchMode;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *branchCompanyList;
@property (nonatomic, strong) NSMutableArray *branchCompanyListCopy;
@property (nonatomic, strong) NSMutableArray *branchCompanyListArr;
@property (nonatomic, strong) id<OptionSelectClient> delegate;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isFromBranchEditView;
@property (nonatomic, strong) NSString *str;

@end
