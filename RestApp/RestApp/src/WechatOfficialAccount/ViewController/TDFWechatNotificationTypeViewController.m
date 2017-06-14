//
//  TDFWechatNotificationTypeViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatNotificationTypeViewController.h"
#import "TDFWXNotificationSelectCell.h"
#import "TDFWechatMarketingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "YYModel.h"
#import "ObjectUtil.h"
#import "TDFWXNotificationEditViewController.h"
#import "TDFOfficialAccountModel.h"

@interface TDFWechatNotificationTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArry;
@property (nonatomic, copy) NSString *titleStr;

@end

@implementation TDFWechatNotificationTypeViewController

#pragma mark - Accessor

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TDFWXNotificationSelectCell class] forCellReuseIdentifier:@"TDFWXNotificationSelectCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:@"ico_ok.png" rightButtonName:NSLocalizedString(@"确定", nil)];
    [self loadData];
    [self configView];
}

#pragma mark - Config View

- (void)configView {
    self.title = self.titleStr;
    [self.view addSubview:self.tableView];
}

- (void)configPrompt {
    
    UILabel *label = [[UILabel alloc] init];
    
    switch (self.contentType) {
        case TDFWXNotificationContentTypeCoupon:
            label.text = @"您没有有效的优惠券可供同步";
            break;
        case TDFWXNotificationContentTypeMemberCard:
            label.text = @"您还没有有效的会员卡可供同步";
            break;
        case TDFWXNotificationContentTypePromotion:
            label.text = @"您没有有效的促销活动可供同步";
            break;
    }
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.view).with.offset(-40);
    }];
}


#pragma mark - Action

- (void)rightNavigationButtonAction:(id)sender {
    [self selected];
}

- (void)leftNavigationButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selected {
    
    TDFWXContentModel *model = [self querySelectedModelWithId:self.selectedId];
    !self.completionBlock ?: self.completionBlock(model._id, model.name);
    [self.navigationController popViewControllerAnimated:YES];
}

- (TDFWXContentModel *)querySelectedModelWithId:(NSString *)selectedId {

    if (!selectedId) {
        return nil;
    }
    
    for (TDFWXContentModel *model in self.dataArry) {
        
        if ([model._id isEqualToString:selectedId]) {
            
            return model;
        }
    }
    
    return nil;
}

#pragma mark - Network

- (void)loadData {
    switch (self.contentType) {
        case TDFWXNotificationContentTypeMemberCard:
            self.actionPath = @"kind_card_list";
            self.titleStr = NSLocalizedString(@"选择要推送的卡", nil);
            [self fetchMemberListWithOAId];
            break;
        case TDFWXNotificationContentTypeCoupon:
            self.actionPath = @"list_coupon_promotion";
            self.titleStr = NSLocalizedString(@"选择要推送的券", nil);
            [self fetchCouponListWithOAId];
            break;
        case TDFWXNotificationContentTypePromotion:
            self.actionPath = @"list_sales_promotion";
            self.titleStr = NSLocalizedString(@"选择促销活动推送", nil);
            [self fetchSalesListWithOAId];
            break;
        default:
            break;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
}

- (void)fetchCouponListWithOAId {
    TDFWechatMarketingService *service = [[TDFWechatMarketingService alloc] init];
    [service fetchPromotionCouponListWithOAId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self NetWorkDataResult:responseObj error:error];
    }];
}

- (void)fetchSalesListWithOAId {
    TDFWechatMarketingService *service = [[TDFWechatMarketingService alloc] init];
    [service fetchPromotionSaleListWithOAId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self NetWorkDataResult:responseObj error:error];
    }];

}

- (void)fetchMemberListWithOAId {
    TDFWechatMarketingService *service = [[TDFWechatMarketingService alloc] init];
    [service fetchKindCardListWithOAId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self NetWorkDataResult:responseObj error:error];
    }];
}

#pragma mark - Method

- (void)NetWorkDataResult:(id)responseObj error:(NSError *)error {
    [self.progressHud setHidden:YES];
    NSDictionary *dict = responseObj;
    if (error) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return ;
    }

    NSArray *data =dict[@"data"];
    self.dataArry = [NSArray yy_modelArrayWithClass:[TDFWXContentModel class] json:data];
    if (self.dataArry.count == 0) {
        [self configPrompt];
    }
    [self.tableView reloadData];
}

#pragma mark - Tableviewdelegate && Tableviewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   TDFWXNotificationSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFWXNotificationSelectCell" forIndexPath:indexPath];
    TDFWXContentModel *model = self.dataArry[indexPath.row];
    cell.contentLabel.text= model.name;
    BOOL flag = [model._id isEqualToString:self.selectedId];
    cell.imgCheck.hidden = !flag;
    cell.imgUnCheck.hidden = flag;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFWXContentModel *model = self.dataArry[indexPath.row];
    if ([model._id isEqualToString:self.selectedId]) {
        self.selectedId = nil;
    } else {
        
        TDFWXContentModel *model = self.dataArry[indexPath.row];
        self.selectedId = model._id;
    }
    
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}



@end
