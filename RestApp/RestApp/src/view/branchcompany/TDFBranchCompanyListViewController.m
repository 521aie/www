//
//  TDFBranchCompanyListViewController.m
//  RestApp
//
//  Created by zishu on 16/7/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBranchCompanyListViewController.h"
#import "NavigateTitle2.h"
#import "ViewFactory.h"
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "NameValueDetail.h"
#import "HelpDialog.h"
#import "XHAnimalUtil.h"
#import "NameValueCell44.h"
#import "NameItemVO.h"
#import "TDFChainService.h"
#import "MJRefresh.h"
#import "BranchTreeVo.h"
#import "TDFMediator+BranchCompanyModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TDFBranchCompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initMainView];
    
    self.branchCompanyTab.backgroundColor = [UIColor clearColor];
    
    [self loadType:self.type target:self.delegate];
    [self initGrid];
}

- (void) initMainView
{
    self.view.backgroundColor = [UIColor clearColor];

    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 40)];
    self.panel.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.75];
    [self.panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    
    UIView *panelBg = [[UIView alloc] initWithFrame:CGRectMake(6, 3, SCREEN_WIDTH - 54, 34)];
    panelBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.panel addSubview:panelBg];
    
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 22, 22)];
    searchImg.backgroundColor = [UIColor clearColor];
    searchImg.image = [UIImage imageNamed:@"ico_search.png"];
    [self.panel addSubview:searchImg];
    
    self.txtKey = [[UITextField alloc] initWithFrame:CGRectMake(34, 5, SCREEN_WIDTH-87, 32)];
    self.txtKey.returnKeyType = UIReturnKeySearch;
    self.txtKey.font = [UIFont systemFontOfSize:14];
    self.txtKey.backgroundColor = [UIColor clearColor];
    self.txtKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtKey.textAlignment = NSTextAlignmentLeft;
    self.txtKey.placeholder = NSLocalizedString(@"输入名称", nil);
    self.txtKey.textColor = [UIColor whiteColor];
    [self.txtKey setDelegate:self];
    [self.txtKey setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    [self.panel addSubview:self.txtKey];
    [KeyBoardUtil initWithTarget:self.txtKey];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 52, 5, 46, 30)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancleBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:cancleBtn];
    [self.view addSubview:self.panel];
    
    self.branchCompanyTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.branchCompanyTab.backgroundColor = [UIColor clearColor];
    self.branchCompanyTab.delegate = self;
    self.branchCompanyTab.dataSource = self;
    [self.view addSubview:self.branchCompanyTab];
    self.branchCompanyTab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initPlaceholderView
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.branchCompanyTab addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT - 220, 50, 120, 120)];
    imageView.image=[UIImage imageNamed:@"img_nobill"];
    [bgView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,180, SCREEN_WIDTH - 40, 120)];
    label.text=self.str;
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [bgView addSubview:label];
}


#pragma mark table deal
-(void)initGrid
{
    self.branchCompanyTab.opaque=NO;
    UIView* view=[ViewFactory generateFooter:76];
    view.backgroundColor=[UIColor clearColor];
    [self.branchCompanyTab setTableFooterView:view];
}

- (void) hasPageQuery
{
    __weak typeof (self)weakSelf = self;
    
    self.branchCompanyTab.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        isRefresh = NO;
//         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//        [weakSelf queryBranchList];
    }];
    
    self.branchCompanyTab.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isRefresh = YES;
        weakSelf.page = weakSelf.page + 1;
//         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//        [weakSelf queryBranchList];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.branchCompanyTab.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)loadType:(TDFBranchType)type target:(id<OptionSelectClient>)target
{
    switch (self.type) {
        case EditType:
            if (self.isFromBranchEditView) {
                 [self loadDataArr:self.branchCompanyList copyArr:self.branchCompanyListArr];
            }else{
                [self loadShopBranch];
            }
            self.title =NSLocalizedString(@"选择分公司", nil);
            [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
            self.title = NSLocalizedString(@"选择分公司", nil);
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeNone];
            break;
        case ModuleType:
            [self loadData];
            self.title = NSLocalizedString(@"分公司", nil);
            if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
                [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd| TDFFooterButtonTypeHelp];
            }else{
                [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
            }
            break;
        default:
            break;
    }
}


