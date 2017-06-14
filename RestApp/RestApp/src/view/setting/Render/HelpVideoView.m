//
//  HelpVideoView.m
//  RestApp
//
//  Created by 果汁 on 15/7/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HelpVideoView.h"
#import "SettingModule.h"

#import "SettingService.h"
#import "MBProgressHUD.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "SettingModuleEvent.h"
#import "RemoteEvent.h"
#import "NavigateTitle2.h"
#import "ItemEndNote.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "OpenTimePlanRender.h"
#import "GlobalRender.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "DateUtils.h"
#import "PairPickerBox.h"
#import "Platform.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "HelpVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayModel.h"
#import "UIViewController+Picker.h"

@interface HelpVideoView ()
{
    MPMoviePlayerViewController *playerController;
}

@end

@implementation HelpVideoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        service=[ServiceFactory Instance].settingService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.changed=NO;
    self.title = NSLocalizedString(@"帮助视频", nil);
    self.needHideOldNavigationBar = YES;
    [self mainView];
}

- (void)mainView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:footView];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (isnavigatemenupush) {
        isnavigatemenupush = NO;
        [parent backNavigateMenuView];
    }
    [parent backMenu];
}

- (NSMutableArray *)arrSection
{
    if (_arrSection == nil) {
        _arrSection = (NSMutableArray *)@[NSLocalizedString(@"重要设置", nil),NSLocalizedString(@"会员", nil),NSLocalizedString(@"商品与套餐", nil),NSLocalizedString(@"顾客端设置", nil),NSLocalizedString(@"智能点餐", nil),NSLocalizedString(@"传菜", nil),NSLocalizedString(@"基础信息", nil),NSLocalizedString(@"收银设置", nil),NSLocalizedString(@"挂账", nil),NSLocalizedString(@"其他工具", nil)];
    }
    return _arrSection;

}
- (NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
        NSArray *arr1 = @[NSLocalizedString(@"员工", nil),NSLocalizedString(@"桌位", nil),NSLocalizedString(@"付款方式", nil),NSLocalizedString(@"电子收款账户", nil)];
        NSArray *arr2 = @[NSLocalizedString(@"短信营销", nil),NSLocalizedString(@"优惠券", nil)];
        NSArray *arr3 = @[NSLocalizedString(@"商品与套餐", nil),NSLocalizedString(@"分类管理", nil),NSLocalizedString(@"商品备注", nil),NSLocalizedString(@"商品加料", nil),NSLocalizedString(@"商品做法", nil),NSLocalizedString(@"商品规格", nil),NSLocalizedString(@"商品促销", nil),NSLocalizedString(@"打折方案", nil)];
         NSArray *arr4 = @[NSLocalizedString(@"店家资料", nil),NSLocalizedString(@"店铺LOGO", nil),NSLocalizedString(@"店家二维码", nil),NSLocalizedString(@"本店销量榜", nil),NSLocalizedString(@"排队桌位类型", nil),NSLocalizedString(@"必选商品", nil),NSLocalizedString(@"黑名单", nil)];
        NSArray *arr5 = @[NSLocalizedString(@"一键智能点餐", nil),NSLocalizedString(@"用餐人数提醒与推荐", nil),NSLocalizedString(@"商品标签设置", nil)];
        NSArray *arr6 = @[NSLocalizedString(@"传菜方案", nil),NSLocalizedString(@"不出单商品", nil),NSLocalizedString(@"备用打印机", nil),NSLocalizedString(@"点菜单分区域打印", nil),NSLocalizedString(@"套餐中商品分类打印设置", nil)];
        NSArray *arr7 = @[NSLocalizedString(@"店家信息", nil),NSLocalizedString(@"营业结束时间", nil),NSLocalizedString(@"营业班次", nil)];
        NSArray *arr8 = @[NSLocalizedString(@"系统参数", nil),NSLocalizedString(@"收银打印", nil),NSLocalizedString(@"收银单据", nil),NSLocalizedString(@"客单备注", nil),NSLocalizedString(@"零头处理方式", nil),NSLocalizedString(@"附加费", nil),NSLocalizedString(@"特殊操作原因", nil)];
        NSArray *arr9 = @[NSLocalizedString(@"挂账设置", nil)];
        NSArray *arr10 = @[NSLocalizedString(@"更换排队机", nil),NSLocalizedString(@"营业数据清理", nil)];
        NSArray *array = @[arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8,arr9,arr10];
        _arr = [NSMutableArray arrayWithArray:array];
    }
    return _arr;

}
- (NSArray *)videoArr
{
    if (_videoArr == nil) {
        NSArray *arr1 = @[@"zhuowei5",@"yuangong5",@"fukuanfangshi5",@"dianzishoukuan5"];
        NSArray *arr2 = @[@"duanxinyingxiao5",@"youhuiquan4"];
        NSArray *arr3 = @[@"shangpintaocan5",@"fenleiguanli5",@"shangpinbeizhu5",@"shangpinjialiao5",@"shangpinzuofa5",@"shangpinguige5",@"shangpincuxiao4",@"dazhefangan4"];
        NSArray *arr4 = @[@"dianjiaziliao5",@"dianpuLOGO5",@"dianma5",@"xiaoliangbang5",@"paiduileixing5",@"bixuanshangpin5",@"heimingdan5"];
        NSArray *arr5 = @[@"yijianzhinengdiancan4",@"yongcanrenshutuijian4",@"shangpinbiaoqian4"];
        NSArray *arr6 = @[@"chuancaifangan5",@"buchudanshangpin5",@"beiyongdayinji5",@"fenquyudayin5",@"taocanfenleidayin5"];
        NSArray *arr7 = @[@"dianjiaxinxi5",@"yingyeshijian5",@"yingyebanci5"];
        NSArray *arr8 = @[@"xitongcanshu5",@"shouyindayin5",@"danjumoban5",@"kedanbeizhu5",@"lingtouchuli5",@"fujiafei5",@"teshucaozuo5"];
        NSArray *arr9 = @[@"guazhang5"];
        NSArray *arr10 = @[@"genghuanpaiduiji5",@"shujuqingli5"];
        _videoArr = @[arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8,arr9,arr10];
    }
    return _videoArr;
}
#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrSection = [self arr][section];
    return [arrSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    HelpVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HelpVideoViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lab.text = [self arr][indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view1.backgroundColor = [UIColor clearColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(50, 10, self.view.frame.size.width - 100, 20)];
    view2.backgroundColor = [UIColor blackColor];
    view2.alpha = 0.5;
    view2.layer.cornerRadius = 10;
    [view1 addSubview:view2];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.frame.size.width - 100, 20)];
    lab.text = self.arrSection[section];
    
    lab.font = [UIFont systemFontOfSize:14];
    
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [view1 addSubview:lab];
    return view1;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.videoArr[indexPath.section];
    if (indexPath.section > self.videoArr.count || indexPath.row > arr.count) {
        return;
    }
    _str = [NSString stringWithFormat:@"https://video.2dfire.com/bangzhu/video/%@.mp4",arr[indexPath.row]];
       NSString *result = [PlayModel getCurrntNet];
    if ([result isEqualToString: NSLocalizedString(@"无网络", nil)]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前网络不可用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
    if ([result isEqualToString:@"3g"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前不是Wi-Fi网络,确认继续播放吗?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alertView show];
    }
    if ([result isEqualToString:@"Wi-Fi"]) {
        [self videoPlayBegin];
     }
 }
- (void)videoPlayBegin
{
    playerController = [PlayModel createVideoPlay:_str WithVc:self.navigationController];
    playerController.view.transform = CGAffineTransformMakeRotation(M_PI *90/180);
    playerController.view.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:playerController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:playerController.moviePlayer];
}
- (void)moviePlayerDidFinish:(NSNotification *)notification
{
    MPMoviePlayerController* theMovie = [notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [playerController.view removeFromSuperview];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direct:kCATransitionFromLeft];
    
}
#pragma mark alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self videoPlayBegin];
        
    }
}

@end
