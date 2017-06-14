//
//  TDFTableEditViewController.m
//  RestApp
//
//  Created by Octree on 29/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableEditViewController.h"
#import "Seat.h"
#import "Area.h"
#import <Masonry/Masonry.h>
#import "TDFTextfieldCell.h"
#import "TDFPickerCell.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"
#import "TDFTextfieldCell.h"
#import "TDFPickerItem.h"
#import "TDFLabelCell.h"
#import "TDFLabelItem.h"
#import "TDFItemChainable.h"
#import "BackgroundHelper.h"
#import "KabawService.h"
#import "SeatRender.h"
#import "TDFShowPickerStrategy.h"
#import "MBProgressHUD.h"
#import "TDFTableQRCodeView.h"
#import "TDFScanViewController.h"
#import "UIViewController+HUD.h"
#import "TDFQRCode.h"
#import "UIColor+Hex.h"
#import "TDFSeatService.h"
#import "ServiceFactory.h"
#import "TDFPAShowManagerStrategy.h"
#import "TDFMediator+SeatModule.h"
#import "NameItemVO.h"

@interface TDFTableEditViewController ()<TDFQRCodeBindViewDelegate, TDFScanViewControllerDelegate>

@property (strong, nonatomic) UIImageView *backgroundView;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TDFPickerItem *areaPickerItem;
@property (strong, nonatomic) TDFTextfieldItem *nameItem;
@property (strong, nonatomic) TDFTextfieldItem *codeItem;
@property (strong, nonatomic) TDFPickerItem *typePickerItem;
@property (strong, nonatomic) TDFTextfieldItem *countItem;

@property (strong, nonatomic) DHTTableViewManager *manager;


@property (strong, nonatomic) NSMutableArray *areaList;
@property (strong, nonatomic) TDFPAShowManagerStrategy *areaStrategy;
@property (strong, nonatomic) TDFShowPickerStrategy *typeStrategy;
@property (strong, nonatomic) Seat *tempSeat;


@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) TDFTableQRCodeView *footerView;

@property (nonatomic) BOOL scrollToQRCode;
@property (nonatomic, readonly) TDFSeatService *service;


@property (strong, nonatomic) TDFQRCode *seatCode;
@property (copy, nonatomic) NSArray *bindCodes;


@property (strong, nonatomic) TDFScanViewController *scanViewController;
@property (nonatomic, getter=isBindingQRCode) BOOL bindingQRCode;

@end

@implementation TDFTableEditViewController

#pragma mark - Life Cycle

