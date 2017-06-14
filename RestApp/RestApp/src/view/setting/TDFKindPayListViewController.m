//
//  TDFKindPayListViewController.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindPayListViewController.h"
#import "TDFBrandKindPayCell.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController+FooterButton.h"
#import "UIView+Sizes.h"
#import "TDFKindPayEditViewController.h"
#import "HelpDialog.h"
#import <TDFMediator+SettingModule.h>
#import "TDFFetchKindPayFromChainViewController.h"
#import "KindPayVO.h"
#import "TDFSettingService.h"
#import "TDFKindPayService.h"
#import "AlertBox.h"
#import "TDFMediator+UserAuth.h"
@interface TDFKindPayListViewController ()<UITableViewDataSource,UITableViewDelegate,ISampleListEvent>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *contentLabelInHeaderView;
@property (nonatomic, strong) UIImageView *iconInHeaderView;
@property (nonatomic, assign) CGFloat contentLabelHeight;

@property (nonatomic,assign) BOOL addible; //能不能添加

@property (nonatomic,assign) BOOL chainManager; //能不能修改

@property (nonatomic,strong) NSMutableArray *kindAllDataList;
@property (nonatomic,strong) NSMutableArray *kindShowDataList;

@end

@implementation TDFKindPayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"付款方式", nil);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_KIND_PAY"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.addible = YES;
    [self.tableView reloadData];
    
    [self loadKindPayListData];
}

- (void)loadKindPayListData {
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFKindPayService alloc] init] getlistKindPayWithSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        
        self.kindAllDataList = nil;
        self.kindShowDataList= nil;
        
        self.addible = [data[@"data"][@"addible"] boolValue];
        self.chainManager = [data[@"data"][@"chainDataManageable"] boolValue]; //能不能修改

        NSArray *list = data[@"data"][@"kindPayList"];
        for (id obj in list) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                KindPay *kind = [KindPay modelWithDictionary:obj];
                [self.kindAllDataList addObject:kind];
            }
        }
        
        if(self.kindAllDataList!=nil && self.kindAllDataList.count>0){
            for (KindPay* kindPay in self.kindAllDataList) {
                if (kindPay.kind!=KIND_CREDIT_ACCOUNT) {
                    [self.kindShowDataList addObject:[kindPay copy]];
                }
            }
        }
        [self.tableView reloadData];
        [self updateFooterButton];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)updateFooterButton {
    [self removeAllFooterButtons];
    
    if(!self.addible) {
        [self generateFooterButtonWithTypes: TDFFooterButtonTypeHelp| TDFFooterButtonTypeSort];
    }else {
            [self generateFooterButtonWithTypes: TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd | TDFFooterButtonTypeSort];
    }
}

- (NSMutableArray *)kindAllDataList {
    if(!_kindAllDataList) {
        _kindAllDataList = [NSMutableArray array];
    }
    return _kindAllDataList;
}

- (NSMutableArray *)kindShowDataList {
    if(!_kindShowDataList) {
        _kindShowDataList = [NSMutableArray array];
    }
    return _kindShowDataList;
}

#pragma mark mark tableviewHeader
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.rowHeight = 66;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 76, 0);
        
        [_tableView registerClass:[TDFBrandKindPayCell class] forCellReuseIdentifier:@"TDFBrandKindPayCell"];
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor =[UIColor clearColor];
        UIView *view =[[UIView alloc] init];
        view.backgroundColor =[UIColor whiteColor];
        view.alpha =0.6;
        [_tableHeaderView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableHeaderView);
        }];
        
        [_tableHeaderView addSubview:self.iconInHeaderView];
        [self.iconInHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableHeaderView.mas_centerX);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            make.top.equalTo(_tableHeaderView.mas_top).with.offset(10);
        }];
        
        [_tableHeaderView addSubview:self.contentLabelInHeaderView];
        [self.contentLabelInHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_tableHeaderView.mas_bottom).with.offset(-10);
            make.left.equalTo(_tableHeaderView.mas_left).with.offset(10);
            make.right.equalTo(_tableHeaderView.mas_right).with.offset(-10);
            make.top.equalTo(self.iconInHeaderView.mas_bottom).with.offset(10);
        }];
        _tableHeaderView.frame = CGRectMake(0, 0,SCREEN_WIDTH, 80+self.contentLabelHeight+10 + 1);
    }
    return _tableHeaderView;
}

- (UIImageView *)iconInHeaderView {
    if(!_iconInHeaderView) {
        _iconInHeaderView =[[UIImageView alloc] init];
        _iconInHeaderView.image =[UIImage imageNamed:@"icon_kindPay"];
        _iconInHeaderView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _iconInHeaderView.layer.masksToBounds =YES;
        _iconInHeaderView.layer.cornerRadius = _iconInHeaderView.width/2;
    }
    return _iconInHeaderView;
}

