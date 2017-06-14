//
//  TDFOrderDetailListViewViewController.m
//  RestApp
//
//  Created by 栀子花 on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderDetailListViewViewController.h"
#import "ColorHelper.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import <YYModel/YYModel.h>
#import "TDFMediator+PaymentModule.h"
#import "OrderPayListCell.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "MJRefreshStateHeader.h"
#import "ChartItem.h"
#import "MJRefresh.h"
#import <libextobjc/EXTScope.h>
#import "TDFPaymentService.h"
#import "TDFPaymentTypeVo.h"
#import "NSString+Estimate.h"
#import "ObjectUtil.h"
#import "TDFMemberPayInfoController.h"

@interface TDFOrderDetailListViewViewController ()<UITableViewDelegate, UITableViewDataSource>
{
      BOOL isRefreshed;
}
@property (nonatomic, strong)  UITableView *mainGrid;
@property (nonatomic, strong) NSMutableArray *jsonArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong)  UIView *line;
@end

@implementation TDFOrderDetailListViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];

    [self initMainGrid];
    [self configHeaderView];
     self.jsonArr = [[NSMutableArray alloc]init];
     [self configureBackground];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)configureBackground
{
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:alphaView atIndex:1];
}

- (void)configHeaderView
{
    UILabel *lblTiShiLabel = [[UILabel alloc] init];
    lblTiShiLabel.textColor = [UIColor whiteColor];
    lblTiShiLabel.font = [UIFont systemFontOfSize:11];
    lblTiShiLabel.text = [NSString stringWithFormat:NSLocalizedString(@" 目前我们有两种转账方式,“已到账”代表二维火公司转账,“已到账”代表兴业银行转账,若是已划账,具体到账时间依据银行操作时间。",nil)];
    lblTiShiLabel.numberOfLines = 0;
    [self.view addSubview:lblTiShiLabel];
    [lblTiShiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
  
    UIButton *detailBtn =[[UIButton  alloc] init];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    detailBtn.backgroundColor =[[UIColor whiteColor]colorWithAlphaComponent:0.1];
    [detailBtn addTarget:self action:@selector(showDetailEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTiShiLabel.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.height.mas_equalTo(35);
    }];

    UILabel *normalLabel =[[UILabel alloc] init];
    normalLabel.textColor = [UIColor whiteColor];
    normalLabel.font = [UIFont systemFontOfSize:15];
    normalLabel.text= NSLocalizedString(@"当日账户明细", nil);
    [detailBtn addSubview:normalLabel];
    
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailBtn.mas_left).offset(10);
        make.top.equalTo(lblTiShiLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    
    UIImageView *picImg =[[UIImageView alloc] init];
    picImg.image =[UIImage imageNamed:@"ico_next_up_w.png"];
    [detailBtn addSubview:picImg];
    
    [picImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailBtn.mas_right).offset(-5);
        make.top.equalTo(lblTiShiLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    UILabel *linkLabel = [[UILabel alloc] init];
    linkLabel.textColor = [UIColor whiteColor];
    linkLabel.font = [UIFont systemFontOfSize:15];
    linkLabel.text= NSLocalizedString(@"收起", nil);
    [detailBtn addSubview:linkLabel];
    
    [linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-37);
        make.top.equalTo(lblTiShiLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(35);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(detailBtn.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    _label = [[UILabel alloc]init];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:15];
    self.label.text = NSLocalizedString(@"暂无数据", nil);
    [self.view addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH/2-30);
        make.top.equalTo(detailBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.mainGrid];
    [self.mainGrid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailBtn.mas_bottom);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
}

- (void)initMainGrid
{
        _mainGrid = [[UITableView alloc] init];
        _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
      _mainGrid.backgroundColor =[UIColor clearColor];
        _mainGrid.opaque=NO;
        self.mainGrid.separatorStyle=UITableViewCellSeparatorStyleNone;
        __weak typeof (self) weakSelf = self;
        self.mainGrid.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            isRefreshed = YES;
            weakSelf.page = 1;
            [weakSelf getWXPayBillListData:weakSelf.page];
        }];
        self.mainGrid.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            isRefreshed = NO;
            weakSelf.page = weakSelf.page + 1;
            [weakSelf getWXPayBillListData:weakSelf.page];
        }];
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.mj_footer;
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
}

