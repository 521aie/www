//
//  SignBillListView.m
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "GridNVCell.h"
#import "DicItemEditView.h"
#import "XHAnimalUtil.h"
#import "HelpDialog.h"
#import "KindPayDetail.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "SignBillEditView.h"
#import "SignBillDetailEditView.h"
#import "SignerCell.h"
#import "SignerHeadCell.h"
#import "KindPayDetailOption.h"
#import "NameValueItemVO.h"
#import "DHHeadItem.h"
#import "ObjectUtil.h"
#import "PairPickerBox.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"
#import "TableEditView.h"
#import "UIHelper.h"
#import "TDFSettingService.h"
#import "TDFMediator+SettingModule.h"
#import "TDFRootViewController+FooterButton.h"
@implementation SignBillListView

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
    self.title = NSLocalizedString(@"挂账设置", nil);
    [self initNotification];
    [self initDelegate:self event:@"signbill" title:NSLocalizedString(@"挂账设置", nil) foots:nil];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeSort | TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    [self loadDatas];
}

#pragma 消息处理部分.
- (void)initNotification
{

}


#pragma 数据加载
- (void)loadDatas
{

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listSignBillKindPaySucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        [self remoteLoadData:data];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];


}

#pragma 实现协议 ISampleListEvent
- (void)closeListEvent:(NSString *)event
{
}

