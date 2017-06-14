//
//  TasteListView.m
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TasteListView.h"
#import "RemoteEvent.h"
#import "MenuModule.h"
#import "XHAnimalUtil.h"
#import "MultiMasterManagerView.h"
#import "HelpDialog.h"
#import "KindPayDetail.h"
#import "NSString+Estimate.h"
#import "KindTasteEditView.h"
#import "AlertBox.h"
#import "KindMenuEditView.h"
#import "GridHead.h"
#import "PairPickerBox.h"
#import "SortTableEditView.h"
#import "GridNVCell2.h"
#import "GridFooter.h"
#import "JsonHelper.h"
#import "TableEditView.h"
#import "UIHelper.h"
#import "TasteEditView.h"
#import "TDFMediator+MenuModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TasteListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=parentTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"taste" title:NSLocalizedString(@"备注库管理", nil) foots:nil];
    
    UIImage *backPicture=[UIImage imageNamed:Head_ICON_CANCEL];
    self.titleBox.imgBack.image=backPicture;
    self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
    [self configLeftNavigationBar:@"Head_ICON_CANCEL" leftButtonName:NSLocalizedString(@"关闭", nil)];
    self.title = NSLocalizedString(@"备注库管理", nil);
    [self createData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd| TDFFooterButtonTypeSort];
}

#pragma 数据加载
-(void) onNavigateEvent:(NSInteger)event{
    
    if (event==1) {
        [parent showView:MULTI_HEAD_CHECK_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    }
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        BOOL  isLoad =  [NSString stringWithFormat:@"%@",self.dic[@"isLoad"]].boolValue;
        if (isLoad) {
            [self loadDatas];
        }
        else
        {
           id headList = self.dic [@"headList"] ;
           [self  loadData:headList ];
        }

    }
}

-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFMenuService new] listAllTaste:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSArray* menuKindTastes = [NSArray yy_modelArrayWithClass:[KindAndTasteVo class] json:data[@"data"]];
        NSMutableArray* kindTastes=[NSMutableArray arrayWithArray:menuKindTastes];
        [self refreshTable:kindTastes];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];    
}

-(void)loadData:(NSMutableArray*)headList
{
    [self refreshTable:headList];
}

#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
    [parent showView:SUITMENUTASTE_LIST_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    
}
-(void) footerAddButtonAction:(UIButton *)sender
{

    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_kindTasteEditViewControllerWthData:nil action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
}

-(void) showAddEvent:(NSString*)event obj:(id)obj;
{
   KindTaste* kind=(KindTaste*)obj;
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_tasteEditViewControllerWthData:nil kind:kind action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];

}
-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
//        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:self.progressHud];
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"taste_id"] = [NSString isBlank:[self.currObj obtainItemId]]?@"":[self.currObj obtainItemId];
        @weakify(self);
        [[TDFMenuService new] removeTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            [self loadDatas];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=obj;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]这个备注吗？如果有分类选了这个备注,将会全部取消关联.", nil),[self.currObj obtainItemName]]];
}

-(void) initSortDic
{
    self.sortDic=[NSMutableDictionary dictionary];
    self.sortKeys=[NSMutableArray array];
    [self.sortDic setObject:[NSMutableArray array] forKey:NSLocalizedString(@"备注分类排序", nil)];
    [self.sortKeys addObject:NSLocalizedString(@"备注分类排序", nil)];
    if (self.headList!=nil && self.headList.count>0) {
        NSMutableArray* arr=[NSMutableArray array];
        for (KindAndTasteVo* kt in self.headList) {
            [arr addObject:kt.kindTasteName];
        }
        [self.sortKeys addObject:NSLocalizedString(@"备注内容排序", nil)];
        [self.sortDic setObject:[arr mutableCopy] forKey:NSLocalizedString(@"备注内容排序", nil)];
    }
}

-(void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    if ([event isEqualToString:@"sortinit"]) {
        [self initSortDic];
        [PairPickerBox initData:self.sortDic keys:self.sortKeys keyPos:0 valPos:0];
        [PairPickerBox show:NSLocalizedString(@"备注库排序", nil) client:self event:0];
    }else if([event isEqualToString:@"sortkind"]){
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadDatas];

        }else{

            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"kind_taste_sort_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            @weakify(self);
            [[TDFMenuService new] sortKindTastesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud hide:YES];
                [self loadDatas];

            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
        
    }else if([event isEqualToString:@"sorttaste"]){
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadDatas];

        }else{

            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"taste_sort_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            [[TDFMenuService new] sortTasteWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
              
                [self.progressHud hide:YES];
                [self loadDatas];

            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj{
    if([event isEqualToString:@"KindAndTasteVo"]){
        KindAndTasteVo* kindTaste=(KindAndTasteVo*)obj;
        if ([kindTaste.kindTasteName isEqualToString:@"-1"]) {
            [AlertBox show:NSLocalizedString(@"[其他]是系统库备注分类，不能删除", nil)];
            return;
        }
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_kindTasteEditViewControllerWthData:kindTaste action:ACTION_CONSTANTS_EDIT delegate:self];
        [self.navigationController  pushViewController:viewController animated:YES];

    }
}

