//
//  TDFSeatSelectViewController.m
//  RestApp
//
//  Created by Octree on 8/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSeatSelectViewController.h"
#import "Seat.h"
#import "SeatType.h"
#import "UIViewController+HUD.h"
#import "BackgroundHelper.h"
#import "TDFQueueService.h"
#import "UIColor+Hex.h"
#import "TDFSeatSelectTableViewCell.h"
#import "SeatRender.h"
#import "TDFQueueService.h"
#import "TDFTableAreaView.h"
#import "Area.h"
#import "YYModel.h"

@interface TDFSeatSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SeatType *seatType;
@property (strong, nonatomic) UITableView *tableView;


@property (copy, nonatomic) NSDictionary *seatMap;
@property (copy, nonatomic) NSArray *areas;

@end

@implementation TDFSeatSelectViewController

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
    [self loadUnbindedSeats];
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
}

- (void)configNav {
    
    if ([[self.tableView indexPathsForSelectedRows] count] == 0) {
        
        
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
    
    UIImage *cancelImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_cancel"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState: UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [cancelButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIImage *okImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_ok"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitle:NSLocalizedString(@"保存", nil) forState: UIControlStateNormal];
    [saveButton setImage:okImage forState:UIControlStateNormal];
    saveButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    saveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
}

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)selectedIds {

    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:indexPaths.count];
    
    for (NSIndexPath *indexPath in indexPaths) {
        Area *area = self.areas[indexPath.section];
        Seat *seat = [self.seatMap[area._id] objectAtIndex:indexPath.row];
        [array addObject:seat._id];
    }
    
    return [array componentsJoinedByString:@","];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.areas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Area *area = self.areas[section];
    NSArray *arr = self.seatMap[area._id];
    return [arr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFSeatSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFSeatSelectTableViewCell" forIndexPath:indexPath];
    
    Area *area = self.areas[indexPath.section];
    Seat *seat = [self.seatMap[area._id] objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [seat obtainItemName];
    cell.detailLabel.text = [SeatRender seatDetailFormat:seat];
    cell.typeLabel.text = [SeatRender formatSeatKind:seat.seatKind];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 102;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self configNav];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self configNav];
}

#pragma mark Action

- (void)cancelButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}


- (void)saveButtonTapped {
    
    @weakify(self);
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    [[[TDFQueueService alloc] init] saveBindSeatsWithIds:[self selectedIds]
                                            seatTypeCode:self.seatType.seatType
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                     @strongify(self);
                                                     [self dismissHUD];
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SeatTypeBindChanged" object:nil];
                                                 }
                                                  failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                     @strongify(self);
                                                     [self dismissHUD];
                                                     [self showErrorMessage:error.localizedDescription];
                                                 }];
}

#pragma mark Network


- (void)loadUnbindedSeats {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    __typeof(self) wself = self;
    [[[TDFQueueService alloc] init] unbindedSeatsWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        __strong __typeof(wself) sself = wself;
        [sself dismissHUD];
        
        if (!sself) return;
        
        NSArray *areaArr = [data valueForKey:@"data"];
        
        NSMutableArray *areas = [NSMutableArray array];
        NSMutableDictionary *seatMap = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in areaArr) {
            
            Area *area = [Area yy_modelWithDictionary:dict[@"area"]];
            [areas addObject:area];
            NSArray *seats = [NSArray yy_modelArrayWithClass:[Seat class] json:dict[@"seats"]];
            seatMap[area._id] = seats;
        }
        
        wself.areas = areas;
        wself.seatMap = seatMap;
        [wself.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself dismissHUD];
        [wself showErrorMessage:[error localizedDescription]];
    }];
}


- (void)bindSeatsWithIds:(NSArray *)ids {

    
}

#pragma mark - Accessor


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithHeX:0xaaaaaa];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TDFSeatSelectTableViewCell class] forCellReuseIdentifier:@"TDFSeatSelectTableViewCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.allowsMultipleSelection = YES;
    }
    
    return _tableView;
}

@end
