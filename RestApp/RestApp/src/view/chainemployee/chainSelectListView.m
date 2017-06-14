//
//  chainSelectListView.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "JsonHelper.h"
#import "EmployeeService.h"
#import "EmployeeModuleEvent.h"
#import "chainEmployeeData.h"
#import "ShopVO.h"
#import "NSString+Estimate.h"
#import "chainSelectListView.h"
#import "DHHeadItem.h"
#import "NameItemVO.h"
#import "BranchTreeVo.h"
#import "NSMutableArray+DeepCopy.h"
#import "TDFRootViewController+FooterButton.h"

@implementation chainSelectListView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    [self initView];
    [self initNotification];
    self.headerItems = [[NSMutableArray alloc] init];
    [self loadMenus:self.oldArrs userId:self.userId delegate:self.delegate targert:self.Istarget issuper:self.currentAction headList:self.headList employeeId:self.employeeId detailMap:self.detailMap entityId:self.entityId];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck|TDFFooterButtonTypeNotAllCheck];
}

- (void)initView
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
    [cancleBtn addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:cancleBtn];
    [self.view addSubview:self.panel];
    
    self.dhListPanel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.dhListPanel.backgroundColor = [UIColor clearColor];
    self.dhListPanel.delegate = self;
    self.dhListPanel.dataSource = self;
    //表格初始.
    [self.dhListPanel setBackgroundView:nil];
    self.dhListPanel.opaque = NO;
    self.dhListPanel.tableFooterView = [ViewFactory generateFooter:76];
    //如果想删除cell之间的分割线，设置
    self.dhListPanel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.dhListPanel];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_Data_Multi_Select object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_Kind_Multi_Select object:nil];
}

-(void) loadMenus:(NSMutableArray*)oldArrs userId:(NSString *)userIdstr delegate:(id<SelectMenuClient>) delegate targert:(NSInteger)targert issuper:(NSInteger)issuper headList:(NSMutableArray *)headList employeeId:(NSString *)employeeId detailMap:(NSMutableDictionary *)detailMap entityId:(NSString *)entityId
{
    self.oldArrs = [oldArrs mutableCopy];
    self.backHeadList = [headList deepCopy];
    self.backDetailMap = [detailMap mutableCopy];
    self.headTitle =nil;
    self.txtKey.placeholder=nil;
    if (targert ==EMPLOYEE_COMMON_RATIO) {
        self.title  =NSLocalizedString(@"选择门店", nil);
    
        self.txtKey.placeholder =NSLocalizedString(@"输入店名", nil);
    }
    else if (targert ==EMPLOYEE_FORCE_RATIO)
    {
        self.title =NSLocalizedString(@"选择品牌", nil);
        self.txtKey.placeholder =NSLocalizedString(@"输入品牌名", nil);
    }
    else if (targert == EMPLOYEE_BRANCHCOMPANY)
    {
        self.title =NSLocalizedString(@"选择分公司", nil);
        self.txtKey.placeholder =NSLocalizedString(@"输入名称", nil);
    }
    [self initOld:oldArrs];
   
    self.headList = [headList deepCopy];
    self.detailMap = [detailMap mutableCopy];
    self.delegate=delegate;
    self.isSearchMode = NO;
    [self hideDHSearchBar];
    [self.dhListPanel reloadData];
}

-(void) initOld:(NSMutableArray*)oldMenus
{
    self.detailList =[[NSMutableArray alloc]initWithArray:oldMenus];
    [self.dhListPanel reloadData];
}

-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    [self checkVal:NO];
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    [self checkVal:YES];
}

-(void) dataChange:(NSNotification*) notification
{
    
}

-(void) checkVal:(BOOL)val
{
    
    if (self.Istarget ==EMPLOYEE_FORCE_RATIO) {
        if (val) {
            for (chainEmployeeData *data in self.detailList) {
                data.isSelected =0;
            }
            
        }
        else
        {
            for (chainEmployeeData *data in self.detailList) {
                data.isSelected =1;
            }
        }
    }
    else if (self.Istarget ==EMPLOYEE_COMMON_RATIO )
    {
        if (val) {
            for (id<INameItem> item in self.headList) {
                if (item != nil) {
                    NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                    if (details != nil) {
                        for ( ShopVO *data in details) {
                          data.isSelected =0;
                        }
                    }
                }
            }
        }
        else
        {
            for (id<INameItem> item in self.headList) {
                if (item != nil) {
                    NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
                    if (details != nil) {
                        for ( ShopVO *data in details) {
                             data.isSelected =1;
                        }
                    }
                }
            }
        }
    } else if (self.Istarget ==EMPLOYEE_BRANCHCOMPANY){
        if (val) {
            
            for (BranchTreeVo *data in self.detailList) {
                data.isSelected =0;
            }
            
        }
        else
        {
            for (BranchTreeVo *data in self.detailList) {
                data.isSelected =1;
            }
        }
    }
    
    [self.dhListPanel reloadData];
}