- (void) loadData{
    [self.branchCompanyList removeAllObjects];
    [self.branchCompanyListArr removeAllObjects];
    [self.branchCompanyListCopy removeAllObjects];
    self.page = 1;
    [self queryBranchList];
}

- (void) queryBranchList
{
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    self.branchCompanyList = [[NSMutableArray alloc] init];
    self.branchCompanyListArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [bgView removeFromSuperview];
    @weakify(self);
    [[TDFChainService new] queryBranchListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         @strongify(self);
        [self.progressHud hide:YES];
        [self.branchCompanyTab.header endRefreshing];
        [self.branchCompanyTab.footer endRefreshing];

        if ([ObjectUtil isNotEmpty:data[@"data"]]) {
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                branchTreeVo.branchName = [self getName:branchTreeVo.level-1 name:branchTreeVo.branchName];
                [self.branchCompanyList addObject:branchTreeVo];
            }
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                [self.branchCompanyListArr addObject:branchTreeVo];
            }
        }else{
            self.str =  NSLocalizedString(@"连锁总部还未添加过分公司", nil);
            [self initPlaceholderView];
        }
        [self.branchCompanyTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         @strongify(self);
        [self.progressHud hide:YES];
        [self.branchCompanyTab.header endRefreshing];
        [self.branchCompanyTab.footer endRefreshing];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) loadShopBranch
{
    [bgView removeFromSuperview];
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [bgView removeFromSuperview];
    @weakify(self);
    [[TDFChainService new] queryShopBranchListLimitWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.branchCompanyTab.header endRefreshing];
        [self.branchCompanyTab.footer endRefreshing];
        self.branchCompanyList = [[NSMutableArray alloc] init];
        self.branchCompanyListArr = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotEmpty:data[@"data"]]) {
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                branchTreeVo.branchName = [self getName:branchTreeVo.level-1 name:branchTreeVo.branchName];
                [self.branchCompanyList addObject:branchTreeVo];
            }
            for (NSMutableDictionary *dic in data[@"data"]) {
                BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                [self.branchCompanyListArr addObject:branchTreeVo];
            }
        }else{
            self.str =  NSLocalizedString(@"已经没有可添加的上级公司.", nil);
            [self initPlaceholderView];
        }
        [self.branchCompanyTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.branchCompanyTab.header endRefreshing];
        [self.branchCompanyTab.footer endRefreshing];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) loadDataArr:(NSMutableArray *)arr copyArr:(NSMutableArray *)copyArr
{
    [bgView removeFromSuperview];
    self.branchCompanyListCopy = [self.branchCompanyList mutableCopy];
    if ([ObjectUtil isEmpty:arr]) {
        self.str =  NSLocalizedString(@"已经没有可添加的上级公司.", nil);
        [self initPlaceholderView];
    }
    [self.branchCompanyTab reloadData];
}

-(NSString*) getName:(int)level name:(NSString*)name
{
    if (level==0) {
        return name;
    }
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    for (int i=0; i<level; i++) {
        [result appendString:NSLocalizedString(@"▪︎", nil)];
    }
    [result appendString:@""];
    [result appendString:name];
    return [NSString stringWithString:result];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SystemUtil hideKeyboard];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        [self initWithKeyword:keyword];
        [self startSearchMode];
    }
    return YES;
}

