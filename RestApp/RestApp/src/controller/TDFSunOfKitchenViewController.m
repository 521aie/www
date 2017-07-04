//
//  TDFSunOfKitchenViewController.m
//  RestApp
//
//  Created by suckerl on 2017/6/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSunOfKitchenViewController.h"
#import "UIColor+Hex.h"
#import "AFNetworkReachabilityManager.h"
#import "TDFSunOfKitchenVideoController.h"
#import "TDFSunOfKitchenCell.h"
#import "TDFSunofKitchenService.h"
#import "YYModel.h"
#import "sunofKitchenVo.h"
#import "AFNetworkReachabilityManager.h"

@interface TDFSunOfKitchenViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *iconInHeaderView;
@property (nonatomic,strong) UILabel *contentLabelInHeaderView;
@property (nonatomic,strong) NSMutableArray *itemsArry;
@property (nonatomic,strong) NSMutableArray *detailArry;
@property (nonatomic,strong) UILabel *noticeLabel;
//保存url地址
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *areaName;

@end

static NSString *cellId = @"TDFSunOfKitchenCell";

@implementation TDFSunOfKitchenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - 
- (void)loadListData {
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFSunofKitchenService alloc] init] getlistSunofKitchenWithSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
       [self.progressHud setHidden:YES];
        
        self.itemsArry = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[sunofKitchenVo class] json:data[@"data"]]];
        
        if (self.itemsArry!=nil && self.itemsArry.count>0) {
            self.noticeLabel.hidden = YES;
        }else {
            self.noticeLabel.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"阳光厨房", nil);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noticeLabel];
    self.noticeLabel.hidden = YES;
    [_tableView registerClass:[TDFSunOfKitchenCell class] forCellReuseIdentifier:cellId];
    [self constructLayout];
}

- (void)constructLayout {
    [self.iconInHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableHeaderView.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.top.equalTo(_tableHeaderView.mas_top).with.offset(10);
    }];
    [self.contentLabelInHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableHeaderView.mas_bottom).with.offset(-10);
        make.left.equalTo(_tableHeaderView.mas_left).with.offset(10);
        make.right.equalTo(_tableHeaderView.mas_right).with.offset(-10);
        make.top.equalTo(self.iconInHeaderView.mas_bottom).with.offset(10);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.top.equalTo(_tableHeaderView.mas_bottom).with.offset(150);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    view.backgroundColor = [UIColor clearColor];;
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 133;
//    }else {
//        return 0;
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFSunOfKitchenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    sunofKitchenVo *vo = self.itemsArry[indexPath.row];
    cell.zoneName = vo.areaName;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    sunofKitchenVo *vo = self.itemsArry[indexPath.row];
    self.videoUrl = vo.videoUrl;
    self.areaName = vo.areaName;
    
    BOOL reachableViaWiFi = [self isNetWorking]; //wifi环境
    if (reachableViaWiFi) {
        [self playVideoDetail:vo.videoUrl andTitle:vo.areaName];
    }
}

#pragma mark - 判断当前网络环境
- (BOOL)isNetWorking {
    BOOL isExistenceNetwork = YES;
    switch ([[AFNetworkReachabilityManager manager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusNotReachable:{
            isExistenceNetwork = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:^{
            }];
            
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            isExistenceNetwork = YES;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            isExistenceNetwork = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用运营商网络，查看视频将消耗大量流量，强烈建议您连接wifi后再进行查看！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *goOn = [UIAlertAction actionWithTitle:@"继续查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self playVideoDetail:self.videoUrl andTitle:self.areaName];
            }];
            [alert addAction:cancle];
            [alert addAction:goOn];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            break;
        }
        default:
            break;
    }
    return isExistenceNetwork;
}

#pragma mark - 播放URL
//- (void)playVideoDetail:(NSString*)urlStr {
//    TDFSunOfKitchenVideoController *videoVC = [[TDFSunOfKitchenVideoController alloc] init];
//    videoVC.videoURL = urlStr;
//    [self.navigationController showViewController:videoVC sender:nil];
//}

- (void)playVideoDetail:(NSString*)urlStr andTitle:(NSString*)areaName {
    TDFSunOfKitchenVideoController *videoVC = [[TDFSunOfKitchenVideoController alloc] init];
    videoVC.videoURL = urlStr;
    videoVC.areaName = areaName;
    [self.navigationController showViewController:videoVC sender:nil];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque = YES;
        _tableView.rowHeight = 46;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 133)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        UIView *view =[[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.7;
        [_tableHeaderView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableHeaderView.mas_top);
            make.left.right.equalTo(_tableHeaderView);
            make.bottom.equalTo(_tableHeaderView.mas_bottom).offset(-1);
        }];
        [_tableHeaderView addSubview:self.iconInHeaderView];
        [_tableHeaderView addSubview:self.contentLabelInHeaderView];
    }
    return _tableHeaderView;
}

- (UIImageView *)iconInHeaderView {
    if(!_iconInHeaderView) {
        _iconInHeaderView =[[UIImageView alloc] init];
        _iconInHeaderView.image =[UIImage imageNamed:@"ico_sunOfKitchen"];
        _iconInHeaderView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _iconInHeaderView.layer.masksToBounds =YES;
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
        _contentLabelInHeaderView.textColor = [UIColor colorWithHexString:                                                               @"#333333"];
        _contentLabelInHeaderView.text = NSLocalizedString(@"您可以在这里查看本店厨房的监控视频，掌握厨房最新动态。", nil);
    }
    return _contentLabelInHeaderView;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"暂无监控视频";
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.backgroundColor = [UIColor clearColor];
        _noticeLabel.textColor = [UIColor whiteColor];
    }
    return  _noticeLabel;
}



@end
