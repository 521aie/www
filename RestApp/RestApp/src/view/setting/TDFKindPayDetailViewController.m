//
//  TDFKindPayDetailViewController.m
//  RestApp
//
//  Created by hulatang on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAddNewCopousInfoViewController.h"
#import "TDFKindPayDetailViewController.h"
#import <TDFMediator+SettingModule.h>
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "FooterListView.h"
#import "EditItemRadio.h"
#import "KindPayRender.h"
#import "SettingModule.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "GridFooter44.h"
#import "TDFMemberCouponService.h"
#import "TDFBaseCell.h"
#import "TDFVoucher.h"
#import "YYModel.h"
#import "NSString+Estimate.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "KindPay.h"
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"

#define SECTIONVIEW_HEIGHT 48
@interface TDFKindPayDetailViewController ()<UITableViewDelegate,UITableViewDataSource,INavigateEvent,TDFBaseCellDelegate,FooterListEvent>
{
    UIView *_tableFooterView;
    UILabel *_attentionlabel;
    SettingService *service;
    UIButton *_deleteButton;
    SettingModule *_parent;
    NSInteger _sectionNum;
    UIView *_sectionView;
    UIView *_footerView;
    MBProgressHUD *hud;
    UIView *_infoView;
    NSInteger _deleteIndex;
    BOOL _isBack;
}
@property (nonatomic, strong)NavigateTitle2 *titleBox;
@property (nonatomic, strong)UIView *titleDiv;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)KindPay *kindPay;
@property (nonatomic, strong)KindPay *changePay;
@property (nonatomic, assign)TDFKindPayType kindPayType;

@property (nonatomic, strong)NSMutableArray *baseDataArray;
@property (nonatomic, strong)NSMutableArray *copousDataArray;
@property (nonatomic, strong)FooterListView *footer;
@end


@implementation TDFKindPayDetailViewController

- (NSMutableArray *)baseDataArray
{
    if (!_baseDataArray) {
        _baseDataArray = [NSMutableArray array];
    }
    return _baseDataArray;
}

- (NSMutableArray *)copousDataArray
{
    if (!_copousDataArray) {
        _copousDataArray = [NSMutableArray array];
    }
    return _copousDataArray;
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
        _sectionNum = 1;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        service=[ServiceFactory Instance].settingService;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self layoutHeaderView];
    [self initTableView];
    [self layoutFooterView];
    
}


- (void)layoutHeaderView
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
//    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
}

-(void) onNavigateEvent:(NSInteger)event
{
   
    if (event==1) {
        [_parent showView:KIND_PAY_LIST_VIEW];
        [XHAnimalUtil animalEdit:_parent action:self.kindPayType];
    }else{
        [self save];
    }
}


- (void)leftNavigationButtonAction:(id)sender
{
     [self removeObserver];
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:nil data:nil];
    }
    [super leftNavigationButtonAction:sender];
}

-(void)rightNavigationButtonAction:(id)sender
{
     [self removeObserver];
    [super rightNavigationButtonAction:sender];
    [self save];
}


- (void)layoutFooterView
{
    self.footer = [[FooterListView alloc] init];
    [self.footer awakeFromNib];
    self.footer.view.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60);
    [self.footer initDelegate:self btnArrs:nil];
    [self.footer showHelp:YES];
    self.footer.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.view addSubview:self.footer.view];
}
-(void) showHelpEvent
{
    [HelpDialog show:@"kindpay"];
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.rowHeight = 48;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark --UITableViewDelegate,UITableViewDataSource

- (UIView *)footerView
{
    
    if (!_tableFooterView) {
      [self initTableFooterView];
       
    }
    if (self.changePay.kind != KIND_COUPON) {
        _attentionlabel.hidden = YES;
    }else
    {
        _attentionlabel.hidden = NO;
    }
    if (self.kindPayType == TDFKindPayTypeEdit) {
        _deleteButton.hidden = NO;
    }else
    {
        _deleteButton.hidden = YES;
    }
    return _tableFooterView;
}

- (void)initTableFooterView
{
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    _tableFooterView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _attentionlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -30, 80)];
    _attentionlabel.text = NSLocalizedString(@"提示：每种代金券下可以添加不同面额的券，收银上使用时相同类型的券会放在一种付款方式入口内，点开后可以选择不同面额的券", nil);
    _attentionlabel.numberOfLines = 0;
    _attentionlabel.textColor = [UIColor grayColor];
    _attentionlabel.font = [UIFont systemFontOfSize:15];
    [_tableFooterView addSubview:_attentionlabel];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(15, 80, SCREEN_WIDTH - 30, 44);
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    _deleteButton.layer.cornerRadius = 3;
    [_deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(removePayKindType) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_deleteButton];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    if (!_sectionView) {
        [self initSectionView];
    }
    if (self.copousDataArray.count == 0) {
        _infoView.hidden = YES;
    }else
    {
        _infoView.hidden = NO;
    }
    return _sectionView;
}

