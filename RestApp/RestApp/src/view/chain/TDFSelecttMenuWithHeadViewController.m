//
//  TDFSelecttMenuWithHeadViewController.m
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFSelecttMenuWithHeadViewController.h"
#import "TDFRootViewController+SearchBar.h"
#import "SystemUtil.h"
#import "MultiCheckCell.h"
#import "XHAnimalUtil.h"
#import "INameValueItem.h"
#import "ActionHeadCell.h"
#import "PlateMenuVoList.h"
#import "Platform.h"
#define CHAINSHOPMODEL   1  //直营
#define DELETEIKINDMENUID  @"-1" //用来判断父类是否是已近删除的

@interface TDFSelecttMenuWithHeadViewController ()

/***传进来后生成的初始化数组*/
@property (nonatomic, strong) NSMutableArray *originIdArr;

@end

@implementation TDFSelecttMenuWithHeadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView];
    [self initGrid];
  [self configRightNavigationBar:@"ico_ok.png" rightButtonName:NSLocalizedString(@"保存", nil)];
    
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    if ([ObjectUtil isEmpty:self.nodeList]) {
        [self initPlaceHolderView];
    }else{
        [self.bgView removeFromSuperview];
    }
    [self processDataList];
    [self initDelegate:self.event delegate:self.delegate title:self.title];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck |TDFFooterButtonTypeNotAllCheck];
  
}

#pragma  interface event
- (void)initDelegate:(NSInteger)eventTemp delegate:(id<MultiCheckHandle>)delegateTemp title:(NSString *) titleName
{
    self.delegate=delegateTemp;
    self.event=eventTemp;
    self.title= titleName;
    self.backDic  = [self.detailMap  mutableCopy];
    if (self.isHideSearch) {
         [ self addSearchBarToView:TDFSearchBarTypeWithNone withPlaceHolder: NSLocalizedString(@"请输入名字", nil)];
    }
    [self.tableView reloadData];
}

- (void) initGrid
{
    self.tableView.opaque=NO;
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [ViewFactory generateFooter:120];
}

-(UITableView *) tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)initMainView
{
    if (self.event == ADD_PRICE_FORMATINT) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [self.view addSubview:bgView];
    }
    [self.view addSubview:self.tableView];
    selectKindMenuPanel = [[NewSelectKindMenuPanel alloc]initWithNibName:@"SelectKindMenuPanel" bundle:nil];
    [self.navigationController.view addSubview:selectKindMenuPanel.view];
    selectKindMenuPanel.btnSelect.hidden = YES;
    self.managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.managerButton.center = CGPointMake(self.view.frame.size.width -20, (self.view.frame.size.height -64-70)/2.0);
    self.managerButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.managerButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.managerButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.managerButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.managerButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    if (self.event == ADD_PRICE_FORMATINT || self.event == TDFSelecttMenuEventBranchShop || self.event == TDFSelecttMenuEventShop) {
          [self.managerButton setTitle:NSLocalizedString(@"分公司", nil) forState:UIControlStateNormal];
    }else{
        [self.managerButton setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
    }
    [self.managerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.managerButton addTarget:self action:@selector(selectPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerButton];
    CGRect selectKindPanelFrame = selectKindMenuPanel.view.frame;
    selectKindPanelFrame.origin.x = SCREEN_WIDTH;
    selectKindMenuPanel.view.frame = selectKindPanelFrame;
}

- (void) creatBgBtn
{
    self.btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBg.frame = CGRectMake(0,0,
                                  SCREEN_WIDTH - selectKindMenuPanel.view.frame.size.width, SCREEN_HEIGHT);
    [self.btnBg addTarget:self action:@selector(btnBgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBg];
}

- (void)selectPanel:(UIButton *)button
{
    self.isOpen = !self.isOpen;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    
    if (isOpen == YES) {
        [self showSelectKindView];
        [self creatBgBtn];
        [self animationMoveIn:self.managerButton backround:self.btnBg];
    }else
    {
        [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
        [self animationMoveOut:self.managerButton backround:self.btnBg];
        [self.btnBg removeFromSuperview];
    }
}

- (void)showSelectKindView
{
    [selectKindMenuPanel initDelegate:self event:self.event];
    [selectKindMenuPanel loadData:self.nodeList];
    [XHAnimalUtil animationMoveIn:selectKindMenuPanel.view backround:self.btnBg];
}

- (IBAction)btnBgClick:(id)sender
{
    self.isOpen = NO;
}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - selectKindMenuPanel.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.5;
    [UIView commitAnimations];
    
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

- (void)initPlaceHolderView
{
    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0,160, SCREEN_WIDTH-80, 160)];
    self.bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 240, 120)];
    label.text= self.content;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [self.bgView addSubview:label];
}

