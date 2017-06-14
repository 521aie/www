//
//  TDFFetchKindPayFromChainViewController.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFFetchKindPayFromChainViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "GridColHead.h"
#import "TDFRootViewController+FooterButton.h"
#import "KindPay.h"
#import "TDFKindPayBatchCell.h"
#import "TDFKindPayService.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "KindPayRender.h"

@interface TDFFetchKindPayFromChainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign) BOOL isChange;

@property (nonatomic,strong) UILabel *emptyLabel;

@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation TDFFetchKindPayFromChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"从总部获取", nil);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
    self.dataList = [NSMutableArray array];
    
    [self loadKindPayListData];
}

- (NSMutableArray *)dataList {
    if(!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)loadKindPayListData {
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFKindPayService alloc] init] getListKindPayFromChainWithSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];

        NSArray *list = data[@"data"];
        for (id obj in list) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                KindPay *kind = [KindPay modelWithDictionary:obj];
                [self.dataList addObject:kind];
            }
        }
        
        if(self.dataList.count > 0) {
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck];
            self.emptyLabel.hidden = YES;
            self.tableView.hidden = NO;
        }else {
            self.emptyLabel.hidden = NO;
            self.tableView.hidden = YES;
        }

        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)leftNavigationButtonAction:(id)sender {
    
    if (self.isChange) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗？", nil) cancelBlock:^{
            
        } enterBlock:^{
            [super leftNavigationButtonAction:sender];
        }];
    }else {
        [super leftNavigationButtonAction:sender];
    }
}

- (void)rightNavigationButtonAction:(id)sender {
    @weakify(self);
    [self showProgressHudWithText:NSLocalizedString(@"正在获取", nil)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"kind_pay_ids"] = [[self getSelectKindPay] yy_modelToJSONString];
    
    [[[TDFKindPayService alloc] init] copyKindPayToShopWithParam:dic sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


- (NSArray *)getSelectKindPay {
    NSMutableArray *array = [NSMutableArray array];
    [self.dataList enumerateObjectsUsingBlock:^(KindPay * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.selectValue) {
            [array addObject:obj._id];
        }
    }];
    return array;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[TDFKindPayBatchCell class] forCellReuseIdentifier:@"TDFKindPayBatchcell"];
    }
    return _tableView;
}

- (UILabel *)emptyLabel {
    if(!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.backgroundColor = [UIColor clearColor];
        _emptyLabel.font = [UIFont systemFontOfSize:18];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.text = NSLocalizedString(@"总部还未添加过任何付款方式", nil);
        _emptyLabel.textColor = [UIColor whiteColor];
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}

#pragma mark --UItableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.tableView dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"名称", nil) col2:NSLocalizedString(@"支付类型", nil)];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KindPay *vo = self.dataList[indexPath.row];
    
    TDFKindPayBatchCell *cell = [[TDFKindPayBatchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TDFKindPayBatchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLable.text = vo.name;
    cell.memoLable.text = [KindPayRender obtainKindPayKindName:vo.kind];
    
    if(vo.selectValue){
        cell.selectIcon.image = [UIImage imageNamed:@"icon_select_filled"];
    }else {
        cell.selectIcon.image = [UIImage imageNamed:@"icon_select_empty"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KindPay *vo = self.dataList[indexPath.row];
    vo.selectValue = !vo.selectValue;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    self.isChange = NO;
    [self.dataList enumerateObjectsUsingBlock:^(KindPay * _Nonnull kindPay, NSUInteger idx, BOOL * _Nonnull stop) {
        if(kindPay.selectValue) {
            self.isChange = YES;
            *stop = YES;
        }
    }];
    
    [self shouldChangeNavTitles];
}

- (void)shouldChangeNavTitles {
    if (self.isChange) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:@"icon_nav_fetch" rightButtonName:NSLocalizedString(@"获取", nil)];
    } else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

- (void)footerAllCheckButtonAction:(UIButton *)sender {
    [self.dataList enumerateObjectsUsingBlock:^(KindPay  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectValue = YES;
    }];
    [self.tableView reloadData];
    self.isChange = YES;
    [self shouldChangeNavTitles];
}

- (void)footerNotAllCheckButtonAction:(UIButton *)sender {
    [self.dataList enumerateObjectsUsingBlock:^(KindPay  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectValue = NO;
    }];
    [self.tableView reloadData];
    self.isChange = NO;
    [self shouldChangeNavTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