- (UILabel *)contentLabelInHeaderView {
    if(!_contentLabelInHeaderView) {
        _contentLabelInHeaderView =[[UILabel alloc] init];
        _contentLabelInHeaderView.backgroundColor =[UIColor clearColor];
        _contentLabelInHeaderView.textAlignment = NSTextAlignmentLeft;
        _contentLabelInHeaderView.font = [UIFont systemFontOfSize:15];
        _contentLabelInHeaderView.numberOfLines = 0;
        _contentLabelInHeaderView.textColor =RGBA(51, 51, 51, 1);
        NSString *text = NSLocalizedString(@"付款方式是收银必备的信息。顾客结账时，可通过收银员在收银机上选择相应的付款方式进行结账。", nil);
        _contentLabelInHeaderView.text = text;
        NSMutableAttributedString *str  =[[NSMutableAttributedString alloc] initWithString:_contentLabelInHeaderView.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentLabelInHeaderView.text.length)];
        _contentLabelInHeaderView.attributedText =str;
        _contentLabelInHeaderView.lineBreakMode = NSLineBreakByTruncatingTail;
        
        CGSize fontsize = [_contentLabelInHeaderView sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)];
        
        self.contentLabelHeight = fontsize.height;
    }
    return _contentLabelInHeaderView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kindShowDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.addible) {
        return 0;
    }
    
    NSString *text = NSLocalizedString(@"注：本店的付款方式是由总部管理，暂无法添加，如需添加，请联系总部。", nil);
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    return size.height + 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    
    UIView *alphaView = [header viewWithTag:1001];
    if(!alphaView) {
        alphaView = [[UIView alloc] init];
        alphaView.backgroundColor =[UIColor whiteColor];
        alphaView.alpha =0.6;
        alphaView.tag = 1001;
        [header addSubview:alphaView];
        [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left);
            make.right.equalTo(header.mas_right);
            make.top.equalTo(header.mas_top).with.offset(1);
            make.bottom.equalTo(header.mas_bottom);
        }];
    }
    
    
    UILabel *label = [header viewWithTag:1002];
    if(!label) {
        label = [[UILabel alloc] init];
        label.textColor = RGBA(204, 0, 0, 1);
        label.font = [UIFont systemFontOfSize:11];
        label.tag = 1002;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"注：本店的付款方式是由总部管理，暂无法添加，如需添加，请联系总部。", nil);
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).with.offset(10);
            make.right.equalTo(header.mas_right);
            make.top.equalTo(header.mas_top);
            make.bottom.equalTo(header.mas_bottom);
        }];
    }
    
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindPayVO *vo = self.kindShowDataList[indexPath.row];
    
    TDFBrandKindPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFBrandKindPayCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = vo.name;

    if(vo.isInclude){
        cell.subtitleLabel.text = NSLocalizedString(@"收入计入实收", nil);
        cell.subtitleLabel.textColor = RGBA(7, 173, 31, 1);
    }else {
        cell.subtitleLabel.text = NSLocalizedString(@"收入不计入实收", nil);
        cell.subtitleLabel.textColor = RGBA(102, 102, 102, 1);
    }
    cell.isChainImg.hidden = !vo.isChain;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    KindPayVO *vo = self.kindShowDataList[indexPath.row];
    TDFKindPayEditViewController *VC = [[TDFKindPayEditViewController alloc] init];
    VC.kindPay = self.kindShowDataList[indexPath.row];
    VC.type = TDFBrandKindPayTypeEdit;
    if (vo.isChain && !self.chainManager) {
        VC.canEdit = NO;
    }else{
        VC.canEdit = YES;
    }
    VC.kindAllPayList = [self.kindAllDataList copy];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark mark footview
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"kindpay"];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    TDFKindPayEditViewController *VC = [[TDFKindPayEditViewController alloc] init];
    VC.type = TDFBrandKindPayTypeAdd;
    VC.kindAllPayList = [self.kindAllDataList copy];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)footerSortButtonAction:(UIButton *)sender {
    
    if (self.kindAllDataList==nil || self.kindAllDataList.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
    
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"kindpaysort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:self.kindAllDataList error:nil needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)footerOtherButtonAction:(UIButton *)sender {
    TDFFetchKindPayFromChainViewController *VC = [[TDFFetchKindPayFromChainViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
    [[TDFSettingService new] sortKindPays:ids sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self loadKindPayListData];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
