//
//  TDFLoanNoteViewController.m
//  RestApp
//
//  Created by zishu on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLoanNoteViewController.h"
#import "SelectMultiMenuItem.h"
#import "TDFMediator+LoanModule.h"
#import "TDFSettingService.h"
#import "AlertBox.h"
#import "MobClick.h"
#import "UIColor+Hex.h"
#import "TDFProtocolView.h"
#import "HelpDialog.h"

@interface TDFLoanNoteViewController ()<ProtocolDelegate>
@property (nonatomic,strong) UIScrollView *bottomScroll;
@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) TDFProtocolView *protocolView;
@property (nonatomic,strong) UIView *bottomView;
@end

@implementation TDFLoanNoteViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"协议授权", nil);
    [self setupUI];
    self.isSelect = NO;
//    [self.view addSubview:self.tableView];
//    [self.tableView reloadData];
}

#pragma mark - setupUI
- (void)setupUI {
    [self.view addSubview:self.bottomScroll];
    [self.bottomScroll addSubview:self.bgImage];
    [self.bottomScroll addSubview:self.bottomView];
    [_bottomView addSubview:self.nextBtn];
    [_bottomView addSubview:self.protocolView];
    [self constructLayout];
}

- (void)constructLayout {
    CGFloat bottomHeight = SCREEN_WIDTH / 375 * 516;
    
    [self.bottomScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bottomScroll);
        make.width.equalTo(self.bottomScroll.mas_width);
        make.height.equalTo(@(bottomHeight));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomScroll.mas_bottom);
        make.width.equalTo(self.bottomScroll.mas_width);
        make.top.equalTo(_bgImage.mas_bottom);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomScroll.mas_centerX);
        make.width.equalTo(@201);
        make.height.equalTo(@44);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-42);
    }];
    
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(_nextBtn.mas_top).offset(-30);
    }];

//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.equalTo(@516);
////        make.height.equalTo(@(SCREEN_HEIGHT - 211));
//    }];
//    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bottomScroll.mas_bottom);
//        make.width.equalTo(self.view.mas_width);
//        make.top.equalTo(_bgImage.mas_bottom);
//    }];
//
//    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.equalTo(@201);
//        make.height.equalTo(@44);
//        make.bottom.equalTo(_bottomView.mas_bottom).offset(-42);
//    }];
//    
//    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomView.mas_top);
//        make.width.equalTo(self.view.mas_width);
//        make.bottom.equalTo(_nextBtn.mas_top).offset(-30);
//    }];
    
}



- (void)layoutTableHeaderView
{
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    _tableHeaderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loan_note"]];
    [_tableHeaderView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"您接下来将进入由%@提供的页面，与对方签订线下贷款协议后，对方将可以获取您的部分营业数据。", nil),self.loanCompanyName];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [_tableHeaderView addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).with.offset(10);
        make.centerX.equalTo(_tableHeaderView.mas_centerX);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(7);
        make.left.equalTo(_tableHeaderView).with.offset(10);
        make.bottom.equalTo(_tableHeaderView).with.offset(-10);
        make.right.equalTo(_tableHeaderView).with.offset(-10);
    }];
}

#pragma mark - ProtocolDelegate
- (void)protocolViewAgreementClick {
     [HelpDialog show:@"loanAgreementHelp"];
}


- (void)protocolViewSelBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        [_nextBtn setBackgroundColor:[UIColor orangeColor]];
        self.isSelect = YES;
    } else {
        _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.isSelect = NO;
    }
}


- (void)nextBtnClick:(UIButton *)btn
{
    if (self.isSelect) {
        [MobClick event:@"click_xinhuo_authority_next"];//点击下一步（绿色状态下
        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"loan_company_id"] = self.loanCompanyId;
        parma[@"is_agree"] = [NSString stringWithFormat:@"%d",self.isSelect];
        
        [[TDFSettingService new] saveLoanAgreementWithParam:parma sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *webViewController = [mediator TDFMediator_loanWebViewControllerWithH5Url:self.h5Url];
            
            [self.navigationController pushViewController:webViewController animated:YES];
        }failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectMultiMenuItem *detailItem = (SelectMultiMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMultiMenuItemIndentifier];
    if (detailItem==nil) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMultiMenuItem" owner:self options:nil].lastObject;
        detailItem.selectionStyle =UITableViewCellSelectionStyleNone;
        detailItem.bgView.backgroundColor = [UIColor clearColor];
        detailItem.lblName.textColor = [UIColor whiteColor];
        detailItem.lblName.font = [UIFont systemFontOfSize:12];
    }
    detailItem.lblName.text = NSLocalizedString(@"同意在签订贷款协议后，为对方提供本店营业数据", nil);
    if (self.isSelect) {
        detailItem.imgCheck.hidden=NO;
        detailItem.imgUnCheck.hidden=YES;
    }else{
        detailItem.imgCheck.hidden=YES;
        detailItem.imgUnCheck.hidden=NO;
    }
    return detailItem;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isSelect = !self.isSelect;
    if (self.isSelect) {
        [MobClick event:@"click_xinhuo_authority_agree"];//点击勾选
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
    }else{
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.nextBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.45];
    }
    [self.tableView reloadData];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
    [MobClick event:@"click_xinhuo_authority_back"];//点击左上角返回
}

#pragma mark - lazy
- (UIImageView *)bgImage {
    if (_bgImage == nil) {
        _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loanBG"]];
    }
    return _bgImage;
}

- (TDFProtocolView *)protocolView {
    if (_protocolView == nil) {
        _protocolView = [[TDFProtocolView alloc] init];
        _protocolView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        _protocolView.delegate = self;
    }
    return _protocolView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    }
    return _bottomView;
}


-(UITableView *) tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = self.tableFooterView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        [self layoutTableHeaderView];
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
        [_tableFooterView addSubview:self.nextBtn];
    }
    return _tableFooterView;
}

- (UIButton *) nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _nextBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 40);
        [_nextBtn setTitle:NSLocalizedString(@"获取预审额度", nil) forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        _nextBtn.layer.cornerRadius = 3;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nextBtn;
}

- (UIScrollView *)bottomScroll {
    if (_bottomScroll == nil) {
        _bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        //没办法,UI不给切图就给一张底图,还非要我自己算,好好的不需要滚动非要搞个滚动,切个合适的图不就啥都没事了
        _bottomScroll.showsHorizontalScrollIndicator = NO;
        _bottomScroll.bounces = NO;
    }
    return _bottomScroll;
}
@end
