//
//  ZeroListView.m
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZeroListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "TailDealEditView.h"
#import "XHAnimalUtil.h"
#import "HelpDialog.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "ZeroCell.h"
#import "TailDealCell.h"
#import "EventConstants.h"
#import "NameValueItemVO.h"
#import "NameItemVO.h"
#import "GridHead.h"
//#import "OptionPickerBox.h"
#import "ConfigRender.h"
#import "ConfigConstants.h"
#import "ConfigVO.h"
#import "ConfigItemOption.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "TDFSettingService.h"
#import "TDFMediator+SettingModule.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+UserAuth.h"

@interface ZeroListView ()

@property (nonatomic,assign) BOOL isChainManager;

@property (nonatomic,strong) UIView *tableViewHeaderView;
@end

@implementation ZeroListView

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
    [self initHeadData];
    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"zerodeal" title:NSLocalizedString(@"零头处理方式", nil) foots:nil];
    self.title = NSLocalizedString(@"零头处理方式", nil);
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
     [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_ZERO_PARA"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configLeftNavigationBar];
    [self loadDatas];
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
        label.text = @"注：您的零头处理方式是由总部管理。如需修改，请联系总部进行操作。";
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
- (void)loadDatas {
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listTailDealSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        
        self.isChainManager = [data[@"data"][@"isChain"] boolValue];

        if(self.isChainManager) {
            self.mainGrid.tableHeaderView = self.tableViewHeaderView;
        }else {
            self.mainGrid.tableHeaderView = nil;
        }

        [self.progressHud setHidden:YES];
        [self remoteLoadData:data];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) showAddEvent:(NSString*)event
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TailDealEditViewControllerWithAction:ACTION_CONSTANTS_ADD];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) showAddEvent:(NSString*)event obj:(id)obj
{
    [self showAddEvent:event];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{

   [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    [[TDFSettingService new] removeTailDeals:ids sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        [self loadDatas];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

-(void) footerHelpButtonAction:(UIButton *)sender{
    [HelpDialog show:@"zeropara"];
}

#pragma 消息处理部分.
-(void) initNotification{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinish:) name:REMOTE_ZERODEAL_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_ZEROPARA_SAVE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_TAILDEAL_DEL object:nil];
}

-(void) loadFinish:(RemoteResult*)result{
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


-(void) remoteLoadData:(id  )data
{
    NSDictionary* map= data [@"data"];
    NSArray *list = [map objectForKey:@"tailDealVos"];
    self.datas=[JsonHelper transList:list objName:@"TailDeal"];
    
    NSArray *listConfig = [map objectForKey:@"configVOs"];
    NSMutableArray *configVOList=[JsonHelper transList:listConfig objName:@"ConfigVO"];
    NSMutableDictionary* mapConfig=[ConfigRender transDic:configVOList];
    
    self.zeroConfig=[mapConfig objectForKey:DEAL_ZERO];
    self.preciseConfig=[mapConfig objectForKey:PRECISE];
    
    self.detailMap=[NSMutableDictionary dictionary];
    
    //零头设置.
    NSMutableArray* details=[NSMutableArray array];
    NameValueItemVO *vo=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"零头处理方式", nil) val:[ConfigRender getOptionName:self.zeroConfig] andId:self.zeroConfig.val];

    [details addObject:vo];
    if ([NSString isNotBlank:self.zeroConfig.val] && ![self.zeroConfig.val isEqualToString:@"1"]) {
        vo=[[NameValueItemVO alloc] initWithVal:NSLocalizedString(@"▪︎ 零头处理精确度", nil) val:[ConfigRender getOptionName:self.preciseConfig] andId:self.preciseConfig.val];
        [details addObject:vo];
    }
    [self.detailMap setObject:details forKey:@"1"];
    [self.detailMap setObject:self.datas forKey:@"2"];
    
    [self.mainGrid reloadData];
}

-(void) initHeadData
{
    self.headList=[NSMutableArray array];
    NameItemVO* item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"零头处理", nil) andId:@"1"];
    [self.headList addObject:item];
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不吉利尾数处理", nil) andId:@"2"];
    [self.headList addObject:item];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            if ([head.itemId isEqualToString:@"1"]) {
                return nil;
            }
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
           
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=NSLocalizedString(@"添加不吉利尾数...", nil);
            return footerItem;
        } else {
            if ([head.itemId isEqualToString:@"1"]) {
                return [self getZeroCell:head details:temps table:tableView index:indexPath.row];
            } else {
                return [self getTailDealCell:head details:temps table:tableView index:indexPath.row];
            }
        }
    }
    return nil;
}

-(ZeroCell*) getZeroCell:(NameItemVO*)head details:(NSMutableArray*)temps table:(UITableView *)tableView index:(NSInteger)row
{
    ZeroCell *detailItem = (ZeroCell *)[tableView dequeueReusableCellWithIdentifier:ZeroCellIndentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"ZeroCell" owner:self options:nil].lastObject;
    }
    if(self.isChainManager) {
        detailItem.lblVal.textColor = RGBA(102, 102, 102, 1);
        detailItem.nextIcon.hidden = YES;
        detailItem.lblVarRightConstraint.constant = 10;
    }else {
        detailItem.lblVal.textColor = RGBA(0, 136, 204, 1);
        detailItem.nextIcon.hidden = NO;
        detailItem.lblVarRightConstraint.constant = 29;
    }
    if ([ObjectUtil isNotNull:temps]) {
        NameValueItemVO* item=[temps objectAtIndex:row];
        [detailItem loadObj:item tag:1];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailItem;
    }
    return nil;
}

