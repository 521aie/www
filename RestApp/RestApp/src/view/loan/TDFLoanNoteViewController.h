//
//  TDFLoanNoteViewController.h
//  RestApp
//
//  Created by zishu on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFLoanNoteViewController : TDFRootViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UIView *tableFooterView;
@property (nonatomic ,strong) UIButton *nextBtn;
@property (nonatomic ,assign) BOOL isSelect;
@property (nonatomic ,strong) NSString *loanCompanyId;
@property (nonatomic ,strong) NSString *loanCompanyName;
@property (nonatomic ,strong) NSString *h5Url;
@end
