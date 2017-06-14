//
//  TDFKindPayAddCouponViewController.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindPayAddCouponViewController.h"
#import "DHTTableViewManager.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFLabelItem.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "TDFSettingService.h"
#import "ObjectUtil.h"
#import "TDFKeyboard.h"

@interface TDFKindPayAddCouponViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic,strong) UIView *tableViewFooterView;

@property (nonatomic,strong) TDFLabelItem *couponAmountItem;
@property (nonatomic,strong) TDFLabelItem *couponSellPriceItem;

@property (nonatomic,strong) TDFVoucher *couponVO;

@end

@implementation TDFKindPayAddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"增加新面额", nil);
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =[UIColor whiteColor];
    view.alpha =0.6;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableFooterView = self.tableViewFooterView;

    [self configureManager];
    
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    
    [self addSections];
}

- (void)addSections {
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.couponAmountItem];
    [section addItem:self.couponSellPriceItem];
    
    [self.manager addSection:section];
}

- (TDFVoucher *)couponVO {
    if(!_couponVO) {
        _couponVO = [[TDFVoucher alloc] init];
    }
    return _couponVO;
}

- (UIView *)tableViewFooterView {
    if(!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] init];
        NSString *text = NSLocalizedString(@"提示：代金券售价小于面额时，使用此代金券支付时，两者的差价会计为账单的优惠金额，", nil);
        CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;

        _tableViewFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height + 10);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGBA(102, 102, 102, 1);
        label.numberOfLines = 0;
        label.text = text;
        [_tableViewFooterView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableViewFooterView.mas_left).with.offset(10);
            make.right.equalTo(_tableViewFooterView.mas_right).with.offset(-10);
            make.top.equalTo(_tableViewFooterView.mas_top);
            make.bottom.equalTo(_tableViewFooterView.mas_bottom);
        }];

    }
    return _tableViewFooterView;
}

- (void)leftNavigationButtonAction:(id)sender {
    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗？", nil) cancelBlock:^{
        
    } enterBlock:^{
        [super leftNavigationButtonAction:sender];
    }];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self save];
}

- (BOOL)isVaild {
    if (!self.couponVO.amount) {
        [AlertBox show:NSLocalizedString(@"代金券面额不能为空!", nil)];
        return NO;
    }
    if (!self.couponVO.sellPrice) {
        [AlertBox show:NSLocalizedString(@"代金券售价不能为空!", nil)];
        return NO;
    }
    if (self.couponVO.amount.floatValue == 0) {
        [AlertBox show:NSLocalizedString(@"代金券面额不能为0", nil)];
        return NO;
    }
    if (self.couponVO.sellPrice.floatValue > self.couponVO.amount.floatValue) {
        [AlertBox show:NSLocalizedString(@"代金券售价不能大于面额", nil)];
        return NO;
    }
    for (TDFVoucher *voucher in self.voucherList) {
        if (voucher.amount.floatValue == self.couponVO.amount.floatValue &&
            voucher.sellPrice.floatValue == self.couponVO.sellPrice.floatValue) {
            [AlertBox show:NSLocalizedString(@"已经存在相同面额和售价的代金券了!", nil)];
            return NO;
        }
    }
    
    return YES;
}
- (void)save {
    if(![self isVaild]) return;

    if (self.kindPayId) {
        NSMutableDictionary *param  = [[NSMutableDictionary alloc] init];
        param[@"kind_pay_id"] = self.kindPayId;
        param[@"voucher_str"] = [JsonHelper getjsonstr:self.couponVO.dictionaryRepresentation];
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        @weakify(self);
        [[TDFSettingService new] saveVoucher:param sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            NSDictionary *voucherDic = data[@"data"];
            if ([ObjectUtil isNotEmpty:voucherDic]) {
                TDFVoucher *voucher = [TDFVoucher modelWithDictionary:voucherDic];
                !self.addCouponCallBack?:self.addCouponCallBack(voucher);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        [AlertBox show:NSLocalizedString(@"保存失败!", nil)];
    }

}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
    }
    return _tableView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}

- (TDFLabelItem *)couponAmountItem {
    if(!_couponAmountItem) {
        
        _couponAmountItem = [[TDFLabelItem alloc] init];
        _couponAmountItem.title = NSLocalizedString(@"代金券面额", nil);
        _couponAmountItem.isRequired = YES;
        _couponAmountItem.keyboardType = TDFNumbericKeyboardTypeFloat;
        @weakify(self);
        _couponAmountItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.couponVO.amount = textValue;
            return YES;
        };
    }
    return _couponAmountItem;
}

- (TDFLabelItem *)couponSellPriceItem {
    if(!_couponSellPriceItem) {
        _couponSellPriceItem = [[TDFLabelItem alloc] init];
        _couponSellPriceItem.title = NSLocalizedString(@"代金券售价", nil);
        _couponSellPriceItem.isRequired = YES;
        _couponSellPriceItem.keyboardType = TDFNumbericKeyboardTypeFloat;
        @weakify(self);
        _couponSellPriceItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.couponVO.sellPrice = textValue;
            return YES;
        };
    }
    return _couponSellPriceItem;
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
