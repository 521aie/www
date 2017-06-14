//
//  RoleEditView.m
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//


#import "RoleEditView.h"

@implementation RoleEditView
#pragma set--get
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *) container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _container;
}

- (EditItemText *) txtName
{
    if (!_txtName) {
        _txtName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        
    }
    return _txtName;
}

- (ItemTitle *) titleRest
{
    if (!_titleRest) {
        _titleRest = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 60) ];
        [_titleRest awakeFromNib];
    }
    return _titleRest;
    
}

- (ItemTitle *) branchTitle
{
    if (!_branchTitle) {
        _branchTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 222, SCREEN_WIDTH, 60) ];
        [_branchTitle awakeFromNib];
    }
    return _branchTitle;
    
}

- (ItemTitle *) titleCash
{
    if (!_titleCash) {
        _titleCash = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 283, SCREEN_WIDTH, 60) ];
        [_titleCash awakeFromNib];
    }
    return _titleCash;
    
}

- (ItemTitle *) titleCashShop
{
    if (!_titleCashShop) {
        _titleCashShop = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 222, SCREEN_WIDTH, 60) ];
        [_titleCashShop awakeFromNib];
    }
    return _titleCashShop;
    
}

- (ActionDetailTable *) cashShopGrid
{
    if (!_cashShopGrid) {
        _cashShopGrid = [[ActionDetailTable alloc] initWithFrame:CGRectMake(0, 165, SCREEN_WIDTH, 175)];
        [_cashShopGrid awakeFromNib];
        [_cashShopGrid initDelegate:self event:CASH_SHOP_DETAIL_EVENT addName:NSLocalizedString(@"添选权限", nil) itemMode:ITEM_MODE_DEL];
    }
    return _cashShopGrid;
}


- (ActionDetailTable *) restGrid
{
    if (!_restGrid) {
        _restGrid = [[ActionDetailTable alloc] initWithFrame:CGRectMake(0, 107, SCREEN_WIDTH, 175)];
        [_restGrid awakeFromNib];
        [_restGrid initDelegate:self event:REST_DETAIL_EVENT addName:NSLocalizedString(@"添选权限", nil) itemMode:ITEM_MODE_DEL];
    }
    return _restGrid;
}

- (ActionDetailTable *) branchTab
{
    if (!_branchTab) {
        _branchTab = [[ActionDetailTable alloc] initWithFrame:CGRectMake(0, 283, SCREEN_WIDTH, 86)];
        [_branchTab awakeFromNib];
        [_branchTab initDelegate:self event:BRANCH_DETAIL_EVENT addName:NSLocalizedString(@"添选权限", nil) itemMode:ITEM_MODE_DEL];
    }
    return _branchTab;
}

- (ActionDetailTable *) cashGrid
{
    if (!_cashGrid) {
        _cashGrid = [[ActionDetailTable alloc] initWithFrame:CGRectMake(0, 345, SCREEN_WIDTH, 175)];
        [_cashGrid awakeFromNib];
        [_cashGrid initDelegate:self event:CASH_DETAIL_EVENT addName:NSLocalizedString(@"添选权限", nil) itemMode:ITEM_MODE_DEL];
    }
    return _cashGrid;
}


- (UIView *) chainView
{
    if (!_chainView) {
        _chainView = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    }
    return _chainView;
}

- (UIView *) branchView
{
    if (!_branchView) {
        _branchView = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    }
    return _branchView;
}

- (UIView *) cashShopView
{
    if (!_cashShopView) {
        _cashShopView = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    }
    return _cashShopView;
}

