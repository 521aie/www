
//
//  TDFAddNewCopousInfoViewController.m
//  RestApp
//
//  Created by hulatang on 16/7/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAddNewCopousInfoViewController.h"
#import "TDFKindPayDetailViewController.h"
//#import "OptionPickerBox.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "EditItemRadio.h"
#import "SettingModule.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "TDFBaseCell.h"
#import "TDFVoucher.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "KindPay.h"
#import "TDFSettingService.h"
#import <TDFMediator+SettingModule.h>

@interface TDFAddNewCopousInfoViewController ()<INavigateEvent,UITableViewDelegate,UITableViewDataSource,TDFBaseCellDelegate>
{
    SettingService *service;
    SettingModule *_parent;
    UIView *_tableFooterView;
    UILabel *_attentionlabel;
    
}
@property (nonatomic, strong)NavigateTitle2 *titleBox;
@property (nonatomic, strong)UIView *titleDiv;
@property (nonatomic, strong)KindPay *kindPay;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)TDFVoucher *voucher;
@end

@implementation TDFAddNewCopousInfoViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIView *)titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [self.view addSubview:_titleDiv];
    }
    return _titleDiv;
}

#pragma mark -- loadView

- (instancetype)initWithParent:(SettingModule *)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
//        hud = [[MBProgressHUD alloc] initWithView:self.view];
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutHeaderView];
    [self initTableView];
    
}

- (void)layoutHeaderView
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"添加新面额", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title =NSLocalizedString(@"添加新面额", nil);
    
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        
        
//        [_parent showView:KIND_PAY_EDIT_VIEW];
//        [_parent.kindPayEditView loadViewWith:self.kindPay With:TDFKindPayTypeEdit];
       // [XHAnimalUtil animal:_parent type:kCATransitionPush direct:kCATransitionFromLeft];
       // [self releaseView];
    }else{
        [self save];
    }
}


-(void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

-(void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self save];
}

- (void)initTableView
{
    [self initDataArray];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.rowHeight = 48;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [self footerView];
    [self.view addSubview:self.tableView];
}
#pragma mark --UITableViewDelegate,UITableViewDataSource

