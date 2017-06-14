//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillPayTotalItem.h"
#import "TDFSignBillService.h"
#import "SignBillConfirmView.h"
#import "SignBillPayTotalVO.h"
#import "SignBillNoPayVO.h"
#import "ServiceFactory.h"
#import "RestConstants.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "TDFDataCenter.h"
#import "TDFMediator+SignBillModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillConfirmView

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
    [self loadSignBillNoPayList:self.signBillPayNoPayOptionTotalVO payIdSet:self.payIdSet];
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
        infoPanel.frame = CGRectMake(0, 44,SCREEN_WIDTH, 112);
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
        label.text = NSLocalizedString(@"收款人", nil);
        label.frame = CGRectMake(8, 82, 100, 20);
        [infoPanel addSubview:label];
        
        [infoPanel addSubview:self.lbLsignBillMan];
        [infoPanel addSubview:self.lbLsignBillCount];
        [infoPanel addSubview:self.lbLsignBillFee];
        [infoPanel addSubview:self.lbLsignBillPayer];
        
        [_container addSubview:self.listTitle];
        [_container addSubview:self.listContainer];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 285,SCREEN_WIDTH, 10);
        lineView.backgroundColor = [UIColor clearColor];
        [_container addSubview:lineView];

        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:NSLocalizedString(@"还款", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(10, 301, SCREEN_WIDTH-20, 44);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(comfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_container addSubview:btn];
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

- (UILabel *)lbLsignBillPayer {
    if(!_lbLsignBillPayer){
        _lbLsignBillPayer = [[UILabel alloc] init];
        _lbLsignBillPayer.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        _lbLsignBillPayer.textAlignment = NSTextAlignmentRight;
        _lbLsignBillPayer.font = [UIFont boldSystemFontOfSize:14];
        _lbLsignBillPayer.frame = CGRectMake(132, 82, SCREEN_WIDTH-140, 20);
    }
    return _lbLsignBillPayer;
}
- (ItemTitle *)listTitle {
    if(!_listTitle) {
        _listTitle = [[ItemTitle alloc] init];
        [_listTitle awakeFromNib];
        _listTitle.frame = CGRectMake(0, 156, SCREEN_WIDTH, 44);
        _listTitle.backgroundColor = [UIColor clearColor];
    }
    return _listTitle;
}

- (UIView *)listContainer {
    if(!_listContainer) {
        _listContainer = [[UIView alloc] init];
        _listContainer.frame = CGRectMake(0, 219, SCREEN_WIDTH, 66);
        _listContainer.backgroundColor = [UIColor clearColor];
    }
    return _listContainer;
}


#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"挂账单确认", nil) backImg:Head_ICON_CANCEL moreImg:nil];
    self.title = NSLocalizedString(@"挂账单确认", nil);
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

- (void)loadSignBillNoPayList:(SignBillPayNoPayOptionTotalVO *)signBillPayNoPayOptionTotalVO payIdSet:(NSMutableArray *)payIdSet;
{
    if ([ObjectUtil isNotEmpty:payIdSet]) {

        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        [[TDFSignBillService new] listSignBillOptNoPayList:payIdSet sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            NSDictionary* signBillPayTotalDic = [data objectForKey:@"data"];
            self.signBillPayTotalVO = [SignBillPayTotalVO convertToSignBillPayTotalVO:signBillPayTotalDic];
            
            [self renderSummaryInfo:self.signBillPayTotalVO];
            [self renderDataListInfo:self.signBillPayTotalVO];
            
            [UIHelper refreshPos:self.container scrollview:self.scrollView];
            [UIHelper clearColor:self.container];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

-(void)loadFinish:(RemoteResult*) result
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

-(void)parseResult:(NSString*)result
{
    NSDictionary* map=[JsonHelper transMap:result];
    NSDictionary* signBillPayTotalDic = [map objectForKey:@"signBillPayTotalVO"];
    self.signBillPayTotalVO = [SignBillPayTotalVO convertToSignBillPayTotalVO:signBillPayTotalDic];
    
    [self renderSummaryInfo:self.signBillPayTotalVO];
    [self renderDataListInfo:self.signBillPayTotalVO];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)renderSummaryInfo:(SignBillPayTotalVO *)signBillPayTotalVO
{
    if ([ObjectUtil isNotNull:self.signBillPayNoPayOptionTotalVO] && [ObjectUtil isNotNull:signBillPayTotalVO]) {
        self.lbLsignBillMan.text = self.signBillPayNoPayOptionTotalVO.name;
        self.lbLsignBillCount.text = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil), (unsigned long)signBillPayTotalVO.count];
        self.lbLsignBillFee.text = [NSString stringWithFormat:@"%0.2f", signBillPayTotalVO.fee];
        NSString *userName = [TDFDataCenter sharedInstance].realName;
        self.lbLsignBillPayer.text = userName;
    }
}

- (void)renderDataListInfo:(SignBillPayTotalVO *)signBillPayTotalVO
{
    for (UIView *viewItem in self.listContainer.subviews) {
        [viewItem removeFromSuperview];
    }
    
    if ([ObjectUtil isNotNull:signBillPayTotalVO] && [ObjectUtil isNotEmpty:signBillPayTotalVO.signBillNoPayVOList]) {
        NSArray *signBillNoPayVOList = signBillPayTotalVO.signBillNoPayVOList;
        for (NSUInteger i=0;i<signBillNoPayVOList.count;++i) {
            SignBillNoPayVO *signBillNoPayVO = [signBillNoPayVOList objectAtIndex:i];
            SignBillPayTotalItem *signBillPayTotalItem = [SignBillPayTotalItem getInstance];
            [signBillPayTotalItem initWithSignBillNoPayVO:signBillNoPayVO];
            CGRect frame = signBillPayTotalItem.frame;
            frame.origin.y = i*88;
            frame.size.width = SCREEN_WIDTH;
            signBillPayTotalItem.frame = frame;
            [self.listContainer addSubview:signBillPayTotalItem];
        }
        CGRect listFrame = self.listContainer.frame;
        listFrame.size.height = signBillNoPayVOList.count*88;
        self.listContainer.frame = listFrame;
    }
}

- (IBAction)comfirmBtnClick:(id)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillPayViewControllerWithData:self.signBillPayTotalVO
                                                                                       signBillPayNoPayOptionTotal:self.signBillPayNoPayOptionTotalVO
                                                                                                          payIdSet:self.payIdSet];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signBill"];
}

@end
