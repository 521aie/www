//
//  TDFHealthCheckViewController.m
//  RestApp
//
//  Created by 黄河 on 2016/12/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckSettingViewController.h"
#import "TDFHealthCheckAlertViewController.h"
#import "TDFHealthCheckItemHeaderModel.h"
#import "TDFHealthCheckViewController.h"
#import "TDFHealthCheckResultModel.h"
#import "TDFHealthCheckDetailModel.h"
#import "TDFHealthCheckLevelModel.h"
#import "TDFHealthCheckHeaderView.h"
#import "TDFHealthCheckScanView.h"
#import "TDFHealthCheckService.h"
#import "TDFHealthCheckHistoryResultModel.h"
#import "MobClick.h"
#import "TDFWaveAnimationView.h"
#import "UIView+TDFUIKit.h"
//#import "HeadNameItem.h"
#import "UIColor+Hex.h"
#import "NSString+TDFRegix.h"
#import "TDFChainService.h"
#import "TDFFunctionKindVo.h"
#import "Masonry.h"
#import "YYModel.h"
#import "AlertBox.h"
#import "ActionConstants.h"
#import "TDFFunctionVo.h"
#import "TDFSwitchTool.h"
#import "TDFFoodSelectHeaderView.h"
#import "TDFHealthCheckHistoryViewController.h"

static NSString *kHealthCheckVersion = @"HEALTH_CHECK_VERSION";

@interface TDFHealthCheckViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _dataBack;
    BOOL _animationOK;
}

//@property (nonatomic, strong)NSMutableDictionary *codeFunctionVoDictionary;
@property (nonatomic, strong)TDFHealthCheckResultModel *resultModel;
@property (nonatomic, assign)BOOL beginAnimation;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) dispatch_source_t timerSource;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *allDataArray;
@property (nonatomic, strong)NSMutableArray *resultDataArray;

@property (nonatomic, strong)TDFHealthCheckHeaderView *headerView;

@property (nonatomic, strong)TDFHealthCheckScanView *headerCellView;

@property (nonatomic, strong)TDFWaveAnimationView *reCheckView;

@property (nonatomic, strong)UIImageView *errorImageView;

@property (nonatomic, assign) BOOL isNavAnimation;

@end

@implementation TDFHealthCheckViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:self.isNavAnimation];
    if (self.beginAnimation) {
        [self startAnimation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestToGetData];
}



- (BOOL)isNetWorking {
    BOOL isExistenceNetwork = YES;
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusNotReachable:{
            
            isExistenceNetwork = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力，请稍后再试！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
                
            }];
            
            break;
            
        }
            
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            
            isExistenceNetwork = YES;
            
            break;
            
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            
            isExistenceNetwork = YES;
            
            break;
            
        }
            
        default:
            
            break;
            
    }
    return isExistenceNetwork;
}
- (void)dismiss {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --init

- (void)defaultConfig {
    self.reCheckView.hidden = YES;
    self.reCheckView.isNoScore = YES;
    self.reCheckView.isShowAttentionText = YES;
    self.reCheckView.attentionText = NSLocalizedString(@"重新体检", nil);
    @weakify(self);
    self.reCheckView.touchClick = ^{
        @strongify(self);
        [MobClick event:@"click_exam_recheck"];//
        [self resetView];
    };
    ///体检设置点击事件
    self.headerView.checkSettingClick = ^{
        @strongify(self);
        if ([self isNetWorking]) {
            [self forwardHealthSetting];
        }
    };
    
    // 体检历史
    self.headerView.healthHistoryClick = ^{
        @strongify(self);
        if ([self isNetWorking]) {
            [self forwardHealthHistory];
        }
    };
    
    self.headerView.buttonClick = ^{
        @strongify(self);
        if (self.beginAnimation) {
            [MobClick event:@"click_exam_process_shut"];//埋点
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否终止体检", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"是", nil) otherButtonTitles:NSLocalizedString(@"否", nil), nil];
            [alert show];
        }else {
            [self dismiss];
        }
    };
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.headerView layoutIfNeeded];
    
//    self.headerCellView.frame = CGRectMake(0, self.headerView.tdf_height, self.view.tdf_width, 66);
    [self.headerCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@66);
    }];
    self.headerCellView.isHeaderCheck = YES;
    TDFHealthCheckItemHeaderModel *itemModel = [TDFHealthCheckItemHeaderModel new];
    itemModel.itemName = NSLocalizedString(@"店家LOGO", nil);
    itemModel.subTitle = nil;
    self.headerCellView.headerModel = itemModel;
    self.headerCellView.showScanAnimation = YES;
    self.headerCellView.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerCellView.mas_bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self initTableView];
    self.errorImageView.hidden = YES;
    [self.errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)initView {
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.headerCellView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.reCheckView];
    
    [self.view addSubview:self.errorImageView];
    [self defaultConfig];
}


