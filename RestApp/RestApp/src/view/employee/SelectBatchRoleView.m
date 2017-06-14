//
//  SelectBatchRoleView.m
//  RestApp
//
//  Created by zxh on 14-10-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectBatchRoleView.h"
#import "MultiCheckCell.h"
#import "INameValueItem.h"
#import "ActionHeadCell.h"
#import "Platform.h"
#import "TreeNode.h"
#import "Action.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFRoleCategoryProxy.h"
#import "MemberSearchBar.h"
#import "TreeNode+Copying.h"

@interface SelectBatchRoleView ()<MemberSearchBarEvent>
@property (nonatomic) BOOL isOpen;
@property (strong, nonatomic) TDFRoleCategoryProxy *proxy;
@property (strong, nonatomic) MemberSearchBar *searchBar;
@property (nonatomic) BOOL searchBarShowing;

@property (nonatomic) NSArray *filteredData;

@end

@implementation SelectBatchRoleView

@synthesize isOpen = _isOpen;

- (void)viewDidLoad
{
    self.needHideOldNavigationBar= YES;
    [super viewDidLoad];
    [self configRightBtn];
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:@"ico_ok.png" rightButtonName:NSLocalizedString(@"保存", nil)];
    [self loadData:self.nodeList];
    [self.view addSubview:self.searchBar];
    [self configRightBtn];
}

#pragma  interface event
- (void)initDelegate:(NSInteger)eventTemp delegate:(id<MultiCheckHandle>)delegateTemp title:(NSString *) titleName
{
    self.delegate=delegateTemp;
    self.event=eventTemp;
    self.title=titleName;
    self.datas=nil;
    [self.mainGrid reloadData];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self.delegate multiCheck:self.event items:self.selectIdSet];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate closeMultiView:1];
}

- (void)loadData:(NSMutableArray *)nodeList
{
    self.nodeList=[nodeList mutableCopy];
    self.filteredData = [self.nodeList copy];
    [self processDataList];
    [self.mainGrid reloadData];
}

- (void)processDataList
{
    self.selectIdSet = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:self.nodeList]) {
        for (TreeNode* node in self.nodeList) {
            Action* action = (Action *)node.orign;
            if ([action isSelected]) {
                [self.selectIdSet addObject:action._id];
            }
            NSMutableArray *temps = node.children;
            if ([ObjectUtil isNotEmpty:temps]) {
                NSInteger i =0;
                for (TreeNode* childNode in temps) {
                    action = (Action *)childNode.orign;
                    if ([action isSelected]) {
                        [self.selectIdSet addObject:action._id];
                        i++;
                    }
                }
                if (i==temps.count) {
                    node.select=YES;
                }
            }
        }
    }
}


#pragma mark - Right Btn && Animation


- (void)configRightBtn {
    self.managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.managerButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0 -35);
    self.managerButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.managerButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.managerButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.managerButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.managerButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.managerButton setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
    [self.managerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.managerButton addTarget:self action:@selector(selectPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerButton];
    
    self.selectPanel = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT)];
    self.proxy = [[TDFRoleCategoryProxy alloc] initWithTableView:self.selectPanel data:nil];
    @weakify(self);
    self.proxy.selectBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        [self.mainGrid scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:indexPath.row]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        self.isOpen = NO;
    };
    
    [self.proxy reloadWithData:self.nodeList];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.btnBg];
    self.btnBg.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectPanel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnBg removeFromSuperview];
    [self.selectPanel removeFromSuperview];
}

- (void)selectPanel:(UIButton *)button
{
    self.isOpen = !self.isOpen;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    
    if (isOpen == YES) {
        
        [self animationMoveIn:self.managerButton backround:self.btnBg];
    }else
    {
        [self animationMoveOut:self.managerButton backround:self.btnBg];
    }
}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - self.selectPanel.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    CGRect frame = self.selectPanel.frame;
    frame.origin.x = SCREEN_WIDTH - frame.size.width;
    self.selectPanel.frame = frame;
    background.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    CGRect frame = self.selectPanel.frame;
    frame.origin.x = SCREEN_WIDTH;
    self.selectPanel.frame = frame;
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

#pragma mark check-button
-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    for (TreeNode* node in self.filteredData) {
        node.select =YES;
        Action* action=(Action *)node.orign;
        [self.selectIdSet addObject:action._id];
        NSMutableArray *temps = node.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            for (TreeNode* sn in temps) {
                action = (Action *)sn.orign;
                [self.selectIdSet addObject:action._id];
            }
        }
    }
    [self.mainGrid reloadData];
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    for (TreeNode *node in self.filteredData) {
        node.select =NO;
        Action* action=(Action *)node.orign;
        [self.selectIdSet removeObject:action._id];
        NSMutableArray *temps = node.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            for (TreeNode* sn in temps) {
                action = (Action *)sn.orign;
                [self.selectIdSet removeObject:action._id];
            }
        }
    }
    [self.mainGrid reloadData];
}

- (void)checkHead:(BOOL)result head:(TreeNode *)head
{
   // head.select=YES;
    if (head.select) {
        head.select=NO;
        NSMutableArray *temps = head.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            for (TreeNode* sn in temps) {
                Action* action = (Action *)sn.orign;
                [self.selectIdSet removeObject:action._id];
//                 [self.selectIdSet removeObject:head.itemId];
            }
        }
        [self.selectIdSet removeObject:head.itemId];
    }
    else
    {
        head.select=YES;
        NSMutableArray *temps = head.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            for (TreeNode* sn in temps) {
                Action* action = (Action *)sn.orign;
                [self.selectIdSet addObject:action._id];
            }
        }
        [self.selectIdSet addObject:head.itemId];
    }
    
    [self.mainGrid reloadData];
    
}


