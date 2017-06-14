//
//  TDFChainPublishRecordViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainPublishRecordViewController.h"
#import "PublishGoodsTableViewCell.h"
#import "TDFMediator+ChainMenuModule.h"
#import "ViewFactory.h"
#import "HeadNameItem.h"
#import "NavigationToJump.h"
#import "UIHelper.h"
#import "YYModel.h"
#import "DateUtils.h"
#import "TDFChainMenuService.h"
#import "ChainPublishHistoryVo.h"
#import "AlertBox.h"
#import "ObjectUtil.h"
@interface TDFChainPublishRecordViewController () <UITableViewDelegate,UITableViewDataSource,NavigationToJump>
@property (nonatomic ,strong) UITableView *tabView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) NSMutableDictionary * dataSoureceDic;
@property (nonatomic ,strong) NSMutableArray *groupsKey;

@end

@implementation TDFChainPublishRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"发布记录", nil);
    [self createTabView];
    [self getDataList];
}

- (void)createTabView
{
    self.tabView  =  [[UITableView  alloc] initWithFrame:self.view.bounds];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    self.tabView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: self.tabView];
    self.tabView.tableFooterView  = [ViewFactory generateFooter:150];
    [self.tabView registerClass:[PublishGoodsTableViewCell class] forCellReuseIdentifier:publishGoodsTableViewCellDefine];
    
}
//获取数据
- (void)getDataList
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD: self.progressHud ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFChainMenuService new]  chainPublishHistory:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self remoteLoadDataFinish:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)remoteLoadDataFinish:(id)data
{
    [self.dataSoureceDic removeAllObjects];
    [self.groupsKey removeAllObjects];
   self.dataSource = [[NSArray yy_modelArrayWithClass:[ChainPublishHistoryVo class] json:data[@"data"]] mutableCopy] ;
    if ([ObjectUtil isEmpty:self.dataSource]) {
        UILabel *label   = [[UILabel  alloc]  initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-64-60)/2, SCREEN_WIDTH, 60)];
        label.text  = NSLocalizedString(@"该连锁没有发布记录!", nil);
        label.textAlignment  = NSTextAlignmentCenter;
        label.numberOfLines =0;
        label.textColor  = [UIColor whiteColor];
        label.font  = [UIFont systemFontOfSize:18];
        [self.view addSubview:label];
    }
    for (ChainPublishHistoryVo *vo  in self.dataSource) {
        NSDate *currentDate   = [DateUtils  DateWithString:vo.publishDate type:  TDFFormatTimeTypeChineseString];
        NSString *dateStr  = [DateUtils formatTimeWithDate:currentDate type:TDFFormatTimeTypeChineseWithoutDay];
        NSMutableArray *tempArr = self.dataSoureceDic[dateStr];
        
        if (tempArr == nil ) {
            tempArr = [[NSMutableArray alloc] init];
            [tempArr addObject:vo];
        }else{
            [tempArr addObject:vo];
        }
        [self.dataSoureceDic  setObject:tempArr forKey:dateStr];
    }
   self.groupsKey  = [[NSMutableArray  alloc] initWithArray:[self.dataSoureceDic allKeys]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [self.groupsKey sortUsingDescriptors:descriptors];
    [self.tabView reloadData];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource  =  [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableDictionary *)dataSoureceDic
{
    if (!_dataSoureceDic) {
        _dataSoureceDic  = [[NSMutableDictionary  alloc ] init];
    }
    return _dataSoureceDic;
}

- (NSMutableArray *)groupsKey
{
    if (!_groupsKey) {
        _groupsKey  = [[NSMutableArray  alloc] init];
    }
    return _groupsKey;
}
#pragma tabView协议方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSArray *array = [self.dataSoureceDic  objectForKey:self.groupsKey[section]];
    return  array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return   self.groupsKey.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishGoodsTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:publishGoodsTableViewCellDefine];

    [cell initDelegate:self];
     NSArray *array = [self.dataSoureceDic  objectForKey:self.groupsKey[indexPath.section]];
    if ([ObjectUtil  isNotEmpty:array]) {
        ChainPublishHistoryVo *vo  =  array [indexPath.row];
        [cell initMainViewWithData:vo ];
    }
    cell.backgroundColor  = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    NSString *dateStr  =  self.groupsKey [section];
    [headNameItem initWithName:dateStr];
    
    return headNameItem;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_TDFChainPublishDetailViewControllerWithData:obj delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
}




@end
