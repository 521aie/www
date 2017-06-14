//
//  BrandManagerView.m
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BrandManagerView.h"
#import "NavigateTitle2.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "KeyBoardUtil.h"
#import "NSString+Estimate.h"
#import "NameValueCell.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "TDFRootViewController+FooterButton.h"

@implementation BrandManagerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initGrid];
    self.title = NSLocalizedString(@"品牌", nil);
    self.brandTab.backgroundColor = [UIColor clearColor];
    self.plateList = [[NSMutableArray alloc] init];
    self.plateListArr = [[NSMutableArray alloc] init];
    [self loadData];
    self.isSearchMode = NO;
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
    [cancleBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:cancleBtn];
    [self.view addSubview:self.panel];
    
    self.brandTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.brandTab.backgroundColor = [UIColor clearColor];
    self.brandTab.delegate = self;
    self.brandTab.dataSource = self;
    [self.view addSubview:self.brandTab];
}

#pragma mark table deal
-(void)initGrid
{
    self.brandTab.opaque=NO;
    self.brandTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView* view=[ViewFactory generateFooter:76];
    view.backgroundColor=[UIColor clearColor];
    [self.brandTab setTableFooterView:view];
}

- (void)loadData
{
    [bgView removeFromSuperview];
    self.view.userInteractionEnabled  = NO;
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
      [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd| TDFFooterButtonTypeHelp];
    }else{
         [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    }
    
    //请求品牌
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    [param setObject:[[Platform Instance] getkey:USER_ID] forKey:@"user_id"];
    
    [self.plateList removeAllObjects];
    [self.plateListArr removeAllObjects];
    
    @weakify(self);
    [[TDFChainService new] queryPlateListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        if ([ObjectUtil isNotEmpty:[data objectForKey:@"data"]]) {
            self.plateList = [Plate convertToPlateListByArr:[data objectForKey:@"data"]];
            [self.plateListArr addObjectsFromArray:self.plateList];
        }else{
            [self initPlaceholderView];
        }
        [self.brandTab reloadData];
        self.view.userInteractionEnabled  = YES;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         @strongify(self);
        self.view.userInteractionEnabled  = YES;
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)initPlaceholderView
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self. brandTab.frame.size.height-60)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.brandTab addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120/2, 50, 120, 120)];
    imageView.image=[UIImage imageNamed:@"img_nobill"];
    [bgView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 120)];
    label.text=NSLocalizedString(@"连锁总部还未添加过品牌", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [bgView addSubview:label];
}

- (void)initWithKeyword:(NSString *)keyword
{
    BOOL nameCheck=NO;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:self.plateListArr]) {
        for (Plate *plate in self.plateListArr) {
           nameCheck = [plate.name rangeOfString:keyword].location!=NSNotFound;
            if (nameCheck) {
                [arr addObject:plate];
            }
        }
        [self.plateList removeAllObjects];
        self.plateList = [NSMutableArray arrayWithArray:arr];
 }
    [self.brandTab reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SystemUtil hideKeyboard];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        [self initWithKeyword:keyword];
        [self startSearchMode];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.plateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    if (self.plateList.count > indexPath.row) {
        Plate *plate = self.plateList[indexPath.row];
        
        cell.lblName.text = plate.name;
        cell.lblVal.textColor = [[UIColor alloc]initWithWhite:0 alpha:0.3];
        cell.lblVal.text = [NSString stringWithFormat:NSLocalizedString(@"%ld家门店", nil),(long)plate.shopCount];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Plate *plate = self.plateList[indexPath.row];
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_editBrandViewControllerWithPlate:plate editBrandCallBack:^(BOOL orFresh) {
        @strongify(self);
        [self loadData];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
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

- (void)startSearchMode
{
    if (self.isSearchMode == NO) {
        [self.txtKey becomeFirstResponder];
        [self showDHSearchBar];
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

- (void)showDHSearchBar
{
    self.isSearchMode = YES;
    self.panel.frame = CGRectMake(0,-40,SCREEN_WIDTH,40);
    self.brandTab.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.brandTab.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)hideDHSearchBar
{
    self.isSearchMode = NO;
    self.panel.frame = CGRectMake(0,0,SCREEN_WIDTH,40);
    self.brandTab.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-104);
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.3];
    self.panel.frame = CGRectMake(0,-40,SCREEN_WIDTH,40);
    self.brandTab.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)cancelSearch {
    [self cancelSearchMode];
    [self loadData];
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_addBrandViewControllerWithAddBrandCallBack:^(BOOL orFresh) {
        @strongify(self);
        [self loadData];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)footerHelpButtonAction:(UIButton *)sender
{
   [HelpDialog show:@"chainhdplate"];
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.listBrandCallBack) {
        self.listBrandCallBack(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