- (void) rightNavigationButtonAction:(id)sender
{
     [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
    [self.delegate multiCheck:self.event items:self.selectIdSet];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate closeMultiView:1];
}

- (void)processDataList
{
    self.selectIdSet = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:self.nodeList]) {
        for (id<INameValueItem> node in self.nodeList) {
            NSMutableArray *temps = [self.detailMap valueForKey:[node obtainItemId]];
            if ([ObjectUtil isNotEmpty:temps]) {
                NSInteger i =0;
                for (id<INameValueItem> item in temps) {
                    if ([item obtainIsSelect]) {
                        [self.selectIdSet addObject:[item obtainItemId]];
                        i++;
                    }
                }
                if (i==temps.count) {
                    [node setIsSelect:YES];
                }
            }
        }
    }
    
    self.originIdArr = [NSMutableArray arrayWithArray:self.selectIdSet];
}

#pragma mark check-button
-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    for (id<INameValueItem> node in self.nodeList) {
         [node setIsSelect:YES];
        NSMutableArray *temps = [self.detailMap valueForKey:[node obtainItemId]];
    
        if ([ObjectUtil isNotEmpty:temps]) {
            for (id<INameValueItem> sn in temps) {
                if (![self.selectIdSet containsObject:[sn  obtainItemId]]) { //避免重复添加数据
                     [self.selectIdSet addObject:[sn obtainItemId]];
                }
            }
        }
    }
    [self.tableView reloadData];
    
    [self judgeIsChange];
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    for (id<INameValueItem> node in self.nodeList) {
        if ([DELETEIKINDMENUID  isEqualToString:[node obtainItemId]]) {
            continue;
        }
        NSMutableArray *temps = [self.detailMap valueForKey:[node obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            for (id<INameValueItem> sn in temps) {
                [self.selectIdSet removeObject:[sn obtainItemId]];
            }
        }
    }
    for (id<INameValueItem> head in self.nodeList) {
        if ([DELETEIKINDMENUID  isEqualToString:[head obtainItemId]]) {
            continue;
        }
        [head setIsSelect:NO];
    }
    [self.tableView reloadData];
    
    [self judgeIsChange];
}

- (void)checkHead:(BOOL)result head:(TreeNode *)head
{
    
    if (head.select) {
        head.select=NO;
        NSMutableArray *temps = [self.detailMap valueForKey:head.itemId];
        if ([ObjectUtil isNotEmpty:temps]) {
            for (id<INameValueItem> sn in temps) {
                [sn setIsSelect:NO];
                [self.selectIdSet removeObject:[sn obtainItemId]];   
            }
            for (id<INameValueItem> item in self.nodeList) {
                if ([[item obtainItemId] isEqualToString:head.itemId]) {
                    [item setIsSelect:NO];
                }
            }
        }
    }
    else
    {
        head.select=YES;
        NSMutableArray *temps = [self.detailMap valueForKey:head.itemId];
        if ([ObjectUtil isNotEmpty:temps]) {
            for (id<INameValueItem> sn in temps) {
                 [sn setIsSelect:YES];
                if ([self.selectIdSet containsObject:[sn obtainItemId]]) {
                    [self.selectIdSet removeObject:[sn obtainItemId]];
                }
                [self.selectIdSet addObject:[sn obtainItemId]];
            }
            for (id<INameValueItem> item in self.nodeList) {
                if ([[item obtainItemId] isEqualToString:head.itemId]) {
                    [item setIsSelect:YES];
                }
            }
        }
    }
    [self.tableView reloadData];
    
    [self judgeIsChange];
}