- (void)initTableView {
    self.tableView.frame = CGRectMake(0, self.headerCellView.tdf_bottomY + 1, self.view.tdf_width, self.view.tdf_height - self.headerCellView.tdf_bottomY - 1);
    [self.view layoutIfNeeded];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 66;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.view.tdf_height - self.reCheckView.tdf_originY, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark --UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.beginAnimation) {
        return self.dataArray.count;
    }
    TDFHealthCheckLevelModel *level = self.resultDataArray[section];
    return level.healthItems.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.beginAnimation) {
        return 1;
    }
    
    
    return self.resultDataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.beginAnimation) {
        return nil;
    }
    TDFFoodSelectHeaderView *headerView = [[TDFFoodSelectHeaderView alloc] initWithTitle:@""];
    if (section < self.resultDataArray.count) {
        TDFHealthCheckLevelModel *level = self.resultDataArray[section];
        headerView = [[TDFFoodSelectHeaderView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@%@", nil), level.levelName, level.extraStr]];
        if (level.levelCode == 0) {
            [headerView updateTitleColor:[UIColor colorWithHeX:0x07AD1F]];
        } else if (level.levelCode == 1) {
            [headerView updateTitleColor:[UIColor colorWithHeX:0xFF8800]];
        } else if (level.levelCode == 2) {
            [headerView updateTitleColor:[UIColor colorWithHeX:0xCC0000]];
        }
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.beginAnimation) {
        return 0;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFHealthCheckScanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TDFHealthCheckScanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    TDFHealthCheckItemHeaderModel *headerModel;
    if (self.beginAnimation) {
        if (indexPath.row < self.dataArray.count) {
            headerModel = [self.dataArray objectAtIndex:indexPath.row];
        }
    }else {
        if (indexPath.section < self.resultDataArray.count) {
            TDFHealthCheckLevelModel *level = self.resultDataArray[indexPath.section];
            if (indexPath.row < level.healthItems.count) {
                headerModel = level.healthItems[indexPath.row];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isShowDetail = !self.beginAnimation && !headerModel.needSetting;
    cell.headerModel = headerModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.resultDataArray.count > indexPath.section) {
        TDFHealthCheckLevelModel *level = self.resultDataArray[indexPath.section];
        TDFHealthCheckItemHeaderModel *model = level.healthItems[indexPath.row];
        [MobClick event:@"click_exam_item_detail" attributes:@{@"click_exam_item_name":model.itemName?model.itemName:@""}];
        if (!self.beginAnimation) {
            if (model.needSetting) {
                [self forwardHealthSetting];
            }else{
                [self loadHealthCheckDetailData:model];
            }
        }
    }
}

#pragma mark --request

- (void)requestToGetData {
//    @weakify(self);
//    [[[TDFChainService alloc] init] getFunctionList:@{@"function_type":@"0"} sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
//        @strongify(self);
//        if (!data) {
//            return ;
//        }
//        NSMutableArray *functionKindVoArray = [NSMutableArray array];
//        for (NSDictionary *dic in data[@"data"]) {
//            TDFFunctionKindVo *kindvo = [TDFFunctionKindVo yy_modelWithDictionary:dic];
//            [functionKindVoArray addObject:kindvo];
//        }
//        [functionKindVoArray enumerateObjectsUsingBlock:^(TDFFunctionKindVo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.functionVoList.count > 0) {
//                [obj.functionVoList enumerateObjectsUsingBlock:^(TDFFunctionVo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if (obj.actionCode.length > 0 && obj) {
//                        [self.codeFunctionVoDictionary setObject:obj forKey:obj.actionCode];
//                    }
//                    if (obj.childFunction.count > 0) {
//                        [obj.childFunction enumerateObjectsUsingBlock:^(TDFFunctionVo*  _Nonnull thirdFunctionVo, NSUInteger idx, BOOL * _Nonnull stop) {
//                            if (thirdFunctionVo.actionCode.length > 0 && thirdFunctionVo) {
//                                [self.codeFunctionVoDictionary setObject:thirdFunctionVo forKey:thirdFunctionVo.actionCode];
//                            }
//                        }];
//                    }
//                }];
//            }
//        }];
//        [TDFSwitchTool switchTool].codeWithFunctionVoDic = self.codeFunctionVoDictionary;
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        @strongify(self);
//        [self.progressHud hide:YES];
//        [AlertBox show:error.localizedDescription];
//    }];
    if (self.homePage.isFirstTime) {
        [self requestToGetNewData];
    }else {
        [self requestToGetHistoryData];
    }
    
    
    
}

- (void)requestToGetNewData {
    self.beginAnimation = YES;
    self.headerCellView.hidden = NO;
    [[[TDFHealthCheckService alloc] init] getHealthCheckSettingInfoSucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        if (data[@"data"]) {
            self.resultModel = [TDFHealthCheckResultModel yy_modelWithDictionary:data[@"data"]];
            if (self.resultModel.isSuccess == 0) {
                self.headerView.text = self.resultModel.message;
                [self requestError];
                return ;
            }
            if (self.resultModel) {
                self.homePage.isFirstTime = 0;
                self.homePage.resultId = self.resultModel.resultId;
                self.homePage.score = self.resultModel.score;
                self.homePage.message = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_HealthCheck" object:self.homePage];
                [self updateWithData:self.resultModel];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.headerView.text = NSLocalizedString(@"啊哦~服务器开小差了，请重新体检!", nil);
        [AlertBox show:error.localizedDescription];
        [self requestError];
    }];
}

- (void)requestToGetHistoryData {
    self.headerView.hidden = YES;
    self.headerCellView.hidden = YES;
    self.beginAnimation = NO;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

    [[[TDFHealthCheckService alloc] init] getHealthCheckHistoryInfoWithResultID:self.homePage.resultId success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        if (data[@"data"]) {
            self.resultModel = [TDFHealthCheckResultModel yy_modelWithDictionary:data[@"data"]];
            self.resultDataArray = [NSMutableArray arrayWithArray:self.resultModel.levels];
            [self checkOverAnimation];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        self.headerView.text = NSLocalizedString(@"啊哦~服务器开小差了，请重新体检!", nil);
        [self requestError];
    }];
}
-(void)loadHealthCheckDetailData:(TDFHealthCheckItemHeaderModel *)modle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
   [[TDFHealthCheckService new] getHealthCheckDetailWithResultId:self.resultModel.resultId itemCode:modle.itemCode callback:^(TDFResponseModel * _Nonnull response) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       @strongify(self);
       if (response.error) {
           [AlertBox show:response.error.localizedDescription];
           return ;
       }
       
     TDFHealthCheckAlertViewController *vc = [[TDFHealthCheckAlertViewController alloc]init];
     vc.detailModel = [TDFHealthCheckDetailModel yy_modelWithJSON:response.responseObject[@"data"]];
     vc.backImage = [self snapshot:self.view];
      [self.navigationController pushViewController:vc animated:NO];

   }];
}
- (void)updateWithData:(TDFHealthCheckResultModel *)resultModel {
    [self resultDataArrayWithData:resultModel];
    self.allDataArray = [NSMutableArray arrayWithArray:resultModel.healthItems];
    
    _dataBack = YES;
    [self  dataAnimation];
}

- (void)resultDataArrayWithData:(TDFHealthCheckResultModel *)resultModel {
    NSMutableArray *arrLevel0 = [NSMutableArray array];
    NSMutableArray *arrLevel1 = [NSMutableArray array];
    NSMutableArray *arrLevel2 = [NSMutableArray array];
    
    [resultModel.healthItems enumerateObjectsUsingBlock:^(TDFHealthCheckItemHeaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.levelCode) {
            case 0:
            {
                [arrLevel0 addObject:obj];
            }
                break;
            case 1:
            {
                [arrLevel1 addObject:obj];
            }
                break;
            case 2:
            {
                [arrLevel2 addObject:obj];
            }
                break;
            default:
                break;
        }
    }];
    TDFHealthCheckLevelModel *level0 = [TDFHealthCheckLevelModel new];
    level0.levelName = @"一切正常";
    level0.extraStr = [NSString stringWithFormat:@"（共%i项）", (int)arrLevel0.count];
    level0.levelCode = 0;
    level0.healthItems = [NSArray arrayWithArray:arrLevel0];
    
    TDFHealthCheckLevelModel *level1 = [TDFHealthCheckLevelModel new];
    level1.levelName = @"有待改进";
    level1.extraStr = [NSString stringWithFormat:@"（共%i项）", (int)arrLevel1.count];
    level1.levelCode = 1;
    level1.healthItems = [NSArray arrayWithArray:arrLevel1];
    
    TDFHealthCheckLevelModel *level2 = [TDFHealthCheckLevelModel new];
    level2.levelName = @"急需优化";
    level2.extraStr = [NSString stringWithFormat:@"（共%i项）", (int)arrLevel2.count];
    level2.levelCode = 2;
    level2.healthItems = [NSArray arrayWithArray:arrLevel2];
    if (level2.healthItems.count > 0) {
        [self.resultDataArray addObject:level2];
    }
    if (level1.healthItems.count > 0) {
        [self.resultDataArray addObject:level1];
    }
    if (level0.healthItems.count > 0) {
        [self.resultDataArray addObject:level0];
    }
}
#pragma mark --reset
-(void)forwardHealthSetting{
    TDFHealthCheckSettingViewController *settingVc = [[TDFHealthCheckSettingViewController alloc]init];
    __weak typeof (self) weakSelf = self;
    settingVc.callback = ^(){
        [weakSelf resetView];
    };
    self.isNavAnimation = YES;
    [self.navigationController pushViewController:settingVc animated:YES];

}

- (void)forwardHealthHistory
{
    TDFHealthCheckHistoryViewController *historyVC = [[TDFHealthCheckHistoryViewController alloc] init];
    
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)resetView {
    self.reCheckView.hidden = YES;
    self.errorImageView.hidden = YES;
    _dataBack = NO;
    _animationOK = NO;
    self.beginAnimation = YES;
    [self.headerView reset];
    TDFHealthCheckItemHeaderModel *itemModel = [TDFHealthCheckItemHeaderModel new];
    itemModel.itemName = NSLocalizedString(@"店家LOGO", nil);
    itemModel.subTitle = nil;
    self.headerCellView.headerModel = itemModel;
    
//    self.tableView.frame = CGRectMake(0, self.headerCellView.tdf_bottomY + 1, self.view.tdf_width, self.view.tdf_height - self.headerCellView.tdf_bottomY - 1);
    [self.headerCellView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@66);
    }];
    [self.view layoutIfNeeded];
    [self.dataArray removeAllObjects];
    [self.resultDataArray removeAllObjects];
    [self.tableView reloadData];
    
    
    self.headerView.text = NSLocalizedString(@"正在进行体检...", nil);
    [self startAnimation];
    [self requestToGetNewData];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark --animation
- (void)startAnimationWithTimeAll:(CGFloat)allTime {
    if (self.allDataArray.count ==0) {
        return;
    }
    __block int i = 0;
    CGFloat oneTime =  (float)allTime/(float)self.allDataArray.count;
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.timerSource, DISPATCH_TIME_NOW, oneTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.allDataArray.count == 0) {
                dispatch_source_cancel(self.timerSource);
                [self checkOverAnimation];
            }else {
                i ++;
                if (i < self.resultModel.healthItems.count) {
                    TDFHealthCheckItemHeaderModel *itemModel = self.resultModel.healthItems[i];
                    self.headerCellView.headerModel = itemModel;
                }
                [self checkAnimation];
            }
        });
    });
    dispatch_resume(self.timerSource);
}

