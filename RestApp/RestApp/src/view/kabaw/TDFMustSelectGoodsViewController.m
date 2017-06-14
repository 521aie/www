//
//  TDFMustSelectGoodsViewController.m
//  RestApp
//
//  Created by hulatang on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMustSelectGoodsViewController.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMustSelectGoodsView.h"
#import <libextobjc/EXTScope.h>
#import "TDFSettingService.h"
#import "TDFForceMenuVo.h"
#import "MBProgressHUD.h"
#import "HelpDialog.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "YYModel.h"
@interface TDFMustSelectGoodsViewController()<TDFMustSelectGoodsViewDelegate>
{
    
    MBProgressHUD *_hud;
}
@property (nonatomic, strong)TDFMustSelectGoodsView *selectGoodsView;
@property (nonatomic, strong)TDFSettingService *service;
@end

@implementation TDFMustSelectGoodsViewController

- (TDFMustSelectGoodsView *)selectGoodsView
{
    if (!_selectGoodsView) {
        _selectGoodsView = [[TDFMustSelectGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _selectGoodsView;
}

- (TDFSettingService *)service
{
    if (!_service) {
        _service = [[TDFSettingService alloc] init];
    }
    return _service;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"必选商品", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.selectGoodsView.delegate = self;
    [self.view addSubview:self.selectGoodsView];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requetTogetMustSelectGoodsList];
}

- (void)requetTogetMustSelectGoodsList
{
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:mainWindow];
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:mainWindow andHUD:_hud];
    NSLog(@"----%@-----%@",self.navigationController.navigationBar,self.navigationController.navigationBar.superview );
    @weakify(self);
    [self.service getMustSelectGoodsList:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [_hud hide:YES];
        NSMutableArray *array = [NSMutableArray array];
        NSArray *dataArray = [data objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            TDFForceMenuVo *menuVo = [TDFForceMenuVo yy_modelWithDictionary:dic];
            [array addObject:menuVo];
        }
        _selectGoodsView.dataArray = array;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [_hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark --TDFMustSelectGoodsViewDelegate

- (void)seeDetailGoodInfoWithData:(id)data
{
    UIViewController *detail = [[TDFMediator sharedInstance] TDFMediator_addForceGoodViewControllerHideOldNavigationBar:NO andData:data withStatus:TDFStatusEdit withCallBack:^(id data) {
        if ([data isKindOfClass:[TDFForceMenuVo class]]) {
            [self requetTogetMustSelectGoodsList];
        }
    }];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)addNewMustSelectGood
{
    UIViewController *list = [[TDFMediator sharedInstance] TDFMediator_mustSelectGoodsListViewController];
    [self.navigationController pushViewController:list animated:YES];
}
- (void)showHelpPage:(NSString *)key
{
    [HelpDialog show:key];
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"forceMenuList"];
}

#pragma mark --FooterListEvent
- (void)footerAddButtonAction:(UIButton *)sender
{
    [self addNewMustSelectGood];
}

@end