- (void)initSectionView
{
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTIONVIEW_HEIGHT)];
    _sectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    label.text = NSLocalizedString(@"    代金券面额", nil);
    label.font = [UIFont systemFontOfSize:17];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 47, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_sectionView addSubview:line];
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(12, 72, SCREEN_WIDTH - 24, 24)];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 100, 24)];
    _infoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _infoView.layer.cornerRadius = 12;
    leftLabel.text = NSLocalizedString(@"代金券面额", nil);
    leftLabel.font = [UIFont systemFontOfSize:12];
    [_infoView addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, 100, 24)];
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.text = NSLocalizedString(@"代金券售价", nil);
    [_infoView addSubview:rightLabel];
    [_sectionView addSubview:_infoView];
    [_sectionView addSubview:label];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        if (self.copousDataArray.count>0) {
            return SECTIONVIEW_HEIGHT + 48;
        }
        return SECTIONVIEW_HEIGHT;
    }
}



//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (!_footerView) {
//        [self initWithSectionFooterView];
//    }
//    return _footerView;
//}
//
//- (void)initWithSectionFooterView
//{
//    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTIONVIEW_HEIGHT)];
//    _footerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SECTIONVIEW_HEIGHT);
//    [button setTitle:NSLocalizedString(@"添加新面额", nil) forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"ico_add_rr"] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:13];
//    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [button setImageEdgeInsets:UIEdgeInsetsMake(15, -10, 15, 0)];
//    [button addTarget:self action:@selector(addNewCopousInfo) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_footerView addSubview:button];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return section == 0 ? 0:SECTIONVIEW_HEIGHT;
//}
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.baseDataArray.count;
    }else
    {
        return self.copousDataArray.count + 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDFTableViewCellType type = TDFTableViewCellTypeDefault;
    NSDictionary *dic ;
    if (indexPath.section == 0) {
        dic =self.baseDataArray[indexPath.row];
        type = [dic[@"type"] integerValue];
    }else
    {
        if (indexPath.row< self.copousDataArray.count) {
            dic = self.copousDataArray[indexPath.row];
        }
    }
    
    TDFBaseCell *cell = [TDFBaseCell getCellinTableView:tableView WithType:type withInitData:dic];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.changePay.kind !=self.kindPay.kind) {
                KindPay *pay = [KindPayRender obtainKindPayType:self.changePay.kind];
                [cell changeDataWithValue:pay.name with:type];
            }
        }else if (indexPath.row == 1) {
            if (self.kindPayType == TDFKindPayTypeEdit) {
                if ([self.changePay.name isEqualToString:self.kindPay.name]) {
                    return cell;
                }
                
            }
            if (self.changePay.name != self.kindPay.name) {
                [cell changeDataWithValue:self.changePay.name with:type];
            }
            
            
        }else if (indexPath.row == 2) {
            if (self.changePay.isInclude!= self.kindPay.isInclude) {
                [cell changeDataWithValue:[NSString stringWithFormat:@"%d",self.changePay.isInclude] with:type];
            }
        }else if (indexPath.row == 3) {
            if (self.changePay.isOpenCashDrawer != self.kindPay.isOpenCashDrawer) {
                [cell changeDataWithValue:[NSString stringWithFormat:@"%d",self.changePay.isOpenCashDrawer] with:type];
            }
        }

    }
    if (indexPath.section == 1) {
        if (indexPath.row > self.copousDataArray.count) {
            return nil;
        }
        if (indexPath.row == self.copousDataArray.count) {
            GridFooter44 *footer = [[[NSBundle mainBundle] loadNibNamed:@"GridFooter44" owner:nil options:nil] lastObject];
            footer.backgroundColor = footer.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
            footer.selectionStyle = UITableViewCellSelectionStyleNone;
            footer.lblName.text = NSLocalizedString(@"添加新面额", nil);
            return footer;
        }
        TDFVoucher *voucher = [self.copousDataArray objectAtIndex:indexPath.row];
        cell = [TDFBaseCell getCellinTableView:tableView WithType:TDFTableViewCellTypeDefault withInitData:@{@"name":voucher.amount,@"detailName":voucher.sellPrice}];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_block"]];
        imageView.frame = CGRectMake(100,5, 20, 20);
        [backView addSubview:imageView];
        cell.accessoryView = backView;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row > self.copousDataArray.count) {
            return;
        }
        if (indexPath.row == self.copousDataArray.count) {
            [self addNewCopousInfo];
            return;
        }
        _deleteIndex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"确定要删除此券吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        TDFVoucher *voucher = [self.copousDataArray objectAtIndex:_deleteIndex];

        NSDictionary *dic = @{@"voucher_id":voucher.voucherID};
          [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
        [[TDFSettingService new] deleteVoucher:dic sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [hud  hide:YES];
            [self.copousDataArray removeObjectAtIndex:_deleteIndex];
            self.changePay.voucherArray = [NSArray arrayWithArray:self.copousDataArray];
            [self.tableView reloadData];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              [hud  hide:YES];
             [AlertBox show:error.localizedDescription ];
        }];
        
    }
}