- (void)footerAddButtonAction:(UIButton *)sender {
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignBillEditViewWithData:nil action:ACTION_CONSTANTS_ADD isContinue:NO CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showAddEvent:(NSString*)event obj:(id)obj;
{
    if ([event isEqualToString:@"option"]) {
        KindPay* kindPay=(KindPay*)obj;
        @weakify(self);
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignBillDetailEditViewWithData:kindPay option:nil  action:ACTION_CONSTANTS_ADD CallBack:^{
            @strongify(self);
            [self loadDatas];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
//    [service removeDicItem:[ids firstObject] Target:self Callback:@selector(delFinish:)];
}

- (void)footerSortButtonAction:(UIButton *)sender {
    if ([ObjectUtil isNotEmpty:self.kindPayNameList]) {
        [PairPickerBox initData:self.optionDic keys:self.kindPayNameList keyPos:0 valPos:0];
        [PairPickerBox show:NSLocalizedString(@"选择挂账排序", nil) client:self event:0];
    } else {
        [AlertBox show:NSLocalizedString(@"暂无挂账，无须进行排序！", nil)];
    }
}

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    if ([event isEqualToString:@"sortinit"]) {
        if ([ObjectUtil isNotEmpty:self.kindPayNameList]) {
            [PairPickerBox initData:self.optionDic keys:self.kindPayNameList keyPos:0 valPos:0];
            [PairPickerBox show:NSLocalizedString(@"选择挂账排序", nil) client:self event:0];
        } else {
            [AlertBox show:NSLocalizedString(@"暂无挂账，无须进行排序！", nil)];
        }
    } else {

        [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
        [[TDFSettingService new] sortKindPayDetailOptions:ids detailId:self.currKindPayDetail._id sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            [self loadDatas];

        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    if ([event isEqualToString:@"option"]) {
        KindPayDetailOption *option = (KindPayDetailOption *)obj;
        @weakify(self);
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignBillDetailEditViewWithData:self.currKindPay option:option  action:ACTION_CONSTANTS_EDIT CallBack:^{
            @strongify(self);
            [self loadDatas];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        KindPay *kindPay = (KindPay *)obj;
        @weakify(self);
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignBillEditViewWithData:kindPay action:ACTION_CONSTANTS_EDIT isContinue:NO CallBack:^{
            @strongify(self);
            [self loadDatas];
        }];
    [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signbill"];
}

-(void)loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
 
    [self remoteLoadData:result.content];
}

-(void)delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];
}

-(void)sortFinish:(RemoteResult*)result
{
    [self.progressHud hide:YES];
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
    NSDictionary* map= data [@"data"];
    NSArray *kindPayTemps = [map objectForKey:@"kindPayVos"];
    self.kindPayList=[JsonHelper transList:kindPayTemps objName:@"KindPay"];
    
    NSArray *list = [map objectForKey:@"kindPayDetailOptionVos"];
    NSMutableArray* optionList=[JsonHelper transList:list objName:@"KindPayDetailOption"];
    
    self.optionMap=[NSMutableDictionary dictionary];
    NSMutableArray* options=[NSMutableArray array];
    
    for (KindPayDetailOption* vo in optionList) {
       
        options=[self.optionMap objectForKey:vo.kindPayDetailId];
        if([self.optionMap objectForKey:vo.kindPayDetailId]) {
            [self.optionMap removeObjectForKey:vo.kindPayDetailId];
        }else{
            options=[NSMutableArray array];
        }
        [options addObject:vo];
        [self.optionMap setObject:options forKey:vo.kindPayDetailId];
    }
    
    self.detailMap=[NSMutableDictionary dictionary];
    self.detailNameMap=[NSMutableDictionary dictionary];
    
    NSArray* arr=[[NSArray alloc] initWithObjects:NSLocalizedString(@"单位", nil),NSLocalizedString(@"个人", nil),nil];
    self.optionDic=[NSMutableDictionary dictionary];
    self.kindPayNameList=[NSMutableArray array];
    
    NSMutableArray* optionTemps=[NSMutableArray array];
    
    if (self.kindPayList!=nil && self.kindPayList.count>0) {
        NSMutableArray* details=[NSMutableArray array];
        for (KindPay* kindPay in self.kindPayList) {
            details=[NSMutableArray array];
            [self.kindPayNameList addObject:kindPay.name];
            [self.optionDic setObject:arr forKey:kindPay.name];
            kindPay.signerList=[NSMutableArray array];
            for (KindPayDetail* detail in kindPay.kindPayDetails) {
                [self.detailNameMap setObject:detail forKey:detail._id];
                optionTemps=[self.optionMap objectForKey:detail._id];
                if (optionTemps && optionTemps.count>0) {
                    if (detail.sortCode==2) {
                        kindPay.signerList=optionTemps;
                    }else{
                        [details addObjectsFromArray:optionTemps];
                    }
                }
            }
            [self.detailMap setObject:details forKey:kindPay._id];
        }
    }
    
    [self.mainGrid reloadData];
    
}


#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindPay *kindPay = [self.kindPayList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:kindPay]) {
        NSMutableArray *temps = [self.detailMap objectForKey:kindPay._id];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
            
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=NSLocalizedString(@"添加挂账人...", nil);
            return footerItem;
        } else {
            SignerCell *detailItem = (SignerCell *)[tableView dequeueReusableCellWithIdentifier:SignerCellIndentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"SignerCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotEmpty:temps]) {
                KindPayDetailOption* item=[temps objectAtIndex: indexPath.row];
                KindPayDetail* kdetail=[self.detailNameMap objectForKey:item.kindPayDetailId];
                NSString  *type=(kdetail!=nil && ([kdetail.name isEqualToString:NSLocalizedString(@"挂账单位", nil)] ||[kdetail.name isEqualToString:NSLocalizedString(@"单位", nil)] ))?NSLocalizedString(@"单位", nil):NSLocalizedString(@"个人", nil);
                
                [detailItem initDelegate:self obj:item type:type];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindPay *kindPay = [self.kindPayList objectAtIndex:indexPath.section];
    self.currKindPay=kindPay;
    if ([ObjectUtil isNotNull:kindPay]) {
        NSMutableArray *temps = [self.detailMap objectForKey:self.currKindPay._id];
        if (temps==nil || indexPath.row==temps.count) {
            [self showAddEvent:@"option" obj:kindPay];
        }else{
            [self showEditNVItemEvent:@"option" withObj:temps[indexPath.row]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KindPay *head = [self.kindPayList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head._id];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count+1;
        } else {
            return 1;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SignerHeadCell *headItem = (SignerHeadCell *)[tableView dequeueReusableCellWithIdentifier:SignerHeadCellIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"SignerHeadCell" owner:self options:nil].lastObject;
    }

    KindPay *head = [self.kindPayList objectAtIndex:section];
    [headItem initDelegate:self obj:head];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.kindPayList!=nil?self.kindPayList.count:0);
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
- (BOOL)pickOption:(NSInteger)keyIndex valIndex:(NSInteger)valIndex event:(NSInteger)eventType
{
    KindPay* kindPay=[self.kindPayList objectAtIndex:keyIndex];
    KindPayDetail* detail=[self getDetail:kindPay index:valIndex];
    self.currKindPayDetail=detail;
     NSMutableArray *temps = [self.optionMap objectForKey:detail._id];
    if (temps==nil || temps.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return YES;
    }
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"sort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:temps error:nil needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    return YES;
}

-(KindPayDetail *) getDetail:(KindPay *)kindPay index:(NSInteger)index
{
    for (KindPayDetail* detail in kindPay.kindPayDetails) {
        if (index==0 && ([detail.name isEqualToString:NSLocalizedString(@"挂账单位", nil)] || [detail.name isEqualToString:NSLocalizedString(@"单位", nil)])) {
            return detail;
        } else if (index==1 && ([detail.name isEqualToString:NSLocalizedString(@"挂账人", nil)] || [detail.name isEqualToString:NSLocalizedString(@"个人", nil)])) {
            return detail;
        }
    }
    return nil;
}

@end
