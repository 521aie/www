//
//  TDFHealthCheckAlertViewController.m
//  RestApp
//
//  Created by xueyu on 2016/12/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "AlertBox.h"
#import "PlayModel.h"
#import "XHAnimalUtil.h"
#import "TDFMediator+EvaluateModule.h"
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>
#import "TDFHealthTitleView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TDFHealthCheckVideoCell.h"
#import "TDFHealthCheckCycleCell.h"
#import "TDFHealthCheckImageCell.h"
#import "TDFHealthCheckSchemeCell.h"
#import "TDFHealthCheckDetailHeader.h"
#import "TDFHealthCheckBarChartCell.h"
#import "TDFHealthCheckSinglePieCell.h"
#import "TDFHealthCheckInspectorCell.h"
#import "TDFHealthCheckTextModel.h"
#import "TDFHealthCheckDetailModel.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckItemHeaderModel.h"
#import "TDFHealthCheckAlertViewController.h"
#import "TDFSwitchTool.h"
#import "TDFFunctionVo.h"
#import "MobClick.h"
#import "TDFHealthCheckScanView.h"
#import "UIColor+Hex.h"
#import "TDFPermissionHelper.h"
#import "TDFIsOpen.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface TDFHealthCheckAlertViewController() <TDFHealthCheckSchemeCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSDictionary *classDatas;
@property (nonatomic, strong) MPMoviePlayerViewController *playerController;
@property (nonatomic, assign) BOOL isNeedHidden;
@end

@implementation TDFHealthCheckAlertViewController

#pragma mark life cycle
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self configViews];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isNeedHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
#pragma mark layout
-(void)configViews{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    
    UIImageView *bigImg= ({
        UIImageView *view = [UIImageView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.image = self.backImage;
        view;
    });
    
    UIView *back= ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            
        }];
        view.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];;
        view;
    });
    
//    UIView *backView= ({
//        UIView *view = [UIView new];
//        [self.view addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(0.95 * SCREENWIDTH, 0.75*SCREENHEIGHT));
//            make.center.equalTo(self.view);
//        }];
//        view.layer.cornerRadius = 12;
//        view.clipsToBounds = YES;
//        view;
//    });
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.tableView= ({
        UITableView *view = [[UITableView alloc]init];
        [backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.95 * SCREENWIDTH, 0.75*SCREENHEIGHT));
            make.top.equalTo(backView.mas_top);
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_right);
        }];
        view.bounces = NO;
        view.delegate = self;
        view.dataSource = self;
        view.layer.cornerRadius = 12;
        view.clipsToBounds = YES;
        view.showsVerticalScrollIndicator = NO;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        view;
    });
 
    UIButton *cancleBtn= ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).offset(10);
            make.centerX.equalTo(self.tableView);
            make.bottom.equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        view.layer.cornerRadius = 12;
        view.clipsToBounds = YES;
        [view setImage:[UIImage imageNamed:@"ico_checkalert_close"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
#pragma clang diagnostic pop
}


#pragma mark - tableView view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.detailModel.components ? self.detailModel.components.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFHealthCheckItemBodyModel *model = self.detailModel.components[indexPath.row];
    Class cls =  NSClassFromString(self.classDatas[[NSString stringWithFormat:@"%ld",model.type]]) ;
    NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName(cls)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([cell respondsToSelector:@selector(cellLoadData:)]) {
        [cell performSelector:@selector(cellLoadData:) withObject:model];
    }
    if ([cell isKindOfClass:[TDFHealthCheckSchemeCell class]]) {
        TDFHealthCheckSchemeCell *schemeCell = (TDFHealthCheckSchemeCell *)cell;
        schemeCell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    TDFHealthCheckScanView *header = [TDFHealthCheckScanView new];
    header.backgroundColor = [UIColor whiteColor];
    header.headerModel = self.detailModel.header;
    UIView *line = [UIView new];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-10);
        make.left.equalTo(header).offset(10);
        make.bottom.equalTo(header);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDFHealthCheckItemBodyModel *model = self.detailModel.components[indexPath.row];
    Class cls = NSClassFromString(self.classDatas[[NSString stringWithFormat:@"%ld",model.type]]);
    if ([cls respondsToSelector:@selector(heightForCellAtIndexPath:model:)]) {
        return [cls heightForCellAtIndexPath:tableView model:model];
    }
    return 0;
}
#pragma mark TDFXXXDelegate
-(void)didSelectCellWithData:(id)data{
    if([data isKindOfClass:[TDFHealthCheckBtnModel class]]){
        TDFHealthCheckBtnModel *btnModel = (TDFHealthCheckBtnModel *)data;
        TDFFunctionVo *funcVo;
        for (TDFFunctionVo *vo in [Platform Instance].allModuleChargeList) {
            if ([vo.actionCode isEqualToString:btnModel.actionCode]) {
                funcVo = vo;
            }
        }
//        TDFFunctionVo *funcVo = [TDFSwitchTool switchTool].codeWithFunctionVoDic[btnModel.actionCode];
        [MobClick event:@"click_exam_item_detail_icon" attributes:@{@"click_exam_item_detail_icon_name":funcVo.actionName?funcVo.actionName:@""}];
        if (funcVo.isLock && funcVo) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有使用[%@]的权限", nil),btnModel.actionName]];
        }else if(!funcVo.isOpen && funcVo){
            if ([[Platform Instance] isBranch]) {
                [AlertBox show:NSLocalizedString(@"连锁总部尚未开通企业连锁管理，分公司功能无法使用。", nil)];
            }else{
                [TDFIsOpen goToModuleDetailViewController:funcVo];
            }
            return;
        }else{
            NSArray *moduleChargeDeniedList = [[TDFPermissionHelper sharedInstance] allModuleChargeList];
            NSArray *roleAllowedList = [[TDFPermissionHelper sharedInstance] notLockedActionCodeList];
            [[TDFSwitchTool switchTool] pushViewControllerWithCode:btnModel.actionCode andObject:roleAllowedList andObject:moduleChargeDeniedList withViewController:self ];}
    } else if ([data isKindOfClass:[TDFHealthCheckVideoModel class]]){
        TDFHealthCheckVideoModel *video = (TDFHealthCheckVideoModel *)data;
        if (video.type == 1) {
            [self netWorkState:video.videoUrl];
        }else if (video.type == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:video.videoUrl]];
        }
    }
}

