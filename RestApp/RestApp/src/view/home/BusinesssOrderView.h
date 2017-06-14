//
//  MemberSingleInfoView.h
//  RestApp
//
//  Created by iOS香肠 on 15/10/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "CustomerRegister.h"
#import "MemberOrderRecordData.h"
#import "MBProgressHUD.h"
#import "TDFRootViewController.h"
@class MemberService;
@interface BusinesssOrderView : TDFRootViewController<INavigateEvent,UITableViewDelegate,UITableViewDataSource>
{
    MemberService *service;
    BOOL isRefresh;
    UIView *bgView;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong)NSMutableDictionary *groupDic;
@property (nonatomic,strong)NSMutableArray *groupKeys;
@property (nonatomic,copy)NSString *customerRegisterId;
@property (nonatomic,assign)NSInteger eventType;
@property (strong, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *extraPoJoName;
@property (nonatomic, strong)NSString *mobile;

@end