-(void) kindChange:(NSNotification*) notification
{
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectMultiMenuItem *detailItem = (SelectMultiMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem" owner:self options:nil].lastObject;
    }
    detailItem.selectionStyle =UITableViewCellSelectionStyleNone;
    if (self.Istarget ==EMPLOYEE_COMMON_RATIO )
    {
        id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            if (details != nil) {
                ShopVO *data = details[indexPath.row];
                detailItem.lblName.text =[NSString stringWithFormat:@"%@",data.name];
                [detailItem IsHide:data.isSelected];
            }
        }
        return  detailItem;
    }
    if ([ObjectUtil isNotNull:self.detailList]) {
        if (self.Istarget ==EMPLOYEE_FORCE_RATIO) {
            chainEmployeeData *data =self.detailList[indexPath.row];
            [detailItem loadChainItem:data];
        }
        else if (self.Istarget == EMPLOYEE_BRANCHCOMPANY)
        {
            BranchTreeVo *data = self.detailList[indexPath.row];
            detailItem.lblName.text = [self getName:data.level-1 name:data.branchName];
            [detailItem IsHide:data.isSelected];
        }
        return  detailItem;
    }
    return  nil;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.Istarget == EMPLOYEE_COMMON_RATIO) {
        id<INameItem> item = [self.headList objectAtIndex:section];
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            if (details != nil) {
                return details.count;
            }
        }
    }
    return self.detailList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.Istarget == EMPLOYEE_COMMON_RATIO) {
        return self.headList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.Istarget ==EMPLOYEE_FORCE_RATIO) {
        chainEmployeeData *data =self.detailList[indexPath.row];
        data.isSelected =!data.isSelected;
    }
    else if (self.Istarget ==EMPLOYEE_COMMON_RATIO )
    {
        id<INameItem> item = [self.headList objectAtIndex:indexPath.section];
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            if (details != nil) {
                ShopVO *data =details[indexPath.row];
                data.isSelected =!data.isSelected;
                data.expire =nil;
            }
        }
    }
    else if (self.Istarget ==EMPLOYEE_BRANCHCOMPANY )
    {
        BranchTreeVo *data =self.detailList[indexPath.row];
        data.isSelected =!data.isSelected;
    }
    [self.dhListPanel reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<INameItem> item = [self.headList objectAtIndex:section];
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [self.headerItems addObject:headItem];
    [headItem.panel.layer setMasksToBounds:YES];
    headItem.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    headItem.lblName.text = [item obtainItemName];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.Istarget == EMPLOYEE_COMMON_RATIO) {
        return 38;
    }else{
        return 0;
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
    self.dhListPanel.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.dhListPanel.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.dhListPanel.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,-40,SCREEN_WIDTH,40);
    self.dhListPanel.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
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
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.Istarget ==EMPLOYEE_FORCE_RATIO) {
        for (chainEmployeeData *data in self.detailList) {
            nameCheck = [data.name rangeOfString:keyword].location!=NSNotFound;
            if (nameCheck) {
                [arr addObject:data];
            }
        }
        [self.detailList removeAllObjects];
        self.detailList = [NSMutableArray arrayWithArray:arr];
    }
    else if (self.Istarget ==EMPLOYEE_COMMON_RATIO)
    {
        [self queryShopWithKeyword:keyword];
    }  else if (self.Istarget ==EMPLOYEE_BRANCHCOMPANY)
    {
        for (BranchTreeVo *data in self.self.detailList) {
            nameCheck = [data.branchName rangeOfString:keyword].location!=NSNotFound;
            if (nameCheck) {
                [arr addObject:data];
            }
        }
        [self.detailList removeAllObjects];
        self.detailList = [NSMutableArray arrayWithArray:arr];
    }

    [self.dhListPanel reloadData];
    
}

