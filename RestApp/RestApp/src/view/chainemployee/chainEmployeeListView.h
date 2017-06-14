//
//  chainEmployeeListView.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Role.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TableIndexView.h"
#import "FooterListEvent.h"
#import "EmployeeService.h"
#import "SingleCheckHandle.h"
#import "DHListSelectHandle.h"
#import "TDFRootViewController.h"

@class SelectRolePanel;
@class EmployeeListPanel;

@interface chainEmployeeListView : TDFRootViewController<SingleCheckHandle,DHListSelectHandle>
{
    EmployeeService *service;
    
    SelectRolePanel *selectRolePanel;
}

@property (nonatomic, strong) EmployeeListPanel *dhListPanel;
@property (nonatomic, strong) UIButton *btnBg;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIImageView *selectShopBImg;
@property (nonatomic, strong) UIView *navigateView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *employeeMap;
@property (nonatomic, strong) id<INameValueItem> currentHead;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL select;
@end