- (UIButton *) btnDel
{
    if (!_btnDel) {
        _btnDel = [[UIButton alloc] init];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDel.layer.masksToBounds = YES;
        _btnDel.layer.cornerRadius = 5;
        [_btnDel setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
        _btnDel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 40);
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
    self.roleEditCallBack (YES);
}

- (void) rightNavigationButtonAction:(id)sender
{
    self.isContinue = NO;
    [self save];
}

- (void) closeMultiView:(NSInteger)event
{
    
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
}

- (void)fillModel
{
    [self.txtName initData:self.role.name];
}

- (void)processTreeNode:(NSMutableArray *)nodes grid:(ActionDetailTable *)grid
{
    NSMutableArray *headList = [NSMutableArray array];
    NSMutableDictionary *detailMap = [NSMutableDictionary dictionary];
    NSMutableArray *childNodes = [NSMutableArray array];
    Action* act=nil;
    Action* seAct=nil;
    int count=0;
    NSMutableArray* arr=nil;
    for (TreeNode* node in nodes) {
        act=(Action*)node.orign;
        [headList addObject:node];
        childNodes = node.children;
        if (childNodes==nil || childNodes.count==0) {
            continue;
        }
        for (TreeNode* secondNode in childNodes) {
            seAct = (Action*)secondNode.orign;
            arr = [detailMap objectForKey:act.id];
            if (!arr) {
                arr=[NSMutableArray array];
            } else {
                [detailMap removeObjectForKey:act.id];
            }
            [arr addObject:seAct];
            count++;
            if (act.id != nil) {
                 [detailMap setObject:arr forKey:act.id];
            }else if (act._id != nil){
                act.id = act._id;
                [detailMap setObject:arr forKey:act._id];
            }
        }
    }
    [grid loadData:headList details:detailMap detailCount:count];
}

#pragma save-data
- (BOOL)valid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"职级名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

- (Role *)transMode
{
    Role *obj = [Role new];
    obj.name = [self.txtName getStrVal];
    return obj;
}


- (void)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.role.name]];
}

- (NSMutableArray *)getActIds
{
    NSMutableArray *idList = [NSMutableArray array];
    NSMutableArray *restIdList = [self getChkActionList:self.restNodes];
    NSMutableArray *cashIdList = [self getChkActionList:self.cashNodes];

    [idList addObjectsFromArray:restIdList];
    [idList addObjectsFromArray:cashIdList];
    return idList;
}

- (NSMutableArray *)getChkActionList:(NSMutableArray*)treeNods
{
    NSMutableArray* idList=[NSMutableArray array];
    Action* act=nil;
    BOOL isExist=NO;
    if (treeNods!=nil && treeNods.count>0) {
        for (TreeNode* node in treeNods) {
            if (node.children==nil || node.children.count==0) {
                continue;
            }
            isExist=NO;
            for (TreeNode* child in node.children) {
                act=(Action*)child.orign;
                if ([act isSelected]) {
                    [idList addObject:act.id];
                    isExist=YES;
                }
            }
            if (!isExist || [node.itemId isEqualToString:@"0"] || [node.itemId isEqualToString:@"1"] || [node.itemId isEqualToString:@"2"] || [node.itemId isEqualToString:@"-100"]) {
                continue;
            }
            [idList addObject:node.itemId];
        }
    }
    return idList;
}

#pragma ISampleListEvent
- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.isContinue=YES;
        self.continueEvent=event;
        [self save];
        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        if ([self hasChanged]) {
            self.isContinue=YES;
            self.continueEvent=event;
            [self save];
        } else {
            [self continueAdd:event];
        }
    }
}

- (void)showSortEvent:(NSString*)event
{
}

//添加此分组内的商品.
- (void)showAddEvent:(NSString*)event obj:(id<INameValueItem>) obj
{
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray *) items
{
    if (event==SELECT_REST_ACTION) {
        [self reSetCheck:self.restNodes items:items];
        [self processTreeNode:self.restNodes grid:self.restGrid];
    } else if (event==SELECT_CASH_ACTION){
        [self reSetCheck:self.cashNodes items:items];
        [self processTreeNode:self.cashNodes grid:self.cashGrid];
    }
    self.isContinue=NO;
    [self saveRelation];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)reSetCheck:(NSMutableArray*)nodes items:(NSMutableArray*)items
{
    NSMutableArray* childNodes=[NSMutableArray array];
    Action* act=nil;
    BOOL isExist=NO;
    for (TreeNode* node in nodes) {
        act=(Action*)node.orign;
        isExist=[items containsObject:act.id];
        [act setIsSelected:isExist];
        childNodes=node.children;
        if (childNodes==nil || childNodes.count==0) {
            continue;
        }
        for (TreeNode* secondNode in childNodes) {
            act=(Action*)secondNode.orign;
            isExist=[items containsObject:act.id];
            [act setIsSelected:isExist];
        }
    }
}

#pragma role-grid
- (void)showHelpEvent
{
    [HelpDialog show:@"emprole"];
}

- (BOOL)hasChanged
{
    return self.txtName.isChange;
}

@end
