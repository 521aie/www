//
//  CustomerListView.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "CustomerListView.h"
#import "DicItemConstants.h"
#import "DicItemEditView.h"
#import "TDFSettingService.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "TableEditView.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "GridFooter.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "GridNVCell.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFSettingService.h"
#import "TDFMediator+SettingModule.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+UserAuth.h"

@interface CustomerListView()

@property (nonatomic,assign) BOOL isChainManager;

@property (nonatomic,strong) UIView *tableViewHeaderView;

@end

@implementation CustomerListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"客单备注", nil);
    [self initNotification];
    self.dicCode=SERVICE_CUSTOMER;
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"customer" title:NSLocalizedString(@"客单备注", nil) foots:nil];
    [self loadDatas];
    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_TABLE_ITEM"];
}

- (UIView *)tableViewHeaderView {
    if(!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc] init];
        _tableViewHeaderView.backgroundColor = [UIColor clearColor];
        
        UIView *alphaView = [[UIView alloc] init];
        alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [_tableViewHeaderView addSubview:alphaView];
        [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableViewHeaderView.mas_left);
            make.right.equalTo(_tableViewHeaderView.mas_right);
            make.top.equalTo(_tableViewHeaderView.mas_top);
            make.bottom.equalTo(_tableViewHeaderView.mas_bottom).with.offset(-1);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"注：您的客单备注是由总部管理。如需修改，请联系总部进行操作。";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGBA(204, 0, 0, 1);
        label.numberOfLines = 0;
        [_tableViewHeaderView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableViewHeaderView.mas_left).with.offset(10);
            make.right.equalTo(_tableViewHeaderView.mas_right).with.offset(-10);
            make.centerY.equalTo(_tableViewHeaderView.mas_centerY);
        }];
        
        CGSize size = [label.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        _tableViewHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height+20);
    }
    return _tableViewHeaderView;
}

#pragma 消息处理部分.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortFinish:) name:REMOTE_DICITEM_SORT object:nil];
}

#pragma 数据加载
- (void)loadDatas
{

     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listDicItem:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        
        NSMutableDictionary *dic = data[@"data"];
        self.isChainManager = [dic[@"isChain"] boolValue];
        
        if(self.isChainManager) {
            self.mainGrid.tableHeaderView = self.tableViewHeaderView;
            [self removeAllFooterButtons];
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeSort];
        }else {
            self.mainGrid.tableHeaderView = nil;
            [self removeAllFooterButtons];
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd|TDFFooterButtonTypeSort];
        }
        
        NSArray *list = [dic objectForKey:@"dicItemVoList"];
        self.datas=[JsonHelper transList:list objName:@"DicItem"];
        [self.mainGrid reloadData];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma 实现协议 ISampleListEvent
- (void)closeListEvent:(NSString*)event
{
}

- (void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEvent:@"sortinit" ids:nil];
}

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    if ([ObjectUtil isEmpty:self.datas] || self.datas.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
    if ([event isEqualToString:@"sortinit"]) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"customersort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:self.datas error:nil needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
        [[TDFSettingService new] sortDicItems:ids code:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud setHidden:YES];
            NSArray *list = [data objectForKey:@"data"];
            self.datas=[JsonHelper transList:list objName:@"DicItem"];
            [self.mainGrid reloadData];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud setHidden:YES];
             [AlertBox show:error.localizedDescription];
        }];

    }
}

- (void)footerAddButtonAction:(UIButton *)sender
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DicItemEditViewWithData:nil action:ACTION_CONSTANTS_ADD title:NSLocalizedString(@"客单备注", nil) code:self.dicCode CallBack:^{
         @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids
{

      [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    [[TDFSettingService new] removeDicItems:ids code:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        NSArray *list = [data objectForKey:@"data"];
        self.datas=[JsonHelper transList:list objName:@"DicItem"];
        [self.mainGrid reloadData];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"dicitem"];
}


- (void)sortFinish:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
//    [self remoteLoadData:result.content];
    [self loadDatas];
}

- (void)delFinish:(RemoteResult*)result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"dicItems"];
    self.datas=[JsonHelper transList:list objName:@"DicItem"];
    [self.mainGrid reloadData];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridNVCell *detailItem = (GridNVCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GridNVCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell" owner:self options:nil].lastObject;
     }
    
    if(self.isChainManager) {
        detailItem.btnDel.hidden = YES;
        detailItem.imgDel.hidden = YES;
    }else {
        detailItem.btnDel.hidden = NO;
        detailItem.imgDel.hidden = NO;
    }
    
     if ([ObjectUtil isNotEmpty:self.datas]) {
        DicItem* item=[self.datas objectAtIndex: indexPath.row];
        [detailItem initDelegate:self obj:item title:NSLocalizedString(@"客单备注", nil) event:@"customermemo"];
         detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
         return detailItem;
     }
    
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

@end
