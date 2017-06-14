//
//  BrandManagerView.h
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>
#import "RestConstants.h"
#import "TDFRootViewController.h"
#import "TDFMediator+BrandModule.h"

@interface BrandManagerView : TDFRootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>

{
    UIView *bgView;
}

@property (nonatomic,copy) void (^listBrandCallBack)(BOOL orRefresh);
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *txtKey;
@property (strong, nonatomic) UITableView *brandTab;

@property (strong, nonatomic) UIView *bgView;
@property (nonatomic, assign) BOOL  isSearchMode;
@property (nonatomic, strong) NSMutableArray *plateList;
@property (nonatomic, strong) NSMutableArray *plateListArr;
- (void)loadDataWithAction:(int)action;
@end