- (instancetype)initWithSeat:(Seat *)seat scrollToQRCode:(BOOL)flag {

    if (self = [super init]) {
    
        _seat = seat;
        _scrollToQRCode = flag;
        _service = [[TDFSeatService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
    [self configManager];
    [self loadArea];
    [self updateViews];
    [self updateFooterView];
    [self.footerView.qrcodeSwitchButton addTarget:self action:@selector(qrcodeSwitchCodeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView.deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.footerView.bindView.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self loadQRCodeInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.scrollToQRCode) {
    
        CGFloat offset = self.footerView.frame.origin.y
                        + self.footerView.qrcodeSwitchButton.frame.origin.y
                        + self.footerView.qrcodeSwitchButton.frame.size.height;
        CGFloat max = self.tableView.contentSize.height - self.tableView.frame.size.height;
        offset = offset < max ? offset : max;
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
        self.scrollToQRCode = NO;
    }
}

- (Area *)areaForId:(NSString *)areaId {

    for (Area *area in self.areaList) {
    
        if ([area._id isEqualToString:areaId]) {
        
            return area;
        }
    }
    
    return nil;
}

- (void)updateViews {

    NSString *areaName = [[self areaForId:self.seat.areaId] name];
    self.areaPickerItem.tdf_preValue(areaName).tdf_textValue(areaName)
    .tdf_requestValue(self.seat.areaId);
    self.nameItem.tdf_preValue(self.seat.name).tdf_textValue(self.seat.name);
    self.codeItem.tdf_preValue(self.seat.code).tdf_textValue(self.seat.code);
    
    NSString *typeName = [SeatRender formatSeatKind:(int)self.seat.seatKind];
    self.typePickerItem.tdf_preValue(typeName).tdf_textValue(typeName).tdf_requestValue([NSString stringWithFormat:@"%zd", (int)self.seat.seatKind]);
    
    NSString *string = [NSString stringWithFormat:@"%zd", self.seat.adviseNum];
    self.countItem.tdf_preValue(string).tdf_textValue(string);
    self.title = self.seat.name;
    [[self manager] reloadData];
}





#pragma mark - Methods

- (void)configManager {

    [self.manager addSection:[self section]];
}

- (DHTTableViewSection *)section {

    DHTTableViewSection *section = [[DHTTableViewSection alloc] init];
    
    [section addItem:self.areaPickerItem];
    [section addItem:self.nameItem];
    [section addItem:self.codeItem];
    [section addItem:self.typePickerItem];
    [section addItem:self.countItem];
    
    return section;
}


- (void)configViews {

    __weak __typeof(self) wself = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wself.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(wself.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}



- (void)updateFooterView {

    self.footerView.seatCode = self.seatCode;
    self.footerView.bindView.qrcodePresenters = self.bindCodes;
    self.footerView.qrcodeMaskView.hidden = self.seatCode.isValid;
    if (self.seatCode.isValid) {
    
        self.footerView.qrcodeSwitchButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        [self.footerView.qrcodeSwitchButton setTitle:NSLocalizedString(@"停用此二维码", nil) forState:UIControlStateNormal];
    } else {
    
        self.footerView.qrcodeSwitchButton.backgroundColor = [UIColor colorWithHeX:0x07AD1F];
        [self.footerView.qrcodeSwitchButton setTitle:NSLocalizedString(@"恢复使用此二维码", nil) forState:UIControlStateNormal];
    }
    
    [self.footerView reloadData];
    self.tableView.tableFooterView = self.footerView;
}


- (void)loadArea {
    
//    [[[ServiceFactory Instance] seatService] listArea:@"false" target:self Callback:@selector(loadAreaFinsh:)];
    __weak __typeof(self) wself = self;
    [self.service areasWithSaleOutFlag:@"false" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself loadAreaFinshError:nil obj:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wself loadAreaFinshError:error obj:nil];
    }];
}

- (void)loadAreaFinshError:(NSError *)error obj:(id)obj {
    
    [self dismissHUD];
    if (error) {
        [AlertBox show:[error localizedDescription]];
        return;
    }
    
    self.areaList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    self.areaStrategy.pickerItemList = self.areaList;
    for (Area *area in self.areaList) {
        if ([area._id isEqualToString:self.seat.areaId]) {
            self.areaStrategy.selectedItem = area;
            break;
        }
    }
    
    [self updateViews];
}

- (void)showMessage:(NSString *)message {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [avc addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (BOOL)valueChanged {

    return self.nameItem.isShowTip || self.codeItem.isShowTip || self.countItem.isShowTip || self.typePickerItem.isShowTip || self.areaPickerItem.isShowTip;
}


- (void)updateNavigationButtonIfNeeded {

    if (![self valueChanged]) {
    
        self.navigationItem.leftBarButtonItem = nil;
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

- (void)updateNavigationBar {

    __weak __typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [wself updateNavigationButtonIfNeeded];
    });
}

#pragma mark - Delegate

#pragma mark TDFQRCodeBindViewDelegate

- (void)qrcodeBindViewAddButtonTapped:(TDFQRCodeBindView *)view {

    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"扫描二维码与桌位绑定", nil)
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                              }];
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"桌号：%@", nil), self.seat.name];
    NSMutableAttributedString *sub = [[NSMutableAttributedString alloc] initWithString:string
                                                                            attributes:@{
                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:24]
                                                                                         }];
    
    [sub addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 3)];
    
    self.scanViewController = [[TDFScanViewController alloc] initWithTitle:NSLocalizedString(@"绑定桌位二维码", nil)
                                                                     subTitle:sub
                                                                       detail:detail];
    self.scanViewController.delegate = self;
    [self.navigationController pushViewController:self.scanViewController animated:YES];
}


- (void)qrcodeBindView:(TDFQRCodeBindView *)view deleteButtonTappedAtIndex:(NSInteger)index {

    [self unbindQRCode:self.bindCodes[index]];
}

- (void)setNeedUpdateSeats {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"TDFSeatChanged" object:nil];
}

#pragma mark TDFScanViewControllerDelegate

- (void)scanViewController:(TDFScanViewController *)viewController didRecognize:(NSString *)text {

    [self bindQRCode:text];
}


#pragma mark - Action

