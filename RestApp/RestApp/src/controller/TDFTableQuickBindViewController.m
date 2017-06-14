//
//  TDFTableQuickBindViewController.m
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableQuickBindViewController.h"
#import "Seat.h"
#import "Area.h"
#import "BackgroundHelper.h"
#import <Masonry/Masonry.h>
#import "TDFTableAreaView.h"
#import "TDFTableCodeBindCell.h"
#import "SeatRender.h"
#import "UIColor+Hex.h"
#import "TDFDetailController.h"
#import "TDFScanViewController.h"
#import "TDFTableEditViewController.h"
#import "ServiceFactory.h"
#import "UIViewController+HUD.h"
#import "TDFSeatService.h"

@interface TDFTableQuickBindViewController ()<TDFScanViewControllerDelegate>

@property (copy, nonatomic) NSDictionary *seatMap;
@property (copy, nonatomic) NSArray *areas;

@property (strong, nonatomic) Seat *currentSeat;
@property (strong, nonatomic, readonly) TDFSeatService *service;

@property (strong, nonatomic) TDFScanViewController *scanController;

@end

@implementation TDFTableQuickBindViewController

- (instancetype)initWithSeatMap:(NSDictionary *)dictionary areas:(NSArray *)areas {

    if (self = [super init]) {
    
        self.seatMap = dictionary;
        self.areas = areas;
        _service = [[TDFSeatService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
    [self configHeaderView];
    self.title = NSLocalizedString(@"绑定桌位二维码", nil);
    [self.tableView registerClass:[TDFTableCodeBindCell class] forCellReuseIdentifier:@"TDFTableCodeBindCell"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seatDataChanged:)
                                                 name:@"SeatModule_Data_Change"
                                               object:nil];
}

- (void)configViews {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    self.tableView.backgroundView = imageView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)seatDataChanged:(NSNotification *)noti {

    NSMutableDictionary* dic = noti.object;
    self.areas = dic[@"head_list"];
    self.seatMap = dic[@"detail_map"];
    [self.tableView reloadData];
}

#pragma mark - Action

- (void)moreInfoButtonTapped {

    TDFDetailController *dvc = [[TDFDetailController alloc] initWithTitle:self.title content:NSLocalizedString(@"如果您已经有二维火提供的已打印好的二维码，在此处与对应桌进行绑定。\n方式一：先将二维码逐一贴在餐厅桌位上，再对应桌号进行绑定。\n方式二：先逐一绑定二维码，并在二维码背面记录相应的桌号，然后贴在对应的桌上。", nil)];
    [self presentViewController:dvc animated:YES completion:nil];
}

- (void)detailButtonTapped:(UIButton *)button {

    TDFTableCodeBindCell *cell = (TDFTableCodeBindCell *)[button superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Area *area = self.areas[indexPath.section];
    NSArray *arr = self.seatMap[area._id];
    Seat *seat = arr[indexPath.row];
    TDFTableEditViewController *tvc = [[TDFTableEditViewController alloc] initWithSeat:seat scrollToQRCode:YES];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)scanButtonTapped:(UIButton *)button {

    TDFTableCodeBindCell *cell = (TDFTableCodeBindCell *)[button superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Area *area = self.areas[indexPath.section];
    NSArray *arr = self.seatMap[area._id];
    self.currentSeat = arr[indexPath.row];
    
    if (self.currentSeat.count == 10) {
    
        [self showErrorMessage:NSLocalizedString(@"每个桌位最多绑定 10 个二维码", nil)];
        return;
    }
    
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"扫描二维码与桌位绑定", nil)
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                              }];
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"桌号：%@", nil), self.currentSeat.name];
    NSMutableAttributedString *sub = [[NSMutableAttributedString alloc] initWithString:string
                                                                            attributes:@{
                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:24]
                                                                                         }];
    
    [sub addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 3)];
    
    self.scanController = [[TDFScanViewController alloc] initWithTitle:NSLocalizedString(@"绑定桌位二维码", nil)
                                                                     subTitle:sub
                                                                       detail:detail];
    self.scanController.delegate = self;
    [self.navigationController pushViewController:self.scanController animated:YES];
}



#pragma mark - TDFScanViewControllerDelegate

- (void)scanViewController:(TDFScanViewController *)viewController didRecognize:(NSString *)text {

    [self bindQRCode:text];
}

#pragma mark Network

- (void)bindQRCode:(NSString *)code {
    
    [self.scanController showHUBWithText:NSLocalizedString(@"正在绑定", nil)];
    //[[self service] bindSeatCodeWithSeatCode:self.currentSeat.code shortURL:code target:self callback:@selector(bindQRCodeFinished:)];
    __weak __typeof(self) wself = self;
    [self.service bindSeatCodeWithSeatCode:self.currentSeat.code
                                  shortURL:code
                                    sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                        
                                        [wself bindQRCodeFinishedWithError:nil];
                                    }
                                   failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                       
                                       [wself bindQRCodeFinishedWithError:error];
                                   }];
}

- (void)bindQRCodeFinishedWithError:(NSError *)error {
    
    if (error) {
        
        [self.scanController dismissHUD];
        [self.scanController showError:error.localizedDescription duration:2.5];
        [self.scanController resume];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self showSuccessMessage:NSLocalizedString(@"绑定成功", nil) duration:2.3];
    self.scanController = nil;
    self.currentSeat.count += 1;
    
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setNeedUpdateSeats];
}


- (void)setNeedUpdateSeats {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TDFSeatChanged" object:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.areas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    Area *area = self.areas[section];
    NSArray *arr = self.seatMap[area._id];
    return [arr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFTableCodeBindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFTableCodeBindCell" forIndexPath:indexPath];

    Area *area = self.areas[indexPath.section];
    Seat *seat = [self.seatMap[area._id] objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@（%@）", nil), seat.name, [SeatRender seatDetailFormat:seat]];
    [cell.detailButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"已绑定%zd个二维码", nil), seat.count] forState:UIControlStateNormal];
    cell.detailButton.enabled = seat.count != 0;
    
//    [cell.detailButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
//    [cell.scanButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [cell.detailButton addTarget:self action:@selector(detailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.scanButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = 44;
    Area *area = self.areas[section];
    return [[TDFTableAreaView alloc] initWithFrame:frame title:area.name];
}

#pragma mark - 

//  config header

- (void)configHeaderView {
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = 185;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"shop_qrcode_logo"];
    
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView.mas_top).with.offset(10);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(57);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 4;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHeX:0x666666];
    label.text = NSLocalizedString(@"如果您已经有二维火提供的已打印好的二维码，在此处与对应桌进行绑定。\n方式一：先将二维码逐一贴在餐厅桌位上，再对应桌号进行绑定。方式二：先逐一绑定二维码，并在二维码背面记录相应的桌号，然后贴在对应的桌上。", nil);
    
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerView.mas_left).with.offset(10);
        make.right.equalTo(headerView.mas_right).with.offset(-10);
        make.top.equalTo(imageView.mas_bottom).with.offset(4);
        make.height.mas_equalTo(88);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitle:NSLocalizedString(@"查看详情", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"oct_detail_icon"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    button.transform = CGAffineTransformMakeScale(-1, 1);
    button.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    button.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    [button addTarget:self action:@selector(moreInfoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor colorWithHeX:0x0088CC];
    
    [headerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerView.mas_right).with.offset(-10);
        make.bottom.equalTo(headerView.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(13);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Accessor


@end