- (UIView *)footerView
{
    
    if (!_tableFooterView) {
        [self initTableFooterView];
    }
    return _tableFooterView;
}
- (void)initTableFooterView
{
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    _tableFooterView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _attentionlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -30, 80)];
    _attentionlabel.text = NSLocalizedString(@"提示：代金券售价小于面额时，使用此代金券支付时，两者的差价会计为账单的优惠金额，", nil);
    _attentionlabel.numberOfLines = 0;
    _attentionlabel.textColor = [UIColor grayColor];
    _attentionlabel.font = [UIFont systemFontOfSize:13];
    [_tableFooterView addSubview:_attentionlabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    TDFBaseCell *cell = [TDFBaseCell getCellinTableView:tableView WithType:[dic[@"type"] integerValue] withInitData:dic];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row == 0 ) {
        [cell changeDataWithValue:self.voucher.amount with:[dic[@"type"] integerValue]];
    }else
    {
        [cell changeDataWithValue:self.voucher.sellPrice with:[dic[@"type"] integerValue]];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark --loadData
- (void)initDataArray
{
    if (self.dataArray.count > 0) {
        return;
    }
    [self.dataArray addObject:@{@"name":NSLocalizedString(@"代金券面额", nil),
                                @"isrequest":@1,
                                @"hit":@"",
                                @"type":@(TDFTableViewCellTypeEditItemText),
                                @"keyboardType":@(UIKeyboardTypeDecimalPad),
                                @"value":@""}];
    [self.dataArray addObject:@{@"name":NSLocalizedString(@"代金券售价", nil),
                                @"isrequest":@1,
                                @"hit":@"",
                                @"type":@(TDFTableViewCellTypeEditItemText),
                                @"keyboardType":@(UIKeyboardTypeDecimalPad),
                                @"value":@""}];
}


- (void)addNewInfoWith:(KindPay *)kindPay
{
    self.kindPay = kindPay;
    self.voucher = [[TDFVoucher alloc] init];
}

#pragma mark --TDFBaseCellDelegate

- (void)editItemTextWithText:(NSString *)text WithCell:(TDFBaseCell *)cell
{
    if ([self.tableView indexPathForCell:cell].row == 0) {
        if (text.floatValue >9999) {
            [AlertBox show:NSLocalizedString(@"代金券面额不能大于9999", nil)];
        }else
        {
            self.voucher.amount = [NSString stringWithFormat:@"%.2f",text.floatValue];
        }
        
    }else
    {
        if (text.floatValue >9999) {
            [AlertBox show:NSLocalizedString(@"代金券售价不能大于9999", nil)];
        }else
        {
            self.voucher.sellPrice = [NSString stringWithFormat:@"%.2f",text.floatValue];
        }
        
    }
    [self.tableView reloadData];
}

#pragma mark --save
- (void)save
{
    [self.tableView endEditing:YES];
    if (!self.voucher.amount) {
        [AlertBox show:NSLocalizedString(@"代金券面额不能为空!", nil)];
        return;
    }
    if (!self.voucher.sellPrice) {
        [AlertBox show:NSLocalizedString(@"代金券售价不能为空!", nil)];
        return;
    }
    if (self.voucher.amount.floatValue == 0) {
        [AlertBox show:NSLocalizedString(@"代金券面额不能为0", nil)];
        return;
    }
    if (self.voucher.sellPrice.floatValue > self.voucher.amount.floatValue) {
        [AlertBox show:NSLocalizedString(@"代金券售价不能大于面额", nil)];
        return;
    }
    for (TDFVoucher *voucher in self.kindPay.voucherArray) {
        if (voucher.amount.floatValue == self.voucher.amount.floatValue &&
            voucher.sellPrice.floatValue == self.voucher.sellPrice.floatValue) {
            [AlertBox show:NSLocalizedString(@"已经存在相同面额和售价的代金券了!", nil)];
            return;
        }
    }
    if (self.kindPay._id) {
        NSMutableDictionary *param  = [[NSMutableDictionary alloc] init];
        [param setObject:self.kindPay._id forKey:@"kind_pay_id"];
        [param setObject:[JsonHelper getjsonstr:self.voucher.dictionaryRepresentation] forKey:@"voucher_str"];
      //  NSDictionary *dic = @{@"id":self.kindPay._id,@"voucherStr":[JsonHelper getjsonstr:self.voucher.dictionaryRepresentation]};
      //  [service saveVoucher:dic Target:self Callback:@selector(saveBack:)];
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        [[TDFSettingService new] saveVoucher:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            NSDictionary *voucherDic = data[@"data"];
            if ([ObjectUtil isNotEmpty:voucherDic]) {
                TDFVoucher *voucher = [TDFVoucher modelWithDictionary:voucherDic];
                NSMutableArray *voucherArray = [NSMutableArray arrayWithArray:self.kindPay.voucherArray];
                [voucherArray insertObject:voucher atIndex:0];
                self.kindPay.voucherArray = [NSArray arrayWithArray:voucherArray];
            }
            [self.navigationController popViewControllerAnimated:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:[NSString stringWithFormat:@"%ld",TDFKindPayTypeEdit] data:self.kindPay];
            }

        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else
    {
        [AlertBox show:NSLocalizedString(@"保存失败!", nil)];
    }
    
}

- (void)saveBack:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *dictionary = [JsonHelper transMap:result.content];
    NSString *voucherStr = dictionary[@"voucherStr"];
    if (voucherStr.length > 0) {
        NSDictionary *voucherDic = [JsonHelper transMap:voucherStr];
        TDFVoucher *voucher = [TDFVoucher modelWithDictionary:voucherDic];
        NSMutableArray *voucherArray = [NSMutableArray arrayWithArray:self.kindPay.voucherArray];
        [voucherArray insertObject:voucher atIndex:0];
        self.kindPay.voucherArray = [NSArray arrayWithArray:voucherArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:[NSString stringWithFormat:@"%ld",TDFKindPayTypeEdit] data:self.kindPay];
    }
//    [_parent.kindPayListView loadDatas];
//    [_parent showView:KIND_PAY_EDIT_VIEW];
//    [_parent.kindPayEditView loadViewWith:self.kindPay With:TDFKindPayTypeEdit];
//    [XHAnimalUtil animal:_parent type:kCATransitionPush direct:kCATransitionFromLeft];
//    [self releaseView];
   
    
}

//- (void)releaseView
//{
//    [_parent.addNewCopous.view removeFromSuperview];
//    _parent.addNewCopous = nil;
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dic) {
        self.delegate =self.dic[@"delegate"];
        [self addNewInfoWith:self.dic[@"data"]];
    }
    [self configNavigationBar:YES];
}
@end