#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultiCheckCell * cell = [tableView dequeueReusableCellWithIdentifier:MultiCheckCellIdentifier];
//    if (!cell) {
//        cell= [[NSBundle mainBundle] loadNibNamed:@"MultiCheckCell" owner:self options:nil].lastObject;
//    }
    TreeNode* head = [self.filteredData objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = head.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            TreeNode* item=(TreeNode *)[temps objectAtIndex:indexPath.row];
            Action* action = (Action*)item.orign;
            cell.lblName.text= [action obtainItemName];
            cell.imgCheck.hidden=![self.selectIdSet containsObject:action._id];
            cell.imgUnCheck.hidden=[self.selectIdSet containsObject:action._id];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode* head = [self.filteredData objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = head.children;
        if ([ObjectUtil isNotEmpty:temps]) {
            TreeNode* item=(TreeNode *)[temps objectAtIndex:indexPath.row];
            Action* action=(Action*)item.orign;
            if (action) {
                if ([self.selectIdSet containsObject:action._id]) {
                    [self.selectIdSet removeObject:action._id];
                    head.select =NO;
                } else {
                    [self.selectIdSet addObject:action._id];
                    
                }
            }
            NSInteger j=0;
            for (NSInteger i=0; i<temps.count; i++) {
                TreeNode* item=(TreeNode *)[temps objectAtIndex:i];
                Action* action=(Action*)item.orign;
                if (action) {
                    if ([self.selectIdSet containsObject:action._id]) {
                        j++;
                    }
                }
            }
            if (j == temps.count) {
                head.select=YES;
            }
            [self.mainGrid reloadData];
            
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TreeNode* head = [self.filteredData objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = head.children;
        return ([ObjectUtil isNotEmpty:temps]?temps.count:0);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TreeNode* head= [self.filteredData objectAtIndex:section];
    ActionHeadCell *headItem = (ActionHeadCell *)[tableView dequeueReusableCellWithIdentifier:ActionHeadCellIdentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"ActionHeadCell" owner:self options:nil].lastObject;
    }
    headItem.allLabel.hidden = YES;
    headItem.isResponseClick = YES;
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem loadData:head delegate:self];
    [headItem ishide:head.select];
    
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.filteredData]?self.filteredData.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    TreeNode* head= [self.nodeList objectAtIndex:section];
//    if (head.children.count>0) {
        return 44;
//    }
//    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y < -60 && !self.searchBarShowing) {
        self.searchBarShowing = YES;
        [self animateShowSearchBar];
    }
}

- (void)animateShowSearchBar {
    
    CGRect sframe = CGRectMake(0, 64, SCREEN_WIDTH, 48);
    CGRect tframe = CGRectMake(0, 64 + 48, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 48);
    [UIView animateWithDuration:0.2 animations:^{
        self.mainGrid.frame = tframe;
        self.searchBar.frame = sframe;
    }];
}

- (void)animateHideSearchBar {
    CGRect sframe = CGRectMake(0, 16, SCREEN_WIDTH, 48);
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.searchBarShowing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.mainGrid.frame = tframe;
        self.searchBar.frame = sframe;
    }];
}

#pragma mark MemberSearchBarEvent

-(void)searchBarEventClick:(NSString*)keyWord sender:(id)sender {
    
    if (sender == nil) {
        return;
    }
    
    [self animateHideSearchBar];
    self.searchBar.textField.text = nil;
    self.filteredData = [self.nodeList copy];
    [self.mainGrid reloadData];
    [self.proxy reloadWithData:self.filteredData];
}


- (NSArray *)searchedDataWithKeyword:(NSString *)keyword {
    
    
    if (keyword.length == 0) {
        return [self.nodeList copy];
    }
    
    NSMutableArray *nodes = [NSMutableArray array];
    for (TreeNode *node in self.nodeList) {
        NSMutableArray *children = [NSMutableArray array];
        for (TreeNode *childNode in node.children) {
            Action* action = (Action*)childNode.orign;
            if ([[action obtainItemName] containsString:keyword]) {
                [children addObject:childNode];
            }
        }
        if (children.count > 0) {
            TreeNode *nodeTmp = [node copy];
            nodeTmp.children = children;
            [nodes addObject:nodeTmp];
        }
    }
    return [nodes copy];
}

- (void)textFieldDidChange:(UITextField *)textField {

    [self searchByKeyword:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (void)searchByKeyword:(NSString *)keyword {
    
    self.filteredData = [self searchedDataWithKeyword:keyword];
    [self.mainGrid reloadData];
    [self.proxy reloadWithData:self.filteredData];
}

- (MemberSearchBar *)searchBar {
    
    if (!_searchBar) {
        
        _searchBar = [[MemberSearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 16, SCREEN_WIDTH, 48);
        _searchBar.delegateTmp = self;
        [_searchBar setSearchBtnTitile:NSLocalizedString(@"取消", @"取消")];
        [_searchBar setSearchBarPlaceholder:@"输入权限名称"];
        [_searchBar.textField addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
    }
    
    return _searchBar;
}
@end