#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectMultiMenuItem *detailItem = (SelectMultiMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem" owner:self options:nil].lastObject;
    }
    detailItem.selectionStyle =UITableViewCellSelectionStyleNone;
    
    id<INameValueItem> head = [self.nodeList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap valueForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item=[temps objectAtIndex:indexPath.row];
            detailItem.lblName.text= [item obtainItemName];
            if (self.event == ADD_PRICE_FORMATINT) {
                detailItem.line.hidden = NO;
                detailItem.bgView.backgroundColor = [UIColor clearColor];
                if ([NSString isNotBlank:[item obtainItemValue]]) {
                    detailItem.lblVal.textColor = [UIColor redColor];
                    detailItem.lblVal.text = [item obtainItemValue];
                }else{
                    detailItem.lblVal.textColor = [UIColor blackColor];
                    detailItem.lblVal.text = NSLocalizedString(@"基础价格", nil);
                }
            }
            else if (self.event == SELECT_BRANCHSHOP){
                NSString *joinModel  = [item obtainItemValue];
//                detailItem.lblName.font = [UIFont systemFontOfSize:15];
//                detailItem.lblName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                [self changeWithJoinModel:joinModel.integerValue detailLbl:detailItem.lblVal] ;
            }
            else
            {
                if (self.isChangeTitle) {
                    NSString *joinModel  = [item obtainItemValue];
                    [self changeWithJoinModel:joinModel.integerValue detailLbl:detailItem.lblVal] ;
                }
            }
            [detailItem IsHide:[self.selectIdSet containsObject:[item obtainItemId]]];
            detailItem.backgroundColor=[UIColor clearColor];
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     id<INameValueItem> head = [self.nodeList objectAtIndex:indexPath.section];
    if ([DELETEIKINDMENUID  isEqualToString:[head obtainItemId]]) { //用来判断是不是删除的商品
        [AlertBox  show:NSLocalizedString(@"连锁删除商品为必选，无法取消。", nil)];
        return ;
    }
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap valueForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:temps]) {
            id<INameValueItem> item=(TreeNode *)[temps objectAtIndex:indexPath.row];
            if (item) {
                if ([self.selectIdSet containsObject:[item obtainItemId]]) {
                    [self.selectIdSet removeObject:[item obtainItemId]];
                    [head setIsSelect:NO];
                } else {
                    [self.selectIdSet addObject:[item obtainItemId]];
                }
            }
            NSInteger j=0;
            for (NSInteger i=0; i<temps.count; i++) {
                id<INameValueItem> node=[temps objectAtIndex:i];
                if (node) {
                    if ([self.selectIdSet containsObject:[node obtainItemId]]) {
                        j++;
                    }
                }
            }
            if (j == temps.count) {
                [head setIsSelect:YES];
            }
            [self.tableView reloadData];
        }
    }
    
    [self judgeIsChange];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     id<INameValueItem> head = [self.nodeList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap valueForKey:[head obtainItemId]];
        return ([ObjectUtil isNotEmpty:temps]?temps.count:0);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<INameValueItem> head= [self.nodeList objectAtIndex:section];
    TreeNode *node = [[TreeNode alloc] init];
    node.itemId = [head obtainItemId];
    node.itemName = [head obtainItemName];
    node.select = [head obtainIsSelect];
    ActionHeadCell *headItem = (ActionHeadCell *)[tableView dequeueReusableCellWithIdentifier:ActionHeadCellIdentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"ActionHeadCell" owner:self options:nil].lastObject;
    }
    if ([DELETEIKINDMENUID  isEqualToString:[head obtainItemId]]) { //用来判断是不是删除的商品
        [headItem setIsResponseClick:NO AlterTitle:NSLocalizedString(@"连锁删除商品为必选，无法取消。", nil)];
    }
    else
    {
        [headItem setIsResponseClick:YES AlterTitle:@" "];
    }
    headItem.allLabel.hidden = YES;
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem loadData:node delegate:self];
    [headItem ishide:[head obtainIsSelect]];
    if (self.event == CHAIN_BAND_RELATE_MENU) {
        headItem.panel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    else if (self.event == SELECT_BRANCHSHOP){
        headItem.panel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        headItem.lblName.textColor = [UIColor whiteColor];
    }
    else{
        if (self.event == PULIMENUDefine) {
            headItem.lblName.textColor = [UIColor whiteColor];
        }else{
            headItem.lblName.textColor = [UIColor blackColor];
        }
        headItem.line.hidden = NO;
        headItem.panel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }

    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.nodeList]?self.nodeList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id<INameValueItem> head = [self.nodeList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap valueForKey:[head obtainItemId]];
        if (temps.count >0) {
            return 44;
        }
    }
    return 0;
}