- (void)startAnimation {
    self.headerCellView.hidden = NO;
    [self.headerView startAnimationWithStartTime:3];
    [self.headerCellView startAnimation];
    _animationOK = YES;
    [self dataAnimation];
}

- (void)dataAnimation {
    if (_dataBack && _animationOK) {
        [self.headerView setScore:self.resultModel.score withAnimation:YES duration:6];
        self.headerView.allTime = 6;
        [self startAnimationWithTimeAll:6];
    }
}

- (void)checkAnimation {
    [self.dataArray insertObject:[self.allDataArray firstObject] atIndex:0];
    [self.allDataArray removeObjectAtIndex:0];
    if (self.allDataArray.count == 0) {
        self.headerCellView.hidden = YES;
    }
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)checkOverAnimation {
    self.headerCellView.hidden = YES;
    [self.headerCellView cancelAnimation];
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"共检测%d个项目，发现{%d}个问题", nil),self.resultModel.totalCnt,self.resultModel.warnCnt];
    NSMutableAttributedString *summarize =[[NSMutableAttributedString alloc] initWithString:string];
    [summarize replaceCharactersInRange:[string rangeOfString:[NSString stringWithFormat:@"{%d}",self.resultModel.warnCnt]] withAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",self.resultModel.warnCnt] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHeX:0xCC0000]}]];

    NSMutableAttributedString *compare = [[NSMutableAttributedString alloc] init];
    if (self.resultModel.beatRatio) {
        compare = [[NSMutableAttributedString alloc] initWithString:@"(击败了{placeholder}的店家)"];
        
        [compare replaceCharactersInRange:[compare.string rangeOfString:@"{placeholder}"] withAttributedString:[[NSAttributedString alloc] initWithString:self.resultModel.beatRatio attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHeX:0xCC0000]}]];
    }
    [self.headerView congfigureSummarize:summarize compare:compare];
    self.headerView.isAnimationOver = YES;
    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.frame = CGRectMake(0, self.headerView.tdf_height, self.tableView.tdf_width, self.view.tdf_height - self.headerView.tdf_height);
        [self.headerCellView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.headerView.hidden = NO;
        self.beginAnimation = NO;
        [self.headerView stopAnimation];
        [self.tableView reloadData];
        self.reCheckView.hidden = NO;
        self.headerView.text = self.resultModel.message;
        [self.headerView setScore:self.resultModel.score withAnimation:NO duration:0];
    }];
}


