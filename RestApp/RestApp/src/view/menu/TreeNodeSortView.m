//
//  TreeNodeSortViewViewController.m
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNodeSortView.h"
#import "MenuModuleEvent.h"
#import "TreeNodeCell.h"
#import "TreeNode.h"
#import "DataSingleton.h"
#import "ServiceFactory.h"
#import "NSMutableArray+DeepCopy.h"
#import "MenuModuleEvent.h"
#import "MenuService.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "JsonHelper.h"
#import "MenuModule.h"
#import "RemoteResult.h"
#import "UIHelper.h"
#import "TreeBuilder.h"
#import "TreeNodeUtils.h"
#import "AlertBox.h"
#import "TDFMenuService.h"

@implementation TreeNodeSortView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=parentTemp;
        service=[ServiceFactory Instance].menuService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    
}

- (void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChildFinish:) name:KINDMENU_SHOW_CHILD object:nil];
    
}

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
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"kindMenus"];
    self.kindList=[JsonHelper transList:list objName:@"KindMenu"];
    self.treeNodes=[TreeBuilder buildTree:self.kindList];
    NSMutableArray* endNodes=[TreeNodeUtils convertEndNode:self.treeNodes];
    
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:endNodes forKey:@"head_list"];
    [dic setObject:self.treeNodes forKey:@"allNode_list"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Kind_Change object:endNodes];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_ALLKind_Change object:dic];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (self.parentNodes!=nil && self.parentNodes.count>0) {
            TreeNode* pNode=[self.parentNodes lastObject];
            [self reload:pNode.children error:nil];
            [self.parentNodes removeLastObject];
        }else{
            [parent showView:KINDMENU_LIST_VIEW];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
        }

     } else {


//        [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud];
//        NSMutableDictionary* menuMoudleMap=[self getSpecMap];
//        if ([menuMoudleMap.allKeys count]==0) {

      //  [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud];
    //    NSMutableArray* ids=[super getIds];
    //   if ([ids count]==0) {

        [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud];
        NSMutableDictionary* menuMoudleMap=[self getSpecMap];
        if ([menuMoudleMap.allKeys count]==0) {
            [self.delegate closeListEvent:self.event];
        }
//         [service sortKindMenu:ids type:@"0" Target:self Callback:@selector(sortFinish:)];
//         NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//         param[@"kind_menu_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
//         [[TDFMenuService new] sortKindWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
//             //            @strongify(self);
//             [hud hide:YES];
//           
//         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//             //        @strongify(self);
//             [hud hide:YES];
//             [AlertBox show:error.localizedDescription];
//         }];
    }
}

-(NSMutableDictionary*) getSpecMap
{
    if (self.datas && [self.datas count]>0) {    //排序的处理.
        for (int i = 0; i<self.datas.count; i++) {
            id<SortItemValue> item = self.datas[i];
            item.sortCode = i;
        }
    }
    
    NSMutableArray* arr=[NSMutableArray array];
    for (int i = 0; i<self.arrDatas.count; i++) {
        id<SortItemValue> specItem = self.arrDatas[i];
        id<SortItemValue> specItem1 = self.datas[i];
        if ([specItem1 obtainItemId] != [specItem obtainItemId]) {
            [arr addObject:specItem1];
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<arr.count; i++) {
        id<SortItemValue> spec = arr[i];
        param[[spec obtainItemId]] = [NSNumber numberWithInt:spec.sortCode];
    }
    return param;
}

-(void) loadChildFinish:(NSNotification*) notification
{
    TreeNode* treeNode= notification.object;
    if ([treeNode isLeaf]) {
        return ;
    }
    TreeNode* pNode=[treeNode mutableCopy];
    [pNode setChildren:[self.datas deepCopy]];
    [self.parentNodes addObject:pNode];
    NSMutableArray* childs=[treeNode children];
    [self reload:childs error:nil];
}

- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error
{
    [super reload:_dataTemps error:error];
    self.arrDatas = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.datas.count; i++) {
        id<SortItemValue> item = self.datas[i];
        item.sortCode = i;
        [self.arrDatas addObject:item];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        TreeNodeCell * cell = [tableView dequeueReusableCellWithIdentifier:TreeNodeCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TreeNodeCell" owner:self options:nil].lastObject;
        }
        TreeNode* item=(TreeNode*)[self.datas objectAtIndex: indexPath.row];
        [cell fillModel:item];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
        self.mainGrid.editing=NO;
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

@end