- (void)initWithKeyword:(NSString *)keyword
{
    BOOL nameCheck=NO;
    BOOL codeCheck=NO;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:self.branchCompanyListArr]) {
        for (BranchTreeVo *branchTreeVo in self.branchCompanyListArr) {
            nameCheck = [branchTreeVo.branchName rangeOfString:keyword].location!=NSNotFound;
            codeCheck = ([branchTreeVo.branchCode isEqualToString:keyword])? YES:NO;
            if (nameCheck || codeCheck) {
                [arr addObject:branchTreeVo];
            }
        }
        [self.branchCompanyList removeAllObjects];
        self.branchCompanyList = [NSMutableArray arrayWithArray:arr];
    }
    [self.branchCompanyTab reloadData];
    
}

- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.txtKey becomeFirstResponder];
        [self showDHSearchBar];
    }
}

- (void)cancelSearch
{
    [self cancelSearchMode];
    if ([ObjectUtil isEmpty:self.branchCompanyListCopy]) {
        [self loadData];
    }else{
        self.branchCompanyList = self.branchCompanyListCopy;
        [self.branchCompanyTab reloadData];
    }
}

- (void)cancelSearchMode
{
    if (self.isSearchMode) {
        self.txtKey.text = @"";
        [self hideDHSearchBar];
        [SystemUtil hideKeyboard];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == EditType) {
        return 44;
    }else{
        return 88;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.branchCompanyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == EditType) {
        NameValueCell44 * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCell44Identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell44" owner:self options:nil].lastObject;
        }
        if ([ObjectUtil isNotEmpty:self.branchCompanyList]) {
            BranchTreeVo *treeVo = self.branchCompanyList[indexPath.row];
            cell.lblName.text= treeVo.branchName;
        }
        cell.lblVal.hidden=YES;
        cell.img.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        NameValueDetail * cell = [tableView dequeueReusableCellWithIdentifier:NameValueDetailIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueDetail" owner:self options:nil].lastObject;
        }
        if ([ObjectUtil isNotEmpty:self.branchCompanyList]) {
            BranchTreeVo *treeVo = self.branchCompanyList[indexPath.row];
            cell.lblName.text = treeVo.branchName;
            cell.lblCodeText.text = [NSString stringWithFormat:NSLocalizedString(@"分公司编码：%@", nil),treeVo.branchCode];
            if (treeVo.level == 4) {
                cell.lblVal.text = [NSString stringWithFormat:NSLocalizedString(@"%d家分店", nil),treeVo.shopCount];
            }else{
                cell.lblVal.text = [NSString stringWithFormat:NSLocalizedString(@"%d家分公司,%d家分店", nil),treeVo.branchCount,treeVo.shopCount];
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (self.type == EditType) {
        [self.navigationController popViewControllerAnimated:YES];
        BranchTreeVo *vo = self.branchCompanyList[indexPath.row];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:vo.branchName andId:vo.entityId];
        [self.delegate selectOption:item branchId:vo.branchId];
    }else{
        BranchTreeVo *vo = self.branchCompanyList[indexPath.row];
        TDFMediator *mediator = [[TDFMediator alloc] init];
        @weakify(self);
        UIViewController *viewController = [mediator TDFMediator_branchCompanEditViewControllerWithType:vo action:ACTION_CONSTANTS_EDIT listCallBack:^(BOOL orRefresh) {
            @strongify(self);
            [self loadData];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    if (0 - point.y >= 44) {
        if (self.isSearchMode == NO) {
            [self.txtKey becomeFirstResponder];
            [self showDHSearchBar];
        }
    }
}


- (void)showDHSearchBar
{
    self.isSearchMode = YES;
    self.panel.frame = CGRectMake(0,-40,SCREEN_WIDTH,40);
    self.branchCompanyTab.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 64);
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.branchCompanyTab.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.branchCompanyTab.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,-40,SCREEN_WIDTH,40);
    self.branchCompanyTab.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"chainbranch"];
}

- (void)footerAddButtonAction:(UIButton *)sender
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_branchCompanEditViewControllerWithType:nil action:ACTION_CONSTANTS_ADD listCallBack:^(BOOL orRefresh) {
        @strongify(self);
        [self loadData];
        }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) leftNavigationButtonAction:(id)sender
{
    self.listCallBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