#pragma mark --loadData

- (void)loadViewWith:(KindPay *)kindPay With:(TDFKindPayType)payType
{
    if (kindPay.thirdType ==1 || kindPay.thirdType ==9) {
        self.IsAdd =YES;
    }
    else
    {
        self.IsAdd =NO;
    }
    [self.tableView scrollsToTop];
    if (kindPay.kind == 11) {
        kindPay.kind = 7;
    }
    _isBack = YES;
    self.kindPay = kindPay?:[KindPayRender obtainKindPayType:KIND_CASH];
   
    if (self.kindPay.kind == KIND_COUPON) {
        _sectionNum = 2;
    }else
    {
        _sectionNum = 1;
    }
    if (self.changePay) {
        [self removeObserver];
    }
    self.changePay = [self.kindPay copy];
    self.kindPayType = payType;
    self.tableView.tableFooterView = [self footerView];
    [self initDataSource];
    [self initCopousDataArray];
    
}




- (void)setKindPayType:(TDFKindPayType)kindPayType
{
    _kindPayType = kindPayType;
    if (kindPayType == TDFKindPayTypeEdit) {
        [self.titleBox initWithName:self.kindPay.name backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
        self.title =self.kindPay.name;
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        if (![self.changePay observationInfo]) {
            for (NSString *str in self.changePay.allPropertyArray) {
                [self.changePay addObserver:self
                                 forKeyPath:str
                                    options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld
                                    context:nil];
            }
        }
    }else
    {
        [self.titleBox initWithName:NSLocalizedString(@"添加", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
         self.title =NSLocalizedString(@"添加", nil);
        [self configNavigationBar:YES];
        
    }

}

- (void)removeObserver
{
    if (![self.changePay observationInfo] ) {
        return;
    }
    for (NSString *string in self.kindPay.allPropertyArray) {
        [self.changePay removeObserver:self forKeyPath:string];
    }
}

#pragma mark --KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[KindPay class]]) {
        KindPay *kind = (KindPay *)object;
        if (![kind.name isEqualToString:self.kindPay.name]||
            kind.isInclude != self.kindPay.isInclude||
            kind.isOpenCashDrawer != self.kindPay.isOpenCashDrawer) {
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        }else{
            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        }
    }
}

- (void)initDataSource
{
    [self.baseDataArray removeAllObjects];
    NSDictionary *dic;
    if (self.kindPayType == TDFKindPayTypeAdd) {
        dic = @{@"name":NSLocalizedString(@"支付类型", nil),
                @"dataArray":[KindPayRender listType],
                @"value":self.kindPay.name,
                @"hit":@"",
                @"type":@(TDFTableViewCellTypePullDown)};
    }else
    {
         KindPay *pay = [KindPayRender obtainKindPayType:self.changePay.kind];
        if (pay) {
            if (!self.IsAdd) {
               
                dic = @{@"name":NSLocalizedString(@"支付类型", nil),
                        @"hit":@"",
                        @"hitHeight":@(0),
                        @"data":pay.name,
                        @"value":pay.name,
                        @"type":@(TDFTableViewCellTypeEditItemView)};
            }
            else
            {
            
            dic = @{@"name":NSLocalizedString(@"支付类型", nil),
                    @"hit":@"",
                    @"hitHeight":@(0),
                    @"data":NSLocalizedString(@"网络支付", nil),
                    @"value":NSLocalizedString(@"网络支付", nil),
                    @"type":@(TDFTableViewCellTypeEditItemView)};
            }
            
        }
        else
         {
            
            dic = @{@"name":NSLocalizedString(@"支付类型", nil),
                    @"hit":@"",
                    @"hitHeight":@(0),
                    @"data":NSLocalizedString(@"网络支付", nil),
                    @"value":NSLocalizedString(@"网络支付", nil),
                    @"type":@(TDFTableViewCellTypeEditItemView)};
         }
    }
    [self.baseDataArray addObject:dic];
    [self isAddTheOtherIteam:self.IsAdd];
    
    
}

-(void)isAddTheOtherIteam:(BOOL)isAdd;
{
    if (!isAdd ) {
        
        [self.baseDataArray addObject:@{@"name":NSLocalizedString(@"付款方式名称", nil),
                                        @"isrequest":@1,
                                        @"hit":@"",
                                        @"type":@(TDFTableViewCellTypeEditItemText),
                                        @"keyboardType":@(UIKeyboardTypeDefault),
                                        @"value":self.kindPayType == TDFKindPayTypeAdd?NSLocalizedString(@"现金", nil):self.kindPay.name}];
        
        [self.baseDataArray addObject:@{@"name":NSLocalizedString(@"是否计入销售额", nil),
                                        @"hit":@"",
                                        @"value":[NSString stringWithFormat:@"%d",self.kindPay.isInclude],
                                        @"type":@(TDFTableViewCellTypeEditItemRadio)}];
        [self.baseDataArray addObject:@{@"name":NSLocalizedString(@"付款完成后自动打开钱箱", nil),
                                        @"hit":@"",
                                        @"value":[NSString stringWithFormat:@"%d",self.kindPay.isOpenCashDrawer],
                                        @"type":@(TDFTableViewCellTypeEditItemRadio)}];
        
        [self.tableView reloadData];
    }
    else
    {
     
        _deleteButton.hidden =YES;
        [self.baseDataArray addObject:@{@"name":NSLocalizedString(@"付款方式名称", nil),
                                        @"hit":@"",
                                        @"type":@(TDFTableViewCellTypeEditItemView),
                                        @"value":self.kindPayType == TDFKindPayTypeAdd?@"":self.kindPay.name,
                                        @"data":self.kindPayType == TDFKindPayTypeAdd?@"":self.kindPay.name}
         ];
        //这个地方是定值
        if (![self.changePay.name isEqualToString:NSLocalizedString(@"[微信]", nil)]) {
           
            [TDFMemberCouponService alipayPaymentCompleteBlock:^(TDFResponseModel * _Nullable response) {
                NSDictionary *dic =response.responseObject;
                if (response.error) {
                    [AlertBox show:response.error.localizedDescription];
                    
                    return ;
                }
                if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
                    [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
                    
                    return ;
                }
                if ([ObjectUtil isNotEmpty:dic]) {
                    NSDictionary *data =dic[@"data"];
                    if ([ObjectUtil isNotEmpty:data]) {
                    NSString *alipayStatus =[NSString stringWithFormat:@"%@",data[@"alipayIsOurAccount"]];
                    NSString *alipayIsEnjoyPreferential =[NSString stringWithFormat:@"%@",data[@"alipayIsEnjoyPreferential"]];
                        if (alipayStatus.integerValue==0) {
                            NSInteger str =alipayIsEnjoyPreferential.integerValue;
                            self.kindPay.isInclude = str;
                            self.changePay.isInclude =str;
                            [self.baseDataArray addObject:@{@"name":NSLocalizedString(@"支付宝扫码点餐时享受支付宝优惠", nil),
                                                            @"hit":NSLocalizedString(@"注：打开此开关，顾客端用支付宝扫码点餐时，既享受店家设置的优惠券、优惠活动等优惠，同时也享受店家在支付宝端（比如口碑）设置过的优惠。", nil),
                                                            @"value":[NSString stringWithFormat:@"%ld",(long)str],
                                                            @"type":@(TDFTableViewCellTypeEditItemRadio)}];
                     }
                   }
                }
                [self.tableView reloadData];
                
            }];
           
        }
        [self.tableView reloadData];
        
    }
    
}

- (void)initCopousDataArray{
    [self.copousDataArray removeAllObjects];
    [self.copousDataArray addObjectsFromArray:self.kindPay.voucherArray];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 0;
        if (self.copousDataArray.count > 0) {
            sectionHeaderHeight = SECTIONVIEW_HEIGHT + 48;
        }else
        {
            sectionHeaderHeight = SECTIONVIEW_HEIGHT;
        }
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark --TDFBaseCellDelegate
- (void)editItemList:(EditItemList *)obj withCell:(TDFBaseCell *)cell
{

//    [OptionPickerBox initData:[KindPayRender listType] itemId:[obj getStrVal]];
//    [OptionPickerBox show:obj.lblName.text client:(id)cell event:cell.tag];
    NSMutableArray *arry =[KindPayRender listType];
    for (KindPay *pay in arry) {
        pay._id =pay.name;
    }

    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                  options:arry
                                                                            currentItemId:[obj getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:[KindPayRender listType][index] event:cell.tag withCell:cell];
    };
    
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType withCell:(TDFBaseCell *)cell
{
    KindPay* vo=(KindPay*)selectObj;
    for (UIView *view in [cell subviews]) {
        if ([view isKindOfClass:[EditItemList class]]) {
            EditItemList *list = (EditItemList *)view;
            [list changeData:vo.name withVal:vo.name];
            self.changePay.name = vo.name;
            self.changePay.kind = vo.kind;
            if (self.changePay.kind == KIND_COUPON) {
                _sectionNum = 2;
            }else
            {
                _sectionNum = 1;
            }
            [self.tableView reloadData];
            break;
        }
    }
    self.tableView.tableFooterView = [self footerView];
    return YES;
}

- (void)onItemRadioClick:(EditItemRadio*)obj WithCell:(TDFBaseCell *)cell
{
    if (self.IsAdd) {
        if ([self.tableView indexPathForCell:cell].row == 2) {
            
            self.changePay.isInclude =[obj getVal];
            
        }else
        {
            self.changePay.isOpenCashDrawer = [obj getVal];
        }
    }
    else
    {
        if ([self.tableView indexPathForCell:cell].row == 2) {
            self.changePay.isInclude = [obj getVal];
        }
        else
        {
            self.changePay.isOpenCashDrawer = [obj getVal];
        }
    }
    
}


-(void)openApilyWithStatus:(NSString *)status
{
    [TDFMemberCouponService alipayPaymentType:status CompleteBlock:^(TDFResponseModel * _Nullable response ) {
        
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
        
        [self popView];
        
    }];
}

- (BOOL)editItemTextWithText:(NSString *)text shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string withCell:(TDFBaseCell *)cell
{
    if (range.location>=50 ) {
        [AlertBox show:NSLocalizedString(@"标题字数限制在50字以内！", nil)];
        return  NO;
    }
    return YES;
}

- (void)editItemTextWithText:(NSString *)text WithCell:(TDFBaseCell *)cell
{
    self.changePay.name = text;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --service
- (void)save
{
    if (self.IsAdd) {
        [self openApilyWithStatus:[NSString stringWithFormat:@"%d",self.changePay.isInclude]];
        return;
    }
    if (self.changePay.name.length == 0) {
        [AlertBox show:NSLocalizedString(@"付款方式名称不能为空", nil)];
        return;
    }
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),_kindPayType==TDFKindPayTypeAdd?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.kindPayType == TDFKindPayTypeAdd) {
        if (self.changePay.kind == KIND_CASH) {
            self.changePay.isCharge = 1;
        }else
        {
            self.changePay.isCharge = 0;
        }
        //[service saveKindPay:self.changePay Target:self Callback:@selector(remoteFinsh:)];
        [[TDFSettingService new] saveKindPay:self.changePay sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [hud hide:YES];
            if (![ data[@"data"]isEqual:[NSNull null]]&&  data[@"data"])
            {
                self.changePay._id =  data [@"data"];
            }
            [self removeObserver];
            if (!_isBack) {
                UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_TDFAddNewCopousInfoViewControllerWithData:self.changePay action:0 delegate:self];
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            [self popView];
            [[NSNotificationCenter defaultCenter] postNotificationName:UI_COUNTDATA_INIT object:nil] ;
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        if ([NSString isNotBlank:self.kindPay._id]) {
            self.changePay._id = self.kindPay._id;
        }
        else{
           self.changePay._id = self.kindPay.id;
        }
//        [service updateKindPay:self.changePay Target:self Callback:@selector(remoteFinsh:)];
//        self.changePay._id = self.kindPay.id;
//        
        [[TDFSettingService new] updateKindPay:self.changePay sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [hud  hide: YES];
            if (![ data[@"data"]isEqual:[NSNull null]]&&  data[@"data"])
            {
                self.changePay._id =  data [@"data"];
            }
            [self removeObserver];
            if (!_isBack) {
                UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_TDFAddNewCopousInfoViewControllerWithData:self.changePay action:0 delegate:self];
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            [self popView];
            [[NSNotificationCenter defaultCenter] postNotificationName:UI_COUNTDATA_INIT object:nil] ;
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud  hide: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }

}



- (void)remoteFinsh:(RemoteResult*) result
{
    [hud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    if (![map[@"kindPayId"]isEqual:[NSNull null]]&& map[@"kindPayId"])
    {
        self.changePay._id = map[@"kindPayId"];
    }
//    [_parent.kindPayListView loadDatas];
     [self removeObserver];
    if (!_isBack) {
//        [_parent showView:ADD_NEW_COUPONS];
//        [_parent.addNewCopous addNewInfoWith:self.changePay];
//        [XHAnimalUtil animal:_parent type:kCATransitionPush direct:kCATransitionFromRight];
        UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_TDFAddNewCopousInfoViewControllerWithData:self.changePay action:0 delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
//    [_parent showView:KIND_PAY_LIST_VIEW];
    [self popView];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_COUNTDATA_INIT object:nil] ;
    
}

- (void)popView
{
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:nil data:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removePayKindType
{
    if (self.copousDataArray.count > 0) {
        [AlertBox show:NSLocalizedString(@"该付款类型下还存在多种代金券面额，无法删除，请先删除代金券面额后再操作", nil)];
        return;
    }
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.kindPay.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.kindPay.name] andView:self.view andHUD:hud];
        NSMutableArray *arry  = [[NSMutableArray alloc] initWithObjects:self.kindPay._id, nil];
        [[TDFSettingService new]  removeKindPays:arry sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [hud hide:YES];
            [self removeObserver];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}




#pragma mark --添加新面额
- (void)addNewCopousInfo
{
    [self.tableView endEditing:YES];
    _isBack = NO;
    [self save];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dic) {
        [self loadViewWith:self.dic[@"data"] With:[self.dic[@"action"] integerValue]];
        if (self.dic[@"delegate"]) {
            self.delegate = self.dic[@"delegate"];
        }
        
    }
    
}

#pragma NavigateMenuDelegate 
-(void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    if (TDFKindPayTypeEdit ==event.integerValue) {
        NSMutableDictionary *dic  =[[NSMutableDictionary alloc] init];
        if (obj) {
            dic[@"data"] =obj;
        }
        if ([NSString isNotBlank:event]) {
         dic[@"action"] =event;
        }
        if (self.delegate) {
            dic[@"delegate"]=self.delegate;
        }
        self.dic =[[NSDictionary alloc] initWithDictionary:dic];
        
    }
}

- (void) dealloc
{
    [self removeObserver];
}

@end