-(void) footerHelpButtonAction:(UIButton *)sender{
    
    [HelpDialog show:@"basemenunote"];
}

#pragma 消息处理部分.
-(void) sortFinish:(RemoteResult*) result
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

- (void)refreshTable:(NSMutableArray *)kindTastes
{
    if (kindTastes==nil || kindTastes.count==0) {
        kindTastes=[NSMutableArray new];
    }
    self.headList=[kindTastes mutableCopy];
    self.detailMap=[NSMutableDictionary new];
    
    
    for (KindAndTasteVo* kindTaste in kindTastes) {
        for (Taste* taste in kindTaste.tasteList) {
            if ([NSString isBlank:taste.kindTasteId]) {
                taste.kindTasteId=@"-1";
            }
            if ([@"-1" isEqualToString:taste.kindTasteId]) {
                KindAndTasteVo* kindTaste=[KindAndTasteVo new];
                kindTaste.kindTasteId=@"-1";
                kindTaste.kindTasteName=NSLocalizedString(@"其他", nil);
                [self.headList addObject:kindTaste];
            }
        }

        if ([ObjectUtil isEmpty:kindTaste.tasteList]) {
             [self.detailMap setObject:[[NSMutableArray alloc]init] forKey:kindTaste.kindTasteId];
        }else{
                [self.detailMap setObject:kindTaste.tasteList forKey:kindTaste.kindTasteId];
        }
     }
    for (UIViewController  *viewController in self.navigationController.viewControllers) {
        if ([viewController  isKindOfClass:[KindMenuEditView  class]]) {
            KindMenuEditView *kindMenuEditView   = (KindMenuEditView *)viewController ;
            [kindMenuEditView  refreshMemoChange:kindTastes ];
        }
        if ([viewController  isKindOfClass:[MultiMasterManagerView class]]) {
            MultiMasterManagerView *multiHeadCheckView  = (MultiMasterManagerView *)viewController;
            [multiHeadCheckView  reLoadData:kindTastes detalMap:self.detailMap];
        }
    }

    [self.mainGrid reloadData];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindAndTasteVo *kindTaste = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:kindTaste]) {
        NSMutableArray *temps = [self.detailMap objectForKey:kindTaste.kindTasteId];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
            
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=NSLocalizedString(@"添加新备注...", nil);
            return footerItem;
        }else{
            GridNVCell2 *detailItem = (GridNVCell2 *)[tableView dequeueReusableCellWithIdentifier:GridNVCell2Indentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell2" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotNull:temps]) {
                Taste* item=[temps objectAtIndex: indexPath.row];
                [detailItem initDelegate:self obj:item title:@"" event:@"taste"];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindAndTasteVo *kindTaste = [self.headList objectAtIndex:indexPath.section];
    self.currKindTaste=kindTaste;
    if ([ObjectUtil isNotNull:kindTaste]) {
        NSMutableArray *temps = [self.detailMap objectForKey:self.currKindTaste.kindTasteId];
        if (temps==nil || indexPath.row==temps.count) {
            [self showAddEvent:@"taste" obj:kindTaste];
        }else{
            [self showEditNVItemEvent:@"taste" withObj:temps[indexPath.row]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KindAndTasteVo *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.kindTasteId];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count+1;
        }else{
            return 1;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KindAndTasteVo *head = [self.headList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"KindAndTasteVo"];
    [headItem initOperateWithAdd:NO edit:![@"-1" isEqualToString:head.kindTasteId]];
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
- (BOOL)pickOption:(NSInteger)keyIndex valIndex:(NSInteger)valIndex event:(NSInteger)eventType
{
    NSMutableArray* datas=nil;
    NSString* sortName=@"";
    NSString* sortEvent=@"sortkind";
    if (keyIndex==0) {
        datas=[self.headList mutableCopy];
        if (datas!=nil && datas.count>0) {
            for (KindAndTasteVo* kt in datas) {
                if ([kt.kindTasteId isEqualToString:@"-1"]) {
                    [datas removeObject:kt];
                }
            }
        }
        
        sortName=NSLocalizedString(@"备注分类", nil);
        sortEvent=@"sortkind";
    } else {
        KindAndTasteVo* kindTaste=[self.headList objectAtIndex:valIndex];
        NSMutableArray* arrs=[self.detailMap objectForKey:kindTaste.kindTasteId];
        datas=[arrs mutableCopy];
        sortName=[NSString stringWithFormat:NSLocalizedString(@"[%@]备注", nil),kindTaste.kindTasteName];
        sortEvent=@"sorttaste";
    }
    if (datas==nil || datas.count<2) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"请至少添加两条%@内容,才能进行排序.", nil),sortName]];
        return YES;
    }
    UIViewController *viewController  = [[TDFMediator sharedInstance]  TDFMediator_sortTableEditViewControllerWithData:datas  error:nil event:sortEvent  action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
    return YES;
}

- (void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEventForMenuMoudle:@"sortinit" menuMoudleMap:nil];
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self loadDatas];
}

- (void) viewWillAppear:(BOOL)animated
{
    //一直取消不掉暂时采用这种办法
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self configRightNavigationBar:@"" rightButtonName:@""];
}

- (void)sortEvent:(NSString *)event ids:(NSMutableArray *)ids
{
    
}

@end

