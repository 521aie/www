//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillPayDetailView.h"
#import "TDFSignBillService.h"
#import "TDFSignBillService.h"
#import "SignBillPayTotalItem.h"
#import "SignBillPayDetailVO.h"
#import "SignBillPayDetailVO.h"
#import "SignBillPayTotalVO.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "FormatUtil.h"
#import "MessageBox.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillPayDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self initNavigate];
    [self initMainView];
    [self initNotifaction];
    [self loadSignBillData:self.signBill];
}

#pragma mark - UI
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}
- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor clearColor];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.baseTitle];
        
        UIView *infoPanel = [[UIView alloc] init];
        infoPanel.frame = CGRectMake(0, 44,SCREEN_WIDTH, 209);
        infoPanel.backgroundColor = [UIColor clearColor];
        [_container addSubview:infoPanel];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"挂账人", nil);
        label.frame = CGRectMake(8, 10, 100, 20);
        [infoPanel addSubview:label];
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"挂账单", nil);
        label.frame = CGRectMake(8, 34, 100, 20);
        [infoPanel addSubview:label];
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"挂账金额(元)", nil);
        label.frame = CGRectMake(8, 58, 100, 20);
        [infoPanel addSubview:label];
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"实收金额(元)", nil);
        label.frame = CGRectMake(8, 82, 100, 20);
        [infoPanel addSubview:label];
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"付款方式", nil);
        label.frame = CGRectMake(8, 106, 100, 20);
        [infoPanel addSubview:label];

        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"备注", nil);
        label.frame = CGRectMake(8, 130, 100, 20);
        [infoPanel addSubview:label];

        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"还款时间", nil);
        label.frame = CGRectMake(8, 154, 100, 20);
        [infoPanel addSubview:label];

        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"收款人", nil);
        label.frame = CGRectMake(8, 178, 100, 20);
        [infoPanel addSubview:label];
        
        [infoPanel addSubview:self.lbLsignBillMan];
        [infoPanel addSubview:self.lbLsignBillCount];
        [infoPanel addSubview:self.lbLsignBillFee];
        [infoPanel addSubview:self.lbLsignBillRealFee];
        [infoPanel addSubview:self.lbLsignBillKindPayName];
        [infoPanel addSubview:self.lbLsignBillMemo];
        [infoPanel addSubview:self.lbLsignBillPayTime];
        [infoPanel addSubview:self.lbLsignBillPayer];
        
        [_container addSubview:self.listTitle];
        [_container addSubview:self.listContainer];
        
        UIButton *btnDel = [[UIButton alloc] init];
        [btnDel setTitle:NSLocalizedString(@"撤销收账", nil) forState:UIControlStateNormal];
        btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        btnDel.frame = CGRectMake(10, 400, SCREEN_WIDTH-20, 44);
        [btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnDel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_container addSubview:btnDel];
    }
    return _container;
}

- (ItemTitle *)baseTitle {
    if(!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] init];
        [_baseTitle awakeFromNib];
        _baseTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _baseTitle.backgroundColor = [UIColor clearColor];
    }
    return _baseTitle;
}

