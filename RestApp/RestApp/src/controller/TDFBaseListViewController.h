//
//  TDFBaseListViewController.h
//  RestApp
//
//  Created by zishu on 16/10/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//
#import "TDFRootViewController+FooterButton.h"
#import "TDFRootViewController.h"
#import "ISampleListEvent.h"
#import "NameValueCell.h"
#import "TDFDataCenter.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "YYModel.h"
@class TDFIntroductionHeaderView;
@interface TDFBaseListViewController : TDFRootViewController<UITableViewDelegate,UITableViewDataSource,ISampleListEvent>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) TDFIntroductionHeaderView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *placeholderContents;
@property (nonatomic, assign) id<ISampleListEvent> delegate;
- (void) initGrid;
- (void)initPlaceHolderView;
@end