#pragma mark --requesterror
- (void)requestError {
    self.headerCellView.hidden = YES;
    self.headerView.progressView.progress = 0;
    self.errorImageView.hidden = NO;
    self.headerView.hidden = NO;
    [self.headerView stopAnimation];
    self.headerView.waveAnimation.isError = YES;
    self.reCheckView.hidden = NO;
    self.beginAnimation = NO;
}

#pragma mark --Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [MobClick event:@"click_exam_process_shut_yes"];//埋点
        [self dismiss];
        return;
    }
    [MobClick event:@"click_exam_process_shut_no"];//埋点
}

#pragma mark -- setter && getter
- (TDFHealthCheckHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TDFHealthCheckHeaderView alloc] initWithDefaultScore:self.homePage.totalScore];
        _headerView.colorRules = self.homePage.colorRules;
    }
    return _headerView;
}

- (TDFHealthCheckScanView *)headerCellView {
    if (!_headerCellView) {
        _headerCellView = [[TDFHealthCheckScanView alloc] init];
    }
    return _headerCellView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (TDFWaveAnimationView *)reCheckView {
    if (!_reCheckView) {
        _reCheckView = [[TDFWaveAnimationView alloc] initWithCenter:CGPointMake(self.view.tdf_width / 2.0,self.view.tdf_height - 76/2.0 - 15 ) andRadius:76/2.0];
    }
    return _reCheckView;
}

- (NSMutableArray *)resultDataArray {
    if (!_resultDataArray) {
        _resultDataArray = [NSMutableArray array];
    }
    return _resultDataArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_checkerror"]];
    }
    return _errorImageView;
}

//- (NSMutableDictionary *)codeFunctionVoDictionary {
//    if (!_codeFunctionVoDictionary) {
//        _codeFunctionVoDictionary = [NSMutableDictionary dictionary];
//    }
//    return _codeFunctionVoDictionary;
//}
@end
