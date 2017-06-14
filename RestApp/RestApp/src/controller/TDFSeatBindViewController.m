//
//  TDFSeatBindViewController.m
//  RestApp
//
//  Created by Octree on 8/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSeatBindViewController.h"
#import "Seat.h"
#import "SeatType.h"
#import "UIViewController+HUD.h"
#import "BackgroundHelper.h"
#import "TDFQueueService.h"
#import "UIColor+Hex.h"
#import "TDFSeatBindTableViewCell.h"
#import "SeatRender.h"
#import "TDFQueueService.h"
#import "TDFSeatSelectViewController.h"
#import <YYModel/YYModel.h>

@interface TDFSeatBindViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SeatType *seatType;
@property (strong, nonatomic) NSArray *seats;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addButton;

@end

@implementation TDFSeatBindViewController

#pragma mark - Life Cycle

- (instancetype)initWithSeatType:(SeatType *)seatType {

    if (self = [super init]) {
        
        _seatType = seatType;
        NSParameterAssert(seatType);
        if (seatType.isLimit ==1) {
            self.title = [NSString stringWithFormat:NSLocalizedString(@"%@(%d人及以上)", nil), seatType.typeName, seatType.minNum];
        } else {
            self.title = [NSString stringWithFormat:NSLocalizedString(@"%@(%d-%d人)", nil), seatType.typeName, self.seatType.minNum,self.seatType.maxNum];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configViews];
    [self loadSeats];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadSeats)
                                                 name:@"SeatTypeBindChanged"
                                               object:nil];
}

#pragma mark - Methods

- (void)configViews {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.addButton];
    @weakify(self);
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-15);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
}

- (void)configNav {

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
    return;
}

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.seats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TDFSeatBindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFSeatBindTableViewCell" forIndexPath:indexPath];
    
    Seat *seat = self.seats[indexPath.row];
    cell.titleLabel.text = [seat obtainItemName];
    cell.detailLabel.text = [SeatRender seatDetailFormat:seat];
    cell.typeLabel.text = [SeatRender formatSeatKind:seat.seatKind];
    __weak __typeof(cell) wcell = cell;
    __weak __typeof(self) wself = self;
    cell.removeBlock = ^void() {
        
        __strong __typeof(wcell) scell = wcell;
        if (!scell) {
            
            return;
        }
        NSIndexPath *indexPath = [tableView indexPathForCell:scell];
        if (indexPath) {
            
            [wself removeSeatButtonTappedWithSeat:wself.seats[indexPath.row]];
        }
    };
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 102;
}

#pragma mark Action

- (void)addButtonTapped {

    TDFSeatSelectViewController *svc = [[TDFSeatSelectViewController alloc] initWithSeatType:self.seatType];
    [[self navigationController] pushViewController:svc animated:YES];
}

- (void)removeSeatButtonTappedWithSeat:(Seat *)seat {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)
                                                                 message:NSLocalizedString(@"确定要删除该桌位的排队类型匹配吗？", nil)
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    @weakify(self);
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self removeSeat:seat];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark Network


- (void)removeSeat:(Seat *)seat {
    
    [self showHUBWithText:NSLocalizedString(@"正在删除", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] removeBindSeatWithId:seat.seatMappingId
                                            seatTypeCode:self.seatType.seatType
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                     @strongify(self);
                                                     [self loadSeats];
                                                 }
                                                 failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                     @strongify(self);
                                                     [self dismissHUD];
                                                     [self showErrorMessage:error.localizedDescription];
                                                 }];
}


- (void)loadSeats {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] bindedSeatsWithTypeCode:self.seatType.seatType
                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                        
                                                        [self loadedSeatsWithData:data error:nil];
                                                    }
                                                    failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                        @strongify(self);
                                                        [self loadedSeatsWithData:nil error:error];
                                                    }];
}

- (void)loadedSeatsWithData:(NSDictionary *)data error:(NSError *)error {

    [self dismissHUD];
    if (error) {

        
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    self.seats = [NSArray yy_modelArrayWithClass:[Seat class] json:data[@"data"]];
    [self.tableView reloadData];
}



#pragma mark - Accessor

- (UIButton *)addButton {

    if (!_addButton) {
        
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"float_btb_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithHeX:0xaaaaaa];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TDFSeatBindTableViewCell class] forCellReuseIdentifier:@"TDFSeatBindTableViewCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

@end