- (void)deleteButtonTapped {

    __weak __typeof(self) wself = self;
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.seat.name]
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself delete];
    }]];
    
    [self presentViewController:avc animated:YES completion:nil];
}



- (void)qrcodeSwitchCodeTapped {

    if (self.seatCode.isValid) {
    
        [self deactiveQRCode];
    } else {
    
        [self activeQRCode];
    }
}


#pragma mark delete

- (void)delete {

    [self showHUBWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.seat.name]];
//    [[[ServiceFactory Instance] seatService] removeSeat:self.seat._id Target:self Callback:@selector(delFinish:)];
    __weak __typeof(self) wslef = self;
    [[[TDFSeatService alloc] init] removeSeatsWithIds:@[ self.seat._id ] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wslef delFinish:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [wslef delFinish:error];
    }];
    
}

- (void)delFinish:(NSError *)error {
    [self dismissHUD];
    
    if (error) {
    
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    
    [self setNeedUpdateSeats];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark cancel & save


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

    NSError *error = nil;
    Seat *seat = [self seatToUpdate:&error];
    if (error) {
    
        [self showMessage:error.localizedDescription];
        return;
    }
    
    [self saveSeat:seat];
}


- (Seat *)seatToUpdate:(NSError **)error {

    self.tempSeat = nil;
    if (self.areaPickerItem.textValue.length == 0) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"请选择区域!", nil)}];
    } else if (self.nameItem.textValue.length == 0) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"桌位名称不能为空!", nil)}];
    }
    else if (self.codeItem.textValue.length == 0) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"桌位编码不能为空,且只能是数字和英文字母!", nil)}];
    } else if ([self.typePickerItem.requestValue length] == 0) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"请选择桌位类型!", nil)}];
    } else if([self.countItem.textValue length] == 0) {
    
        *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"建议人数不能为空,且只能是大于0的数字!", nil)}];
    } else {
        if (self.nameItem.textValue.length > 0)
        {
            unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            if ([self.nameItem.textValue dataUsingEncoding:encode].length > 12) {
                *error = [NSError errorWithDomain:@"com.2dfire.form.empty" code:4004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"桌位名称不能超过12个字符!", nil)}];
            }else{
                self.tempSeat = [self.seat copy];
                self.tempSeat.areaId = self.areaPickerItem.requestValue;
                self.tempSeat.name = self.nameItem.textValue;
                self.tempSeat.code = self.codeItem.textValue;
                self.tempSeat.seatKind = [self.typePickerItem.requestValue integerValue];
                self.tempSeat.adviseNum = [self.countItem.textValue intValue];
                self.tempSeat._id = self.seat._id;
                self.tempSeat.sortCode = self.seat.sortCode;
            }
        }
    }
    
    return self.tempSeat;
}

- (void)updateLocalSeat {

    self.seat.areaId = self.tempSeat.areaId;
    self.seat.name = self.tempSeat.name;
    self.seat.code = self.tempSeat.code;
    self.seat.seatKind = self.tempSeat.seatKind;
    self.seat.adviseNum = self.tempSeat.adviseNum;
}


- (void)saveSeat:(Seat *)seat {

    [self.view addSubview:self.hud];
    [self.hud show:YES];
//    [[[ServiceFactory Instance] seatService] updateSeat:seat Target:self Callback:@selector(saveFinsh:)];
    __typeof(self) __weak wself = self;
    
    [[self service] updateSeatWithParam:[seat yy_modelToJSONObject] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        [wself saveFinsh:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
        [wself saveFinsh:error];
    }];
}

-(void)saveFinsh:(NSError *)error {
    [self.hud hide:YES];
    
    if (error) {
        [self showMessage:error.localizedDescription];
        return;
    }
    
    [self updateLocalSeat];
    [self updateViews];
    [self updateNavigationBar];
    [self setNeedUpdateSeats];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Networking

- (void)loadQRCodeInfo {
    
    if (!self.isBindingQRCode) {
    
        [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    }
    
    //[self.service seatQRCodeForSeatWithCode:self.seat.code target:self callback:@selector(didLoadCodeInfo:)];
    
    __weak __typeof(self) wself = self;
    [self.service seatQRCodeForSeatWithCode:self.seat.code
                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                         
                                         [wself didLoadCodeInfoWithObj:data error:nil];
                                     }
                                    failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                        
                                        [wself didLoadCodeInfoWithObj:nil error:error];
                                    }];
}