- (void)queryShopWithKeyword:(NSString *)keyword
{
    self.headList=[NSMutableArray array];
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray *details=nil;
    NSMutableArray* arr=nil;
    
    for (id<INameItem> head in self.backHeadList) {
        details= [self.backDetailMap objectForKey:[head obtainItemId]];
        BOOL isExist=NO;
        BOOL nameCheck=NO;
        BOOL codeCheck=NO;
        if ([ObjectUtil isNotEmpty:details]) {
            for (id<IMultiNameValueItem> item in details) {
                nameCheck=[[item obtainItemName] rangeOfString:keyword].location!=NSNotFound;
                codeCheck=[[item obtainItemValue] rangeOfString:keyword].location!=NSNotFound;
                if (nameCheck || codeCheck) {
                    arr=[self.detailMap objectForKey:[head obtainItemId]];
                    if (!arr) {
                        arr=[NSMutableArray array];
                    } else {
                        [self.detailMap removeObjectForKey:[head obtainItemId]];
                    }
                    [arr addObject:item];
                    [self.detailMap setObject:arr forKey:[head obtainItemId]];
                    isExist=YES;
                }
            }
        }
        if (isExist) {
            [self.headList addObject:head];
        }
    }
    [self.headerItems removeAllObjects];
    [self.dhListPanel reloadData];
}


- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.txtKey becomeFirstResponder];
        [self showDHSearchBar];
    }
}
- (IBAction)cancelSelect:(id)sender
{
    [self cancelSelect];
    self.txtKey.text = @"";
    self.headList = self.backHeadList;
    self.detailMap = self.backDetailMap;
    
    self.detailList =[[NSMutableArray alloc]initWithArray:self.oldArrs];
    [self.dhListPanel reloadData];
    
}

- (void)cancelSelect
{
    if (self.isSearchMode) {
        self.txtKey.text = @"";
        [self hideDHSearchBar];
        [SystemUtil hideKeyboard];
    }
}

-(void)save
{
    if (self.Istarget ==EMPLOYEE_COMMON_RATIO) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *str;

        for (id<INameItem> item in self.headList) {
            if (item != nil) {
              NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
              if (details != nil) {
                  for ( ShopVO *data in details) {
                      if (data.isSelected) {
                          data.expire =nil;
                          [arr addObject:data._id];
                      }
                  }
              }
            }
        }

        if ([ObjectUtil isEmpty:arr]) {
            str =@"[]";
        }
        else
        {
        str =[JsonHelper arrTransJson:arr];
        }
        
        [self showProgressHudWithText:NSLocalizedString(@"正在保存门店", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        [parma setObject:self.userId forKey:@"user_id"];
        [parma setObject:str forKey:@"shop_id_list_str"];
        [parma setObject:self.entityId forKey:@"entity_id"];
        
        @weakify(self);
        [[TDFChainService new] saveEmployeeShopWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.employeeEditCallBack(YES);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
    else if (self.Istarget ==EMPLOYEE_FORCE_RATIO )
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *str;
        for ( chainEmployeeData *data in self.detailList) {
            if (data.isSelected) {
                
                [arr addObject:data.id];
            }
        }
        if ([ObjectUtil isEmpty:arr]) {
            str =@"[]";
        }
        else
        {
            str =[JsonHelper arrTransJson:arr];
        }
        
        [self showProgressHudWithText:NSLocalizedString(@"正在保存品牌", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        [parma setObject:self.userId forKey:@"user_id"];
        [parma setObject:str forKey:@"plate_id_list_str"];
        [parma setObject:self.entityId forKey:@"entity_id"];
        
        @weakify(self);
        [[TDFChainService new] saveEmployeePlateWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.employeeEditCallBack(YES);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
               @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
        
    } else if (self.Istarget ==EMPLOYEE_BRANCHCOMPANY )
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *str;
        for ( BranchTreeVo *data in self.detailList) {
            if (data.isSelected) {
                
                [arr addObject:data.branchId];
            }
        }
        if ([ObjectUtil isEmpty:arr]) {
            str =@"[]";
        }
        else
        {
            str =[JsonHelper arrTransJson:arr];
        }

        [self showProgressHudWithText:NSLocalizedString(@"正在保存分公司", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        [parma setObject:self.userId forKey:@"user_id"];
        [parma setObject:str forKey:@"branch_id_list_str"];
        [parma setObject:self.entityId forKey:@"entity_id"];
        
        @weakify(self);
        [[TDFChainService new] saveGlobalManageBranchListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.employeeEditCallBack(YES);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    self.employeeEditCallBack(YES);
}
@end
