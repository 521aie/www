//
//  SpecialReasonListView.m
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecialReasonListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "GridNVCell.h"
#import "DicItemEditView.h"
#import "XHAnimalUtil.h"
#import "HelpDialog.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "NameValueItemVO.h"
#import "GridHead.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "TableEditView.h"
#import "UIHelper.h"
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"
#import "TDFMediator+SettingModule.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+UserAuth.h"
@interface SpecialReasonListView()

@property (nonatomic,assign) BOOL isChainManager;

@property (nonatomic,strong) UIView *tableViewHeaderView;

@end
@implementation SpecialReasonListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"特殊操作原因", nil);
    [self initNotification];
    [self.footView removeFromSuperview];
    [self loadDatas];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_SPECIAL_OPERATE"];
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
        label.text = @"注：您的特殊操作原因是由总部管理。如需修改，请联系总部进行操作。";
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

#pragma 数据加载
-(void)loadDatas{

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listReasonsSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        
        self.isChainManager = [data[@"data"][@"isChain"] boolValue];
        if(self.isChainManager) {
            [self initHeadData];
            self.mainGrid.tableHeaderView = self.tableViewHeaderView;
        }else {
            [self initHeadData];
            [self initDelegate:self event:@"spcialreason" title:NSLocalizedString(@"特殊操作原因", nil) foots:nil];
            self.mainGrid.tableHeaderView = nil;
        }
        
        [self removeAllFooterButtons];
        [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeSort];

        [self remoteLoadData:data];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
          [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEvent:@"sortinit" ids:nil];
}

#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
}

-(void) showAddEvent:(NSString*)event title:(NSString*)title code:(NSString*)code
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DicItemEditViewWithData:nil action:ACTION_CONSTANTS_ADD title:title code:code CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) showAddEvent:(NSString*)event obj:(id)obj
{
    NameValueItemVO* head=(NameValueItemVO*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DicItemEditViewWithData:nil action:ACTION_CONSTANTS_ADD title:head.itemName code:head.itemVal CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    [[TDFSettingService new] removeDicItems:ids code:event sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self loadDatas];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];


}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    if ([event isEqualToString:@"sortinit"]) {
//        [OptionPickerBox initData:self.headList itemId:nil];
//        [OptionPickerBox show:NSLocalizedString(@"选择特殊操作原因排序", nil) client:self event:0];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"选择特殊操作原因排序", nil)
                                                                              options:self.headList
                                                                        currentItemId:nil];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:wself.headList[index] event:0];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }else{
        [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
        [[TDFSettingService new] sortDicItems:ids code:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud setHidden:YES];
             [self loadDatas];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender{
    
    [HelpDialog show:@"spcialreason"];
}

#pragma 消息处理部分.
-(void) initNotification{
}


-(void) loadFinish:(RemoteResult*) result{
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


-(void) delFinish:(RemoteResult*)result{
    [self.progressHud setHidden:YES];
       if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];
}

-(void) sortFinish:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self loadDatas];
}

-(void) remoteLoadData:(id ) data
{
    NSArray* map= data[@"data"][@"dicVoList"];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    
    NSMutableArray *alldics = [NSMutableArray array];
    
    for (NSDictionary *dic in map) {
        
        NSString *str = [NSString stringWithFormat:@"%@|%@",[dic objectForKey:@"code"],[dic objectForKey:@"id"]];
        [titleArray addObject:str];
        
        for (NSDictionary *dd in [dic objectForKey:@"dicItemList"]) {
            
            [alldics addObject:dd];
        }
    }
    
    NSArray *dicTemplist = [NSArray arrayWithArray:titleArray];
    
    NSArray *list = [NSArray arrayWithArray:alldics];
    
    NSMutableArray* items=[JsonHelper transList:list objName:@"DicItem"];
    
    for (NSString* dicId in dicTemplist) {
        NSArray* resultArr=[dicId componentsSeparatedByString:@"|"];
        for (NameValueItemVO* vo in self.headList) {
            if ([vo.itemVal isEqualToString:resultArr[0]]) {
                vo.itemId=resultArr[1];
                break;
            }
        }
    }
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray* details=[NSMutableArray array];
    
    for (NameValueItemVO* vo in self.headList) {
        details=[NSMutableArray array];
        for (DicItem* item in items) {
            if ([vo.itemId isEqualToString:item.dicId]) {
                [details addObject:item];
            }
        }
        [self.detailMap setObject:details forKey:vo.itemId];
    }
    
    if(self.isChainManager) {
       //筛选一遍将details是空的项 移出 headlist
        [self.detailMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if(obj.count <= 0){
                NSMutableArray *tempArray = [self.headList mutableCopy];
                [tempArray enumerateObjectsUsingBlock:^(NameValueItemVO * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.itemId isEqualToString:key]) {
                        [self.headList removeObjectAtIndex:idx];
                    }
                }];
            }
        }];
    }
    [self.mainGrid reloadData];
}


-(void) initHeadData
{
    self.headList=[NSMutableArray array];
    NameValueItemVO* item=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"退货原因", nil) val:@"TC_REASON" andId:@""];
    [self.headList addObject:item];
    item=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"打折原因", nil) val:@"RATIO_REASON" andId:@""];
    [self.headList addObject:item];
    item=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"撤单原因", nil) val:@"CZ_REASON" andId:@""];
    [self.headList addObject:item];
    item=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"反结账原因", nil) val:@"ACCOUNT_REASON" andId:@""];
    [self.headList addObject:item];
    item=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"赠送原因", nil) val:@"PRESENT_REASON" andId:@""];
    [self.headList addObject:item];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps==nil || indexPath.row==temps.count) {
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
            
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=[NSString stringWithFormat:NSLocalizedString(@"添加%@...", nil),head.itemName];
            return footerItem;
        } else {
            GridNVCell *detailItem = (GridNVCell *)[tableView dequeueReusableCellWithIdentifier:GridNVCellIndentifier];
            
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

            if ([ObjectUtil isNotNull:temps]) {
                DicItem* item=[temps objectAtIndex: indexPath.row];
                [detailItem initDelegate:self obj:item title:head.itemName event:head.itemVal];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    self.dicCode=head.itemVal;
    self.currTitleName=head.itemName;
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            [self showAddEvent:head.itemVal title:head.itemName code:head.itemVal];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
       if ([ObjectUtil isNotNull:temps]) {
           if(self.isChainManager) {
               return temps.count;
           }
          return temps.count+1;
       } else {
          return 1;
       }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"reason"];
    [headItem initOperateWithAdd:YES edit:NO];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma edititemlist click event.
- (BOOL)pickOption:(id)temp event:(NSInteger)event
{
    NameValueItemVO* item=(NameValueItemVO*)temp;
    self.dicCode=item.itemVal;
    NSMutableArray *temps = [self.detailMap objectForKey:item.itemId];
    if ([ObjectUtil isNull:temps] || temps.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return YES;
    }
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"specialreasonsort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:temps error:nil needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    return YES;
}

@end
