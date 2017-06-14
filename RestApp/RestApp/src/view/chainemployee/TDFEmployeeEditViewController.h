//
//  TDFEmployeeEditViewController.h
//  RestApp
//
//  Created by 刘红琳 on 2016/12/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController+AlertMessage.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "TDFRootViewController.h"
#import "TDFShowPickerStrategy.h"
#import "EmployeeModuleEvent.h"
#import "DHTTableViewManager.h"
#import "TDFCardBgImageItem.h"
#import "TDFAvatarImageItem.h"
#import "NSString+Estimate.h"
#import "TDFEditViewHelper.h"
#import "TDFChainService.h"
#import "TDFTextfieldItem.h"
#import "ServiceFactory.h"
#import "EmployeeUserVo.h"
#import "ExtraActionVo.h"
#import "TDFSwitchItem.h"
#import "TDFPickerItem.h"
#import "TDFLabelItem.h"
#import "NameItemVO.h"
#import "AlertBox.h"

typedef NS_ENUM(NSInteger,TDFEmployeeType) {
    TDFEmployeeAdd = 1,
    TDFEmployeeEdit,
};

@interface TDFEmployeeEditViewController : TDFRootViewController

@property (nonatomic,copy) void (^employeeEditCallBack)(BOOL orRefresh);
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic,strong) UIView *tableViewFooterView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TDFCardBgImageBaseItem *frontItem;
@property (nonatomic, strong) TDFCardBgImageBaseItem *backItem;
@property (nonatomic, strong) TDFTextfieldItem *nameItemText;
@property (nonatomic, strong) DHTTableViewSection *headSetion;
@property (nonatomic, strong) TDFAvatarImageItem *nameImageItem;
@property (nonatomic, strong)  TDFTextfieldItem *identifierItem;
@property (nonatomic, strong) TDFTextfieldItem *phoneItem;
@property (nonatomic, strong) TDFTextfieldItem * nameItem;
@property (nonatomic, strong) TDFPickerItem *roleItem;
@property (nonatomic, strong) TDFPickerItem *sexItem;

@property (nonatomic,assign) TDFEmployeeType employeeType;
@property (nonatomic, strong) NSMutableArray *roleList;
@property (nonatomic, strong) MemberExtend *memberExtend;
@property (nonatomic, strong) EmployeeUserVo *employee;
@property (nonatomic, strong)  Employee *employeeVo;
@property (nonatomic, strong) NSString *employeeId;
@property (nonatomic, strong) NSString* entityId;
@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) UserVO* userTemp;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic, strong) UIView *headView;

- (void)addBaseSettingSection;
- (void)addAccountInfoSection;
-(void) addIdentifierInfoSection;
- (BOOL)isValid;

@end
