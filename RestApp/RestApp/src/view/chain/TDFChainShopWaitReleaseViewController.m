//
//  TDFChainShopWaitReleaseViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainShopWaitReleaseViewController.h"
#import "TDFChainMenuService.h"
#import "ColorHelper.h"
#import "ObjectUtil.h"
#import "DateUtils.h"
#import "TDFPlatePublishVo.h"
#import "NSString+Estimate.h"
#import "NavigationToJump.h"
#import "Masonry.h"
#import "UIHelper.h"
#import "AlertBox.h"

@interface TDFChainShopWaitReleaseViewController ()<UIAlertViewDelegate>
@property (nonatomic ,strong) UILabel *publishDateLbl;
@property (nonatomic, strong) id <NavigationToJump> delegate;
@property (nonatomic ,strong) TDFPlatePublishVo *vo;
@end

@implementation TDFChainShopWaitReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  NSLocalizedString(@"等待发布", nil);
    [self initMainView];
    [self getPlatesData];
}

- (void)initMainView
{
    UIView *bgView  = [[UIView  alloc] init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha =0.7 ;
    [self customView];
    
}

- (void)customView
{
    UIImageView  *imagPic   =  [[UIImageView alloc] init];
    [self.view addSubview:imagPic];
    [imagPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo (self.view.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    imagPic.image  = [UIImage imageNamed:@"shalou"];
    UILabel *statusLbl  = [[UILabel  alloc] init];
    [self.view addSubview:statusLbl];
    [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.top.equalTo(imagPic.mas_bottom).with.offset(20);
        make.size.mas_equalTo (CGSizeMake(160, 20));
    }];
    statusLbl.textColor  =  RGBA(236, 111, 35, 1);
    statusLbl.font = [UIFont boldSystemFontOfSize:22];
    statusLbl.text  = NSLocalizedString(@"即将发布到门店", nil);
    statusLbl.textAlignment  =NSTextAlignmentCenter;
   self.publishDateLbl = [[UILabel  alloc] init];
    [self.view addSubview:self.publishDateLbl];
    [self.publishDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo (statusLbl.mas_bottom).with.offset(10);
        make.size.mas_equalTo (CGSizeMake(300, 15));
    }];
    self.publishDateLbl.textColor  = RGBA(236, 111, 35, 1);
   self.publishDateLbl.font  = [UIFont systemFontOfSize:16];
    self.publishDateLbl.text  = @"";
   self.publishDateLbl.textAlignment  =NSTextAlignmentCenter;
    
    UIView *line  =  [[UIView alloc] init];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.view.mas_left).with.offset(10);
        make.top.equalTo (self.publishDateLbl.mas_top).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-10*2, 1));
    }];
    line.backgroundColor  = [UIColor  lightGrayColor];
    line.alpha =0.7;
    
    UILabel *remarkLbl  =  [[UILabel  alloc] init];
    [self.view addSubview:remarkLbl];
    [remarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo (line.mas_bottom).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(self.view.frame.size.width -10*2, 40));
    }];
    remarkLbl.textColor  = [UIColor grayColor];
    remarkLbl.font = [UIFont systemFontOfSize:13];
    remarkLbl.text = NSLocalizedString(@"注：到发布日期商品会自动更新到门店。发布成功后，请提醒门店重启收银机或点击数据更新按钮。", nil);
    remarkLbl.numberOfLines = 0;
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view  addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(remarkLbl.mas_bottom).with.offset(20);
        make.size.mas_equalTo (CGSizeMake(self.view.frame.size.width - 30, 40));
    }];
    bottomButton.backgroundColor = [ColorHelper getRedColor];
    bottomButton.layer.cornerRadius = 5;
    [bottomButton setTitle:NSLocalizedString(@"取消发布", nil) forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomButton addTarget:self action:@selector(cancelPublish:) forControlEvents:UIControlEventTouchUpInside];
}

//传值数据
- (void)getPlatesData
{
    if ([ObjectUtil isNotEmpty:self.dataDic]) {
        self.vo  = self.dataDic [@"data"];
        self.delegate  =  self.dataDic [@"delegate"];
       [self fillIteamWithData:self.vo];
    }
}

- (void)fillIteamWithData:(TDFPlatePublishVo *)data
{
    NSString *dateStr   = [NSString stringWithFormat:@"%@ %@",[DateUtils formatTimeWithTimestamp:data.publishDate*1000 type:TDFFormatTimeTypeChinese],data.timeInterval];
    self.publishDateLbl.text  = [NSString stringWithFormat:NSLocalizedString(@"发布日期:%@", nil),dateStr];
}

//取消按钮
- (void)cancelPublish:(UIButton *)button
{
    UIAlertView *alter   = [[UIAlertView  alloc] initWithTitle:@"" message:NSLocalizedString(@"确定要取消本次发布计划吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self cancelCurrentPublish];
    }
  
}
//判断时候允许取消
- (void)cancelCurrentPublish
{
    [UIHelper showHUD:NSLocalizedString(@"正在处理", nil) andView:self.view andHUD: self.progressHud ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    if ([NSString isNotBlank:self.vo.publishPlanId]) {
        [parma setObject:self.vo.publishPlanId forKey:@"publish_plan_id"];
    }
    @weakify(self);
    [[TDFChainMenuService new]  chainCancelPublish:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        if (self.delegate ) {
            [self.delegate navitionToPushBeforeJump:nil data:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

@end
