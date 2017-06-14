//
//  TDFMustSelectGoodsListViewController.m
//  RestApp
//
//  Created by hulatang on 16/8/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMustSelectGoodsListViewController.h"
#import "TDFMustSelectGoodsListView.h"
#import "TDFMediator+KabawModule.h"
#import "TDFRightSelectView.h"
#import "TDFForceKindMenuVo.h"
#import "TDFSettingService.h"
#import "TDFForceMenuVo.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "YYModel.h"
@interface TDFMustSelectGoodsListViewController()<TDFMustSelectGoodsListViewDelegate>
{
    TDFRightSelectView *_selectView;
    MBProgressHUD *_hud;
}
@property (nonatomic, strong)TDFMustSelectGoodsListView *listView;
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, strong)TDFSettingService *service;
@end

@implementation TDFMustSelectGoodsListViewController

- (TDFMustSelectGoodsListView *)listView
{
    if (!_listView) {
        _listView = [[TDFMustSelectGoodsListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _listView;
}

- (TDFSettingService *)service
{
    if (!_service) {
        _service = [[TDFSettingService alloc] init];
    }
    return _service;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"添加必选商品", nil);
    self.listView.delegate = self;
    [self.view addSubview:self.listView];
    [self requetTogetAllMustSelectGoodsList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initRightView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.selectButton.hidden = YES;
    _selectView.hidden = YES;
}
#pragma mark --requestData
- (void)requetTogetAllMustSelectGoodsList
{
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:mainWindow];
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:mainWindow andHUD:_hud];
    @weakify(self);
    [self.service getAllSelectGoodsList:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [_hud setHidden:YES];
        NSMutableArray *array = [NSMutableArray array];
        NSArray *dataArray = [data objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            TDFForceKindMenuVo *menuVo = [TDFForceKindMenuVo yy_modelWithDictionary:dic];
            [array addObject:menuVo];
        }
        _selectView.dataArray = array;
        self.listView.dataArray = array;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [_hud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


#pragma mark --TDFMustSelectGoodsListViewDelegate

- (void)selectGoodWithData:(id)data andIsForceMenu:(int)isForceMenu
{
    UIViewController *controller = [[TDFMediator sharedInstance] TDFMediator_addForceGoodViewControllerHideOldNavigationBar:NO andData:data withStatus:isForceMenu withCallBack:^(id data) {
        if ([data isKindOfClass:[TDFForceMenuVo class]]) {
            [self requetTogetAllMustSelectGoodsList];
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- 右边侧滑
- (void)initRightView
{
    if (_selectView) {
        _selectView.hidden = NO;
        [self layoutButton];
        return;
    }
    _selectView = [[TDFRightSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _selectView.dataString = ^(id data){
        if ([data isKindOfClass:[TDFForceKindMenuVo class]]) {
            TDFForceKindMenuVo *menuVo = (TDFForceKindMenuVo *)data;
            return menuVo.kindMenuName;
        }
        return @"";
    };
    @weakify(self);
    _selectView.selectClick = ^(NSInteger index){
        @strongify(self);
        self.listView.scrollIndex = index;
        [self buttonAnimateMoveOut:self.selectButton];
    };
    
    
    _selectView.touchClick = ^(){
        @strongify(self);
        [self buttonAnimateMoveOut:self.selectButton];
    };
    [self.navigationController.view addSubview:_selectView];
    [self layoutButton];
}

- (void)layoutButton
{
    if (self.selectButton) {
        self.selectButton.hidden = NO;
        return;
    }
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0 - 20);
    self.selectButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.selectButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.selectButton setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.selectButton addTarget:self action:@selector(buttonClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:self.selectButton];
}

#pragma mark --ButtonClick
-(void)buttonClickWithButton:(UIButton *)button
{
    _selectView.isOpen = !_selectView.isOpen;
    if (_selectView.isOpen) {
        [self buttonAnimateMoveIn:button];
    }else
    {
        [self buttonAnimateMoveOut:button];
    }
    
}

#pragma mark --animate
- (void)buttonAnimateMoveIn:(UIButton *)button
{
    [UIView animateWithDuration: 0.3 animations: ^{
        button.center = CGPointMake(80, SCREEN_HEIGHT /2.0 - 20);
    } completion: nil];
}

- (void)buttonAnimateMoveOut:(UIButton *)button{
    [UIView animateWithDuration: 0.3 animations: ^{
        button.center = CGPointMake(SCREEN_WIDTH-20, SCREEN_HEIGHT /2.0 - 20);
    } completion: nil];
}


@end