-(TailDealCell*) getTailDealCell:(NameItemVO*)head details:(NSMutableArray*)temps table:(UITableView *)tableView index:(NSInteger)row
{
    TailDealCell *detailItem = (TailDealCell *)[tableView dequeueReusableCellWithIdentifier:TailDealCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"TailDealCell" owner:self options:nil].lastObject;
    }
    if(self.isChainManager) {
        detailItem.lblVal.textColor = RGBA(102, 102, 102, 1);
        detailItem.lblName.textColor = RGBA(102, 102, 102, 1);
        detailItem.deleteButton.hidden = YES;
        detailItem.deleteIcon.hidden = YES;
    }else {
        detailItem.lblVal.textColor = RGBA(0, 136, 204, 1);
        detailItem.lblName.textColor = RGBA(0, 136, 204, 1);
        detailItem.deleteButton.hidden = NO;
        detailItem.deleteIcon.hidden = NO;
    }
    if ([ObjectUtil isNotNull:temps]) {
        TailDeal* item=[temps objectAtIndex:row];
        [detailItem initDelegate:self obj:item];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailItem;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isChainManager) return;
    
    NameItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps==nil || indexPath.row==temps.count) {
            if ([head.itemId isEqualToString:@"1"]) {
                return;
            }
            [self showAddEvent:@"taildeal"];
        } else {
            if ([head.itemId isEqualToString:@"1"]) {
                 NameValueItemVO* item=[temps objectAtIndex:indexPath.row];
                if (indexPath.row==0) {
                    //选择零头处理方式
//                    [OptionPickerBox initData:self.zeroConfig.options itemId:item.itemId];
//                    [OptionPickerBox show:NSLocalizedString(@"零头处理方式", nil) client:self event:indexPath.row];
                    
                    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"零头处理方式", nil)
                                                                                                  options:self.zeroConfig.options
                                                                                            currentItemId:item.itemId];
                    __weak __typeof(self) wself = self;
                    pvc.competionBlock = ^void(NSInteger index) {
                        
                        [wself pickOption:self.zeroConfig.options[index] event:indexPath.row];
                    };
                    
                    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
                } else {
//                    [OptionPickerBox initData:self.preciseConfig.options itemId:item.itemId];
//                    [OptionPickerBox show:NSLocalizedString(@"零头处理精确度", nil) client:self event:indexPath.row];
                    
                    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"零头处理精确度", nil)
                                                                                                  options:self.preciseConfig.options
                                                                                            currentItemId:item.itemId];
                    __weak __typeof(self) wself = self;
                    pvc.competionBlock = ^void(NSInteger index) {
                        
                        [wself pickOption:self.preciseConfig.options[index] event:indexPath.row];
                    };
                    
                    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameItemVO *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([head.itemId isEqualToString:@"2"]) {
            if ([ObjectUtil isNotNull:temps]) {
                if(self.isChainManager) {
                    return temps.count;
                }
                return temps.count+1;
            } else {
                return 1;
            }
        } else {
            return temps.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NameItemVO *head = [self.headList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"tail"];
    [headItem initOperateWithAdd:(section!=0) edit:NO];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        if ([head.itemId isEqualToString:@"1"]) {
            return 44;
        } else {
            return 88;
        }
    }
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma  zero零头处理
-(void)save
{
    if ([self.idList count]==0) {
        [UIHelper ToastNotification:NSLocalizedString(@"没有配置项可以设置", nil) andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    [[TDFSettingService new] saveConfig:self.idList sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         [self loadDatas];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];


}

-(void)remoteFinsh:(RemoteResult*) result
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

#pragma edititemlist click event.
- (BOOL)pickOption:(id)temp event:(NSInteger)event
{
    id<INameItem> item=(id<INameItem>)temp;
    self.idList = [NSMutableArray array];
    if (event==0) {
        if (self.zeroConfig) {
            [self.idList addObject:[NSString stringWithFormat:@"%@|%@", self.zeroConfig._id,[item obtainItemId]]];
        }
        NSString* itemId=[item obtainItemId];
        if ([NSString isNotBlank:itemId] && ![itemId isEqualToString:@"1"]) {
            NSMutableArray* preciseOptions=self.preciseConfig.options;
            ConfigItemOption* option=(ConfigItemOption*)[preciseOptions firstObject];
            
            [self.idList addObject:[NSString stringWithFormat:@"%@|%@", self.preciseConfig._id,option.value]];
        } else if (self.preciseConfig){
            [self.idList addObject:[NSString stringWithFormat:@"%@|%@", self.preciseConfig._id,self.preciseConfig.val]];
        }
    } else {
        if (self.zeroConfig) {
            [self.idList addObject:[NSString stringWithFormat:@"%@|%@", self.zeroConfig._id,self.zeroConfig.val]];
        }
        
        if (self.preciseConfig) {
            [self.idList addObject:[NSString stringWithFormat:@"%@|%@", self.preciseConfig._id,[item obtainItemId]]];
        }
    }
    [self save];
    return YES;
}

@end