#pragma sigleView
- (void)singleCheckWithEvent:(NSInteger)event item:(id<INameValueItem>) item
{
   id<INameValueItem> node = item;
    [self scrocll:node];
    self.isOpen = NO;
}

- (void)scrocll:(id)node
{
    if ([ObjectUtil isNotNull:self.nodeList] && [ObjectUtil isNotNull:node]) {
        NSInteger index = [GlobalRender getPos:self.nodeList itemId:[node obtainItemId]];
        CGFloat offset = index*44;
        for (NSUInteger i=0;i<index;++i) {
            id<INameValueItem>nodeTemp = [self.nodeList objectAtIndex:i];
            if([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap valueForKey:[nodeTemp obtainItemId]];
                if ([ObjectUtil isNotEmpty:menus]) {
                      for (id<INameValueItem>menu in menus) {
                            offset += 48;
                      }
                }
            }
        }
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

#pragma SearchBarDelegate
- (void)cancelSearchModel
{
//    [self hideSearchBar];
    self.detailMap = [self.backDic  mutableCopy];
    [self.tableView reloadData];
    [self hideSearhBarWithTableView:self.tableView];
}

- (void)searchWithKeyWord:(NSString *)keyWord
{
    BOOL isExist  =  NO;
    [self.detailMap removeAllObjects];
    for (id<INameValueItem> head in self.nodeList) {
      NSArray *menus = [self.backDic valueForKey:[head obtainItemId]];
        NSMutableArray * nodeSearch   = [[NSMutableArray  alloc]  init];
        for (id<INameValueItem> menu  in menus) {
            isExist =[[menu obtainItemName] rangeOfString:keyWord].location != NSNotFound;
            if (isExist  ) {
               [nodeSearch addObject:menu];
            }
        }
        [self.detailMap  setObject:nodeSearch forKey:[head obtainItemId]];
       }
    
      [self.tableView reloadData];
}

- (void)changeWithJoinModel:(NSInteger)jionModel detailLbl:(UILabel *)detailLbl
{
    detailLbl.textAlignment  = NSTextAlignmentRight;
    if (jionModel  == CHAINSHOPMODEL) {
        detailLbl.text   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"直营", nil)];
        detailLbl.textColor  = [UIColor grayColor];
    }
     else  {
        detailLbl.text   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"加盟", nil)];
        detailLbl.textColor  = [UIColor redColor];

    }
    
    if (self.event == SELECT_BRANCHSHOP) {
        
        detailLbl.font = [UIFont systemFontOfSize:11];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.event == ADD_PRICE_FORMATINT) {
        CGFloat sectionHeaderHeight = 44;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (NSMutableArray *)originIdArr {

    if (!_originIdArr) {
        
        _originIdArr = [NSMutableArray new];
    }
    
    return _originIdArr;
}
- (void)judgeIsChange {

    __block BOOL ischange = NO;
    
    if (self.originIdArr.count != self.selectIdSet.count) {
        
        ischange = YES;
    }
    
    [self.originIdArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![self.selectIdSet containsObject:obj]) {
            
            ischange = YES;
            
            *stop = YES;
        }
    }];
    
    
    
    //    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    //    if (self.event == SELECT_BRANCHSHOP) {
    //
    //        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    //    }
    //    [self configRightNavigationBar:@"ico_ok.png" rightButtonName:NSLocalizedString(@"保存", nil)];
    
    if (ischange) {
    
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:@"ico_ok.png" rightButtonName:NSLocalizedString(@"保存", nil)];
    }else {
        
        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

@end