- (void)didLoadCodeInfoWithObj:(id)obj error:(NSError *)error {

    if (!self.isBindingQRCode) {
    
        [self dismissHUD];
    }
    
    if (error) {
    
        [self showErrorMessage:error.localizedDescription];
        return;
    }

    NSDictionary *dict = [obj objectForKey:@"data"];
    self.seatCode = [TDFQRCode yy_modelWithDictionary:dict[@"seatQrcodeVo"]];
    self.bindCodes = [NSArray yy_modelArrayWithClass:[TDFQRCode class] json:dict[@"bindQrcodeVoList"]];
    [self updateFooterView];
    if (self.isBindingQRCode) {
    
        self.bindingQRCode = NO;
        [self showBindingSuccessInfo];
    }
}

- (void)bindQRCode:(NSString *)code {

    [self.scanViewController showHUBWithText:NSLocalizedString(@"正在绑定", nil)];
    //[[self service] bindSeatCodeWithSeatCode:self.seat.code shortURL:code target:self callback:@selector(bindQRCodeFinished:)];
    __weak __typeof(self) wself = self;
    [self.service bindSeatCodeWithSeatCode:self.seat.code shortURL:code
                                    sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                        
                                        [wself bindQRCodeFinishedWithError:nil];
                                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                        [wself bindQRCodeFinishedWithError:error];
                                    }];
}

- (void)unbindQRCode:(TDFQRCode *)code {

    [self showHUBWithText:NSLocalizedString(@"正在解除绑定", nil)];
    
    //[[self service] unbindSeatCodeWithSeatCode:self.seat.code shortURL:code.url target:self callback:@selector(postFinished:)];
    __weak __typeof(self) wself = self;
    [self.service unbindSeatCodeWithSeatCode:self.seat.code shortURL:code._id
                                      sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                          
                                          [wself postFinishedWithError:nil];
                                      } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                          [wself postFinishedWithError:error];
                                      }];
}


- (void)activeQRCode {

    [self showHUBWithText:NSLocalizedString(@"正在启用", nil)];
    //[[self service] reactiveQRCodeWithSeatCode:self.seat.code target:self callback:@selector(postFinished:)];
    __weak __typeof(self) wself = self;
    [self.service reactiveQRCodeWithSeatCode:self.seat.code
                                      sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                          
                                          [wself postFinishedWithError:nil];
                                      } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                          [wself postFinishedWithError:error];
                                      }];
}


- (void)deactiveQRCode {

    [self showHUBWithText:NSLocalizedString(@"正在停用", nil)];
    __weak __typeof(self) wself = self;
    [self.service deactiveQRCodeWithSeatCode:self.seat.code
                                      sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                          
                                          [wself postFinishedWithError:nil];
                                      } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                          [wself postFinishedWithError:error];
                                      }];
}


- (void)bindQRCodeFinishedWithError:(NSError *)error {
    
    if (error) {
        
        [self.scanViewController dismissHUD];
        [self.scanViewController showError:[error localizedDescription] duration:2.5];
        [self.scanViewController resume];
        return;
    }
    
    self.bindingQRCode = YES;
    [self loadQRCodeInfo];
    [self setNeedUpdateSeats];
}

- (void)postFinishedWithError:(NSError *)error {

    [self dismissHUD];
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    
    [self loadQRCodeInfo];
    [self setNeedUpdateSeats];
}

- (void)showBindingSuccessInfo {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self showSuccessMessage:NSLocalizedString(@"绑定成功", nil) duration:2.3];
    self.scanViewController = nil;
}

- (void)presentAreaManagerViewController {

    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_AreaListViewWithCallBack:^{
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Accessor

- (TDFPAShowManagerStrategy *)areaStrategy {

    if (!_areaStrategy) {
    
        _areaStrategy = [[TDFPAShowManagerStrategy alloc] init];
        _areaStrategy.pickerName = NSLocalizedString(@"选择区域", nil);
        _areaStrategy.managerName = NSLocalizedString(@"管理区域", nil);
        __weak __typeof(self) wself = self;
        _areaStrategy.managerClickedBlock = ^void () {
            [wself presentAreaManagerViewController];
        };
    }
    
    return _areaStrategy;
}

- (TDFShowPickerStrategy *)typeStrategy {

    if (!_typeStrategy) {
    
        _typeStrategy = [[TDFShowPickerStrategy alloc] init];
        _typeStrategy.pickerItemList = [SeatRender listKind];
        _typeStrategy.pickerName = NSLocalizedString(@"选择桌位类型", nil);
        
        for (NameItemVO *vo in [SeatRender listKind]) {
            if ([vo.itemId isEqualToString:[NSString stringWithFormat:@"%zd", self.seat.seatKind]]) {
                _typeStrategy.selectedItem = vo;
                break;
            }
        }
    }
    
    return _typeStrategy;
}

- (UIImageView *)backgroundView {

    if (!_backgroundView) {
    
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[BackgroundHelper getBackgroundImage]]];
    }
    
    return _backgroundView;
}