- (void)showDetailEvent
{
      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark load data
- (void)loadData
{
    self.page = 1;
    isRefreshed = NO;
    if (self.isShow) {
            [self configRightNavigationBar:@"ico_bangWXcount.png" rightButtonName:NSLocalizedString(@"收款账户", nil)];
    }
    self.title = self.payment.detail;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [self getWXPayBillListData:self.page];
}

- (void)getWXPayBillListData:(NSInteger)page
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"page"] = [NSString stringWithFormat:@"%li", (long)page];
    param[@"page_size"] = @"20";
    param[@"pay_type"] = self.payment.typeCode;
    param[@"find_date"] = self.str;
    
    @weakify(self);
    [[TDFPaymentService new] getRecordByDayWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.mainGrid.mj_header endRefreshing];
        [self.mainGrid.mj_footer endRefreshing];
        NSArray *list = [data objectForKey:@"data"];
        NSArray *dataArr = [NSArray yy_modelArrayWithClass:[OrderPayListData class] json:list];
        if (isRefreshed==NO) {
            [self.jsonArr addObjectsFromArray:dataArr];
        }else{
            [self.jsonArr removeAllObjects];
            [self.jsonArr addObjectsFromArray:dataArr];
        }
        
        if ([ObjectUtil isEmpty:self.jsonArr]) {
            self.mainGrid.hidden=YES;
            self.label.hidden = NO;
            self.page= self.page -1;
            return;
        }
        self.mainGrid.hidden=NO;
        self.label.hidden=YES;
        [_mainGrid reloadData];
        self.line.hidden=NO;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self.mainGrid.mj_header endRefreshing];
        [self.mainGrid.mj_footer endRefreshing];
        self.page = self.page - 1;
        self.mainGrid.hidden = YES;
        [AlertBox show:error.localizedDescription];
    }];
}



#pragma mark -- Gettes && Setters --
-(NSMutableArray *)jsonArr{
    
    if (!_jsonArr) {
        
        _jsonArr = [[NSMutableArray alloc]init];
    }
    return _jsonArr;
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.jsonArr.count == 0 ? 0 :self.jsonArr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderPayListData *orderPayListData = self.jsonArr[indexPath.row];
    
    return ([orderPayListData.wechatNickName isEqualToString:NSLocalizedString(@"支付宝付款码支付", nil)]&& orderPayListData.payType ==2)?105:120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    OrderPayListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderPayListCell" owner:self options:nil] lastObject];
    }
    OrderPayListData *orderPayListData = self.jsonArr[indexPath.row];
    [cell initWithData:orderPayListData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    OrderPayListData *orderPayListData = self.jsonArr[row];
    if (orderPayListData.type ==2) {
        return;
    }
    
    if ([NSString isBlank: orderPayListData.orderId ]) {
        [AlertBox show:NSLocalizedString(@"此账单还未经过收银员的同意，暂时无法查看详情哦", nil)];
        return;
    }
    TDFMemberPayInfoController *vc = [[TDFMemberPayInfoController alloc] init];
    vc.orderId = orderPayListData.orderId;
    vc.totalPayId = @"";
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_orderPayDetailViewControllerWithorderId:orderPayListData.orderId totalPayId:@"" type:3] animated:YES];
}

#pragma mark -右边导航事件
- (void)rightNavigationButtonAction:(id)sender{
    [self BtnClick];
}

- (void)BtnClick{
    NSString *isSuper =[[Platform Instance]getkey:USER_IS_SUPER];
    if ([isSuper isEqualToString:@"1"]){
       
      
            [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentEditViewControllerWithCallBack:^{
            }] animated:YES];
    }else
    {
        [AlertBox show:NSLocalizedString(@"您没有[收款账户]的权限", nil)];
    }
}

- (BOOL) isChain
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
