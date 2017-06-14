//
//  TDFChainMemberSearchViewController.m
//  RestApp
//
//  Created by chaiweiwei on 16/7/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFChainMemberSearchViewController.h"
#import "XHAnimalUtil.h"
#import "TDFBranchSelecteHeaderView.h"
#import "KeyBoardUtil.h"
#import "NSString+Estimate.h"
#import "TDFChainMemberCell.h"
#import "TDFChainService.h"
#import "MBProgressHUD.h"
#import "EmpCompanyVo.h"
#import "AlertBox.h"
#import "MemberUserArrayVo.h"
#import <libextobjc/EXTScope.h>
#import <Mantle.h>

@interface TDFChainMemberSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TDFBranchSelecteHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmpCompanyVo *empCompanyVO;

@property (nonatomic,strong) TDFBranchSelecteHeaderView *tableHeaderView;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *searchPanelView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSArray *searchDataSource;

@property (nonatomic,assign) BOOL isSearchModel;

@end

@implementation TDFChainMemberSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initMainView];
    
    self.title = NSLocalizedString(@"员工筛选", nil);
    
    self.selectedIndex = -1;
    
    [self fetchMemberData];
}

- (void)initMainView
{
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.searchPanelView];
    
    [self.searchPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(-40);
    }];
    
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.searchPanelView.mas_bottom);
    }];
    
    [self.tableView registerClass:[TDFChainMemberCell class] forCellReuseIdentifier:@"TDFChainMemberCell"];
    
    [self fetchMemberData];
}

- (void)fetchMemberData {
    
    NSString *userId = [[Platform Instance] getkey:USER_ID];
    if ([NSString isNotBlank:userId]) {
        self.tableHeaderView = nil;
        self.empCompanyVO = nil;
        self.isSearchModel = NO;
        self.searchDataSource = nil;
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
        
        NSDictionary *param = @{@"user_id":userId,@"page_index":@"1"};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        @weakify(self);
        [[[TDFChainService alloc] init] getGlobalManageEntityListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            self.empCompanyVO = [MTLJSONAdapter modelOfClass:[EmpCompanyVo class] fromJSONDictionary:data[@"data"] error:nil];
            self.tableView.tableHeaderView =  self.tableHeaderView;
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque=NO;
    }
    return _tableView;
}

- (TDFBranchSelecteHeaderView *)tableHeaderView {
    if(!_tableHeaderView) {
        _tableHeaderView = [[TDFBranchSelecteHeaderView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110);
        _tableHeaderView.delegate = self;
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:3];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
        dic[@"title"] = NSLocalizedString(@"连锁总部", nil);
        dic[@"defaultImage"] = @"icon_boss_default";
        dic[@"hightImage"] = @"icon_boss_hight";
        dic[@"canEdit"] = @(YES);

        if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]) {
            self.selectedIndex = 0;
            dic[@"selected"] = @(YES);
        }
        
        [list addObject:dic];
        
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        dic[@"title"] = NSLocalizedString(@"分公司", nil);
        dic[@"defaultImage"] = @"icon_branch_default";
        dic[@"hightImage"] = @"icon_branch_hight";
        dic[@"canEdit"] = @(YES);
        
        if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRANCH]]) {
            self.selectedIndex = 1;
            dic[@"selected"] = @(YES);
        }
        
        [list addObject:dic];
        
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        dic[@"title"] = NSLocalizedString(@"门店", nil);
        dic[@"defaultImage"] = @"icon_part_default";
        dic[@"hightImage"] = @"icon_part_hight";
        dic[@"canEdit"] = @(YES);
        if ([@"0" isEqualToString:[[Platform Instance]getkey:IS_BRANCH]] && [@"0" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]) {
            self.selectedIndex = 2;
            dic[@"selected"] = @(YES);
        }
        [list addObject:dic];
        _tableHeaderView.itemList = [list copy];
    }
    return _tableHeaderView;
}

