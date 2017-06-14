//
//  TDFFunctionViewController.m
//  RestApp
//
//  Created by 黄河 on 16/10/18.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFFunctionViewController.h"
#import "TDFFunctionTableViewCell.h"
#import "TDFFunctionPopView.h"
#import "TDFFunctionKindVo.h"
#import "FuctionViewCell.h"
#import "ActionConstants.h"
#import "TDFChainService.h"
#import "TDFFunctionVo.h"
#import "HeadNameItem.h"
#import "TDFBaseView.h"
#import "SystemUtil.h"
#import "NetworkBox.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "TDFForwardGroup.h"
#import "TDFFuncSectionHeader.h"
@interface TDFFunctionViewController ()<NetWorkBoxClient>

@property (nonatomic, strong)TDFBaseView *baseView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *originalDataArray;
@property (nonatomic, strong)TDFFunctionPopView *popView;
@end

@implementation TDFFunctionViewController

#pragma mark --init
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)originalDataArray
{
    if (!_originalDataArray) {
        _originalDataArray = [NSMutableArray array];
    }
    return _originalDataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseView = [[TDFBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withHeaderImage:[UIImage imageNamed:@"ico_functionview_header.png"] andHelpText:NSLocalizedString(@"功能大全里显示所有的功能模块，您可以对常用的功能模块进行勾选，选择以后，二维火掌柜的首页或左侧设置栏就会显示您勾选的功能，不勾选则不会显示哦。", nil) showDetail:NO];
    self.title = NSLocalizedString(@"功能大全", nil);
    [self.view addSubview:self.baseView];
    [self initBaseView];
    [self loadList];
}

#pragma mark --request
- (void)loadList {
    @weakify(self);
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [[[TDFChainService alloc] init] getFunctionList:@{@"function_type":@"0"} sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
//        @strongify(self);
//        [self.progressHud hide:YES];
//        if (!data) {
//            return ;
//        }
//        [self.dataArray removeAllObjects];
//        for (NSDictionary *dic in data[@"data"]) {
//            TDFFunctionKindVo *kindvo = [TDFFunctionKindVo yy_modelWithDictionary:dic];
//            [self.dataArray addObject:kindvo];
//            ///保存一份原始数据
//            kindvo = [TDFFunctionKindVo yy_modelWithDictionary:dic];
//            [self.originalDataArray addObject:kindvo];
//        }
//        [self.baseView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        @strongify(self);
//        [self.progressHud hide:YES];
//        [NetworkBox show:error.localizedDescription client:self];
//    }];
    
    [[[TDFChainService alloc]init] getNewFunctionList:@{@"":@""} sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        if (!data) {
            return ;
        }
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in data[@"data"]) {
            TDFForwardGroup *kindvo = [TDFForwardGroup yy_modelWithDictionary:dic];
            [self.dataArray addObject:kindvo];
            ///保存一份原始数据
            kindvo = [TDFForwardGroup yy_modelWithDictionary:dic];
            [self.originalDataArray addObject:kindvo];
        }
        
        self.dataArray = [self changeNewModelWithArr:self.dataArray];
        
        self.originalDataArray = [self changeNewModelWithArr:self.originalDataArray];
        
        [self.baseView reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        [NetworkBox show:error.localizedDescription client:self];
    }];
}

/// other controller use the old model ,so just change the new model to old
- (NSMutableArray *)changeNewModelWithArr:(NSMutableArray *)arr {

    NSMutableArray *newArr = [NSMutableArray new];
    
    for (TDFForwardGroup *groupModel in arr) {
        
        TDFFunctionKindVo *kindVo = [TDFFunctionKindVo new];
        
        NSMutableArray *vos = [NSMutableArray new];
        
        for (TDFForwardCells *forwardModel in groupModel.forwardCells) {
            
            TDFFunctionVo *functionVo = [TDFFunctionVo new];
            
            functionVo.actionName = forwardModel.title;
            functionVo.isSuggestShow = forwardModel.isSuggestShow;
            functionVo.actionCode = forwardModel.actionCode;
            functionVo.actionId = forwardModel.actionId;
            functionVo.detail = forwardModel.detail;
            functionVo.isHide = forwardModel.isHide;
            functionVo.isLock = forwardModel.isLock;
            functionVo.isOpen = forwardModel.open;
            TDFFunctionVoIconImageUrl *imageUrl = [[TDFFunctionVoIconImageUrl alloc] init];
            imageUrl.fUrl = forwardModel.iconUrl;
            functionVo.iconImageUrl = imageUrl;
            
            [vos addObject:functionVo];
        }
        
        kindVo.name = groupModel.title;
        
        kindVo.kindType = [groupModel.pageCode isEqualToString:@"left"]?0:1;
        
        kindVo.functionVoList = [NSArray arrayWithArray:vos];
        
        [newArr addObject:kindVo];
    }
    return newArr;
}

#pragma mark --NetWorkBoxClient
- (void)reTry
{
    [self loadList];
}

#pragma mark --BaseVIew
- (void)initBaseView
{
    @weakify(self);
    self.baseView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseView.cellWithTableViewAndIndexPath = ^(UITableView* tableView,NSIndexPath *indexPath){
        @strongify(self);
        static NSString *cellReuseIdentifier = @"cell";
        TDFFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (!cell) {
            cell = [[TDFFunctionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier]    ;
            cell.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.7];
        }
        
        
        if (self.dataArray.count > indexPath.section) {
            TDFFunctionKindVo *kindVO =[self.dataArray objectAtIndex:indexPath.section];
            if (kindVO.functionVoList.count > indexPath.row ) {
                TDFFunctionVo * functionVO = [kindVO.functionVoList objectAtIndex:indexPath.row];
                [cell initWithData:functionVO];
                cell.selectBlock = ^(TDFFunctionTableViewCell *cell) {
                    functionVO.isHide = !functionVO.isHide;
                    NSString *str= [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstFuctionLancun"];
                    if (str.length == 0) {
                        NSString *infoStr = [NSString stringWithFormat:NSLocalizedString(@"保存后“%@”功能可%@", nil),functionVO.actionName,functionVO.isHide?[NSString stringWithFormat:NSLocalizedString(@"从%@移除", nil),kindVO.kindType?NSLocalizedString(@"首页", nil):NSLocalizedString(@"左侧栏", nil)]:[NSString stringWithFormat:NSLocalizedString(@"添加到%@", nil),kindVO.kindType?NSLocalizedString(@"首页", nil):NSLocalizedString(@"左侧栏", nil)]];
                        if (infoStr.length > 0) {
                            [SystemUtil showMessage:infoStr];
                        }
                    }
                    [tableView reloadData];
                    [self updateHeaderView];
                };
            }
        }

        return cell;
    };
    
    self.baseView.numberOfSection = ^(UITableView *tableView) {
        @strongify(self);
        return (NSInteger)self.dataArray.count;
    };
    
    self.baseView.numberOfRowWithSection = ^(NSInteger section) {
        @strongify(self);
        if (section < self.dataArray.count) {
            TDFFunctionKindVo *kindVO = self.dataArray[section];
            return (int)kindVO.functionVoList.count;
        }
        return 0;
    };
    
    self.baseView.heightForRowInTableViewWithIndexPath = ^CGFloat(UITableView* tableView,NSIndexPath *indexPath) {
        return 90.0;
    };
    
    self.baseView.sectionHeaderview = ^(UITableView *tableView, NSInteger section){
        @strongify(self);
//        HeadNameItem *headNameItem = [HeadNameItem getInstance];
//        if (section < self.dataArray.count) {
//            TDFFunctionKindVo *kindVO = self.dataArray[section];
//            [headNameItem initWithName:kindVO.name panelRect:CGRectMake(0, 0,200, 24)];
//            headNameItem.panel.backgroundColor = [UIColor blackColor];
//            return headNameItem;
//            
//        }
//        headNameItem.hidden = YES;
//        return headNameItem;
        
        TDFFuncSectionHeader *header = [[TDFFuncSectionHeader alloc]init];

        if (section < self.dataArray.count) {
            
            BOOL isSelect = YES;
            
            for (TDFFunctionVo *vo in ((TDFFunctionKindVo *)self.dataArray[section]).functionVoList) {
                
                if (vo.isHide) {
                    
                    isSelect = NO;
                    
                    break;
                }
            }
            
            TDFFunctionKindVo *kindVO = self.dataArray[section];
            
            [header loadName:kindVO.name andIsSelected:isSelect andSelectBlock:^(BOOL select) {
                
                for (TDFFunctionVo *vo in kindVO.functionVoList) {
                    
                    vo.isHide = !select;
                }
                
                [tableView reloadData];
                
                [self updateHeaderView];
            }];
            
            return header;
        }
        header.hidden = YES;
        return header;
    };
    self.baseView.heightForSectionView = ^CGFloat(UITableView* tableView,NSInteger section){
        return 44.0;
    };
    
    
    self.baseView.didSelectRow = ^(UITableView* tableView,NSIndexPath *indexPath){
        @strongify(self);
        if (self.dataArray.count > indexPath.section) {
            TDFFunctionPopView *popView = [[TDFFunctionPopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [self.view addSubview:popView];
            TDFFunctionKindVo *kindVO =[self.dataArray objectAtIndex:indexPath.section];
            popView.backBlock = ^{
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self updateHeaderView];
                [tableView reloadData];
            };

            [popView loadDataWithFunctionKindVo:kindVO andIndexPath:indexPath];
            
        }
    };
    
    self.baseView.showHelpDialog = ^{
        [HelpDialog show:@"functionList"];
    };
}

#pragma mark --updateHeaderView

- (void)updateHeaderView
{
    if ([self.dataArray isEqual:self.originalDataArray]) {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }else
    {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}

#pragma mark --save
- (void)rightNavigationButtonAction:(id)sender
{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSString *str= [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstFuctionLancun"];
    if (str.length == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"111" forKey:@"FirstFuctionLancun"];
    }

    NSMutableArray *isShowIds = [NSMutableArray array];
    NSMutableArray *isHideIds = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(TDFFunctionKindVo *functionKindVO, NSUInteger idx, BOOL * _Nonnull stop) {
        [functionKindVO.functionVoList enumerateObjectsUsingBlock:^(TDFFunctionVo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isHide) {
                [isHideIds addObject:obj.actionId];
            }else
            {
                [isShowIds addObject:obj.actionId];
            }
        }];
    }];
    @weakify(self);
    
    [[[TDFChainService alloc] init] saveFunctionList:@{@"isShowIds":[isShowIds yy_modelToJSONString],@"isHideIds":[isHideIds yy_modelToJSONString]} sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self updateInfo];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)updateInfo
{
    @weakify(self);
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[[TDFChainService alloc] init] getFunctionList:@{@"function_type":@"1"} sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        if (!data) {
            return ;
        }
        BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
        NSMutableArray *allInfoArray = [NSMutableArray array];
        NSMutableArray *leftInfoArray = [NSMutableArray array];
        NSMutableArray *homeInfoArray = [NSMutableArray array];
        for (NSDictionary *dic in data[@"data"]) {
            TDFFunctionKindVo *kindvo = [TDFFunctionKindVo yy_modelWithDictionary:dic];
            if (!showRestApp) {
                NSMutableArray *functionListArray = [NSMutableArray array];
                [kindvo.functionVoList enumerateObjectsUsingBlock:^(TDFFunctionVo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!([obj.actionCode isEqualToString:TO_SUPPLY_MANAGE])) {//||[obj.actionCode isEqualToString:PHONE_KOUBEI_SHOP]
                        [functionListArray addObject:obj];
                    }
                }];
                kindvo.functionVoList = [NSArray arrayWithArray:functionListArray];
            }
            if (kindvo.functionVoList.count == 0) {
                continue;
            }

            
            [allInfoArray addObject:kindvo];
            if (kindvo.kindType == 1) {
                [homeInfoArray addObject:kindvo];
            }else if (kindvo.kindType == 0)
            {
                [leftInfoArray addObject:kindvo];
            }
        }
        [Platform Instance].allFunctionArray     = allInfoArray;
        [Platform Instance].allLeftFunctionArray = leftInfoArray;
        [Platform Instance].allHomeFunctionArray = homeInfoArray;
        [self.progressHud hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_back_navigateView" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


- (void)leftNavigationButtonAction:(id)sender
{
    if ([self.originalDataArray isEqual:self.dataArray]) {
        [super leftNavigationButtonAction:sender];
    }else
    {
        [self alertChangedMessage:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