- (UILabel *)lbLsignBillMan {
    if(!_lbLsignBillMan){
        _lbLsignBillMan = [[UILabel alloc] init];
        _lbLsignBillMan.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillMan.textAlignment = NSTextAlignmentRight;
        _lbLsignBillMan.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillMan.frame = CGRectMake(132, 10, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillMan;
}

- (UILabel *)lbLsignBillCount {
    if(!_lbLsignBillCount){
        _lbLsignBillCount = [[UILabel alloc] init];
        _lbLsignBillCount.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillCount.textAlignment = NSTextAlignmentRight;
        _lbLsignBillCount.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillCount.frame = CGRectMake(132, 34, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillCount;
}

- (UILabel *)lbLsignBillFee {
    if(!_lbLsignBillFee){
        _lbLsignBillFee = [[UILabel alloc] init];
        _lbLsignBillFee.textColor = [UIColor redColor];
        _lbLsignBillFee.textAlignment = NSTextAlignmentRight;
        _lbLsignBillFee.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillFee.frame = CGRectMake(132, 58, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillFee;
}

- (UILabel *)lbLsignBillRealFee {
    if(!_lbLsignBillRealFee){
        _lbLsignBillRealFee = [[UILabel alloc] init];
        _lbLsignBillRealFee.textColor = [UIColor redColor];
        _lbLsignBillRealFee.textAlignment = NSTextAlignmentRight;
        _lbLsignBillRealFee.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillRealFee.frame = CGRectMake(132, 82, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillRealFee;
}
- (UILabel *)lbLsignBillKindPayName {
    if(!_lbLsignBillKindPayName){
        _lbLsignBillKindPayName = [[UILabel alloc] init];
        _lbLsignBillKindPayName.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillKindPayName.textAlignment = NSTextAlignmentRight;
        _lbLsignBillKindPayName.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillKindPayName.frame = CGRectMake(132, 106, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillKindPayName;
}
- (UILabel *)lbLsignBillMemo {
    if(!_lbLsignBillMemo){
        _lbLsignBillMemo = [[UILabel alloc] init];
        _lbLsignBillMemo.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillMemo.textAlignment = NSTextAlignmentRight;
        _lbLsignBillMemo.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillMemo.frame = CGRectMake(132, 130, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillMemo;
}
- (UILabel *)lbLsignBillPayTime {
    if(!_lbLsignBillPayTime){
        _lbLsignBillPayTime = [[UILabel alloc] init];
        _lbLsignBillPayTime.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillPayTime.textAlignment = NSTextAlignmentRight;
        _lbLsignBillPayTime.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillPayTime.frame = CGRectMake(132, 154, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillPayTime;
}
- (UILabel *)lbLsignBillPayer {
    if(!_lbLsignBillPayer){
        _lbLsignBillPayer = [[UILabel alloc] init];
        _lbLsignBillPayer.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillPayer.textAlignment = NSTextAlignmentRight;
        _lbLsignBillPayer.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillPayer.frame = CGRectMake(132, 178, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillPayer;
}
- (ItemTitle *)listTitle {
    if(!_listTitle) {
        _listTitle = [[ItemTitle alloc] init];
        [_listTitle awakeFromNib];
        _listTitle.frame = CGRectMake(0, 253, SCREEN_WIDTH, 44);
        _listTitle.backgroundColor = [UIColor clearColor];
    }
    return _listTitle;
}

- (UIView *)listContainer {
    if(!_listContainer) {
        _listContainer = [[UIView alloc] init];
        _listContainer.frame = CGRectMake(0, 305, SCREEN_WIDTH, 66);
        _listContainer.backgroundColor = [UIColor clearColor];
    }
    return _listContainer;
}


#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"还款详情", nil);
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {

    }
}

-(void) initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本信息", nil);
    self.listTitle.lblName.text=NSLocalizedString(@"挂账单", nil);
    [self.container setBackgroundColor:[UIColor clearColor]];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma notification 处理.
-(void) initNotifaction
{

}

- (void)loadSignBillData:(SignBill *)signBill;
{
    if ([ObjectUtil isNotNull:signBill]) {

       [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
         [[TDFSignBillService new] findSignBillDetail:signBill.signBillId sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
             [self.progressHud hideAnimated:YES];
             NSArray *signBillPayDetails = [data objectForKey:@"data"];
             
             NSMutableArray *signBillPayDetailList = [SignBillPayDetailVO convertToSignBillPayDetailList:signBillPayDetails];
             
             [self renderSignBillInfo:self.signBill signBillPayDetailList:signBillPayDetailList];
             [self renderSignBillList:signBillPayDetailList];
             
             [UIHelper refreshPos:self.container scrollview:self.scrollView];
             [UIHelper clearColor:self.container];
         } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hideAnimated:YES];
             [AlertBox show:error.localizedDescription];
         }];

    }
}

-(void) loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseResult:result.content];
}

-(void) removeFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) parseResult:(NSString*)result
{
    NSDictionary* map = [JsonHelper transMap:result];
    NSArray *signBillPayDetails = [map objectForKey:@"signBillPayDetailVOs"];
    
    NSMutableArray *signBillPayDetailList = [SignBillPayDetailVO convertToSignBillPayDetailList:signBillPayDetails];
    
    [self renderSignBillInfo:self.signBill signBillPayDetailList:signBillPayDetailList];
    [self renderSignBillList:signBillPayDetailList];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)renderSignBillInfo:(SignBill *)signBill signBillPayDetailList:(NSArray *)signBillPayDetailList
{
    self.lbLsignBillMan.text = [FormatUtil formatString:signBill.company];
    self.lbLsignBillCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)signBillPayDetailList.count];
    self.lbLsignBillFee.text = [FormatUtil formatDouble3:signBill.fee];
    self.lbLsignBillRealFee.text = [FormatUtil formatDouble3:signBill.realFee];
    self.lbLsignBillPayTime.text = [DateUtils formatTimeWithTimestamp:signBill.payTime type:TDFFormatTimeTypeChineseWithTime];
    self.lbLsignBillKindPayName.text = [FormatUtil formatString:signBill.payName];
    self.lbLsignBillMemo.text = [FormatUtil formatString:signBill.memo];
    self.lbLsignBillPayer.text = [FormatUtil formatString:signBill.operatorName];
}

- (void)renderSignBillList:(NSArray *)signBillPayDetailList
{
    for (UIView *viewItem in self.listContainer.subviews) {
        [viewItem removeFromSuperview];
    }
    
    if ([ObjectUtil isNotEmpty:signBillPayDetailList]) {
        for (NSUInteger i=0;i<signBillPayDetailList.count;++i) {
            SignBillPayDetailVO *signBillPayDetail = [signBillPayDetailList objectAtIndex:i];
            SignBillPayTotalItem *signBillPayTotalItem = [SignBillPayTotalItem getInstance];
            [signBillPayTotalItem initWithSignBillPayDetailVO:signBillPayDetail];
            CGRect frame = signBillPayTotalItem.frame;
            frame.origin.y = i*88;
            frame.size.width = SCREEN_WIDTH;
            
            signBillPayTotalItem.frame = frame;
            [self.listContainer addSubview:signBillPayTotalItem];
        }
        CGRect listFrame = self.listContainer.frame;
        listFrame.size.height = signBillPayDetailList.count*88+10;
        self.listContainer.frame = listFrame;
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [MessageBox show:NSLocalizedString(@"您确实要撤销还款吗?", nil) client:self];
}

- (void)confirm
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSignBillService new] removeSignBillDetail:self.signBill.signBillId sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated: YES];
        if (self.callBack) {
            self.callBack();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signBill"];
}

@end