- (UIView *)searchPanelView {
    if(!_searchPanelView) {
        _searchPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _searchPanelView.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.75];
        [_searchPanelView.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
        _searchPanelView.hidden = YES;
        
        UIView *panelBg = [[UIView alloc] initWithFrame:CGRectMake(6, 3, 266, 34)];
        panelBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        [_searchPanelView addSubview:panelBg];
        
        UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 22, 22)];
        searchImg.backgroundColor = [UIColor clearColor];
        searchImg.image = [UIImage imageNamed:@"ico_search.png"];
        [_searchPanelView addSubview:searchImg];
        
        [_searchPanelView addSubview:self.searchTextField];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(268, 5, 46, 30)];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancleBtn.titleLabel.textColor = [UIColor whiteColor];
        [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        [_searchPanelView addSubview:cancleBtn];
    }
    return _searchPanelView;
}

- (UITextField *)searchTextField {
    if(!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(34, 5, 233, 32)];
        _searchTextField.font = [UIFont systemFontOfSize:14];
        _searchTextField.textColor = [UIColor whiteColor];
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.placeholder = NSLocalizedString(@"输入名称", nil);
        [_searchTextField setDelegate:self];
        [_searchTextField setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        [KeyBoardUtil initWithTarget:_searchTextField];
    }
    return _searchTextField;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!self.isSearchModel) {
        if(self.selectedIndex == 0) {
            return 1;
        }else if(self.selectedIndex == 1){
            return 1;
        }else if (self.selectedIndex == 2) {
            return self.empCompanyVO.shopVoList.count;
        }
    }else {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.isSearchModel) {
        if(self.selectedIndex == 0) {
            if (self.empCompanyVO.brandVo) {
                return 1;
            }
        }else if(self.selectedIndex == 1){
            return self.empCompanyVO.branchVoList.count;
        }else if (self.selectedIndex == 2) {
            MemberUserArrayVo *vo = self.empCompanyVO.shopVoList[section];
            return vo.memberUserVoList.count;
        }
    }else {
        return self.searchDataSource.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDFChainMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFChainMemberCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if(!self.isSearchModel) {
        if(self.selectedIndex == 0) {
            MemberUserVo *memberUser = self.empCompanyVO.brandVo;
            cell.titleLabel.text = memberUser.shopName;
        }else if(self.selectedIndex == 1){
            BranchTreeVo *vo = self.empCompanyVO.branchVoList[indexPath.row];
            NSMutableString *branchName = [[NSMutableString alloc] init];
            for (int i = 1; i < vo.level; i ++) {
                [branchName appendString:NSLocalizedString(@"• ", nil)];
            }
            [branchName appendString:vo.branchName];
            cell.titleLabel.text = branchName;
        }else if (self.selectedIndex == 2) {
            MemberUserArrayVo *vo = self.empCompanyVO.shopVoList[indexPath.section];
            MemberUserVo *memberUser = vo.memberUserVoList[indexPath.row];
            cell.titleLabel.text = memberUser.shopName;
        }
    }else {
        id vo = self.searchDataSource[indexPath.row];
        if([vo isKindOfClass:[BranchTreeVo class]]) {
            BranchTreeVo *branchTreeVo = (BranchTreeVo *)vo;
            cell.titleLabel.text = branchTreeVo.branchName;
        }else if([vo isKindOfClass:[MemberUserVo class]]) {
            MemberUserVo *memberUserVo = (MemberUserVo *)vo;
            cell.titleLabel.text = memberUserVo.shopName;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!self.isSearchModel) {
        if(self.selectedIndex == 2) {
            MemberUserArrayVo *vo = self.empCompanyVO.shopVoList[section];
            if(vo.branchName.length > 0) {
               return 40;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MemberUserArrayVo *vo = self.empCompanyVO.shopVoList[section];
    NSString *title =  vo.branchName;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [[UIView alloc] init];
    alphaView.bounds = CGRectMake(0, 0, size.width + 136, 22);
    alphaView.center = CGPointMake(self.view.frame.size.width/2.0f, 20);
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.5;
    alphaView.layer.masksToBounds = YES;
    alphaView.layer.cornerRadius = 11;
    [view addSubview:alphaView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.frame = alphaView.frame;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    if(!self.isSearchModel) {
        if(self.selectedIndex == 0) {
            dic[@"entityId"] = self.empCompanyVO.brandVo.entityId;
            dic[@"shopName"] = self.empCompanyVO.brandVo.shopName;
            dic[@"type"] = @"brand";
        }else if(self.selectedIndex == 1){
            BranchTreeVo *vo = self.empCompanyVO.branchVoList[indexPath.row];
            dic[@"entityId"] = vo.entityId;
            dic[@"shopName"] = vo.branchName;
            dic[@"type"] = @"branch";
        }else if (self.selectedIndex == 2) {
            MemberUserArrayVo *vo = self.empCompanyVO.shopVoList[indexPath.section];
            MemberUserVo *memberUser = vo.memberUserVoList[indexPath.row];
            dic[@"entityId"] = memberUser.entityId;
            dic[@"shopName"] = memberUser.shopName;
            dic[@"type"] = @"shop";
        }
    }else {
        id vo = self.searchDataSource[indexPath.row];
        if([vo isKindOfClass:[BranchTreeVo class]]) {
            BranchTreeVo *branchTreeVo = (BranchTreeVo *)vo;
            dic[@"entityId"] = branchTreeVo.entityId;
            dic[@"shopName"] = branchTreeVo.branchName;
            dic[@"type"] = @"branch";
        }else if([vo isKindOfClass:[MemberUserVo class]]) {
            MemberUserVo *memberUserVo = (MemberUserVo *)vo;
            dic[@"entityId"] = memberUserVo.entityId;
            dic[@"shopName"] = memberUserVo.shopName;
            if([memberUserVo.entityTypeId isEqualToString:@"2"]) {
                dic[@"type"] = @"brand";
            }else {
                dic[@"type"] = @"shop";
            }
        }
    }

    !self.memberItemSelectedCallBack?:self.memberItemSelectedCallBack([dic copy]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        self.isSearchModel = YES;
        [self.searchTextField becomeFirstResponder];
        
        
        NSMutableArray *array = [NSMutableArray array];
        
        if([self.empCompanyVO.brandVo.shopName containsString:keyword]) {
            [array addObject:self.empCompanyVO.brandVo];
        }

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"branchName CONTAINS %@",keyword];
        [array addObjectsFromArray:[[self.empCompanyVO.branchVoList filteredArrayUsingPredicate:predicate] mutableCopy]];
        
        predicate = [NSPredicate predicateWithFormat:@"shopName CONTAINS %@",keyword];
        [self.empCompanyVO.shopVoList enumerateObjectsUsingBlock:^(MemberUserArrayVo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObjectsFromArray:[[obj.memberUserVoList filteredArrayUsingPredicate:predicate] mutableCopy]];
        }];
        
        self.searchDataSource = [array copy];
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }else {
        self.isSearchModel = NO;
        self.tableView.tableHeaderView = self.tableHeaderView;
        [self.tableView reloadData];
    }
    return YES;
}

- (void)cancelSearch
{
    self.isSearchModel = NO;
    self.searchTextField.text = @"";
    [self hideDHSearchBar];
    [self.searchTextField resignFirstResponder];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.searchPanelView.hidden) {
        CGPoint point = scrollView.contentOffset;
        if (0 - point.y >= 44) {
            [self.searchTextField becomeFirstResponder];
            [self showDHSearchBar];
        }
    }
}

- (void)showDHSearchBar
{
    self.searchPanelView.hidden = NO;
    
    [self.searchPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
    }];

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)hideDHSearchBar
{
    [self.searchPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-40);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.searchPanelView.hidden = YES;
    }];
}

- (void)itemButtonActionCallBack:(NSInteger)index {
    self.selectedIndex = index;
    [self.tableView reloadData];
}

@end