- (TDFPickerItem *)areaPickerItem {

    if (!_areaPickerItem) {
    
        _areaPickerItem = [[TDFPickerItem alloc] init];
        _areaPickerItem.tdf_title(NSLocalizedString(@"区域", nil)).tdf_isRequired(YES).tdf_shouldShow(YES).tdf_strategy(self.areaStrategy);
        __weak __typeof(self) wself = self;
        _areaPickerItem.tdf_filterBlock(^BOOL(NSString *string, id val) {
        
            [wself updateNavigationBar];
            return YES;
        });
    }
    
    return _areaPickerItem;
}


- (TDFTextfieldItem *)nameItem {

    if (!_nameItem) {
    
        _nameItem = [[TDFTextfieldItem alloc] init];
        _nameItem.tdf_title(NSLocalizedString(@"桌位名称", nil)).tdf_isRequired(YES).tdf_shouldShow(YES);
        __weak __typeof(self) wself = self;
        _nameItem.tdf_filterBlock(^BOOL (NSString *string) {

            [wself updateNavigationBar];
            
            return  YES;
        });
    }
    
    return _nameItem;
}

- (TDFTextfieldItem *)codeItem {

    if (!_codeItem) {
    
        _codeItem = [[TDFTextfieldItem alloc] init];
        _codeItem.tdf_title(NSLocalizedString(@"桌位编码", nil)).tdf_isRequired(YES).tdf_shouldShow(YES);
        __weak __typeof(self) wself = self;
        _codeItem.tdf_filterBlock(^BOOL (NSString *string) {
            
            NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
            NSString *newString = [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
            if (newString.length > 12) {
            
                newString = [newString substringToIndex:12];
            }
            wself.codeItem.tdf_textValue(newString);
            [wself updateNavigationBar];
            return NO;
        });
    }
    
    return _codeItem;
}

- (TDFPickerItem *)typePickerItem {

    if (!_typePickerItem) {
    
        _typePickerItem = [[TDFPickerItem alloc] init];
        _typePickerItem.tdf_title(NSLocalizedString(@"桌位类型", nil)).tdf_isRequired(YES).tdf_shouldShow(YES).tdf_strategy(self.typeStrategy);
        __weak __typeof(self) wself = self;
        _typePickerItem.tdf_filterBlock(^BOOL(NSString *string, id val) {
        
            [wself updateNavigationBar];
            return YES;
        });
    }
    
    return _typePickerItem;
}

- (TDFTextfieldItem *)countItem {

    if (!_countItem) {
    
        _countItem = [[TDFTextfieldItem alloc] init];
        _countItem.tdf_title(NSLocalizedString(@"建议人数", nil)).tdf_isRequired(YES).tdf_shouldShow(YES).tdf_keyboardType(UIKeyboardTypeNumberPad);
        __weak __typeof(self) wself = self;
        _countItem.tdf_filterBlock(^BOOL (NSString *string) {
        
            NSCharacterSet *charactersToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            NSString *newString = [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
            if (newString.length > 4) {
                
                newString = [newString substringToIndex:4];
            }
            wself.countItem.tdf_textValue(newString);
            [wself updateNavigationBar];
            return NO;
        });
    }
    
    return _countItem;
}


- (UITableView *)tableView {

    if (!_tableView) {
    
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    return _tableView;
}

- (DHTTableViewManager *)manager {
    
    if (!_manager) {
    
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        
        [_manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
        [_manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
        [_manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    }
    
    return _manager;
}

- (MBProgressHUD *)hud {

    if (!_hud) {
    
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [_hud setLabelText:NSLocalizedString(@"正在更新", nil)];
    }
    
    return _hud;
}

- (TDFTableQRCodeView *)footerView {

    if (!_footerView) {
    
        _footerView = [[TDFTableQRCodeView alloc] initWithSeat:self.seat];
    }
    
    return _footerView;
}

@end