#pragma mark media player
-(void)playWithURL:(NSString *)urlString{

    _playerController = [PlayModel createVideoPlay:urlString WithVc:self];
    [self.view addSubview:_playerController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_playerController.moviePlayer];
  
}

-(void)netWorkState:(NSString *)urlString{
    NSString *result = [PlayModel getCurrntNet];
   if ([result isEqualToString: NSLocalizedString(@"无网络", nil)]) {
        UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前网络不可用", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleBtn = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [alerVc addAction:cancleBtn];
        [self presentViewController:alerVc animated:YES completion:nil];
    }else if ([result isEqualToString:@"3g"]) {
        UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"当前不是Wi-Fi网络,确认继续播放吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleBtn = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self playWithURL:urlString];
        }];
        [alerVc addAction:cancleBtn];
        [alerVc addAction:confirmBtn];
        [self presentViewController:alerVc animated:YES completion:nil];
    }  else if ([result isEqualToString:@"Wi-Fi"]) {
        [self playWithURL:urlString];
    }

}


/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
- (void)moviePlayerDidFinish:(NSNotification *)notification
{
    MPMoviePlayerController* theMovie = [notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [_playerController.view removeFromSuperview];
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
    
}

#pragma mark private method

-(void)dismiss{
    self.isNeedHidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark getter setter
-(NSArray *)datas{
    if (!_datas) {
        _datas = [[NSArray alloc]init];
    }
    return _datas;
}

-(NSDictionary *)classDatas{
    if (!_classDatas) {
        _classDatas = @{@"0":@"TDFHealthCheckInspectorCell",
                        @"1":@"TDFHealthCheckLineCircleCell",
                        @"2":@"TDFHealthCheckLinePieCell",
                        @"3":@"TDFHealthCheckBarListCell",
                        @"4":@"TDFHealthCheckLineImageCell",
                        @"5":@"TDFHealthCheckSchemeCell",
                        @"6":@"TDFHealthCheckLineChartCell"
};
    }
    return _classDatas;
}


@end
